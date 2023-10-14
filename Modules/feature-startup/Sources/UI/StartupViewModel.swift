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
import Foundation
import logic_ui
import feature_common
import logic_business

struct StartupState: ViewState {}

@MainActor
final class StartupViewModel<Router: RouterHostType, Interactor: StartupInteractorType>: BaseViewModel<Router, StartupState> {

  private let interactor: Interactor

  init(router: Router, interactor: Interactor) {
    self.interactor = interactor
    super.init(router: router, initialState: .init())
  }

  func onClickOnlineLoading() {
    router.push(with: .authenticationLoader)
  }

  func onClickTestSuccess() {
    router.push(
      with: .success(
        config: successConfig()
      )
    )
  }

  func onClickFAQ() {
    router.push(with: .faqs)
  }

  func onClickBiometry() {
    router.push(
      with: .biometry(
        config: UIConfig.Biometry(
          title: .genericErrorTitle,
          caption: .genericErrorDesc,
          quickPinOnlyCaption: .genericErrorDesc,
          navigationSuccessConfig: .init(screen: .success(config: successConfig()), navigationType: .push),
          navigationBackConfig: .init(screen: .startup, navigationType: .pop),
          isPreAuthorization: false,
          shouldInitializeBiometricOnCreate: true
        )
      )
    )
  }

  private func successConfig() -> UIConfig.Success {
    return UIConfig.Success(
      title: .custom("LITERAL PLACEHOLDER"),
      subtitle: .custom("LITERAL PLACEHOLDER"),
      buttons: [
        .init(title: .custom("LITERAL PLACEHOLDER"), screen: .startup, style: .primary, navigationType: .pop)
      ],
      visualKind: .defaultIcon
    )
  }
}
