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
import feature_common

struct WelcomeState: ViewState {
  let isAnimating: Bool
}

final class WelcomeViewModel<Router: RouterHost>: BaseViewModel<Router, WelcomeState> {

  private let interactor: WelcomeInteractor

  init(
    router: Router,
    interactor: WelcomeInteractor
  ) {
    self.interactor = interactor
    super.init(router: router, initialState: .init(isAnimating: true))
  }

  func onAnimationCompletion() {
    setNewState(isAnimating: false)
  }

  func onClickFAQ() {
    router.push(with: .faqs)
  }

  func onClickLogin() {
    router.push(with: .quickPin(config: QuickPinUiConfig(flow: .set)))
  }

  private func setNewState(
  isAnimating: Bool? = nil
  ) {
    setState { previous in
        .init(isAnimating: isAnimating ?? previous.isAnimating)
    }
  }
}
