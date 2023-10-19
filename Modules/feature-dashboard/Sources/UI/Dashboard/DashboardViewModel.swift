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

struct DashboardState: ViewState {
  let bearerLoading: Bool
  let documentsLoading: Bool
  let documents: [DocumentUIModel]
  let bearer: BearerUIModel?
}

@MainActor
final class DashboardViewModel<Router: RouterHostType, Interactor: DashboardInteractorType>: BaseViewModel<Router, DashboardState> {

  private let interactor: Interactor

  var bearerName: String {
    viewState.bearer?.value.name ?? ""
  }

  var isLoading: Bool {
    !viewState.bearerLoading && !viewState.documentsLoading
  }

  init(router: Router, interactor: Interactor) {
    self.interactor = interactor
    super.init(
      router: router,
      initialState: .init(
        bearerLoading: true,
        documentsLoading: true,
        documents: DocumentUIModel.mocks(),
        bearer: BearerUIModel.mock()
      )
    )
  }

  func fetch() async {
    await fetchPossesor()
    await fetchDocuments()
  }

  private func fetchPossesor() async {
    switch await interactor.fetchBearer() {
    case .success(let possesor):
      setNewState(
        bearerLoading: false,
        bearer: possesor
      )
    case .failure:
      setNewState(
        bearerLoading: false,
        bearer: nil
      )
    }
  }

  private func fetchDocuments() async {
    switch await interactor.fetchDocuments() {
    case .success(let documents):
      setNewState(
        documentsLoading: false,
        documents: documents
      )
    case .failure:
      setNewState(
        documentsLoading: false,
        documents: []
      )
    }
  }

  private func setNewState(
    bearerLoading: Bool? = nil,
    documentsLoading: Bool? = nil,
    documents: [DocumentUIModel]? = nil,
    bearer: BearerUIModel? = nil
  ) {
    setState { previousSate in
        .init(
          bearerLoading: bearerLoading ?? previousSate.bearerLoading,
          documentsLoading: documentsLoading ?? previousSate.documentsLoading,
          documents: documents ?? previousSate.documents,
          bearer: bearer ?? previousSate.bearer
        )
    }
  }
}
