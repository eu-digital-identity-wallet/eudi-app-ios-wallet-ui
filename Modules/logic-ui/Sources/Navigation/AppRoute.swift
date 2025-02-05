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

public enum FeatureStartupRouteModule: AppRouteModule {

  case startup

  public var info: (key: String, arguments: [String: String]) {
    return switch self {
    case .startup:
      (key: "Startup", arguments: [:])
    }
  }
}

public enum FeatureCommonRouteModule: AppRouteModule {

  case quickPin(config: any UIConfigType)
  case qrScanner(config: any UIConfigType)
  case biometry(config: any UIConfigType)
  case success(config: any UIConfigType)
  case issuanceAddDocumentOptions(config: any UIConfigType)

  public var info: (key: String, arguments: [String: String]) {
    return switch self {
    case .success(let config):
      (key: "Success", arguments: ["config": config.log])
    case .biometry(let config):
      (key: "Biometry", arguments: ["config": config.log])
    case .quickPin(let config):
      (key: "QuickPin", arguments: ["config": config.log])
    case .qrScanner(config: let config):
      (key: "QRScanner", arguments: ["config": config.log])
    case .issuanceAddDocumentOptions(let config):
      (key: "issuanceAddDocumentOptions", arguments: ["config": config.log])
    }
  }
}

public enum FeatureDashboardRouteModule: AppRouteModule {

  case dashboard
  case signDocument
  case sideMenu

  public var info: (key: String, arguments: [String: String]) {
    return switch self {
    case .dashboard:
      (key: "Dashboard", arguments: [:])
    case .signDocument:
      (key: "SignDocument", arguments: [:])
    case .sideMenu:
      (key: "SideMenu", arguments: [:])
    }
  }
}

public indirect enum FeaturePresentationRouteModule: AppRouteModule {

  case presentationLoader(
    String,
    presentationCoordinator: RemoteSessionCoordinator,
    originator: AppRoute,
    [any Routable]
  )
  case presentationRequest(
    presentationCoordinator: RemoteSessionCoordinator,
    originator: AppRoute
  )
  case presentationSuccess(
    config: any UIConfigType,
    [any Routable]
  )

  public var info: (key: String, arguments: [String: String]) {
    return switch self {
    case .presentationLoader(let id, _, let originator, _):
      (key: "PresentationLoader", arguments: ["id": id, "originator": originator.info.key])
    case .presentationRequest(_, let originator):
      (key: "PresentationRequest", arguments: ["originator": originator.info.key])
    case .presentationSuccess(let config, _):
      (key: "PresentationSuccess", arguments: ["config": config.log])
    }
  }
}

public indirect enum FeatureProximityRouteModule: AppRouteModule {

  case proximityConnection(
    presentationCoordinator: ProximitySessionCoordinator,
    originator: AppRoute
  )
  case proximityRequest(
    presentationCoordinator: ProximitySessionCoordinator,
    originator: AppRoute
  )
  case proximityLoader(
    String,
    presentationCoordinator: ProximitySessionCoordinator,
    originator: AppRoute,
    [any Routable]
  )
  case proximitySuccess(
    config: any UIConfigType,
    [any Routable]
  )

  public var info: (key: String, arguments: [String: String]) {
    return switch self {
    case .proximityConnection(_, let originator):
      (key: "ProximityConnection", arguments: ["originator": originator.info.key])
    case .proximityRequest(_, let originator):
      (key: "ProximityRequest", arguments: ["originator": originator.info.key])
    case .proximityLoader(let id, _, let originator, _):
      (key: "ProximityLoader", arguments: ["id": id, "originator": originator.info.key])
    case .proximitySuccess:
      (key: "ProximitySuccess", arguments: [:])
    }
  }
}

public enum FeatureIssuanceRouteModule: AppRouteModule {

  case issuanceAddDocument(config: any UIConfigType)
  case issuanceDocumentDetails(config: any UIConfigType)
  case issuanceSuccess(config: any UIConfigType, requestItems: [any Routable])
  case credentialOfferRequest(config: any UIConfigType)
  case issuanceCode(config: any UIConfigType)

  public var info: (key: String, arguments: [String: String]) {
    return switch self {
    case .issuanceAddDocument(let config):
      (key: "IssuanceAddDocument", arguments: ["config": config.log])
    case .issuanceDocumentDetails(let config):
      (key: "IssuanceDocumentDetails", arguments: ["config": config.log])
    case .issuanceSuccess(let config, _):
      (key: "IssuanceSuccess", arguments: ["config": config.log])
    case .issuanceCode(let config):
      (key: "IssuanceCode", arguments: ["config": config.log])
    case .credentialOfferRequest(let config):
      (key: "CredentialOfferRequest", arguments: ["config": config.log])
    }
  }
}

public enum AppRoute: AppRouteModule {

  case featureStartupModule(FeatureStartupRouteModule)
  case featureDashboardModule(FeatureDashboardRouteModule)
  case featureCommonModule(FeatureCommonRouteModule)
  case featureIssuanceModule(FeatureIssuanceRouteModule)
  case featurePresentationModule(FeaturePresentationRouteModule)
  case featureProximityModule(FeatureProximityRouteModule)

  public var info: (key: String, arguments: [String: String]) {
    return switch self {
    case .featureStartupModule(let module):
      module.info
    case .featureDashboardModule(let module):
      module.info
    case .featureCommonModule(let module):
      module.info
    case .featureIssuanceModule(let module):
      module.info
    case .featurePresentationModule(let module):
      module.info
    case .featureProximityModule(let module):
      module.info
    }
  }
}
