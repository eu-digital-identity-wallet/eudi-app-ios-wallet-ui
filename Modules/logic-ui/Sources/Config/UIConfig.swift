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
import logic_resources

public protocol UIConfigType {
  var string: String { get }
}

public struct NoConfig: UIConfigType {
  public var string: String {
    return ""
  }
}

public struct UIConfig {}

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

public extension UIConfig {
  struct ToolBar: Equatable {

    public let backgroundColor: Color

    public init(_ backgroundColor: Color) {
      self.backgroundColor = backgroundColor
    }
  }
}
