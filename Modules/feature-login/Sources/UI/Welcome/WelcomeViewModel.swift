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

struct WelcomeState: ViewState {
  let isAnimating: Bool
}

@MainActor
final class WelcomeViewModel<Router: RouterHostType, Interactor: WelcomeInteractorType>: BaseViewModel<Router, WelcomeState> {

  private let interactor: Interactor

  init(
    router: Router,
    interactor: Interactor
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
    router.push(with: .dashboard)
  }

  private func setNewState(
  isAnimating: Bool? = nil
  ) {
    setState { previous in
        .init(isAnimating: isAnimating ?? previous.isAnimating)
    }
  }
}
