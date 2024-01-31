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
import logic_business

public indirect enum AppRoute: Equatable {

  public static func == (lhs: AppRoute, rhs: AppRoute) -> Bool {
    return lhs.info.key == rhs.info.key
  }

  case startup
  case success(config: any UIConfigType)
  case faqs
  case dashboard
  case biometry(config: any UIConfigType)
  case presentationLoader(String, presentationCoordinator: PresentationSessionCoordinatorType)
  case presentationRequest(presentationCoordinator: PresentationSessionCoordinatorType)
  case welcome
  case proximityConnection(presentationCoordinator: PresentationSessionCoordinatorType)
  case proximityRequest(presentationCoordinator: PresentationSessionCoordinatorType)
  case proximityLoader(String, presentationCoordinator: PresentationSessionCoordinatorType)
  case quickPin(config: any UIConfigType)
  case issuanceAddDocument(config: any UIConfigType)
  case issuanceDocumentDetails(config: any UIConfigType)
  case issuanceSuccess(config: any UIConfigType, documentIdentifier: String)

  public var info: (key: String, arguments: [String: String]) {
    return switch self {
    case .startup:
      (key: "Startup", arguments: [:])
    case .faqs:
      (key: "FAQ", arguments: [:])
    case .success(let config):
      (key: "Success", arguments: ["config": config.string])
    case .dashboard:
      (key: "Dashboard", arguments: [:])
    case .biometry(let config):
      (key: "Biometry", arguments: ["config": config.string])
    case .welcome:
      (key: "Welcome", arguments: [:])
    case .presentationLoader(let id, _):
      (key: "PresentationLoader", arguments: ["id": id])
    case .presentationRequest:
      (key: "PresentationRequest", arguments: [:])
    case .proximityConnection:
      (key: "ProximityConnection", arguments: [:])
    case .proximityRequest:
      (key: "ProximityRequest", arguments: [:])
    case .proximityLoader(let id, _):
      (key: "ProximityLoader", arguments: ["id": id])
    case .quickPin(let config):
      (key: "QuickPin", arguments: ["config": config.string])
    case .issuanceAddDocument(let config):
      (key: "IssuanceAddDocument", arguments: ["config": config.string])
    case .issuanceDocumentDetails(let config):
      (key: "IssuanceDocumentDetails", arguments: ["config": config.string])
    case .issuanceSuccess(let config, let id):
      (key: "IssuanceSuccess", arguments: ["id": id, "config": config.string])
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
