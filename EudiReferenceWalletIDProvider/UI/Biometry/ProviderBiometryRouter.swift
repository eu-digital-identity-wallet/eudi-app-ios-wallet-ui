/*
 * Copyright (c) 2026 European Commission
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
import SwiftUI
import logic_ui

@MainActor
final class ProviderBiometryRouter: RouterHost {

  private let onPop: () -> Void

  init(onPop: @escaping () -> Void) {
    self.onPop = onPop
  }

  func pop() {
    onPop()
  }

  func push(with route: AppRoute) {}

  func popTo(with route: AppRoute, inclusive: Bool) {}

  func popTo(with route: AppRoute) {}

  func composeApplication() -> AnyView {
    EmptyView().eraseToAnyView()
  }

  func getCurrentScreen() -> AppRoute? {
    nil
  }

  func getToolbarConfig() -> UIConfig.ToolBar {
    .init(.clear)
  }

  func userIsLoggedInWithDocuments() -> Bool {
    false
  }

  func userIsLoggedInWithNoDocuments() -> Bool {
    true
  }

  func isScreenForeground(with route: AppRoute) -> Bool {
    false
  }

  func isScreenOnBackStack(with route: AppRoute) -> Bool {
    true
  }
}
