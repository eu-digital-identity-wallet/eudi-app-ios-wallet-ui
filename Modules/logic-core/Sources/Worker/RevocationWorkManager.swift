/*
 * Copyright (c) 2023 European Commission
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

public protocol RevocationWorkManager: Sendable {
  func start() async
  func stop() async
}

final actor RevocationWorkManagerImpl: RevocationWorkManager {

  private let configLogic: WalletKitConfig
  private let walletKitController: WalletKitController

  private let initialDelay: TimeInterval = 30
  private var revocationTask: Task<Void, Never>?
  private var isRunning = false

  init(configLogic: WalletKitConfig, walletKitController: WalletKitController) {
    self.configLogic = configLogic
    self.walletKitController = walletKitController
  }

  func start() async {

    guard revocationTask == nil else { return }

    isRunning = true

    revocationTask = Task(priority: .userInitiated) { [weak self] in

      guard let self else { return }

      try? await Task.sleep(seconds: initialDelay)

      while await self.isRunning {
        try? await self.checkRevocation()
        try? await Task.sleep(seconds: self.configLogic.revocationInterval)
      }
    }
  }

  func stop() async {
    isRunning = false
    revocationTask?.cancel()
    revocationTask = nil
  }

  private func checkRevocation() async throws {

    let issuedDocuments = walletKitController.fetchIssuedDocuments()
    let revokedStoredDocuments = (try? await walletKitController.fetchRevokedDocuments()) ?? []

    var revokedDocuments: [String: String] = [:]
    var fromRevokedToValid: [String] = []

    for document in issuedDocuments {

      guard let identifier = document.statusIdentifier else { continue }

      let status = try await walletKitController.getDocumentStatus(for: identifier)
      let isInRevokedStorage = revokedStoredDocuments.first(where: { $0 == document.id }) != nil

      switch status {
      case .invalid, .suspended:
        if !isInRevokedStorage {
          revokedDocuments[document.displayName.orEmpty] = document.id
        }
      case .valid:
        if isInRevokedStorage {
          fromRevokedToValid.append(document.id)
        }
      default:
        continue
      }
    }

    if !fromRevokedToValid.isEmpty {
      try await removeRevokedDocuments(with: fromRevokedToValid)
    }

    if !revokedDocuments.isEmpty {
      try await storeRevokedDocuments(with: Array(revokedDocuments.values))
      await notifyListeners(with: revokedDocuments)
    }

    if !fromRevokedToValid.isEmpty || !revokedDocuments.isEmpty {
      await notifyDocumentTabListener()
    }
  }

  private func storeRevokedDocuments(with ids: [String]) async throws {
    try await walletKitController.storeRevokedDocuments(with: ids)
  }

  private func removeRevokedDocuments(with ids: [String]) async throws {
    for id in ids {
      try await walletKitController.removeRevokedDocument(with: id)
    }
  }

  @MainActor
  private func notifyListeners(with revoked: [String: String]) async {
    NotificationCenter.default.post(
      name: NSNotification.RevocationDashboard,
      object: nil,
      userInfo: revoked
    )
    NotificationCenter.default.post(
      name: NSNotification.RevocationDocumentDetailsRefresh,
      object: nil,
      userInfo: ["revoked_ids": Array(revoked.values)]
    )
  }

  @MainActor
  private func notifyDocumentTabListener() async {
    NotificationCenter.default.post(
      name: NSNotification.RevocationDocumentTabRefresh,
      object: nil,
      userInfo: [:]
    )
  }
}

public extension NSNotification {
  static let RevocationDashboard = Notification.Name("RevocationDashboard")
  static let RevocationDocumentTabRefresh = Notification.Name("RevocationDocumentTabRefresh")
  static let RevocationDocumentDetailsRefresh = Notification.Name("RevocationIdsDetailsExtra")
}
