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
import logic_analytics
import feature_startup
import feature_login
import feature_common
import feature_dashboard
import feature_presentation
import feature_proximity
import feature_issuance

private typealias QueueItem = () -> Void

public final class RouterHost: RouterHostType {

  private let pilot: UIPilot<AppRoute>
  private lazy var uiConfigLogic: ConfigUiLogic = ConfigUiProvider.shared.getConfigUiLogic()
  private lazy var analyticsController: AnalyticsControllerType = AnalyticsController.shared

  private var queueNavigation: [QueueItem] = []
  private let lockInterval: Int = 1000
  private var isLocked: Bool = false

  public init() {
    self.pilot = UIPilot(initial: .startup, debug: true)
  }

  public func push(with route: AppRoute) {
    guard canNavigate(block: self.push(with: route)) else { return }
    lockNavigation()
    pilot.push(route)
    onNavigationFollowUp(with: route)
  }

  public func popTo(with route: AppRoute, inclusive: Bool, animated: Bool) {
    guard
      canNavigate(
        block: self.popTo(
          with: route,
          inclusive: inclusive,
          animated: animated
        )
      )
    else {
      return
    }
    lockNavigation()
    pilot.popTo(route, inclusive: inclusive, animated: animated)
    onNavigationFollowUp(with: route)
  }

  public func popTo(with route: AppRoute, inclusive: Bool) {
    popTo(with: route, inclusive: inclusive, animated: true)
  }

  public func popTo(with route: AppRoute) {
    popTo(with: route, inclusive: false, animated: true)
  }

  public func pop(animated: Bool) {
    guard
      canNavigate(block: self.pop(animated: animated))
    else {
      return
    }
    lockNavigation()
    pilot.pop(animated: animated)
    if let current = getCurrentScreen() {
      onNavigationFollowUp(with: current)
    }
  }

  public func pop() {
    pop(animated: true)
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
      case .presentationLoader(let relyingParty, let presentationCoordinator):
        PresentationLoadingView(
          with: self,
          and: PresentationInteractor(with: presentationCoordinator),
          relyingParty: relyingParty
        )
      case .presentationRequest(let presentationCoordinator):
        PresentationRequestView(with: self, and: PresentationInteractor(with: presentationCoordinator))
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
      case .proximityConnection(let presentationSessionCoordinator):
        ProximityConnectionView(
          with: self,
          and: ProximityInteractor(with: presentationSessionCoordinator)
        )
      case .proximityRequest(let presentationSessionCoordinator):
        ProximityRequestView(
          with: self,
          and: ProximityInteractor(with: presentationSessionCoordinator)
        )
      case .proximityLoader(let relyingParty, let presentationSessionCoordinator):
        ProximityLoadingView(
          with: self,
          and: ProximityInteractor(with: presentationSessionCoordinator),
          relyingParty: relyingParty
        )
      case .quickPin(let config):
        QuickPinView(
          with: self,
          interactor: QuickPinInteractor(),
          config: config
        )
      case .issuanceSuccess(let config, let documentIdentifier):
        DocumentSuccessView(
          with: self,
          and: DocumentSuccessInteractor(),
          config: config,
          documentIdentifier: documentIdentifier
        )
      }
    }
    .eraseToAnyView()
  }

  public func getToolbarConfig() -> UIConfig.ToolBar {
    guard let screenKey = self.getCurrentScreen()?.info.key else {
      return .init(Theme.shared.color.backgroundPaper)
    }

    return uiConfigLogic.backgroundColorForScreenDictionary[screenKey]
    ?? .init(Theme.shared.color.backgroundPaper)
  }

  public func isAfterAuthorization() -> Bool {
    return getCurrentScreen()?.info.key == uiConfigLogic.landingRoute.info.key ||
    pilot.routes.contains(where: { $0.info.key == uiConfigLogic.landingRoute.info.key })
  }

  public func isScreenForeground(with route: AppRoute) -> Bool {
    getCurrentScreen()?.info.key == route.info.key
  }

  private func canNavigate(block: @escaping @autoclosure () -> Void) -> Bool {
    guard !isLocked else {
      queueNavigation.append(block)
      return false
    }
    return true
  }

  private func lockNavigation() {
    isLocked = true
    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(lockInterval)) {
      self.isLocked = false
      self.executePendingNavigation()
    }
  }

  private func executePendingNavigation() {
    guard let item = queueNavigation.getQueuedItem() else {
      return
    }
    item()
  }

  private func onNavigationFollowUp(with route: AppRoute) {
    notifyBackgroundColorUpdate()
    analyticsController.logScreen(
      screen: route.info.key,
      arguments: route.info.arguments
    )
  }

  private func notifyBackgroundColorUpdate() {
    NotificationCenter.default.post(name: .shouldChangeBackgroundColor, object: nil)
  }
}

fileprivate extension Array where Element == QueueItem {
  mutating func getQueuedItem() -> QueueItem? {
    guard
      !self.isEmpty,
      let item = self.last
    else {
      return nil
    }
    self.removeAll()
    return item
  }
}
