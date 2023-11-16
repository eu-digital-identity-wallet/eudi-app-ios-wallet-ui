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
  case crossDeviceLoader(String)
  case crossDeviceRequest
  case sameDeviceLoader(String)
  case sameDeviceRequest
  case welcome
  case addDocument
  case documentDetails(docoumentId: String)
  case proximityConnection
  case proximityRequest
  case proximityLoader(String)

  public var key: String {
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
    case .crossDeviceLoader:
      "CrossDeviceLoader"
    case .sameDeviceRequest:
      "SameDeviceRequest"
    case .welcome:
      "Welcome"
    case .documentDetails:
      "DocumentDetails"
    case .addDocument:
      "AddDocument"
    case .crossDeviceRequest:
      "CrossDeviceRequest"
    case .sameDeviceLoader:
      "SameDeviceLoader"
    case .proximityConnection:
      "ProximityConnection"
    case .proximityRequest:
      "ProximityRequest"
    case .proximityLoader:
      "ProximityLoader"
    }
  }
}

public protocol RouterHostType {
  func push(with route: AppRoute)
  func popTo(with route: AppRoute, inclusive: Bool, animated: Bool)
  func pop(animated: Bool)
  func pop()
  func popTo(with route: AppRoute, inclusive: Bool)
  func popTo(with route: AppRoute)
  func composeApplication() -> AnyView
  func getCurrentScreen() -> AppRoute?
  func getToolbarConfig() -> UIConfig.ToolBar
  func isAfterAuthorization() -> Bool
  func isScreenForeground(with route: AppRoute) -> Bool
}

public class PreviewRouter: RouterHostType {

  public init() {}

  public func push(with route: AppRoute) {}

  public func popTo(with route: AppRoute, inclusive: Bool, animated: Bool) {}

  public func popTo(with route: AppRoute, inclusive: Bool) {}

  public func popTo(with route: AppRoute) {}

  public func pop(animated: Bool) {}

  public func pop() {}

  public func composeApplication() -> AnyView { EmptyView().eraseToAnyView() }

  public func getCurrentScreen() -> AppRoute? { .none }

  public func getToolbarConfig() -> UIConfig.ToolBar { .init(.clear) }

  public func isAfterAuthorization() -> Bool {
    false
  }

  public func isScreenForeground(with route: AppRoute) -> Bool {
    true
  }

}
