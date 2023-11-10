/*
 * Copyright (c) 2023 European Commission
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import feature_common

@MainActor
final class ProximityLoadingViewModel<Router: RouterHostType, Interactor: ProximityInteractorType>: BaseLoadingViewModel<Router> {

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
            navigationType: .pop
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
    switch await interactor.doWork() {
    case .success:
      self.onNavigate(type: .push)
    case .failure(let error):
      self.onError(with: error)
    }
  }
}
