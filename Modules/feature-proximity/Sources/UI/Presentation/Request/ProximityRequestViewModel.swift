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

@MainActor
final class ProximityRequestViewModel<Router: RouterHostType, Interactor: ProximityInteractorType>: BaseRequestViewModel<Router> {

  private let interactor: Interactor

  init(
    router: Router,
    interactor: Interactor
  ) {
    self.interactor = interactor
    super.init(router: router)

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
    case .success(let items, let relyingParty, let dataRequestInfo, let isTrusted):
      self.onReceivedItems(
        with: items,
        title: .requestDataTitle([relyingParty]),
        relyingParty: relyingParty,
        isTrusted: isTrusted
      )
    case .failure(let error):
      self.onError(with: error)
    }
  }

  override func onShare() {
    Task {
      await switch interactor.onResponsePrepare(requestItems: viewState.items) {
      case .success:
        if let route = getSuccessRoute() {
          router.push(with: route)
        } else {
          router.pop()
        }
      case .failure(let error):
        self.onError(with: error)
      }
    }
  }

  override func getSuccessRoute() -> AppRoute? {
    .biometry(
      config: UIConfig.Biometry(
        title: getTitle(),
        caption: .requestDataShareBiometryCaption,
        quickPinOnlyCaption: .requestDataShareBiometryCaption,
        navigationSuccessConfig: .init(
          screen: .proximityLoader(
            getRelyingParty(),
            presentationCoordinator: interactor.presentationSessionCoordinator
          ),
          navigationType: .push
        ),
        navigationBackConfig: .init(
          screen: .proximityRequest(presentationCoordinator: interactor.presentationSessionCoordinator),
          navigationType: .pop
        ),
        isPreAuthorization: false,
        shouldInitializeBiometricOnCreate: true
      )
    )
  }

  override func getPopRoute() -> AppRoute? {
    return .dashboard
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

  override func getTitleCaption() -> LocalizableString.Key {
    .requestDataTitle([""])
  }

  override func getTrustedRelyingParty() -> LocalizableString.Key {
    .requestDataVerifiedEntity
  }

  override func getTrustedRelyingPartyInfo() -> LocalizableString.Key {
    .requestDataVerifiedEntityMessage
  }
}
