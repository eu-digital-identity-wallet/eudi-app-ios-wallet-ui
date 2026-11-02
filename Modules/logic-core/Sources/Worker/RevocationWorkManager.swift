/*
 * Copyright (c) 2026 European Commission
 *
 * Licensed under the EUPL, Version 1.2 or - as soon they will be approved by the European
 * Commission - subsequent versions of the EUPL (the "Licence"); You may not use this work
 * except in compliance with the Licence.
 *
 * You may obtain a copy of the Licence at:
 * https://joinup.ec.europa.eu/software/page/eupl
 *
 * Unless required by applicable law or agreed to in writing, software distributed under
 * the Licence is distributed on an "AS IS" basis, WITHOUT WARRANTIES OR CONDITIONS OF
 * ANY KIND, either express or implied. See the Licence for the specific language
 * governing permissions and limitations under the Licence.
 */

import Foundation

protocol RevocationWorkManager: Sendable {
  func start() async
  /// Stops the checks and returns once a check under way has finished.
  func stop() async
  /// Runs the revocation check now, or right after one under way, if the original of a completed re-issue
  /// gained a revocation record while it was re-issued, so the new copy's status is read without waiting for
  /// the interval, as the Android wallet does. Does nothing while the checks are stopped.
  func checkAfterReIssue(of originalId: String) async
}

