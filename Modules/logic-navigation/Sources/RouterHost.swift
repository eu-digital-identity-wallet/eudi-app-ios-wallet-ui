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

import EudiWalletKit
import MdocDataModel18013

public final class RouterHost: RouterHostType {

  private let pilot: UIPilot<AppRoute>
  private lazy var uiConfigLogic: ConfigUiLogic = ConfigUiProvider.shared.getConfigUiLogic()

  public init() {
    self.pilot = UIPilot(initial: .startup, debug: true)
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
      case .documentDetails(let documentId):
        DocumentDetailsView(
          with: self,
          and: DocumentDetailsInteractor(),
          documentId: documentId
        )
      case .addDocument:
        AddDocumentView(with: self, and: AddDocumentInteractor())
      case .proximityConnection(let presentationSession):
        ProximityConnectionView(
          with: self,
          and: ProximityInteractor(presentationSession: presentationSession)
        )
      case .proximityRequest(let presentationSession):
        ProximityRequestView(
          with: self,
          and: ProximityInteractor(presentationSession: presentationSession)
        )
      case .proximityLoader(let relyingParty, let presentationSession, let requestItems):
        ProximityLoadingView(
          with: self,
          and: ProximityInteractor(presentationSession: WalletKitController.shared.activeSession!),
          relyingParty: relyingParty,
          requestItems: RequestItems()
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
