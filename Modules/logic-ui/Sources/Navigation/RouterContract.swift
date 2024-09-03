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
import logic_core

public indirect enum AppRoute: Equatable {

  public static func == (lhs: AppRoute, rhs: AppRoute) -> Bool {
    return lhs.info.key == rhs.info.key
  }

  case startup
  case success(config: any UIConfigType)
  case faqs
  case dashboard
  case biometry(config: any UIConfigType)
  case presentationLoader(
    String,
    presentationCoordinator: PresentationSessionCoordinator,
    originator: AppRoute
  )
  case presentationRequest(
    presentationCoordinator: PresentationSessionCoordinator,
    originator: AppRoute
  )
  case welcome
  case proximityConnection(presentationCoordinator: PresentationSessionCoordinator, originator: AppRoute)
  case proximityRequest(
    presentationCoordinator: PresentationSessionCoordinator,
    originator: AppRoute
  )
  case proximityLoader(
    String,
    presentationCoordinator: PresentationSessionCoordinator,
    originator: AppRoute
  )
  case quickPin(config: any UIConfigType)
  case issuanceAddDocument(config: any UIConfigType)
  case issuanceDocumentDetails(config: any UIConfigType)
  case issuanceSuccess(config: any UIConfigType, documentIdentifier: String)
  case qrScanner(config: any UIConfigType)
  case credentialOfferRequest(config: any UIConfigType)
  case issuanceCode(config: any UIConfigType)

  public var info: (key: String, arguments: [String: String]) {
    return switch self {
    case .startup:
      (key: "Startup", arguments: [:])
    case .faqs:
      (key: "FAQ", arguments: [:])
    case .success(let config):
      (key: "Success", arguments: ["config": config.log])
    case .dashboard:
      (key: "Dashboard", arguments: [:])
    case .biometry(let config):
      (key: "Biometry", arguments: ["config": config.log])
    case .welcome:
      (key: "Welcome", arguments: [:])
    case .presentationLoader(let id, _, let originator):
      (key: "PresentationLoader", arguments: ["id": id, "originator": originator.info.key])
    case .presentationRequest(_, let originator):
      (key: "PresentationRequest", arguments: ["originator": originator.info.key])
    case .proximityConnection(_, let originator):
      (key: "ProximityConnection", arguments: ["originator": originator.info.key])
    case .proximityRequest(_, let originator):
      (key: "ProximityRequest", arguments: ["originator": originator.info.key])
    case .proximityLoader(let id, _, let originator):
      (key: "ProximityLoader", arguments: ["id": id, "originator": originator.info.key])
    case .quickPin(let config):
      (key: "QuickPin", arguments: ["config": config.log])
    case .issuanceAddDocument(let config):
      (key: "IssuanceAddDocument", arguments: ["config": config.log])
    case .issuanceDocumentDetails(let config):
      (key: "IssuanceDocumentDetails", arguments: ["config": config.log])
    case .issuanceSuccess(let config, let id):
      (key: "IssuanceSuccess", arguments: ["id": id, "config": config.log])
    case .qrScanner(config: let config):
      (key: "QRScanner", arguments: ["config": config.log])
    case .credentialOfferRequest(let config):
      (key: "CredentialOfferRequest", arguments: ["config": config.log])
    case .issuanceCode(let config):
      (key: "IssuanceCode", arguments: ["config": config.log])
    }
  }
}

public protocol RouterHost {
  func push(with route: AppRoute)
  func popTo(with route: AppRoute, inclusive: Bool, animated: Bool)
  func pop(animated: Bool)
  func pop()
  func popTo(with route: AppRoute, inclusive: Bool)
  func popTo(with route: AppRoute)
  func composeApplication() -> AnyView
  func getCurrentScreen() -> AppRoute?
  func getToolbarConfig() -> UIConfig.ToolBar
  func userIsLoggedInWithDocuments() -> Bool
  func userIsLoggedInWithNoDocuments() -> Bool
  func isScreenForeground(with route: AppRoute) -> Bool
  func isScreenOnBackStack(with route: AppRoute) -> Bool
}

public class PreviewRouter: RouterHost {

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

  public func userIsLoggedInWithDocuments() -> Bool {
    false
  }

  public func userIsLoggedInWithNoDocuments() -> Bool {
    true
  }

  public func isScreenForeground(with route: AppRoute) -> Bool {
    false
  }

  public func isScreenOnBackStack(with route: AppRoute) -> Bool {
    true
  }
}
