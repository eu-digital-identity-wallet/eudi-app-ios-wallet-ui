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
  let config: UIConfig.Generic
  let offerUri: String
  let allowIssue: Bool

  var title: LocalizableString.Key {
    return .requestCredentialOfferTitle([documentOfferUiModel.issuerName])
  }

  var successNavigation: UIConfig.TwoWayNavigationType {
    return config.navigationSuccessType
  }

  var cancelNavigation: UIConfig.ThreeWayNavigationType {
    return config.navigationCancelType
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
      let config = config as? UIConfig.Generic,
      let offerUri = config.arguments["uri"]
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

    if let code = viewState.documentOfferUiModel.txCode {
      router.push(
        with: .issuanceCode(
          config: IssuanceCodeUiConfig(
            offerUri: viewState.offerUri,
            issuerName: viewState.documentOfferUiModel.issuerName,
            txCodeLength: code.codeLenght,
            docOffers: viewState.documentOfferUiModel.docOffers,
            successNavigation: viewState.successNavigation,
            navigationCancelType: .pop
          )
        )
      )
      return
    }

    Task {
      setNewState(isLoading: true)
      switch await self.interactor.issueDocuments(
        with: viewState.offerUri,
        issuerName: viewState.documentOfferUiModel.issuerName,
        docOffers: viewState.documentOfferUiModel.docOffers,
        successNavigation: viewState.successNavigation,
        txCodeValue: nil
      ) {
      case .success(let route):
        router.push(with: route)
      case .failure(let error):
        setNewState(
          error: ContentErrorView.Config(
            description: .custom(error.localizedDescription),
            cancelAction: self.setNewState(error: nil)
          )
        )
      case .partialSuccess(let route):
        router.push(with: route)
      }
    }
  }

  func onShowCancelModal() {
    isCancelModalShowing = !isCancelModalShowing
  }

  func onPop() {
    isCancelModalShowing = false
    switch viewState.cancelNavigation {
    case .popTo(let route):
      router.popTo(with: route)
    case .push(let route):
      router.push(with: route)
    case .pop:
      router.pop()
    }
  }

  func handleNotification(with info: [AnyHashable: Any]) {
    guard let uri = info["uri"] as? String else {
      return
    }
    setNewState(
      isLoading: true,
      documentOfferUiModel: DocumentOfferUIModel.mock(),
      allowIssue: false,
      config: .init(
        arguments: ["uri": uri],
        navigationSuccessType: viewState.config.navigationSuccessType,
        navigationCancelType: viewState.config.navigationCancelType
      ),
      offerUri: uri
    )
    Task {
      await self.processRequest()
    }
  }

  private func setNewState(
    isLoading: Bool = false,
    error: ContentErrorView.Config? = nil,
    documentOfferUiModel: DocumentOfferUIModel? = nil,
    allowIssue: Bool? = nil,
    config: UIConfig.Generic? = nil,
    offerUri: String? = nil
  ) {
    setState { previousSate in
        .init(
          isLoading: isLoading,
          documentOfferUiModel: documentOfferUiModel ?? previousSate.documentOfferUiModel,
          error: error,
          config: config ?? previousSate.config,
          offerUri: offerUri ?? previousSate.offerUri,
          allowIssue: allowIssue ?? previousSate.allowIssue
        )
    }
  }
}
