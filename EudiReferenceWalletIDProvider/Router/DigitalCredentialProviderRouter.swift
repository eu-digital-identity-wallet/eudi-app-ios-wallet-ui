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
import feature_common
import IdentityDocumentServicesUI
import logic_authentication
import logic_assembly
import logic_ui
import DcApi18013AnnexC
import feature_proximity

// MARK: - Extension Router Host
private typealias QueueItem = () -> Void

@Observable
final class DigitalCredentialProviderRouter: RouterHost {

  private var pathElements: [logic_ui.AppRoute] = []

  @ObservationIgnored
  private var rootRoute: logic_ui.AppRoute = .featureIDPModule(.requestAuthorization)

  @ObservationIgnored
  private let lockInterval: Int = 1000
  @ObservationIgnored
  private var queueNavigation: [QueueItem] = []
  @ObservationIgnored
  private var isLocked: Bool = false
  @ObservationIgnored
  private var authorizationContext: ISO18013MobileDocumentRequestContext?
  @ObservationIgnored
  private var authorizationHandler: DcApiHandler?

  public func push(with route: logic_ui.AppRoute) {
    guard canNavigate(block: self.push(with: route)) else { return }
    lockNavigation()
    pathElements.append(route)
    onNavigationFollowUp(with: route)
  }

  public func popTo(with route: logic_ui.AppRoute, inclusive: Bool) {
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

  public func popTo(with route: logic_ui.AppRoute) {
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

  public func getCurrentScreen() -> logic_ui.AppRoute? {
    return pathElements.last
  }

  public func getToolbarConfig() -> UIConfig.ToolBar {
    return .init(Theme.shared.color.onSurface)
  }

  public func userIsLoggedInWithDocuments() -> Bool {
    return true
  }

  public func userIsLoggedInWithNoDocuments() -> Bool {
    return false
  }

  public func isScreenForeground(with route: logic_ui.AppRoute) -> Bool {
    getCurrentScreen()?.info.key == route.info.key
  }

  public func isScreenOnBackStack(with route: logic_ui.AppRoute) -> Bool {
    pathElements.contains(where: { $0.info.key == route.info.key })
  }

  public func composeApplication() -> AnyView {
    RouterContainerView(host: self).eraseToAnyView()
  }
}

private extension DigitalCredentialProviderRouter {

  @MainActor func isForegroundOrBackStack(with route: logic_ui.AppRoute) -> Bool {
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

  @MainActor func onNavigationFollowUp(with route: logic_ui.AppRoute) {
    notifyBackgroundColorUpdate()
  }

  @MainActor func notifyBackgroundColorUpdate() {
    NotificationCenter.default.post(name: .shouldChangeBackgroundColor, object: nil)
  }

  @ViewBuilder
  @MainActor func resolveView(_ route: logic_ui.AppRoute) -> some View {
    switch route {
    case .featureStartupModule(let module):
      StartupRouter.resolve(module: module, host: self)
    case .featureCommonModule(let module):
      CommonRouter.resolve(module: module, host: self)
    case .featureIssuanceModule(let module):
      IssuanceRouter.resolve(module: module, host: self)
    case .featurePresentationModule(let module):
      PresentationRouter.resolve(module: module, host: self)
    case .featureProximityModule(let module):
      ProximityRouter.resolve(module: module, host: self)
    case .featureIDPModule(let module):
      IDPRouter.resolve(module: module, host: self)
    case .featureDashboardModule(let module):
      DashboardRouter.resolve(module: module, host: self)
    }
  }
}

extension DigitalCredentialProviderRouter {

  func configureAuthorization(
    context: ISO18013MobileDocumentRequestContext,
    handler: DcApiHandler
  ) {
    authorizationContext = context
    authorizationHandler = handler
  }

  fileprivate func authorizationDependencies()
  -> (context: ISO18013MobileDocumentRequestContext, handler: DcApiHandler)? {
    guard
      let authorizationContext,
      let authorizationHandler
    else {
      return nil
    }
    return (authorizationContext, authorizationHandler)
  }
}

private extension DigitalCredentialProviderRouter {

  struct RouterContainerView: View {

    @State var host: DigitalCredentialProviderRouter

    var body: some View {
      NavigationStack(path: $host.pathElements) {
        host.resolveView(host.rootRoute)
          .navigationDestination(for: logic_ui.AppRoute.self) { route in
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

public extension Notification.Name {
  static let shouldChangeBackgroundColor = Notification.Name("shouldChangeBackgroundColor")
}

@MainActor
public final class IDPRouter {
  @ViewBuilder
  public static func resolve(module: FeatureIDPRouteModule, host: some RouterHost) -> some View {
    switch module {
    case .requestAuthorization:
      if
        let documentRouter = host as? DigitalCredentialProviderRouter,
        let dependencies = documentRouter.authorizationDependencies() {
        RequestAuthorizationView(
          with: .init(
            router: host,
            context: dependencies.context,
            dcApiHandler: dependencies.handler
          )
        )
      } else {
        ContentUnavailableView(
          title: LocalizableStringKey.custom(""),
          description: LocalizableStringKey.custom("")
        )
      }
    case .biometry(config: let config):
      CommonRouter.resolve(module: .biometry(config: config), host: host)
    }
  }
}
