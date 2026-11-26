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
import feature_common
import logic_core

final class PresentationRequestViewModel<Router: RouterHost>: BaseRequestViewModel<Router> {

  private let interactor: PresentationInteractor
  private var coordinator: RemoteSessionCoordinator?

  init(
    router: Router,
    interactor: PresentationInteractor,
    originator: AppRoute
  ) {
    self.interactor = interactor
    super.init(router: router, originator: originator)
  }

  override func doWork() async {

    onStartLoading()
    await getCoordinator()

    let result = await interactor.onDeviceEngagement()

    switch result {
    case .success(let authenticationRequest):
      self.onReceivedCombinations(
        with: authenticationRequest.requestDataCombinations,
        title: .requestDataTitle(
          [authenticationRequest.relyingParty]
        ),
        relyingParty: .custom(authenticationRequest.relyingParty),
        isTrusted: authenticationRequest.isTrusted
      )
      self.onReceivedRegistration(
        authenticationRequest.relyingPartyRegistration,
        isRelyingPartyTrusted: authenticationRequest.isTrusted
      )
    case .notSecuredRequest:
      self.onTrustBlocked()
    case .failure(let error):
      self.onEmptyDocuments(error: error.errorMessage)
      if let registration = await interactor.registrationForFailedRequest() {
        self.onReceivedRegistration(registration, isRelyingPartyTrusted: registration.isVerified)
      }
    }
  }

  /// Prepares the response from the screen as it is when Share is tapped, and shows the same documents on the
  /// success screen.
  override func onShare() {
    let items = viewState.items
    let combinationIndex = viewState.selectedCombinationIndex
    Task {

      let result = await interactor.onResponsePrepare(
        combinationIndex: combinationIndex,
        chosenDocumentIds: items.chosenDocumentIds()
      )

      switch result {
      case .success:
        if let route = self.getSuccessRoute(sharing: items) {
          self.router.push(with: route)
        } else {
          self.router.popTo(
            with: self.getPopRoute() ?? .featureDashboardModule(.dashboard)
          )
        }
      case .failure(let error):
        self.onError(with: error)
      }
    }
  }

  override func getSuccessRoute() -> AppRoute? {
    getSuccessRoute(sharing: viewState.items)
  }

  override func getPopRoute() -> AppRoute? {
    return getOriginator()
  }

  override func stopPresentation() async {
    await interactor.stopPresentation()
  }

  override func declineRequest() async {
    await interactor.onDeclineRequest()
  }

  override func getRelyingParty() -> LocalizableStringKey {
    viewState.relyingParty
  }

  /// The biometry route that shares `items`: the success screen lists only the documents they share.
  private func getSuccessRoute(sharing items: [RequestDataUiModel]) -> AppRoute? {
    guard let coordinator = self.coordinator else { return nil }
    return .featureCommonModule(
      .biometry(
        config: UIConfig.Biometry(
          navigationTitle: .biometryConfirmRequest,
          caption: .requestDataShareBiometryCaption,
          quickPinOnlyCaption: .requestDataShareQuickPinCaption,
          pinTextFieldTitle: .enterYourPin,
          navigationSuccessType: .push(
            .featurePresentationModule(
              .presentationLoader(
                relyingParty: getRelyingParty().toString,
                relyingPartyisTrusted: getRelyingPartyIsTrusted(),
                presentationCoordinator: coordinator,
                originator: getOriginator(),
                items: items.sharedDocuments().filterSelectedRows()
              )
            )
          ),
          navigationBackType: .pop,
          isPreAuthorization: false,
          shouldInitializeBiometricOnCreate: true
        )
      )
    )
  }

  private func getCoordinator() async {
    return switch await interactor.getCoordinator() {
    case .success(let remoteSessionCoordinator):
      self.coordinator = remoteSessionCoordinator
    case .failure:
      self.coordinator = nil
    }
  }
}
