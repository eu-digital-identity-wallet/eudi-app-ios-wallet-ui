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
import SwiftUI

public indirect enum AppRoute: Equatable {

  public static func == (lhs: AppRoute, rhs: AppRoute) -> Bool {
    return lhs.key == rhs.key
  }

  case startup
  case success(config: any UIConfigType)
  case faqs
  case dashboard
  case biometry(config: any UIConfigType)
  case authenticationLoader

  var key: String {
    return switch self {
    case .startup:
      "Startup"
    case .faqs:
      "FAQ"
    case .success:
      "Success"
    case .dashboard:
      "Dashboard"
    case .biometry:
      "Biometry"
    case .authenticationLoader:
      "AuthenticationLoader"
    }
  }
}

public protocol RouterHostType {
  func push(with route: AppRoute)
  func popTo(with route: AppRoute, inclusive: Bool, animated: Bool)
  func pop(animated: Bool)
  func popTo(with route: AppRoute, inclusive: Bool)
  func popTo(with route: AppRoute)
  func composeApplication() -> AnyView
  func getCurrentScreen() -> AppRoute?
}

public class PreviewRouter: RouterHostType {

  public init() {}

  public func push(with route: AppRoute) {}

  public func popTo(with route: AppRoute, inclusive: Bool, animated: Bool) {}

  public func popTo(with route: AppRoute, inclusive: Bool) {}

  public func popTo(with route: AppRoute) {}

  public func pop(animated: Bool) {}

  public func composeApplication() -> AnyView { EmptyView().eraseToAnyView() }

  public func getCurrentScreen() -> AppRoute? { .none }
}
