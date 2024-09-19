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
import logic_business

final class ProximityRequestViewModel<Router: RouterHost>: BaseRequestViewModel<Router> {

  private let interactor: ProximityInteractor

  init(
    router: Router,
    interactor: ProximityInteractor,
    originator: AppRoute
  ) {
    self.interactor = interactor
    super.init(router: router, originator: originator)

    Task {
      await self.subscribeToCoordinatorPublisher()
    }
  }

  func subscribeToCoordinatorPublisher() async {
    await interactor.getSessionStatePublisher()
      .sink { state in
        switch state {
        case .error(let error):
          self.onError(with: error)
        default:
          ()
        }
      }
      .store(in: &cancellables)
  }

  override func doWork() async {
    self.onStartLoading()
    switch await interactor.onRequestReceived() {
    case .success(let items, let relyingParty, _, let isTrusted):
      self.onReceivedItems(
        with: items,
        title: .requestDataTitle([relyingParty]),
        relyingParty: relyingParty,
        isTrusted: isTrusted
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
          self?.router.pop()
        }
      case .failure(let error):
        self?.onError(with: error)
      }
    }
  }

  override func getSuccessRoute() -> AppRoute? {
    .featureCommonModule(
      .biometry(
        config: UIConfig.Biometry(
          title: getTitle(),
          caption: .requestDataShareBiometryCaption,
          quickPinOnlyCaption: .requestDataShareQuickPinCaption,
          navigationSuccessType: .push(
            .featureProximityModule(
              .proximityLoader(
                getRelyingParty(),
                presentationCoordinator: interactor.presentationSessionCoordinator,
                originator: getOriginator()
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
}
