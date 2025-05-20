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
import logic_resources
import feature_common
import logic_core

@Copyable
struct DocumentDetailsViewState: ViewState {
  let document: DocumentUIModel
  let isLoading: Bool
  let error: ContentErrorView.Config?
  let documentId: String
  let documentFieldsCount: Int
  let isBookmarked: Bool
  let isRevoked: Bool
}

final class DocumentDetailsViewModel<Router: RouterHost>: ViewModel<Router, DocumentDetailsViewState> {

  @Published var isDeletionModalShowing: Bool = false
  @Published var isVisible = true
  @Published var showAlert = false

  private let interactor: DocumentDetailsInteractor

  init(
    router: Router,
    interactor: DocumentDetailsInteractor,
    documentId: String
  ) {
    self.interactor = interactor
    super.init(
      router: router,
      initialState: .init(
        document: DocumentUIModel.mock(),
        isLoading: true,
        error: nil,
        documentId: documentId,
        documentFieldsCount: 0,
        isBookmarked: false,
        isRevoked: false
      )
    )
  }

  func fetchDocumentDetails() async {

    let documentId = viewState.documentId
    let state = await Task.detached { () -> DocumentDetailsPartialState in
      return await self.interactor.fetchStoredDocument(
        documentId: documentId
      )
    }.value

    switch state {

    case .success(let document, let isBookmarked, let isRevoked):
      self.setState {
        $0.copy(
          document: document,
          isLoading: false,
          documentFieldsCount: document.documentFields.count,
          isBookmarked: isBookmarked,
          isRevoked: isRevoked
        ).copy(error: nil)
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
        .init(
          image: viewState.isBookmarked ? Theme.shared.image.bookmarkIconFill : Theme.shared.image.bookmarkIcon
        ) {
          self.saveBookmark(self.viewState.document.id)
        },
        .init(
          image: isVisible ? Theme.shared.image.eyeSlash : Theme.shared.image.eye
        ) {
          self.isVisible.toggle()
          self.toggleVisibility()
        }
      ],
      leadingActions: [
        .init(image: Theme.shared.image.chevronLeft) {
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
