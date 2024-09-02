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
import feature_common
import logic_business
import logic_core

public protocol AddDocumentInteractor {
  func fetchStoredDocuments(with flow: IssuanceFlowUiConfig.Flow) -> StoredDocumentsPartialState
  func loadSampleData() async -> LoadSampleDataPartialState
  func issueDocument(docType: String) async -> IssueDocumentPartialState
  func resumeDynamicIssuance() async -> IssueDynamicDocumentPartialState
}

final class AddDocumentInteractorImpl: AddDocumentInteractor {

  private let walletController: WalletKitController

  init(
    walletController: WalletKitController
  ) {
    self.walletController = walletController
  }

  public func fetchStoredDocuments(with flow: IssuanceFlowUiConfig.Flow) -> StoredDocumentsPartialState {

    let types = AddDocumentUIModel.items.map({
      var item = $0
      switch item.type {
      case .PID:
        item.isEnabled = true
      case .MDL:
        item.isEnabled = flow == .extraDocument
      case .AGE:
        item.isEnabled = flow == .extraDocument
      case .PHOTOID:
        item.isEnabled = flow == .extraDocument
      case .GENERIC:
        break
      }
      return item
    })

    switch flow {
    case .noDocument:
      return .success(
        types + [
          .init(
            isEnabled: true,
            documentName: .loadSampleData,
            image: Theme.shared.image.id,
            isLoading: false,
            type: .GENERIC(docType: "load_sample_data")
          )
        ]
      )
    case .extraDocument:
      return .success(types)
    }
  }

  public func loadSampleData() async -> LoadSampleDataPartialState {
    do {
      try await walletController.loadSampleData(dataFiles: ["EUDI_sample_data"])
      return .success
    } catch {
      return .failure(error)
    }
  }

  public func issueDocument(docType: String) async -> IssueDocumentPartialState {
    do {
      let doc = try await walletController.issueDocument(docType: docType, format: .cbor)
      if doc.isDeferred {
        return .deferredSuccess
      } else if let authorizePresentationUrl = doc.authorizePresentationUrl {
        guard
          let presentationUrl = URL(string: authorizePresentationUrl),
          let presentationComponents = URLComponents(url: presentationUrl, resolvingAgainstBaseURL: true) else {
          return .failure(WalletCoreError.unableToIssueAndStore)
        }
        let session = walletController.startSameDevicePresentation(deepLink: presentationComponents)
        return .dynamicIssuance(session)
      } else {
        return .success(doc.id)
      }
    } catch {
      return .failure(WalletCoreError.unableToIssueAndStore)
    }
  }

  func resumeDynamicIssuance() async -> IssueDynamicDocumentPartialState {

    guard let pendingData = await walletController.getDynamicIssuancePendingData() else {
      return .noPending
    }

    do {

      let doc = try await walletController.resumePendingIssuance(
        pendingDoc: pendingData.pendingDoc,
        webUrl: pendingData.url
      )

      if doc.status == .issued {
        return .success(doc.id)
      } else {
        return .failure(WalletCoreError.unableToIssueAndStore)
      }

    } catch {
      return .failure(WalletCoreError.unableToIssueAndStore)
    }
  }
}

public enum StoredDocumentsPartialState {
  case success([AddDocumentUIModel])
  case failure(Error)
}

public enum LoadSampleDataPartialState {
  case success
  case failure(Error)
}

public enum IssueDocumentPartialState {
  case success(String)
  case deferredSuccess
  case dynamicIssuance(PresentationSessionCoordinator)
  case failure(Error)
}

public enum IssueDynamicDocumentPartialState {
  case success(String)
  case noPending
  case failure(Error)
}
