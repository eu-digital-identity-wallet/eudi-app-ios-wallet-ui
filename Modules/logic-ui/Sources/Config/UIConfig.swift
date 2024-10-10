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

public protocol UIConfigType: Sendable {
  var log: String { get }
}

public struct NoConfig: UIConfigType, Equatable {

  public var log: String {
    return ""
  }

  public init() {}
}

public struct UIConfig: Sendable {}

public extension UIConfig {
  struct ToolBar: Equatable, Sendable {

    public let backgroundColor: Color

    public init(_ backgroundColor: Color) {
      self.backgroundColor = backgroundColor
    }
  }
}

public extension UIConfig {
  enum TwoWayNavigationType: Equatable, Sendable {

    case popTo(AppRoute)
    case push(AppRoute)

    public var key: String {
      return switch self {
      case .popTo(let appRoute):
        "pop to \(appRoute)"
      case .push(let appRoute):
        "push to \(appRoute)"
      }
    }
  }

  enum ThreeWayNavigationType: Equatable, Sendable {
    case popTo(AppRoute)
    case pop
    case push(AppRoute)

    public var key: String {
      return switch self {
      case .popTo(let appRoute):
        "pop to \(appRoute)"
      case .push(let appRoute):
        "push to \(appRoute)"
      case .pop:
        "pop back"
      }
    }
  }

  enum DeepLinkNavigationType: Equatable, Sendable {

    case pop(screen: AppRoute, inclusive: Bool = false)
    case push(screen: AppRoute)
    case deepLink(link: URL, popToScreen: AppRoute)

    public var type: String {
      return switch self {
      case .pop(let screen, _):
        "pop to \(screen)"
      case .push(let screen):
        "push to \(screen)"
      case .deepLink(let link, _):
        "open \(link)"
      }
    }
  }
}

public extension UIConfig {
  struct Generic: UIConfigType, Equatable {

    public let arguments: [String: String]
    public let navigationSuccessType: TwoWayNavigationType
    public let navigationCancelType: ThreeWayNavigationType

    public var log: String {
      return "arguments: '\(arguments.values.joined(separator: ","))" +
      " onSuccessNav: \(navigationSuccessType.key)" +
      " onCancelNav: \(navigationCancelType.key)"
    }

    public init(
      arguments: [String: String],
      navigationSuccessType: TwoWayNavigationType,
      navigationCancelType: ThreeWayNavigationType
    ) {
      self.arguments = arguments
      self.navigationSuccessType = navigationSuccessType
      self.navigationCancelType = navigationCancelType
    }
  }
}
