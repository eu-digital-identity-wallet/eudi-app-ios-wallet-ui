/*
 * Copyright (c) 2025 European Commission
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

@Copyable
struct StartupState: ViewState {
  let splashDuration: TimeInterval
  let setupError: Error?
}

final class StartupViewModel<Router: RouterHost>: ViewModel<Router, StartupState> {

  private let interactor: StartupInteractor

  init(
    router: Router,
    interactor: StartupInteractor,
    splashDuration: TimeInterval = 1.5
  ) {
    self.interactor = interactor
    super.init(
      router: router,
      initialState: .init(
        splashDuration: splashDuration,
        setupError: nil
      )
    )
  }

  func initialize() async {
    let route = await interactor.initialize(with: viewState.splashDuration)
    router.push(with: route)
  }
}
