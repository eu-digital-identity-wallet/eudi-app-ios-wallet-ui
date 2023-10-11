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
import UIPilot
import logic_ui
import SwiftUI
import logic_business
import feature_startup
import feature_login
import feature_common

public final class RouterHost: RouterHostType {

  private let pilot: UIPilot<AppRoute>

  public init() {
    self.pilot = UIPilot(
      initial: ConfigUiProvider.shared.getConfigUiLogic().initialRoute
    )
  }

  public func push(with route: AppRoute) {
    pilot.push(route)
  }

  public func popTo(with route: AppRoute, inclusive: Bool, animated: Bool) {
    pilot.popTo(route, inclusive: inclusive, animated: animated)
  }

  public func popTo(with route: AppRoute, inclusive: Bool) {
    pilot.popTo(route, inclusive: inclusive)
  }

  public func popTo(with route: AppRoute) {
    pilot.popTo(route)
  }

  public func pop(animated: Bool) {
    pilot.pop(animated: animated)
  }

  public func getCurrentScreen() -> AppRoute? {
    return pilot.routes.last
  }

  public func composeApplication() -> AnyView {
    return UIPilotHost(pilot) { route in
      switch route {
      case .startup:
        StartupView(with: self, and: StartupInteractor())
      case .faqs:
        FAQsView(with: self, and: FAQsInteractor())
      case .success(let config):
        SuccessView(with: self, and: config)
      }
    }.eraseToAnyView()
  }
}
