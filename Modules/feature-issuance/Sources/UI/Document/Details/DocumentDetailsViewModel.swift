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
  let issuerData: IssuerDataUIModel
  let isLoading: Bool
  let error: ContentErrorView.Config?
  let config: IssuanceDetailUiConfig
  let hasDeleteAction: Bool
  let documentFieldsCount: Int

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
  @Published var isBookmarked = true
  @Published var alertType: AlertType?

  enum AlertType {
    case bookmark
    case issuer
  }

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
        issuerData: IssuerDataUIModel.mock(),
        isLoading: true,
        error: nil,
        config: config,
        hasDeleteAction: false,
        documentFieldsCount: 0
      )
    )
  }

  func fetchDocumentDetails() async {

    guard let documentId = viewState.config.documentIds.first else {
      self.setState {
        $0.copy(
          isLoading: true,
          error: .init(
            description: .itemNotFoundInStorage,
            cancelAction: self.pop()
          )
        )
      }
      return
    }

    let state = await Task.detached { () -> DocumentDetailsPartialState in
      return await self.interactor.fetchStoredDocument(documentId: documentId)
    }.value

    switch state {

    case .success(let documents):
      guard let document = documents.first else {
        self.setState {
          $0.copy(
            isLoading: true,
            error: .init(
              description: .itemNotFoundInStorage,
              cancelAction: self.pop()
            )
          )
        }
        return
      }

      switch viewState.config.flow {
      case .extraDocument:
        self.setState {
          $0.copy(
            document: document,
            isLoading: false,
            hasDeleteAction: true,
            documentFieldsCount: document.documentFields.count
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

  func fetchIssuerData() async {
    let issuer = IssuerDataUIModel(
      icon: Theme.shared.image.issuerCardImagePlaceholder,
      title: "Another Organization",
      subtitle: "Non-Government agency",
      caption: "Athens - Greece",
      isVerified: true
    )
    self.setState {
      $0.copy(
        issuerData: issuer
      )
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

  func bookmarked() async {
    guard let documentId = viewState.config.documentIds.first else {
      self.setState {
        $0.copy(
          isLoading: true,
          error: .init(
            description: .itemNotFoundInStorage,
            cancelAction: self.pop()
          )
        )
      }
      return
    }

    do {
      _ = try await interactor.fetchBookmarks(documentId)
      isBookmarked = true
    } catch {
      isBookmarked = false
    }
  }

  func saveBookmark(_ identifier: String) {
    Task {
      do {
        if isBookmarked {
          try await interactor.delete(identifier)
          isBookmarked = false
        } else {
          try await interactor.save(identifier)
          isBookmarked = true
        }
      } catch {}
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
