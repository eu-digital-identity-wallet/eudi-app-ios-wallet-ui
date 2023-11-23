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
import UIPilot
import logic_ui
import SwiftUI
import logic_business
import feature_startup
import feature_login
import feature_common
import feature_dashboard
import feature_presentation
import feature_proximity
import feature_issuance

public final class RouterHost: RouterHostType {

  private let pilot: UIPilot<AppRoute>
  private lazy var uiConfigLogic: ConfigUiLogic = ConfigUiProvider.shared.getConfigUiLogic()

  public init() {
    self.pilot = UIPilot(initial: .startup)
  }

  public func push(with route: AppRoute) {
    pilot.push(route)
    onNavigationFollowUp()
  }

  public func popTo(with route: AppRoute, inclusive: Bool, animated: Bool) {
    pilot.popTo(route, inclusive: inclusive, animated: animated)
    onNavigationFollowUp()
  }

  public func popTo(with route: AppRoute, inclusive: Bool) {
    pilot.popTo(route, inclusive: inclusive)
    onNavigationFollowUp()
  }

  public func popTo(with route: AppRoute) {
    pilot.popTo(route)
    onNavigationFollowUp()
  }

  public func pop(animated: Bool) {
    pilot.pop(animated: animated)
    onNavigationFollowUp()
  }

  public func pop() {
    pilot.pop()
    onNavigationFollowUp()
  }

  public func getCurrentScreen() -> AppRoute? {
    return pilot.routes.last
  }

  public func composeApplication() -> AnyView {
    return UIPilotHost(pilot) { route in
      switch route {
      case .startup:
        StartupView(with: self, and: StartupInteractor())
      case .faqs:
        FAQsView(with: self, and: FAQsInteractor())
      case .success(let config):
        SuccessView(with: self, and: config)
      case .dashboard:
        DashboardView(with: self, and: DashboardInteractor(), also: DeepLinkController())
      case .biometry(let config):
        BiometryView(with: self, interactor: BiometryInteractor(), config: config)
      case .crossDeviceLoader(let relyingParty):
        CrossDeviceLoadingView(
          with: self,
          and: CrossDeviceInteractor(),
          relyingParty: relyingParty
        )
      case .crossDeviceRequest:
        CrossDeviceRequestView(with: self, and: CrossDeviceInteractor())
      case .sameDeviceLoader(let relyingParty):
        SameDeviceLoadingView(
          with: self,
          and: SameDeviceInteractor(),
          relyingParty: relyingParty
        )
      case .sameDeviceRequest:
        SameDeviceRequestView(with: self, and: SameDeviceInteractor())
      case .welcome:
        WelcomeView(with: self, and: WelcomeInteractor())
      case .issuanceDocumentDetails(let config):
        DocumentDetailsView(
          with: self,
          and: DocumentDetailsInteractor(),
          config: config
        )
      case .issuanceAddDocument(let config):
        AddDocumentView(
          with: self,
          and: AddDocumentInteractor(),
          config: config
        )
      case .proximityConnection:
        ProximityConnectionView(with: self, and: ProximityInteractor())
      case .proximityRequest:
        ProximityRequestView(with: self, and: ProximityInteractor())
      case .proximityLoader(let relyingParty):
        ProximityLoadingView(
          with: self,
          and: ProximityInteractor(),
          relyingParty: relyingParty
        )
      case .quickPin(let config):
        QuickPinView(
          with: self,
          interactor: QuickPinInteractor(),
          config: config
        )
      case .issuanceExternalLogin(let config, let documentName):
        ExternalLoginView(
          with: self,
          and: ExternalLoginInteractor(),
          config: config,
          documentName: documentName
        )
      case .issuanceSuccess(let config, let documentName):
        DocumentSuccessView(
          with: self,
          and: DocumentSuccessInteractor(),
          config: config,
          documentName: documentName
        )
      }
    }
    .eraseToAnyView()
  }

  public func getToolbarConfig() -> UIConfig.ToolBar {
    guard let screenKey = self.getCurrentScreen()?.key else {
      return .init(Theme.shared.color.backgroundPaper)
    }

    return uiConfigLogic.backgroundColorForScreenDictionary[screenKey]
    ?? .init(Theme.shared.color.backgroundPaper)
  }

  public func isAfterAuthorization() -> Bool {
    return getCurrentScreen()?.key == uiConfigLogic.landingRoute.key ||
    pilot.routes.contains(where: { $0.key == uiConfigLogic.landingRoute.key })
  }

  public func isScreenForeground(with route: AppRoute) -> Bool {
    getCurrentScreen()?.key == route.key
  }

  private func onNavigationFollowUp() {
    notifyBackgroundColorUpdate()
  }

  private func notifyBackgroundColorUpdate() {
    NotificationCenter.default.post(name: .shouldChangeBackgroundColor, object: nil)
  }
}
