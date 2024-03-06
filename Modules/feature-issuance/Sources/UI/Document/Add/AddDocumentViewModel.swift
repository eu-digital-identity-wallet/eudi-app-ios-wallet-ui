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
import logic_business
import feature_common
import MdocDataModel18013
import EudiWalletKit

struct AddDocumentViewState: ViewState {
  let addDocumentCellModels: [AddDocumentUIModel]
  let error: ContentErrorView.Config?
  let config: IssuanceFlowUiConfig

  var isFlowCancellable: Bool {
    return config.isExtraDocumentFlow
  }
}

final class AddDocumentViewModel<Router: RouterHostType, Interactor: AddDocumentInteractorType>: BaseViewModel<Router, AddDocumentViewState> {

  private let interactor: Interactor

  init(router: Router, interactor: Interactor, config: any UIConfigType) {
    guard let config = config as? IssuanceFlowUiConfig else {
      fatalError("AddDocumentViewModel:: Invalid configuraton")
    }
    self.interactor = interactor
    super.init(
      router: router,
      initialState: .init(
        addDocumentCellModels: AddDocumentUIModel.mocks,
        error: nil,
        config: config
      )
    )
  }

  func fetchStoredDocuments() {
    switch self.interactor.fetchStoredDocuments(with: viewState.config.flow) {
    case .success(let documents):
      self.setNewState(addDocumentCellModels: documents)
    case .failure(let error):
      setNewState(
        error: ContentErrorView.Config(
          description: .custom(error.localizedDescription),
          cancelAction: self.pop(),
          action: { self.fetchStoredDocuments() }
        )
      )
    }
  }

  func onClick(for documentIdentifier: DocumentIdentifier) {
    switch documentIdentifier {
    case .EuPidDocType:
      issueDocument(docType: EuPidModel.euPidDocType)
    case .IsoMdlModel:
      issueDocument(docType: IsoMdlModel.isoDocType)
    case .genericDocument:
      loadSampleData()
    }
  }

  func pop() {
    router.pop(animated: true)
  }

  private func issueDocument(docType: String, format: DataFormat = .cbor) {
    Task {
      setNewState(
        addDocumentCellModels: transformCellLoadingState(with: true)
      )
      switch await interactor.issueDocument(
        docType: docType,
        format: format
      ) {
      case .success(let docType):
        router.push(
          with: .issuanceSuccess(
            config: viewState.config,
            documentIdentifier: docType
          )
        )
      case .failure(let error):
        setNewState(
          addDocumentCellModels: transformCellLoadingState(with: false),
          error: .init(
            description: .custom(error.localizedDescription),
            cancelAction: self.setNewState(error: nil)
          )
        )
      }
    }
  }

  private func transformCellLoadingState(with isLoading: Bool) -> [AddDocumentUIModel] {
    return viewState.addDocumentCellModels.map({
        var cell = $0
        cell.isLoading = isLoading
        return cell
      }
    )
  }

  private func loadSampleData() {
    Task {
      switch await interactor.loadSampleData() {
      case .success:
        router.push(with: .dashboard)
      case .failure(let error):
        setNewState(
          error: .init(
            description: .custom(error.localizedDescription),
            cancelAction: self.setNewState(error: nil)
          )
        )
      }
    }
  }

  private func setNewState(
    addDocumentCellModels: [AddDocumentUIModel]? = nil,
    error: ContentErrorView.Config? = nil
  ) {
    setState { previousSate in
        .init(
          addDocumentCellModels: addDocumentCellModels ?? previousSate.addDocumentCellModels,
          error: error,
          config: previousSate.config
        )
    }
  }
}
