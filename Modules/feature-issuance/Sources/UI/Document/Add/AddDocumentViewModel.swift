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

struct AddDocumentViewState: ViewState {
  let addDocumentCellModels: [AddDocumentCellModel]
  let error: ContentError.Config?
  let config: IssuanceFlowUiConfig

  var isFlowCancellable: Bool {
    return config.isExtraDocumentFlow
  }
}

@MainActor
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
        addDocumentCellModels: AddDocumentCellModel.mocks,
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
        error: ContentError.Config(
          description: .custom(error.localizedDescription),
          cancelAction: self.pop(),
          action: { self.fetchStoredDocuments() }
        )
      )
    }
  }

  func onClick(for documentIdentifier: DocumentIdentifier) {
    switch documentIdentifier {
    case .EuPidDocType, .IsoMdlModel:
      router.push(with: .issuanceExternalLogin(config: viewState.config, documentIdentifier: documentIdentifier.rawValue))
    case .genericDocument:
      loadSampleData()
    }
  }

  func pop() {
    router.pop(animated: true)
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
    addDocumentCellModels: [AddDocumentCellModel]? = nil,
    error: ContentError.Config? = nil
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
