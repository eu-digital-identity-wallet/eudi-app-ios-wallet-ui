/*
 * Copyright (c) 2023 European Commission
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import Foundation
import logic_ui
import logic_resources

struct AddDocumentViewState: ViewState {
  var addDocumentCellModels: [AddDocumentCellModel]
}

final class AddDocumentViewModel<Router: RouterHostType, Interactor: AddDocumentInteractorType>: BaseViewModel<Router, AddDocumentViewState> {

  private let interactor: Interactor

  init(router: Router, interactor: Interactor) {
    self.interactor = interactor

    super.init(
      router: router,
      initialState: .init(
        addDocumentCellModels: AddDocumentCellModel.mocks
      )
    )
  }

  func fetchStoredDocuments() {
    switch self.interactor.fetchStoredDocuments() {
    case .success(let documents):
      self.setNewState(addDocumentCellModels: documents)
    case .failure(let error):
      ()
    }
  }

  func routeToIssuance(for docType: AddDocumentCellModel.`Type`) {
    switch docType {
    case .pid:
      print("route to pid issuance flow")
    case .mdl:
      print("route to pid issuance flow")
    }
  }

  func pop() {
    router.pop(animated: true)
  }

  private func setNewState(
    addDocumentCellModels: [AddDocumentCellModel]? = nil
  ) {
    setState { previousSate in
        .init(
          addDocumentCellModels: addDocumentCellModels ?? previousSate.addDocumentCellModels
        )
    }
  }
}
