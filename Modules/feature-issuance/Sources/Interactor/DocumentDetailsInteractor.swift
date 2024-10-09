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
import logic_ui
import logic_resources
import logic_core
import logic_business

public protocol DocumentDetailsInteractor: ThreadSafeInteractor {
  func fetchStoredDocument(documentId: String) async -> DocumentDetailsPartialState
  func deleteDocument(with documentId: String, and type: DocumentTypeIdentifier) async -> DocumentDetailsDeletionPartialState
}

final class DocumentDetailsInteractorImpl: DocumentDetailsInteractor {

  private let walletController: WalletKitController

  public init(walletController: WalletKitController) {
    self.walletController = walletController
  }

  public func fetchStoredDocument(documentId: String) async -> DocumentDetailsPartialState {
    let document = walletController.fetchDocument(with: documentId)
    guard let documentDetails = document?.transformToDocumentDetailsUi() else {
      return .failure(WalletCoreError.unableFetchDocument)
    }
    return .success(documentDetails)
  }

  public func deleteDocument(with documentId: String, and type: DocumentTypeIdentifier) async -> DocumentDetailsDeletionPartialState {

    let successState: DocumentDetailsDeletionPartialState

    do {

      var shouldDeleteAllDocuments: Bool {
        if type == .PID {

          let documentPids = walletController.fetchIssuedDocuments(
            with: DocumentTypeIdentifier.PID
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
}

public enum DocumentDetailsPartialState: ThreadSafePartialState {
  case success(DocumentDetailsUIModel)
  case failure(Error)
}

public enum DocumentDetailsDeletionPartialState: ThreadSafePartialState {
  case success(shouldReboot: Bool)
  case failure(Error)
}
