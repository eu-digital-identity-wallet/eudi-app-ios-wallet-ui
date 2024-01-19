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
import EudiWalletKit

public protocol AddDocumentInteractorType {
  func fetchStoredDocuments(with flow: IssuanceFlowUiConfig.Flow) -> StoredDocumentsPartialState
  func loadSampleData() async -> LoadSampleDataPartialState
  func issueDocument(docType: String, format: DataFormat) async -> IssueDocumentPartialState
}

public final class AddDocumentInteractor: AddDocumentInteractorType {

  private lazy var walletController: WalletKitControllerType = WalletKitController.shared

  public init() {}

  public func fetchStoredDocuments(with flow: IssuanceFlowUiConfig.Flow) -> StoredDocumentsPartialState {

    let types = AddDocumentCellModel.items.map({
      var item = $0
      switch item.type {
      case .EuPidDocType:
        item.isEnabled = walletController.fetchDocument(
          with: DocumentIdentifier.EuPidDocType.rawValue
        ) == nil
      case .IsoMdlModel:
        item.isEnabled = walletController.fetchDocument(
          with: DocumentIdentifier.IsoMdlModel.rawValue
        ) == nil && flow == .extraDocument
      case .genericDocument:
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
            type: .genericDocument(docType: "load_sample_data")
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

  public func issueDocument(docType: String, format: DataFormat) async -> IssueDocumentPartialState {
    do {
      let doc = try await walletController.issueDocument(docType: docType, format: format)
      return .success(doc.docType)
    } catch {
      return .failure(RuntimeError.unableFetchDocument)
    }
  }
}

public enum StoredDocumentsPartialState {
  case success([AddDocumentCellModel])
  case failure(Error)
}

public enum LoadSampleDataPartialState {
  case success
  case failure(Error)
}

public enum IssueDocumentPartialState {
  case success(String)
  case failure(Error)
}
