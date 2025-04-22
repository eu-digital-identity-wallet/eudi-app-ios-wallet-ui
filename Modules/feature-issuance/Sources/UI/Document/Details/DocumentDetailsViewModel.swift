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
  let hasDeleteAction: Bool
  let documentFieldsCount: Int
  let isBookmarked: Bool
  let isRevoked: Bool

  var isCancellable: Bool {
    return config.isExtraDocument
  }

  var hasContinueButton: Bool {
    return !config.isExtraDocument
  }
}

final class DocumentDetailsViewModel<Router: RouterHost>: ViewModel<Router, DocumentDetailsViewState> {

  @Published var isDeletionModalShowing: Bool = false
  @Published var isVisible = true
  @Published var showAlert = false

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
        hasDeleteAction: false,
        documentFieldsCount: 0,
        isBookmarked: false,
        isRevoked: false
      )
    )
  }

  func fetchDocumentDetails() async {

    let documentId = viewState.config.documentId
    let state = await Task.detached { () -> DocumentDetailsPartialState in
      return await self.interactor.fetchStoredDocument(
        documentId: documentId
      )
    }.value

    switch state {

    case .success(let document, let isBookmarked, let isRevoked):
      switch viewState.config.flow {
      case .extraDocument:
        self.setState {
          $0.copy(
            document: document,
            isLoading: false,
            hasDeleteAction: true,
            documentFieldsCount: document.documentFields.count,
            isBookmarked: isBookmarked,
            isRevoked: isRevoked
          ).copy(error: nil)
        }
      case .noDocument:
        self.setState {
          $0.copy(
            document: document,
            isLoading: false,
            hasDeleteAction: false,
            documentFieldsCount: document.documentFields.count
          ).copy(error: nil)
        }
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
    router.popTo(with: .featureDashboardModule(.dashboard))
  }

  func onContinue() {
    router.push(with: .featureDashboardModule(.dashboard))
  }

  func onDeleteDocument() {
    isDeletionModalShowing = false
    onDocumentDelete(with: viewState.document.type, and: viewState.document.id)
  }

  func onShowDeleteModal() {
    isDeletionModalShowing = !isDeletionModalShowing
  }

  func saveBookmark(_ identifier: String) {
    Task {
      do {
        if viewState.isBookmarked {
          try await interactor.delete(identifier)
          self.setState {
            $0.copy(
              isBookmarked: false
            )
          }
        } else {
          try await interactor.save(identifier)
          self.setState {
            $0.copy(
              isBookmarked: true
            )
          }
        }
        self.showAlert = true
      } catch {}
    }
  }

  func alertTitle() -> LocalizableStringKey {
    if viewState.isBookmarked {
      return .savedToFavorites
    } else {
      return .removedFromFavorites
    }
  }

  func alertMessage() -> LocalizableStringKey {
    if viewState.isBookmarked {
      return .savedToFavoritesMessage
    } else {
      return .removedFromFavoritesMessages
    }
  }

  func toolbarContent() -> ToolBarContent {
    .init(
      trailingActions: [
        Action(
          image: viewState.isBookmarked ? Theme.shared.image.bookmarkIconFill : Theme.shared.image.bookmarkIcon
        ) {
          self.saveBookmark(self.viewState.document.id)
        },
        Action(
          image: isVisible ? Theme.shared.image.eyeSlash : Theme.shared.image.eye
        ) {
          self.isVisible.toggle()
          self.toggleVisibility()
        }
      ],
      leadingActions: [
        Action(image: Theme.shared.image.chevronLeft) {
          self.pop()
        }
      ]
    )
  }

  func handleRevocationNotification(for payload: [AnyHashable: Any]?) {
    guard let ids = payload?["revoked_ids"] as? [String] else { return }
    if ids.contains(where: { $0 == viewState.document.id }) {
      setState { $0.copy(isRevoked: true) }
    }
  }

  private func toggleVisibility() {
    let documentFields = viewState.document.toggleVisibility(
      isVisible: isVisible
    )
    self.setState {
      $0.copy(
        document: viewState.document.copy(
          documentFields: documentFields
        )
      )
    }
  }

  private func onDocumentDelete(with type: DocumentTypeIdentifier, and id: String) {
    Task {

      self.setState { $0.copy(isLoading: true).copy(error: nil) }

      let state = await Task.detached { () -> DocumentDetailsDeletionPartialState in
        return await self.interactor.deleteDocument(with: id, and: type)
      }.value

      switch state {
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
    router.popTo(with: .featureStartupModule(.startup))
  }
}
