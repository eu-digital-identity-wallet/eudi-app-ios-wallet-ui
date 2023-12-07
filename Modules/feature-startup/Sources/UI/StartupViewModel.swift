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
      fatalError("StartupViewModel:: Invalid configuraton")
    }

    self.interactor = interactor
    super.init(
      router: router,
      initialState: .init(
        config: config,
        isAnimating: false,
        setupError: nil
      )
    )
  }

  func startAnimatingSplash() {
    self.setNewState(isAnimating: true)
  }

  func initialize() async {
    let route = await interactor.initialize(with: viewState.config.splashDuration)
    setNewState(isAnimating: false)
    router.push(with: route)
  }

  private func setNewState(
    isAnimating: Bool? = nil,
    setupError: Error? = nil
  ) {
    setState { previous in
        .init(
          config: previous.config,
          isAnimating: isAnimating ?? previous.isAnimating,
          setupError: setupError ?? previous.setupError
        )
    }
  }
}