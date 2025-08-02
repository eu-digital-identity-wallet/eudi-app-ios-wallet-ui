/*
 * Copyright (c) 2025 European Commission
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
import logic_resources

public typealias AppRouteKey = String

public protocol ConfigUiLogic: Sendable {

  var dashboardRoute: AppRoute { get }

  var issuanceRoute: AppRoute { get }

  var backgroundColorForScreenDictionary: [AppRouteKey: UIConfig.ToolBar] { get }

  init(themeConfiguration: ThemeConfiguration)
}

struct ConfigUiLogicImpl: ConfigUiLogic {

  public var backgroundColorForScreenDictionary: [AppRouteKey: UIConfig.ToolBar] = [
    AppRoute.featureDashboardModule(.dashboard).info.key: .init(Theme.shared.color.background),
    AppRoute.featureDashboardModule(.documentDetails(id: "")).info.key: .init(Theme.shared.color.background)
  ]

  public var dashboardRoute: AppRoute {
    return .featureDashboardModule(.dashboard)
  }

  var issuanceRoute: AppRoute {
    return .featureIssuanceModule(.issuanceAddDocument(config: NoConfig()))
  }

  public init(themeConfiguration: ThemeConfiguration) {
    Theme.config(themeConfiguration: themeConfiguration)
  }
}
