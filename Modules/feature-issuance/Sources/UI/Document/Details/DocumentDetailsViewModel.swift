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
import logic_core

@Copyable
struct DocumentDetailsViewState: ViewState {
  let document: DocumentDetailsUIModel
  let isLoading: Bool
  let error: ContentErrorView.Config?
  let config: IssuanceDetailUiConfig
  let toolBarActions: [ContentHeaderView.Action]?

  var isCancellable: Bool {
    return config.isExtraDocument
  }

  var hasContinueButton: Bool {
    return !config.isExtraDocument
  }
}

final class DocumentDetailsViewModel<Router: RouterHost>: BaseViewModel<Router, DocumentDetailsViewState> {

  @Published var isDeletionModalShowing: Bool = false

  private let interactor: DocumentDetailsInteractor

  init(
    router: Router,
    interactor: DocumentDetailsInteractor,
    config: any UIConfigType
  ) {
    guard let config = config as? IssuanceDetailUiConfig else {
      fatalError("DocumentDetailsViewModel:: Invalid configuraton")
    }
    self.interactor = interactor
    super.init(
      router: router,
      initialState: .init(
        document: DocumentDetailsUIModel.mock(),
        isLoading: true,
        error: nil,
        config: config,
        toolBarActions: nil
      )
    )
  }

  func fetchDocumentDetails() async {

    switch await self.interactor.fetchStoredDocument(documentId: viewState.config.documentId) {

    case .success(let document):

      var actions: [ContentHeaderView.Action]? {
        switch viewState.config.flow {
        case .extraDocument:
          return [
            .init(
              image: Theme.shared.image.trash,
              callback: self.onShowDeleteModal()
            )
          ]
        case .noDocument:
          return nil
        }
      }

      self.setState {
        $0
          .copy(
            document: document,
            isLoading: false,
            toolBarActions: actions
          )
          .copy(error: nil)
      }

    case .failure(let error):
      self.setState {
        $0.copy(
          isLoading: true,
          error: .init(
            description: .custom(error.localizedDescription),
            cancelAction: self.pop()
          )
        )
      }
    }
  }

  func pop() {
    isDeletionModalShowing = false
    router.popTo(with: .dashboard)
  }

  func onContinue() {
    router.push(with: .dashboard)
  }

  func onDeleteDocument() {
    isDeletionModalShowing = false
    onDocumentDelete(with: viewState.document.type, and: viewState.document.id)
  }

  func onShowDeleteModal() {
    isDeletionModalShowing = !isDeletionModalShowing
  }

  private func onDocumentDelete(with type: DocumentTypeIdentifier, and id: String) {
    Task {

      self.setState { $0.copy(isLoading: true).copy(error: nil) }

      switch await self.interactor.deleteDocument(with: id, and: type) {
      case .success(let shouldReboot):
        if shouldReboot {
          self.onReboot()
        } else {
          self.pop()
        }
      case .failure(let error):
        self.setState {
          $0.copy(
            isLoading: false,
            error: .init(
              description: .custom(error.localizedDescription),
              cancelAction: self.setState { $0.copy(error: nil) }
            )
          )
        }
      }
    }
  }

  private func onReboot() {
    isDeletionModalShowing = false
    router.popTo(with: .startup)
  }
}
