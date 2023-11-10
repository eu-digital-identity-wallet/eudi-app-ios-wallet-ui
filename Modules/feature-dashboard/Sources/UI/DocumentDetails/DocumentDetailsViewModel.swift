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

struct DocumentDetailsViewState: ViewState {
  var document: DocumentDetailsUIModel
  var isLoading: Bool
  let error: ContentError.Config?
  let documentId: String
}

@MainActor
final class DocumentDetailsViewModel<Router: RouterHostType, Interactor: DocumentDetailsInteractorType>: BaseViewModel<Router, DocumentDetailsViewState> {

  private let interactor: Interactor

  init(
    router: Router,
    interactor: Interactor,
    documentId: String
  ) {
    self.interactor = interactor
    super.init(
      router: router,
      initialState: .init(
        document: DocumentDetailsUIModel.mock(),
        isLoading: true,
        error: nil,
        documentId: documentId
      )
    )
  }

  func fetchDocumentDetails() async {

    switch await self.interactor.fetchStoredDocument(documentId: viewState.documentId) {

    case .success(let document):
      self.setNewState(
        isLoading: false,
        document: document
      )
    case .failure(let error):
      self.setNewState(
        isLoading: true,
        error: ContentError.Config(
          description: .custom(error.localizedDescription),
          cancelAction: self.pop()
        )
      )
    }
  }

  func pop() {
    router.pop()
  }

  private func setNewState(
    isLoading: Bool = false,
    document: DocumentDetailsUIModel? = nil,
    error: ContentError.Config? = nil
  ) {
    setState { previous in
        .init(
          document: document ?? previous.document,
          isLoading: isLoading,
          error: error,
          documentId: previous.documentId
        )
    }
  }
}
