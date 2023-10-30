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
      !routerHost.isScreenForeground(with: .authenticationRequest) ? .authenticationRequest : nil
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

    init(link: URLComponents, action: Action) {
      self.link = link
      self.action = action
    }
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
