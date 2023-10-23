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

struct StartupState: ViewState {
  let config: UIConfig.Startup
  let isAnimating: Bool
  let setupError: Error?
}

@MainActor
final class StartupViewModel<Router: RouterHostType, Interactor: StartupInteractorType>: BaseViewModel<Router, StartupState> {

  private let interactor: Interactor

  init(
    router: Router,
    interactor: Interactor,
    config: any UIConfigType = UIConfig.Startup(splashDuration: 1.5)
  ) {

    guard let config = config as? UIConfig.Startup else {
      fatalError("BiometryViewModel:: Invalid configuraton")
    }

    self.interactor = interactor
    super.init(
      router: router,
      initialState: .init(
        config: config,
        isAnimating: false,
        setupError: nil)
    )
  }

  func startAnimatingSplash() {
    self.setNewState(isAnimating: true)
  }

  func setup() async {
    do {
      switch try await interactor.splashSetup(splashAnimationDuration: viewState.config.splashDuration) {
      case .success:
        splashFinished()
      case .failure(let error):
        self.setNewState(setupError: error)
      }
    } catch {
      self.setNewState(setupError: error)
    }
  }

  func splashFinished() {
    self.setNewState(isAnimating: false)
    router.push(with: .dashboard)
  }

  private func setNewState(
    isAnimating: Bool? = nil,
    setupError: Error? = nil
  ) {
    setState { previous in
        .init(config: previous.config,
              isAnimating: isAnimating ?? previous.isAnimating,
              setupError: setupError ?? previous.setupError)
    }
  }
}
