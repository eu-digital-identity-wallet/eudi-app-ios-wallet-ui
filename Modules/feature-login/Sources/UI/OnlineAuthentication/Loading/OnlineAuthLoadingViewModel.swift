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
final class OnlineAuthLoadingViewModel<Router: RouterHostType, Interactor: OnlineAuthInteractorType>: BaseLoadingViewModel<Router> {

  private let interactor: Interactor

  init(router: Router, interactor: Interactor) {
    self.interactor = interactor
    super.init(router: router)
  }

  override func getTitle() -> LocalizableString.Key {
    .custom("TEST TEST TEST TEST TEST TEST TEST")
  }

  override func getCaption() -> LocalizableString.Key {
    .custom("TEST TEST TEST TEST TEST TEST TEST")
  }

  override func getOnSuccessRoute() -> AppRoute? {
    .success(
      config: UIConfig.Success(
        title: .custom("TEST"),
        subtitle: .custom("TEST"),
        buttons: [.init(title: .custom("BUTTON TEST"), screen: .startup, style: .primary, navigationType: .pop)],
        visualKind: .defaultIcon
      )
    )
  }

  override func getOnPopRoute() -> AppRoute? {
    .startup
  }

  override func doWork() async {
    switch await interactor.testWork() {
    case .success:
      self.onNavigate(type: .push)
    case .failure(let error):
      self.onError(with: error)
    }
  }
}
