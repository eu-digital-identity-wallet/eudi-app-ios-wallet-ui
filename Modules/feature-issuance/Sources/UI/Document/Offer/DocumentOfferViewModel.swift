/*
 * Copyright (c) 2026 European Commission
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
import Observation

@Copyable
struct DocumentOfferViewState: ViewState {
  let isLoading: Bool
  let documentOfferUiModel: DocumentOfferUIModel
  let error: ContentErrorView.Config?
  let config: UIConfig.Generic
  let offerUri: String
  let allowIssue: Bool
  let initialized: Bool
  let issuerRegistration: RelyingPartyRegistrationData?

  var title: LocalizableStringKey {
    return .requestCredentialOfferTitle([documentOfferUiModel.issuerName])
  }

  var successNavigation: UIConfig.TwoWayNavigationType {
    return config.navigationSuccessType
  }

  var cancelNavigation: UIConfig.ThreeWayNavigationType {
    return config.navigationCancelType
  }
}

@Observable
final class DocumentOfferViewModel<Router: RouterHost>: ViewModel<Router, DocumentOfferViewState> {

  var isTrustBlockedAlertShowing: Bool = false
  var isRegistrationBlockedAlertShowing: Bool = false

  private let interactor: DocumentOfferInteractor

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
        allowIssue: false,
        initialized: false,
        issuerRegistration: nil
      )
    )
  }

  func initialize() async {

    if viewState.initialized {
      await handleResumeIssuance()
      return
    }

    let offerUri = viewState.offerUri

    let state = await interactor.processOfferRequest(with: offerUri)

    switch state {
    case .success(let uiModel, let issuerRegistration):
      setState {
        $0.copy(
          isLoading: false,
          documentOfferUiModel: uiModel,
          allowIssue: !uiModel.uiOffers.isEmpty,
          initialized: true
        )
        .copy(error: nil)
        .copy(
          issuerRegistration: issuerRegistration.toRegistrationData(
            issuerName: uiModel.issuerName,
            issuerLogo: uiModel.issuerLogo
          )
        )
      }
    case .registrationBlocked:
      setState {
        $0.copy(
          isLoading: false,
          documentOfferUiModel: DocumentOfferUIModel.empty(),
          allowIssue: false,
          initialized: false
        ).copy(error: nil)
      }
      isRegistrationBlockedAlertShowing = true
    case .issuerNotTrusted:
      setState {
        $0.copy(
          isLoading: false,
          documentOfferUiModel: DocumentOfferUIModel.empty(),
          allowIssue: false,
          initialized: false
        ).copy(error: nil)
      }
      isTrustBlockedAlertShowing = true
    case .failure(let error):
      setState {
        $0.copy(
          isLoading: false,
          error: ContentErrorView.Config(
            description: .custom(error.errorMessage),
            cancelAction: self.onPop()
          ),
          allowIssue: false,
          initialized: true
        )
      }
    }
  }

  func onIssueDocuments() {

    if let code = viewState.documentOfferUiModel.txCode {
      router.push(
        with: .featureIssuanceModule(
          .issuanceCode(
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
      )
      return
    }

    Task {
      setState { $0.copy(isLoading: true).copy(error: nil) }

      let offerUri = viewState.offerUri
      let issuerName = viewState.documentOfferUiModel.issuerName
      let docOffers = viewState.documentOfferUiModel.docOffers
      let successNavigation = viewState.successNavigation

      let state = await interactor.issueDocuments(
        with: offerUri,
        issuerName: issuerName,
        docOffers: docOffers,
        successNavigation: successNavigation,
        txCodeValue: nil
      )

      switch state {
      case .success(let route):
        router.push(with: route)
      case .dynamicIssuance(let session):
        setState {
          $0.copy(
            isLoading: false
          )
        }
        router.push(
          with: .featurePresentationModule(
            .presentationRequest(
              presentationCoordinator: session,
              originator: .featureIssuanceModule(.credentialOfferRequest(config: viewState.config))
            )
          )
        )
      case .issuerNotTrusted:
        setState { $0.copy(isLoading: false).copy(error: nil) }
        isTrustBlockedAlertShowing = true
      case .failure(let error):
        setState {
          $0.copy(
            isLoading: false,
            error: .init(
              description: .custom(error.errorMessage),
              cancelAction: self.setState { $0.copy(error: nil) }
            )
          )
        }
      case .partialSuccess(let route):
        router.push(with: route)
      case .deferredSuccess(let route):
        router.push(with: route)
      }
    }
  }

  func onRegistrationBlockedClose() {
    isRegistrationBlockedAlertShowing = false
    onPop()
  }

  func onTrustBlockedClose() {
    isTrustBlockedAlertShowing = false
    onPop()
  }

  func onPop() {
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
    setState {
      $0
        .copy(
          isLoading: true,
          documentOfferUiModel: DocumentOfferUIModel.mock(),
          config: .init(
            arguments: ["uri": uri],
            navigationSuccessType: viewState.config.navigationSuccessType,
            navigationCancelType: viewState.config.navigationCancelType
          ),
          offerUri: uri,
          allowIssue: false,
          initialized: false
        )
        .copy(error: nil)
        .copy(issuerRegistration: nil)
    }
    Task {
      await self.initialize()
    }
  }

  private func handleResumeIssuance() async {
    setState { $0.copy(isLoading: true) }

    let issuerName = viewState.documentOfferUiModel.issuerName
    let successNavigation = viewState.successNavigation

    let state = await interactor.resumeDynamicIssuance(
      issuerName: issuerName,
      successNavigation: successNavigation
    )

    switch state {
    case .success(let route):
      router.push(with: route)
    case .noPending:
      setState { $0.copy(isLoading: false) }
    case .issuerNotTrusted:
      setState { $0.copy(isLoading: false).copy(error: nil) }
      isTrustBlockedAlertShowing = true
    case .failure(let error):
      setState {
        $0.copy(
          isLoading: false,
          error: .init(
            description: .custom(error.errorMessage),
            cancelAction: self.setState { $0.copy(error: nil) }
          )
        )
      }
    }
  }

  func toolbarContent() -> ToolBarContent {
    .init(
      leadingActions: [
        .init(
          image: Theme.shared.image.xmark,
          accessibilityLocator: DocumentOfferLocators.cancelButton
        ) {
          self.onPop()
        }
      ]
    )
  }
}
