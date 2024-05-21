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
import logic_core

struct DocumentOfferViewState: ViewState {
  let isLoading: Bool
  let documentOfferUiModel: DocumentOfferUIModel
  let error: ContentErrorView.Config?
  let config: IssuanceFlowUiConfig
  let offerUri: String
  let allowIssue: Bool

  var title: LocalizableString.Key {
    return .requestCredentialOfferTitle([documentOfferUiModel.issuerName])
  }
}

@MainActor
final class DocumentOfferViewModel<Router: RouterHost>: BaseViewModel<Router, DocumentOfferViewState> {

  private let interactor: DocumentOfferInteractor

  @Published var isCancelModalShowing: Bool = false

  init(
    router: Router,
    interactor: DocumentOfferInteractor,
    config: any UIConfigType
  ) {
    guard
      let config = config as? IssuanceFlowUiConfig,
      let offerUri = config.credentialOfferUri
    else {
      fatalError("DocumentOfferViewModel:: Invalid configuraton")
    }
    self.interactor = interactor
    super.init(
      router: router,
      initialState: .init(
        isLoading: true,
        documentOfferUiModel: DocumentOfferUIModel.mock(),
        error: nil,
        config: config,
        offerUri: offerUri,
        allowIssue: false
      )
    )
  }

  func processRequest() async {
    switch await self.interactor.processOfferRequest(with: viewState.offerUri) {
    case .success(let uiModel):
      setNewState(
        documentOfferUiModel: uiModel,
        allowIssue: !uiModel.uiOffers.isEmpty
      )
    case .failure(let error):
      setNewState(
        error: ContentErrorView.Config(
          description: .custom(error.localizedDescription),
          cancelAction: self.onPop()
        ),
        allowIssue: false
      )
    }
  }

  func onIssueDocuments() {
    Task {
      setNewState(isLoading: true)
      switch await self.interactor.issueDocuments(
        with: viewState.offerUri,
        and: viewState.documentOfferUiModel
      ) {
      case .success:
        router.push(
          with: retrieveSuccessRoute(
            with: .credentialOfferSuccessCaption([viewState.documentOfferUiModel.issuerName])
          )
        )
      case .failure(let error):
        setNewState(
          error: ContentErrorView.Config(
            description: .custom(error.localizedDescription),
            cancelAction: self.setNewState(error: nil)
          )
        )
      case .partialSuccess(let notIssued):
        router.push(
          with: retrieveSuccessRoute(
            with: .credentialOfferPartialSuccessCaption(
              [
                viewState.documentOfferUiModel.issuerName, notIssued.joined(separator: ", ")
              ]
            )
          )
        )
      }
    }
  }

  func onShowCancelModal() {
    isCancelModalShowing = !isCancelModalShowing
  }

  func onPop() {
    isCancelModalShowing = false
    router.popTo(with: .issuanceAddDocument(config: viewState.config))
  }

  private func retrieveSuccessRoute(with key: LocalizableString.Key) -> AppRoute {

    var navigationType: UIConfig.Success.Button.NavigationType {
      return switch self.viewState.config.flow {
      case .noDocument: .push(screen: .dashboard)
      case .extraDocument: .pop(screen: .dashboard)
      }
    }

    return .success(
      config: UIConfig.Success(
        title: .success,
        subtitle: key,
        buttons: [
          .init(
            title: .credentialOfferSuccessButton,
            style: .primary,
            navigationType: navigationType
          )
        ],
        visualKind: .defaultIcon
      )
    )
  }

  private func setNewState(
    isLoading: Bool = false,
    error: ContentErrorView.Config? = nil,
    documentOfferUiModel: DocumentOfferUIModel? = nil,
    allowIssue: Bool? = nil
  ) {
    setState { previousSate in
        .init(
          isLoading: isLoading,
          documentOfferUiModel: documentOfferUiModel ?? previousSate.documentOfferUiModel,
          error: error,
          config: previousSate.config,
          offerUri: previousSate.offerUri,
          allowIssue: allowIssue ?? previousSate.allowIssue
        )
    }
  }
}
