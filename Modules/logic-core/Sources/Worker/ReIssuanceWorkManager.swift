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

protocol ReIssuanceWorkManager: Sendable {
  func start() async
  /// Stops the checks and returns once a re-issuance under way has finished, so nothing is stored afterwards.
  func stop() async
}

final actor ReIssuanceWorkManagerImpl: ReIssuanceWorkManager {

  /// Fallback re-issuance thresholds used when neither the document's persisted `CredentialOptions`
  /// nor the local `documentIssuanceConfig` rule specify a trigger.
  /// `defaultReissueTriggerUnused` is a credential count; `defaultReissueTriggerLifetimeLeft` is in
  /// seconds (14 hours), matching the unit of `CredentialOptions.reissueTriggerLifetimeLeft`.
  private let defaultReissueTriggerUnused = 2
  private let defaultReissueTriggerLifetimeLeft = 14 * 60 * 60

  private let documentIssuanceConfig: DocumentIssuanceConfig
  private let walletKitController: WalletKitController
  private let revocationWorkManager: RevocationWorkManager

  private let initialDelay: TimeInterval = 30
  private var reIssuanceTask: Task<Void, Never>?
  private var isRunning = false
  private let checkRunner: SerialCheckRunner

  /// - Parameter checkRunner: Runs the rounds one at a time; `stop()` waits on it.
  init(
    configLogic: WalletKitConfig,
    walletKitController: WalletKitController,
    revocationWorkManager: RevocationWorkManager,
    checkRunner: SerialCheckRunner = SerialCheckRunner()
  ) {
    self.revocationWorkManager = revocationWorkManager
    self.documentIssuanceConfig = configLogic.documentIssuanceConfig
    self.walletKitController = walletKitController
    self.checkRunner = checkRunner
  }

  func start() async {

    guard reIssuanceTask == nil else { return }

    isRunning = true

    reIssuanceTask = Task(priority: .userInitiated) { [weak self] in

      guard let self else { return }

      do {
        try await Task.sleep(seconds: initialDelay)
        while await self.isRunning, !Task.isCancelled {
          await self.runCheck()
          try await Task.sleep(seconds: self.documentIssuanceConfig.reIssuanceBackgroundRule.backgroundIntervalSeconds)
        }
      } catch {
        return
      }
    }
  }

  func stop() async {
    isRunning = false
    reIssuanceTask?.cancel()
    reIssuanceTask = nil
    await checkRunner.waitUntilIdle()
  }

  /// Runs one round through `checkRunner`, so `stop()` can wait for it. A round that starts after `stop()` does
  /// nothing.
  private func runCheck() async {
    await checkRunner.run { [weak self] in
      guard let self, await self.isRunning else { return }
      try? await self.checkReIssuance()
    }
  }

  /// A revoked, suspended or unrecognised document is not re-issued, as on Android: the copy would get a
  /// new identifier and no record, which would undo the block. A failed read of the records skips the
  /// round. A round with nothing due clears the failure records too, as on Android, so that a document's
  /// details do not keep an old "could not renew" notice.
  func checkReIssuance() async throws {

    let blockedDocuments = try await walletKitController.fetchRevokedDocumentStatuses()
    var issuedDocuments: [any DocClaimsDecodable] = []
    for document in await walletKitController.fetchIssuedDocuments() where blockedDocuments[document.id] == nil {
      if await shouldReIssue(document) {
        issuedDocuments.append(document)
      }
    }

    guard !issuedDocuments.isEmpty else {
      try await removeAllFailedFromStorage()
      return
    }

    var succeed: [String] = []
    var failed: [String] = []
    var removedIds: [String] = []

    for document in issuedDocuments {
      do {

        let newDocument = try await walletKitController.reIssueDocument(
          identifier: document.id,
          isBackgroundOperation: true
        )

        removedIds.append(document.id)
        succeed.append(newDocument.id)
        await revocationWorkManager.checkAfterReIssue(of: document.id)

      } catch {
        guard !Task.isCancelled else { return }
        failed.append(document.id)
      }

      try await removeAllFailedFromStorage()

      if !failed.isEmpty {
        try await storeFailedDocuments(with: failed)
      }

      if !succeed.isEmpty {
        await notifyDocumentsList()
        await notifyDocumentDetails(with: removedIds)
      }
    }
  }

  private func shouldReIssue(_ document: any DocClaimsDecodable) async -> Bool {
    let credentialOptions = await walletKitController.getDocumentCredentialOptions(with: document.id)
    let configOptions = documentIssuanceConfig.credentialOptions(for: document.documentTypeIdentifier)

    let unusedThreshold = credentialOptions?.reissueTriggerUnused
      ?? configOptions.reissueTriggerUnused
      ?? defaultReissueTriggerUnused
    let lifetimeSecondsThreshold = credentialOptions?.reissueTriggerLifetimeLeft
      ?? configOptions.reissueTriggerLifetimeLeft
      ?? defaultReissueTriggerLifetimeLeft

    switch document.credentialPolicy {
    case .oneTimeUse:
      return isDueForUnusedCountReIssue(document, reissueTriggerUnused: unusedThreshold)
    case .rotateUse:
      return isDueForLifetimeReIssue(document, reissueTriggerLifetimeLeft: lifetimeSecondsThreshold)
    @unknown default:
      return isDueForLifetimeReIssue(document, reissueTriggerLifetimeLeft: lifetimeSecondsThreshold)
    }
  }

  private func isDueForLifetimeReIssue(
    _ document: any DocClaimsDecodable,
    reissueTriggerLifetimeLeft seconds: Int
  ) -> Bool {
    guard let validUntil = document.validUntil else { return true }
    let expirationLimit = Date().addingTimeInterval(TimeInterval(seconds))
    return validUntil <= expirationLimit
  }

  private func isDueForUnusedCountReIssue(
    _ document: any DocClaimsDecodable,
    reissueTriggerUnused threshold: Int
  ) -> Bool {
    let remainingUnused = document.credentialsUsageCounts?.remaining ?? 0
    return remainingUnused <= threshold
  }

  private func storeFailedDocuments(with ids: [String]) async throws {
    try await walletKitController.storeFailedReIssuedDocuments(ids: ids)
  }

  private func removeAllFailedFromStorage() async throws {
    try await walletKitController.removeAllFailedReIssuedDocuments()
  }

  @MainActor
  private func notifyDocumentDetails(with removedIds: [String]) async {
    NotificationCenter.default.post(
      name: NSNotification.ReIssuanceDetailsRefresh,
      object: nil,
      userInfo: ["ids": removedIds]
    )
  }

  @MainActor
  private func notifyDocumentsList() async {
    NotificationCenter.default.post(
      name: NSNotification.DocumentTabRefresh,
      object: nil,
      userInfo: [:]
    )
  }
}
