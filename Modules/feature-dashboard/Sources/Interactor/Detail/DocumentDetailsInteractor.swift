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
import logic_core
import feature_common

public protocol DocumentDetailsInteractor: Sendable {
  func fetchStoredDocument(documentId: String) async -> DocumentDetailsPartialState
  func deleteDocument(with documentId: String, and type: DocumentTypeIdentifier) async -> DocumentDetailsDeletionPartialState
  func save(_ identifier: String) async throws
  func delete(_ identifier: String) async throws
}

final class DocumentDetailsInteractorImpl: DocumentDetailsInteractor {

  private let walletController: WalletKitController
  private let prefsController: PrefsController

  init(
    walletController: WalletKitController,
    prefsController: PrefsController
  ) {
    self.walletController = walletController
    self.prefsController = prefsController
  }

  func fetchStoredDocument(documentId: String) async -> DocumentDetailsPartialState {
    let document = walletController.fetchDocument(with: documentId)
    guard let documentDetails = document?.transformToDocumentUi() else {
      return .failure(WalletCoreError.unableFetchDocument)
    }
    let isBookmarked = await walletController.isDocumentBookmarked(with: documentId)
    let isRevoked = await walletController.isDocumentRevoked(with: documentId)

    if isBatchCounterEnabled() {
      let info = getCredentialsUsageCount(credentialsUsageCounts: document?.credentialsUsageCounts)
      return .success(documentDetails, info, isBookmarked, isRevoked)
    }
    return .success(documentDetails, nil, isBookmarked, isRevoked)
  }

  func deleteDocument(with documentId: String, and type: DocumentTypeIdentifier) async -> DocumentDetailsDeletionPartialState {

    let successState: DocumentDetailsDeletionPartialState

    do {

      var shouldDeleteAllDocuments: Bool {
        if type == .mDocPid || type == .sdJwtPid {

          let documentPids = walletController.fetchIssuedDocuments(
            with: [DocumentTypeIdentifier.mDocPid, DocumentTypeIdentifier.sdJwtPid]
          )
          let mainPid = walletController.fetchMainPidDocument()

          guard documentPids.count > 1 else { return true }

          return mainPid?.id == documentId

        } else {
          return false
        }
      }

      if shouldDeleteAllDocuments {
        await walletController.clearAllDocuments()
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

  private func getCredentialsUsageCount(credentialsUsageCounts: CredentialsUsageCounts?) -> DocumentCredentialsInfoUi? {
    if let usageCounts = credentialsUsageCounts {
      return documentCredentialsInfoUi(usageCounts: usageCounts)
    } else {
      return documentCredentialsInfoUi()
    }
  }

  private func documentCredentialsInfoUi(usageCounts: CredentialsUsageCounts? = nil) -> DocumentCredentialsInfoUi {
    let defaultValue = 1
    let availableCredentials = usageCounts?.remaining ?? defaultValue
    let totalCredentials = usageCounts?.total ?? defaultValue

    return DocumentCredentialsInfoUi(
      availableCredentials: availableCredentials,
      totalCredentials: totalCredentials,
      title: .documentDetailsDocumentCredentialsText([availableCredentials.string, totalCredentials.string]),
      collapsedInfo: CollapsedInfo(
        moreInfoText: .documentDetailsDocumentCredentialsMoreInfoText
      ),
      expandedInfo: ExpandedInfo(
        subtitle: .documentDetailsDocumentCredentialsExpandedTextSubtitle,
        hideButtonText: .documentDetailsDocumentCredentialsExpandedButtonHideText
      )
    )
  }

  private func isBatchCounterEnabled() -> Bool {
    prefsController.getBool(forKey: .batchCounter)
  }
}

public enum DocumentDetailsPartialState: Sendable {
  case success(DocumentUIModel, DocumentCredentialsInfoUi?, Bool, Bool)
  case failure(Error)
}

public enum DocumentDetailsDeletionPartialState: Sendable {
  case success(shouldReboot: Bool)
  case failure(Error)
}
