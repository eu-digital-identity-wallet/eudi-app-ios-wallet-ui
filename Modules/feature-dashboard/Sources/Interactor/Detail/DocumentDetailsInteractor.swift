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
import logic_core
import logic_authentication
import feature_common

public protocol DocumentDetailsInteractor: Sendable {
  func fetchStoredDocument(documentId: String) async -> DocumentDetailsPartialState
  func reIssueDocument(identifier: String) async -> DocumentDetailsReIssuancePartialState
  func deleteDocument(with documentId: String, and type: DocumentTypeIdentifier) async -> DocumentDetailsDeletionPartialState
  func save(_ identifier: String) async throws
  func delete(_ identifier: String) async throws
}

final actor DocumentDetailsInteractorImpl: DocumentDetailsInteractor {

  private let walletController: WalletKitController
  private let prefsController: PrefsController
  private let configLogic: ConfigLogic
  private let sessionController: SessionController
  private let walletWorkScheduler: WalletWorkScheduler

  init(
    walletController: WalletKitController,
    prefsController: PrefsController,
    configLogic: ConfigLogic,
    sessionController: SessionController,
    walletWorkScheduler: WalletWorkScheduler
  ) {
    self.walletController = walletController
    self.prefsController = prefsController
    self.configLogic = configLogic
    self.sessionController = sessionController
    self.walletWorkScheduler = walletWorkScheduler
  }

  func fetchStoredDocument(documentId: String) async -> DocumentDetailsPartialState {
    let document = await walletController.fetchDocument(with: documentId)
    let issuerLogoOrigins = await walletController.issuerLogoOrigins()
    guard let documentDetails = document?.transformToDocumentUi(issuerLogoOrigins: issuerLogoOrigins) else {
      return .failure(WalletCoreError.unableFetchDocument)
    }
    let isBookmarked = await walletController.isDocumentBookmarked(with: documentId)
    let revocationStatus = await walletController.getDocumentRevocationStatus(with: documentId)
    let isRevoked = revocationStatus != nil
    let hasStatusRefreshFailed = await walletController.hasStatusRefreshFailure(with: documentId)
    let hasReIssuanceFailed = await walletController.hasReIssuanceFailure(with: documentId)

    let issuerDetailsCard = document?.transformToIssuerDetailsCardDataUi(
      revocationStatus: revocationStatus,
      hasStatusRefreshFailed: hasStatusRefreshFailed,
      hasReIssuanceFailed: hasReIssuanceFailed,
      issuerLogoOrigins: issuerLogoOrigins
    )

    if isBatchCounterEnabled() {
      let info = documentCredentialsInfoUi(usageCounts: document?.credentialsUsageCounts)
      return .success(documentDetails, issuerDetailsCard, info, isBookmarked, isRevoked)
    }

    return .success(documentDetails, issuerDetailsCard, nil, isBookmarked, isRevoked)
  }

  /// Re-issuance can go through the issuer's sign-in from this screen, which is not a protected-flow
  /// screen, so the session lock treats it as an external flow, as on Android. A revoked, suspended or
  /// unrecognised document is refused before anything starts at the issuer, because the new copy would
  /// carry no revocation record and the block would be lost; so is any document whose records cannot be
  /// read. The screen disables re-issue for a blocked document; this also covers one blocked while the
  /// screen is open.
  func reIssueDocument(identifier: String) async -> DocumentDetailsReIssuancePartialState {
    do {
      try await walletController.refuseReIssueIfBlocked(identifier)
      _ = try await sessionController.duringExternalFlow {
        try await walletController.reIssueDocument(
          identifier: identifier,
          isBackgroundOperation: false
        )
      }
      await walletWorkScheduler.scheduleRevocationCheck(afterReIssueOf: identifier)
      return .success
    } catch {
      if (error as? WalletCoreError) == .documentBlocked {
        return .documentBlocked
      }
      return error.isTrustBlocked ? .issuerNotTrusted : .failure(error)
    }
  }

  func deleteDocument(with documentId: String, and type: DocumentTypeIdentifier) async -> DocumentDetailsDeletionPartialState {

    func shouldDeleteAllDocuments(type: DocumentTypeIdentifier) async -> Bool {
      if configLogic.forcePidActivation && (type == .mDocPid || type == .sdJwtPid ) {

        let documentPids = await walletController.fetchIssuedDocuments(
          with: [DocumentTypeIdentifier.mDocPid, DocumentTypeIdentifier.sdJwtPid]
        )
        let mainPid = await walletController.fetchMainPidDocument()

        guard documentPids.count > 1 else { return true }

        return mainPid?.id == documentId

      } else {
        return false
      }
    }

    let successState: DocumentDetailsDeletionPartialState

    do {

      if await shouldDeleteAllDocuments(type: type) {
        try await walletController.clearAllDocuments()
        successState = .success(shouldReboot: true)
      } else {
        try await walletController.deleteDocument(with: documentId, status: .issued)
        successState = .success(shouldReboot: false)
      }

    } catch {
      return .failure(error)
    }
    return successState
  }

  func save(_ identifier: String) async throws {
    try await walletController.storeBookmarkedDocument(with: identifier)
  }

  func delete(_ identifier: String) async throws {
    try await walletController.removeBookmarkedDocument(with: identifier)
  }

  private func documentCredentialsInfoUi(
    usageCounts: CredentialsUsageCounts? = nil
  ) -> DocumentCredentialsInfoUi {
    let defaultValue = 1
    let availableCredentials = usageCounts?.remaining ?? defaultValue
    let totalCredentials = usageCounts?.total ?? defaultValue

    return DocumentCredentialsInfoUi(
      availableCredentials: availableCredentials,
      totalCredentials: totalCredentials,
      title: .documentDetailsDocumentCredentialsText([availableCredentials.string, totalCredentials.string])
    )
  }

  private func isBatchCounterEnabled() -> Bool {
    prefsController.getBool(forKey: .batchCounter)
  }
}

public enum DocumentDetailsPartialState: Sendable {
  case success(
    DocumentUIModel,
    IssuerDocumentDetailsCardUIModel?,
    DocumentCredentialsInfoUi?,
    Bool,
    Bool
  )
  case failure(Error)
}

public enum DocumentDetailsDeletionPartialState: Sendable {
  case success(shouldReboot: Bool)
  case failure(Error)
}

public enum DocumentDetailsReIssuancePartialState: Sendable {
  case success
  case issuerNotTrusted
  /// The issuer has revoked or suspended the document, so it was not re-issued.
  case documentBlocked
  case failure(Error)
}
