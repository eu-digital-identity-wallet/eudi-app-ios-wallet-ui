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

public protocol ReIssuanceWorkManager: Sendable {
  func start() async
  func stop() async
}

final actor ReIssuanceWorkManagerImpl: ReIssuanceWorkManager {

  private let reIssuanceRule: ReIssuanceRule
  private let walletKitController: WalletKitController

  private let initialDelay: TimeInterval = 30
  private var reIssuanceTask: Task<Void, Never>?
  private var isRunning = false

  init(configLogic: WalletKitConfig, walletKitController: WalletKitController) {
    self.reIssuanceRule = configLogic.documentIssuanceConfig.reIssuanceRule
    self.walletKitController = walletKitController
  }

  func start() async {

    guard reIssuanceTask == nil else { return }

    isRunning = true

    reIssuanceTask = Task(priority: .userInitiated) { [weak self] in

      guard let self else { return }

      try? await Task.sleep(seconds: initialDelay)

      while await self.isRunning {
        try? await self.checkReIssuance()
        try? await Task.sleep(seconds: self.reIssuanceRule.backgroundIntervalSeconds)
      }
    }
  }

  func stop() async {
    isRunning = false
    reIssuanceTask?.cancel()
    reIssuanceTask = nil
  }

  private func checkReIssuance() async throws {

    var issuedDocuments: [any DocClaimsDecodable] = []
    for document in await walletKitController.fetchIssuedDocuments() where await shouldReIssue(document) {
      issuedDocuments.append(document)
    }

    guard !issuedDocuments.isEmpty else { return }

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

      } catch {
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

    let unusedThreshold = credentialOptions?.reissueTriggerUnused ?? reIssuanceRule.minNumberOfCredentials
    let lifetimeHoursThreshold = credentialOptions?.reissueTriggerLifetimeLeft ?? reIssuanceRule.minExpirationHours

    let remainingUsage = document.credentialsUsageCounts?.remaining ?? -1
    let belowMinCount = remainingUsage <= unusedThreshold
    let hasOneTimeUsePolicy = document.credentialPolicy == .oneTimeUse
    let expiresWithinThreshold = document.validUntil?.isWithinNextHours(lifetimeHoursThreshold) ?? false

    return (belowMinCount && hasOneTimeUsePolicy) || expiresWithinThreshold
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

public extension NSNotification {
  static let ReIssuanceDetailsRefresh = Notification.Name("ReIssuanceDetailsRefresh")
}
