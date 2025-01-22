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
import logic_ui
import logic_resources
import feature_common

@Copyable
struct DocumentSuccessState: ViewState {
  let title: LocalizableString.Key
  let caption: LocalizableString.Key?
  let holderName: String?
  let config: IssuanceFlowUiConfig
  let documentIdentifiers: [String]
  let documents: [DocumentDetailsUIModel]
  let isLoading: Bool
  let error: ContentErrorView.Config?
}

final class DocumentSuccessViewModel<Router: RouterHost>: ViewModel<Router, DocumentSuccessState> {

  private let interactor: DocumentSuccessInteractor
  private let detailsInteractor: DocumentDetailsInteractor

  public init(
    router: Router,
    interactor: DocumentSuccessInteractor,
    detailsInteractor: DocumentDetailsInteractor,
    config: any UIConfigType,
    documentIdentifiers: [String]
  ) {

    guard let config = config as? IssuanceFlowUiConfig else {
      fatalError("ExternalLoginViewModel:: Invalid configuraton")
    }

    self.interactor = interactor
    self.detailsInteractor = detailsInteractor

    super.init(
      router: router,
      initialState: .init(
        title: .successTitlePunctuated,
        caption: nil,
        holderName: nil,
        config: config,
        documentIdentifiers: documentIdentifiers,
        documents: [DocumentDetailsUIModel.mock()],
        isLoading: true,
        error: nil
      )
    )
  }

  func initialize() async {
    await fetchDocumentDetails()

    if let first = viewState.documentIdentifiers.first {
      setState {
        $0.copy(
          caption: .succesfullyAddedFollowingToWallet,
          holderName: interactor.getHoldersName(
            for: first
          )
        )
      }
    }
  }

  func onIssue() {
    router.push(
      with: .featureDashboardModule(
        .dashboard
      )
    )
  }

  func fetchDocumentDetails() async {

    let documentIdentifiers = viewState.documentIdentifiers
    let state = await Task.detached { () -> DocumentsPartialState in
      return await self.detailsInteractor.fetchStoredDocuments(
        documentIds: documentIdentifiers
      )
    }.value

    switch state {
    case .success(let documents):
      switch viewState.config.flow {
      case .extraDocument:
        self.setState {
          $0.copy(
            documents: documents,
            isLoading: false
          )
        }
      default:
        self.setState {
          $0.copy(
            documents: documents,
            isLoading: false
          )
        }
      }

    case .failure:
      self.setState {
        $0.copy(
          title: .issuanceSuccessHeaderDescriptionWhenError,
          documents: [],
          isLoading: false
        )
      }
    }
  }
}
