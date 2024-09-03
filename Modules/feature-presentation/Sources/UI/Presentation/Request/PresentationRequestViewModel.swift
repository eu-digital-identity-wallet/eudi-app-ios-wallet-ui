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

import feature_common
import logic_core

final class PresentationRequestViewModel<Router: RouterHost>: BaseRequestViewModel<Router> {

  private let interactor: PresentationInteractor

  init(
    router: Router,
    interactor: PresentationInteractor,
    originator: AppRoute
  ) {
    self.interactor = interactor
    super.init(router: router, originator: originator)
  }

  override func doWork() async {
    self.onStartLoading()
    switch await interactor.onDeviceEngagement() {
    case .success(let authenticationRequest):
      self.onReceivedItems(
        with: authenticationRequest.requestDataCells,
        title: .requestDataTitle([authenticationRequest.relyingParty]),
        relyingParty: authenticationRequest.relyingParty,
        isTrusted: authenticationRequest.isTrusted
      )
    case .failure:
      self.onEmptyDocuments()
    }
  }

  override func onShare() {
    Task { [weak self] in
      guard
        let items = self?.viewState.items,
        let response = await self?.interactor.onResponsePrepare(requestItems: items)
      else {
        return
      }
      switch response {
      case .success:
        if let route = self?.getSuccessRoute() {
          self?.router.push(with: route)
        } else {
          self?.router.popTo(with: self?.getPopRoute() ?? .dashboard)
        }
      case .failure(let error):
        self?.onError(with: error)
      }
    }
  }

  override func getSuccessRoute() -> AppRoute? {
    .biometry(
      config: UIConfig.Biometry(
        title: getTitle(),
        caption: .requestDataShareBiometryCaption,
        quickPinOnlyCaption: .requestDataShareQuickPinCaption,
        navigationSuccessType: .push(
          .presentationLoader(
            getRelyingParty(),
            presentationCoordinator: interactor.presentationCoordinator,
            originator: getOriginator()
          )
        ),
        navigationBackType: .pop,
        isPreAuthorization: false,
        shouldInitializeBiometricOnCreate: true
      )
    )
  }

  override func getPopRoute() -> AppRoute? {
    return getOriginator()
  }

  override func getTitle() -> LocalizableString.Key {
    viewState.title
  }

  override func getCaption() -> LocalizableString.Key {
    .requestDataCaption
  }

  override func getDataRequestInfo() -> LocalizableString.Key {
    .requestDataInfoNotice
  }

  override func getRelyingParty() -> String {
    viewState.relyingParty
  }

  override func getTitleCaption() -> String {
    LocalizableString.shared.get(with: .requestDataTitle([""]))
  }

  override func getTrustedRelyingParty() -> LocalizableString.Key {
    .requestDataVerifiedEntity
  }

  override func getTrustedRelyingPartyInfo() -> LocalizableString.Key {
    .requestDataVerifiedEntityMessage
  }

  func handleDeepLinkNotification(with info: [AnyHashable: Any]) {
    guard let session = info["session"] as? PresentationSessionCoordinator else {
      return
    }
    resetState()
    interactor.updatePresentationCoordinator(with: session)
    Task { await doWork() }
  }
}
