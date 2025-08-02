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
import logic_ui

private typealias QueueItem = () -> Void

final class RouterHostImpl: RouterHost, ObservableObject {

  @Published private var pathElements: [AppRoute] = []
  private let rootRoute: AppRoute = .featureStartupModule(.startup)

  private let uiConfigLogic: ConfigUiLogic
  private let analyticsController: AnalyticsController

  private let lockInterval: Int = 1000

  private var queueNavigation: [QueueItem] = []
  private var isLocked: Bool = false

  init(
    uiConfigLogic: ConfigUiLogic,
    analyticsController: AnalyticsController
  ) {
    self.uiConfigLogic = uiConfigLogic
    self.analyticsController = analyticsController
  }

  public func push(with route: AppRoute) {
    guard canNavigate(block: self.push(with: route)) else { return }
    lockNavigation()
    pathElements.append(route)
    onNavigationFollowUp(with: route)
  }

  public func popTo(with route: AppRoute, inclusive: Bool) {
    guard
      canNavigate(
        block: self.popTo(
          with: route,
          inclusive: inclusive
        )
      )
    else {
      return
    }

    lockNavigation()

    if route.info.key == rootRoute.info.key {
      pathElements.removeAll()
    } else if let idx = pathElements.lastIndex(where: { $0.info.key == route.info.key }) {
      if inclusive {
        pathElements.removeSubrange(idx..<pathElements.count)
      } else {
        let cutoff = idx + 1
        if cutoff < pathElements.count {
          pathElements.removeSubrange(cutoff..<pathElements.count)
        }
      }
    }

    onNavigationFollowUp(with: route)
  }

  public func popTo(with route: AppRoute) {
    popTo(with: route, inclusive: false)
  }

  public func pop() {
    guard
      canNavigate(block: self.pop())
    else {
      return
    }
    lockNavigation()
    pathElements.removeLast()
    if let current = getCurrentScreen() {
      onNavigationFollowUp(with: current)
    }
  }

  public func getCurrentScreen() -> AppRoute? {
    return pathElements.last
  }

  public func getToolbarConfig() -> UIConfig.ToolBar {
    guard let screenKey = self.getCurrentScreen()?.info.key else {
      return .init(Theme.shared.color.onSurface)
    }

    return uiConfigLogic.backgroundColorForScreenDictionary[screenKey]
    ?? .init(Theme.shared.color.background)
  }

  public func userIsLoggedInWithDocuments() -> Bool {
    return isForegroundOrBackStack(with: uiConfigLogic.dashboardRoute)
  }

  public func userIsLoggedInWithNoDocuments() -> Bool {
    return isForegroundOrBackStack(with: uiConfigLogic.issuanceRoute)
  }

  public func isScreenForeground(with route: AppRoute) -> Bool {
    getCurrentScreen()?.info.key == route.info.key
  }

  public func isScreenOnBackStack(with route: AppRoute) -> Bool {
    pathElements.contains(where: { $0.info.key == route.info.key })
  }

  public func composeApplication() -> AnyView {
    RouterContainerView(host: self).eraseToAnyView()
  }
}

private extension RouterHostImpl {

  @MainActor func isForegroundOrBackStack(with route: AppRoute) -> Bool {
    return isScreenForeground(with: route) || isScreenOnBackStack(with: route)
  }

  @MainActor func canNavigate(block: @escaping @autoclosure () -> Void) -> Bool {
    guard !isLocked else {
      queueNavigation.append(block)
      return false
    }
    return true
  }

  @MainActor func lockNavigation() {
    isLocked = true
    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(lockInterval)) {
      self.isLocked = false
      self.executePendingNavigation()
    }
  }

  @MainActor func executePendingNavigation() {
    guard let item = queueNavigation.getQueuedItem() else {
      return
    }
    item()
  }

  @MainActor func onNavigationFollowUp(with route: AppRoute) {
    notifyBackgroundColorUpdate()
    analyticsController.logScreen(
      screen: route.info.key,
      arguments: route.info.arguments
    )
  }

  @MainActor func notifyBackgroundColorUpdate() {
    NotificationCenter.default.post(name: .shouldChangeBackgroundColor, object: nil)
  }

  @MainActor func resolveView(_ route: AppRoute) -> AnyView {
    switch route {
    case .featureStartupModule(let module):
      StartupRouter.resolve(module: module, host: self)
    case .featureDashboardModule(let module):
      DashboardRouter.resolve(module: module, host: self)
    case .featureCommonModule(let module):
      CommonRouter.resolve(module: module, host: self)
    case .featureIssuanceModule(let module):
      IssuanceRouter.resolve(module: module, host: self)
    case .featurePresentationModule(let module):
      PresentationRouter.resolve(module: module, host: self)
    case .featureProximityModule(let module):
      ProximityRouter.resolve(module: module, host: self)
    }
  }
}

private extension RouterHostImpl {

  struct RouterContainerView: View {

    @ObservedObject var host: RouterHostImpl

    var body: some View {
      NavigationStack(path: $host.pathElements) {
        host.resolveView(host.rootRoute)
          .navigationDestination(for: AppRoute.self) { route in
            host.resolveView(route)
          }
      }
    }
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