final actor RevocationWorkManagerImpl: RevocationWorkManager {

  private let configLogic: WalletKitConfig
  private let walletKitController: WalletKitController

  private let initialDelay: TimeInterval = 30
  private var revocationTask: Task<Void, Never>?
  private var isRunning = false
  private var didRunInitialCheck = false
  private let checkRunner: SerialCheckRunner

  /// - Parameter checkRunner: Runs the checks one at a time; `stop()` waits on it.
  init(
    configLogic: WalletKitConfig,
    walletKitController: WalletKitController,
    checkRunner: SerialCheckRunner = SerialCheckRunner()
  ) {
    self.configLogic = configLogic
    self.walletKitController = walletKitController
    self.checkRunner = checkRunner
  }

  func start() async {

    guard revocationTask == nil else { return }

    isRunning = true

    revocationTask = Task(priority: .userInitiated) { [weak self] in

      guard let self else { return }

      do {
        try await Task.sleep(seconds: self.firstCheckDelay())
        while await self.isRunning, !Task.isCancelled {
          await self.runCheck()
          try await Task.sleep(seconds: self.configLogic.revocationIntervalSeconds)
        }
      } catch {
        return
      }
    }
  }

  func stop() async {
    isRunning = false
    revocationTask?.cancel()
    revocationTask = nil
    await checkRunner.waitUntilIdle()
  }

  func checkAfterReIssue(of originalId: String) async {
    guard
      isRunning,
      let statuses = try? await walletKitController.fetchRevokedDocumentStatuses(),
      statuses[originalId] != nil
    else { return }
    await runCheck()
  }

  /// Runs one check through `checkRunner`, so two never overlap. A check that starts after `stop()` does nothing,
  /// so `stop()` returning means no check runs.
  private func runCheck() async {
    await checkRunner.run { [weak self] in
      guard let self, await self.isRunning else { return }
      try? await self.checkRevocation()
    }
  }

  /// The first check of the process comes `initialDelay` after the workers start, which is after login.
  /// Once it has run, a later start, after the workers were stopped, waits the full interval.
  func firstCheckDelay() -> TimeInterval {
    didRunInitialCheck ? configLogic.revocationIntervalSeconds : initialDelay
  }

  /// One sweep over the issued documents that carry a status list, with the Android wallet's rules
  /// (`RevocationRecordUpdate`): a revocation is permanent; a suspended or unrecognised record is cleared
  /// when the list reports the document valid again; a status value the wallet cannot interpret blocks
  /// the document. A document whose status cannot be fetched keeps its record, gets a refresh-failure
  /// record that the next successful check removes, and the sweep goes on. The dashboard notice lists
  /// only documents newly blocked. A failed read of the stored records ends the sweep before anything is
  /// changed.
  func checkRevocation() async throws {

    didRunInitialCheck = true

    let issuedDocuments = await walletKitController.fetchIssuedDocuments()
    let storedStatuses = try await walletKitController.fetchRevokedDocumentStatuses()
    let previousFailures = try await walletKitController.fetchStatusRefreshFailures()

    var newStatuses: [String: DocumentRevocationStatus] = [:]
    var revokedDocuments: [String: String] = [:]
    var suspendedDocuments: [String: String] = [:]
    var cleared: [String] = []
    var failed: [String] = []
    var refreshedAfterFailure: [String] = []

    for document in issuedDocuments {

      guard let statusList = document.statusList else { continue }

      let status: CredentialStatus
      do {
        status = try await walletKitController.getDocumentStatus(for: statusList)
      } catch {
        guard !Task.isCancelled else { return }
        failed.append(document.id)
        continue
      }

      if previousFailures.contains(document.id) {
        refreshedAfterFailure.append(document.id)
      }

      let storedStatus = storedStatuses[document.id]

      switch RevocationRecordUpdate.after(stored: storedStatus, observed: status) {
      case .keep:
        continue
      case .clear:
        cleared.append(document.id)
      case .record(let newStatus):
        newStatuses[document.id] = newStatus
        guard storedStatus == nil else { continue }
        if newStatus == .suspended {
          suspendedDocuments[document.id] = document.displayName.orEmpty
        } else {
          revokedDocuments[document.id] = document.displayName.orEmpty
        }
      }
    }

    if !newStatuses.isEmpty {
      try await storeRevokedDocuments(with: newStatuses)
      if !revokedDocuments.isEmpty || !suspendedDocuments.isEmpty {
        await notifyListeners(revoked: revokedDocuments, suspended: suspendedDocuments)
      }
    }

    if !cleared.isEmpty {
      try await removeRevokedDocuments(with: cleared)
    }

    let newFailures = failed.filter { !previousFailures.contains($0) }
    if !newFailures.isEmpty {
      try await walletKitController.storeStatusRefreshFailures(ids: newFailures)
    }
    if !refreshedAfterFailure.isEmpty {
      try await walletKitController.removeStatusRefreshFailures(ids: refreshedAfterFailure)
    }

    let changed = Array(newStatuses.keys) + cleared + newFailures + refreshedAfterFailure
    if !changed.isEmpty {
      await notifyDocumentDetails(with: changed)
      await notifyDocumentTabListener()
    }
  }

  private func storeRevokedDocuments(with statuses: [String: DocumentRevocationStatus]) async throws {
    try await walletKitController.storeRevokedDocuments(with: statuses)
  }

  private func removeRevokedDocuments(with ids: [String]) async throws {
    for id in ids {
      try await walletKitController.removeRevokedDocument(with: id)
    }
  }

  /// Tells the dashboard which documents were newly revoked and which newly suspended, and refreshes
  /// their details.
  @MainActor
  private func notifyListeners(revoked: [String: String], suspended: [String: String]) async {
    NotificationCenter.default.post(
      name: NSNotification.RevocationDashboard,
      object: nil,
      userInfo: RevocationDashboardPayload(revoked: revoked, suspended: suspended).userInfo
    )
  }

  @MainActor
  private func notifyDocumentDetails(with ids: [String]) async {
    NotificationCenter.default.post(
      name: NSNotification.DocumentDetailsRefresh,
      object: nil,
      userInfo: ["ids": ids]
    )
  }

  @MainActor
  private func notifyDocumentTabListener() async {
    NotificationCenter.default.post(
      name: NSNotification.DocumentTabRefresh,
      object: nil,
      userInfo: [:]
    )
  }
}
