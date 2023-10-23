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
import logic_resources

public protocol UIConfigType {
}

public struct UIConfig {
  public static let screenBackgroundColor: [String: Color] = [
    AppRoute.dashboard.key: Theme.shared.color.primary,
    AppRoute.startup.key: Theme.shared.color.primary
  ]
}

public extension UIConfig {

  struct NavigationConfig: Equatable {

    public enum NavigationType: Equatable {
      case pop
      case push
    }

    public let screen: AppRoute
    public let navigationType: NavigationType

    public init(
      screen: AppRoute,
      navigationType: NavigationType
    ) {
      self.screen = screen
      self.navigationType = navigationType
    }
  }
}
