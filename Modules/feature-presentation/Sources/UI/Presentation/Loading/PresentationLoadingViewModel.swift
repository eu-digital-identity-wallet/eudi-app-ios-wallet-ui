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

@MainActor
final class PresentationLoadingViewModel<Router: RouterHostType, Interactor: PresentationInteractorType>: BaseLoadingViewModel<Router> {

  private let interactor: Interactor
  private let relyingParty: String

  init(
    router: Router,
    interactor: Interactor,
    relyingParty: String
  ) {
    self.interactor = interactor
    self.relyingParty = relyingParty
    super.init(router: router)
  }

  override func getTitle() -> LocalizableString.Key {
    .requestDataTitle([relyingParty])
  }

  override func getCaption() -> LocalizableString.Key {
    .pleaseWait
  }

  override func getOnSuccessRoute() -> AppRoute? {
    .success(
      config: UIConfig.Success(
        title: .success,
        subtitle: .requestDataShareSuccess([relyingParty]),
        buttons: [
          .init(
            title: .okButton,
            screen: .dashboard,
            style: .primary,
            navigationType: .pop()
          )
        ],
        visualKind: .defaultIcon
      )
    )
  }

  override func getOnPopRoute() -> AppRoute? {
    .dashboard
  }

  override func doWork() async {
    switch await interactor.onSendResponse() {
    case .success:
      self.onNavigate(type: .push)
    case .failure(let error):
      self.onError(with: error)
    }
  }
}
