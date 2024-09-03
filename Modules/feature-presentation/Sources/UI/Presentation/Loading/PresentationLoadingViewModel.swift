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

final class PresentationLoadingViewModel<Router: RouterHost>: BaseLoadingViewModel<Router> {

  private let interactor: PresentationInteractor
  private let relyingParty: String

  init(
    router: Router,
    interactor: PresentationInteractor,
    relyingParty: String,
    originator: AppRoute
  ) {
    self.interactor = interactor
    self.relyingParty = relyingParty
    super.init(router: router, originator: originator)
  }

  override func getTitle() -> LocalizableString.Key {
    .requestDataTitle([relyingParty])
  }

  override func getCaption() -> LocalizableString.Key {
    .pleaseWait
  }

  private func getOnSuccessRoute(with url: URL?) -> AppRoute {

    var navigationType: UIConfig.DeepLinkNavigationType {
      guard let url else {
        return .pop(screen: getOriginator())
      }
      guard !isDynamicIssuance() else {
        interactor.storeDynamicIssuancePendingUrl(with: url)
        return .pop(screen: getOriginator())
      }
      return .deepLink(link: url, popToScreen: .dashboard)
    }

    return .success(
      config: UIConfig.Success(
        title: .init(value: .success),
        subtitle: .requestDataShareSuccess([relyingParty]),
        buttons: [
          .init(
            title: .requestDataShareButton,
            style: .primary,
            navigationType: navigationType
          )
        ],
        visualKind: .defaultIcon
      )
    )
  }

  private func isDynamicIssuance() -> Bool {
    guard
      getOriginator() == AppRoute.credentialOfferRequest(config: NoConfig()) ||
      getOriginator() == AppRoute.issuanceAddDocument(config: NoConfig()) ||
      getOriginator() == AppRoute.issuanceCode(config: NoConfig())
    else {
      return false
    }
    return true
  }

  override func getOnPopRoute() -> AppRoute? {
    .presentationRequest(
      presentationCoordinator: interactor.presentationCoordinator,
      originator: getOriginator()
    )
  }

  override func doWork() async {
    switch await interactor.onSendResponse() {
    case .success(let url):
      self.onNavigate(type: .push(getOnSuccessRoute(with: url)))
    case .failure(let error):
      self.onError(with: error)
    }
  }
}
