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
import logic_business

public protocol DeepLinkControllerType {
  func hasDeepLink(url: URL) -> DeepLinkController.DeepLinkAction?
  func handleDeepLinkAction(routerHost: RouterHostType, deepLinkAction: DeepLinkController.DeepLinkAction)
  func getPendingDeepLinkAction() -> DeepLinkController.DeepLinkAction?
}

public final class DeepLinkController: DeepLinkControllerType {

  private lazy var prefsController: PrefsControllerType = PrefsController.shared

  public init() {}

  public func getPendingDeepLinkAction() -> DeepLinkAction? {
    if let cachedLink = prefsController.getString(forKey: .cachedDeepLink),
       let url = URL(string: cachedLink) {
      return hasDeepLink(url: url)
    }
    return nil
  }

  public func hasDeepLink(url: URL) -> DeepLinkAction? {
    if let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
       let params = components.queryItems,
       !params.isEmpty,
       let action = DeepLinkAction.Action.parseType(with: components.host.orEmpty) {
      return DeepLinkAction(link: components, action: action)
    }
    return nil
  }

  public func handleDeepLinkAction(routerHost: RouterHostType, deepLinkAction: DeepLinkAction) {

    guard routerHost.isAfterAuthorization() else {
      if let url = deepLinkAction.link.url {
        cacheDeepLinkURL(url: url)
      }
      return
    }

    removeCachedDeepLinkURL()

    let route: AppRoute? = switch deepLinkAction.action {
    case .authorization:
      !routerHost.isScreenForeground(with: .sameDeviceRequest) ? .sameDeviceRequest : nil
    }

    if let route {
      routerHost.push(with: route)
    }
  }

  private func cacheDeepLinkURL(url: URL) {
    prefsController.setValue(url.absoluteString, forKey: .cachedDeepLink)
  }

  private func removeCachedDeepLinkURL() {
    prefsController.remove(forKey: .cachedDeepLink)
  }
}

public extension DeepLinkController {
  struct DeepLinkAction {
    public let link: URLComponents
    public let action: Action
  }
}

public extension DeepLinkController.DeepLinkAction {
  enum Action: String, CaseIterable {

    case authorization

    public static func parseType(with url: String) -> Action? {
      Action.allCases.first(where: { url.contains($0.rawValue) })
    }
  }
}
