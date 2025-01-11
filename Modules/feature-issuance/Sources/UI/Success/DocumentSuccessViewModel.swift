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
  let documentIdentifier: String
  let document: DocumentDetailsUIModel?
  let issuerData: IssuerDataUIModel
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
    documentIdentifier: String
  ) {

    guard let config = config as? IssuanceFlowUiConfig else {
      fatalError("ExternalLoginViewModel:: Invalid configuraton")
    }

    self.interactor = interactor
    self.detailsInteractor = detailsInteractor

    super.init(
      router: router,
      initialState: .init(
        title: .issuanceSuccessTitlePunctuated,
        caption: nil,
        holderName: nil,
        config: config,
        documentIdentifier: documentIdentifier,
        document: DocumentDetailsUIModel.mock(),
        issuerData: IssuerDataUIModel.mock(),
        isLoading: true,
        error: nil
      )
    )
  }

  func initialize() async {
    await fetchDocumentDetails()
    await fetchIssuerData()

    setState {
      $0.copy(
        caption: interactor.getDocumentSuccessCaption(for: viewState.documentIdentifier),
        holderName: interactor.getHoldersName(for: viewState.documentIdentifier)
      )
    }
  }

  func onIssue() {

    var flow: IssuanceDetailUiConfig.Flow {
      switch viewState.config.flow {
      case .noDocument:
        return .noDocument(viewState.documentIdentifier)
      case .extraDocument:
        return .extraDocument(viewState.documentIdentifier)
      }
    }

    router.push(
      with: .featureIssuanceModule(
        .issuanceDocumentDetails(
          config: IssuanceDetailUiConfig(
            flow: flow
          )
        )
      )
    )
  }

  func fetchDocumentDetails() async {

    let documentId = viewState.documentIdentifier

    let state = await Task.detached { () -> DocumentDetailsPartialState in
      return await self.detailsInteractor.fetchStoredDocument(documentId: documentId)
    }.value

    switch state {

    case .success(let document):
      switch viewState.config.flow {
      case .extraDocument:
        self.setState {
          $0
            .copy(
              document: document,
              isLoading: false
            )
        }
      default:
        self.setState {
          $0
            .copy(
              document: nil,
              isLoading: false
            )
        }
      }

    case .failure:
      self.setState {
        $0
          .copy(
            document: nil,
            isLoading: false
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
}
