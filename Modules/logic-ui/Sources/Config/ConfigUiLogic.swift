/*
 * Copyright (c) 2026 European Commission
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

  /// The screens of an issuance, presentation or signing in progress, by `AppRoute.info.key`. On them the
  /// session lock waits `AuthenticationConfig.protectedFlowLockTimeout` in the background instead of
  /// `backgroundLockTimeout`, as the Android wallet's `protectedFlowScreens` do. The proximity QR screen is
  /// not one: leaving the app there once its code is shown stops the session and closes the screen.
  var protectedFlowRouteKeys: [AppRouteKey] { get }

  /// Whether the wallet hides its screens, and the ID Provider extension's, behind a cover while the screen is
  /// recorded, mirrored (AirPlay, QuickTime) or shared, and in the app switcher, as the Android wallet's
  /// `shouldPreventScreenCapture` keeps them out of captures and the recent-apps preview (`ScreenCaptureController`).
  /// Off in the reference configuration, so that its screens can be recorded in development and testing; a production
  /// build should turn it on. iOS cannot block a screenshot: the app learns of one only after it is taken.
  var hideContentWhileCaptured: Bool { get }

  /// The screens a locked wallet may show, by `AppRoute.info.key`: start-up and its login, PIN creation and
  /// the Trust Mark introduction, as the Android wallet's `loginScreens`. While locked, the navigation
  /// opens no other screen, and one already on the path sends the wallet back to start-up.
  var loginRouteKeys: [AppRouteKey] { get }

  /// The claims that hold a picture of the holder, by the last element of their path. A request for one of them
  /// shows a biometric-data notice, and Share asks for confirmation while it would be disclosed, as the Android
  /// wallet's `userImageClaimKeys`; add the claims your credentials use.
  var userImageClaimKeys: Set<String> { get }

  /// The Swift modules whose screens, presented over the wallet, cover it for the session lock
  /// (`SessionController.setCovered(_:)`): the RQES SDK's. Add the module of any SDK your build presents the same way.
  var coveringScreenModules: [String] { get }

  init(themeConfiguration: ThemeConfiguration)
}

public extension ConfigUiLogic {
  /// True when `route` is one of the `protectedFlowRouteKeys`.
  func isProtectedFlow(_ route: AppRoute?) -> Bool {
    guard let key = route?.info.key else { return false }
    return protectedFlowRouteKeys.contains(key)
  }

  /// True when `route` is one of the `loginRouteKeys`.
  func isLoginRoute(_ route: AppRoute) -> Bool {
    loginRouteKeys.contains(route.info.key)
  }
}

struct ConfigUiLogicImpl: ConfigUiLogic {

  /// Read on each use, so the toolbars follow the theme `Theme.config` sets, also when an integrator applies one
  /// after this configuration is created.
  public var backgroundColorForScreenDictionary: [AppRouteKey: UIConfig.ToolBar] {
    [
      AppRoute.featureDashboardModule(.dashboard).info.key: .init(Theme.shared.color.background),
      AppRoute.featureDashboardModule(.documentDetails(id: "")).info.key: .init(Theme.shared.color.background)
    ]
  }

  public var loginRouteKeys: [AppRouteKey] = [
    AppRoute.featureStartupModule(.startup).info.key,
    AppRoute.featureCommonModule(.biometry(config: NoConfig())).info.key,
    AppRoute.featureCommonModule(.quickPin(config: NoConfig())).info.key,
    AppRoute.featureCommonModule(.trustMark(config: NoConfig())).info.key
  ]

  /// The presentation and proximity routes carry a session coordinator, so their keys are written out;
  /// `TestConfigUiLogic` checks them against `AppRoute.info.key`.
  public var protectedFlowRouteKeys: [AppRouteKey] = [
    AppRoute.featureIssuanceModule(.issuanceAddDocument(config: NoConfig())).info.key,
    AppRoute.featureIssuanceModule(.credentialOfferRequest(config: NoConfig())).info.key,
    AppRoute.featureIssuanceModule(.issuanceCode(config: NoConfig())).info.key,
    "PresentationRequest",
    "PresentationLoader",
    "ProximityRequest",
    "ProximityLoader",
    AppRoute.featureDashboardModule(.signDocument).info.key,
    AppRoute.featureDashboardModule(.walletReset).info.key,
    AppRoute.featureCommonModule(.biometry(config: NoConfig())).info.key
  ]

  public var hideContentWhileCaptured: Bool = false

  public var userImageClaimKeys: Set<String> = ["portrait", "picture"]

  public var coveringScreenModules: [String] = ["EudiRQESUi"]

  public var dashboardRoute: AppRoute {
    return .featureDashboardModule(.dashboard)
  }

  public var issuanceRoute: AppRoute {
    return .featureIssuanceModule(.issuanceAddDocument(config: NoConfig()))
  }

  public init(themeConfiguration: ThemeConfiguration) {
    Theme.config(themeConfiguration: themeConfiguration)
  }
}
