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

@Copyable
struct DocumentOfferViewState: ViewState {
  let isLoading: Bool
  let documentOfferUiModel: DocumentOfferUIModel
  let error: ContentErrorView.Config?
  let config: UIConfig.Generic
  let offerUri: String
  let allowIssue: Bool
  let initialized: Bool
  let contentHeaderConfig: ContentHeaderConfig

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

final class DocumentOfferViewModel<Router: RouterHost>: ViewModel<Router, DocumentOfferViewState> {

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
        contentHeaderConfig: .init(
          appIconAndTextData: AppIconAndTextData(
            appIcon: ThemeManager.shared.image.logoEuDigitalIndentityWallet,
            appText: ThemeManager.shared.image.euditext
          )
        )
      )
    )
  }

  func initialize() async {

    if viewState.initialized {
      await handleResumeIssuance()
      return
    }

    let offerUri = viewState.offerUri

    let state = await Task.detached { () -> OfferRequestPartialState in
      return await self.interactor.processOfferRequest(with: offerUri)
    }.value

    switch state {
    case .success(let uiModel):
      setState {
        $0.copy(
          isLoading: false,
          documentOfferUiModel: uiModel,
          allowIssue: !uiModel.uiOffers.isEmpty,
          initialized: true,
          contentHeaderConfig: .init(
            appIconAndTextData: AppIconAndTextData(
              appIcon: ThemeManager.shared.image.logoEuDigitalIndentityWallet,
              appText: ThemeManager.shared.image.euditext
            ),
            description: .dataSharingTitle,
            mainText: .issuanceRequest,
            icon: .remoteImage(uiModel.issuerLogo, nil),
            relyingPartyData: RelyingPartyData(
              isVerified: false,
              name: .custom(uiModel.issuerName),
              description: .issuerWantWalletAddition
            )
          )
        ).copy(error: nil)
      }
    case .failure(let error):
      setState {
        $0.copy(
          isLoading: false,
          error: ContentErrorView.Config(
            description: .custom(error.localizedDescription),
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

      let state = await Task.detached { () -> OfferResultPartialState in
        return await self.interactor.issueDocuments(
          with: offerUri,
          issuerName: issuerName,
          docOffers: docOffers,
          successNavigation: successNavigation,
          txCodeValue: nil
        )
      }.value

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
      case .failure(let error):
        setState {
          $0.copy(
            isLoading: false,
            error: .init(
              description: .custom(error.localizedDescription),
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
    }
    Task {
      await self.initialize()
    }
  }

  private func handleResumeIssuance() async {
    setState { $0.copy(isLoading: true) }

    let issuerName = viewState.documentOfferUiModel.issuerName
    let successNavigation = viewState.successNavigation

    let state = await Task.detached { () -> OfferDynamicIssuancePartialState in
      return await self.interactor.resumeDynamicIssuance(
        issuerName: issuerName,
        successNavigation: successNavigation
      )
    }.value

    switch state {
    case .success(let route):
      router.push(with: route)
    case .noPending:
      setState { $0.copy(isLoading: false) }
    case .failure(let error):
      setState {
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

  func toolbarContent() -> ToolBarContent {
    .init(
      trailingActions: [
        Action(
          title: .issueButton
        ) {
          self.onIssueDocuments()
        }
      ],
      leadingActions: [
        Action(
          title: .cancelButton
        ) {
          self.onPop()
        }
      ]
    )
  }
}
