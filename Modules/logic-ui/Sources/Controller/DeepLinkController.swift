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
import logic_core

public struct DeepLink {}

public protocol DeepLinkController {
  func hasDeepLink(url: URL) -> DeepLink.Executable?
  func handleDeepLinkAction(routerHost: RouterHost, deepLinkExecutable: DeepLink.Executable)
  func getPendingDeepLinkAction() -> DeepLink.Executable?
  func cacheDeepLinkURL(url: URL)
  func removeCachedDeepLinkURL()
}

final class DeepLinkControllerImpl: DeepLinkController {

  private let prefsController: PrefsController
  private let walletKitController: WalletKitController

  init(
    prefsController: PrefsController,
    walletKitController: WalletKitController
  ) {
    self.prefsController = prefsController
    self.walletKitController = walletKitController
  }

  public func getPendingDeepLinkAction() -> DeepLink.Executable? {
    if let cachedLink = prefsController.getString(forKey: .cachedDeepLink),
       let url = URL(string: cachedLink) {
      return hasDeepLink(url: url)
    }
    return nil
  }

  public func hasDeepLink(url: URL) -> DeepLink.Executable? {
    if let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
       let scheme = components.scheme,
       let action = DeepLink.Action.parseType(with: scheme) {
      return DeepLink.Executable(link: components, plainUrl: url, action: action)
    }
    return nil
  }

  public func handleDeepLinkAction(
    routerHost: RouterHost,
    deepLinkExecutable: DeepLink.Executable
  ) {

    var isVciExecutable: Bool {
      deepLinkExecutable.action == .credentialOffer && routerHost.userIsLoggedInWithNoDocuments()
    }

    guard
      routerHost.userIsLoggedInWithDocuments() || isVciExecutable
    else {
      if let url = deepLinkExecutable.link.url {
        cacheDeepLinkURL(url: url)
      }
      return
    }

    removeCachedDeepLinkURL()

    switch deepLinkExecutable.action {
    case .openid4vp:
      let session = walletKitController.startSameDevicePresentation(deepLink: deepLinkExecutable.link)
      if !routerHost.isScreenForeground(with: .presentationRequest(presentationCoordinator: session)) {
        routerHost.push(with: .presentationRequest(presentationCoordinator: session))
      } else {
        postNotification(
          with: NSNotification.OpenId4VP,
          and: ["session": session]
        )
      }
    case .external:
      deepLinkExecutable.plainUrl.open()
    case .credentialOffer:
      let config = UIConfig.Generic(
        arguments: ["uri": deepLinkExecutable.plainUrl.absoluteString],
        navigationSuccessType: .popTo(.dashboard),
        navigationCancelType: .pop
      )
      if !routerHost.isScreenForeground(with: .credentialOfferRequest(config: config)) {
        routerHost.push(with: .credentialOfferRequest(config: config))
      } else {
        postNotification(
          with: NSNotification.OpenId4VCI,
          and: ["uri": deepLinkExecutable.plainUrl.absoluteString]
        )
      }
    }
  }

  public func cacheDeepLinkURL(url: URL) {
    prefsController.setValue(url.absoluteString, forKey: .cachedDeepLink)
  }

  public func removeCachedDeepLinkURL() {
    prefsController.remove(forKey: .cachedDeepLink)
  }

  private func postNotification(
    with name: NSNotification.Name,
    and info: [AnyHashable: Any]? = nil
  ) {
    NotificationCenter.default.post(
      name: name,
      object: nil,
      userInfo: info
    )
  }
}

public extension DeepLink {
  struct Executable: Equatable {
    public let link: URLComponents
    public let plainUrl: URL
    public let action: DeepLink.Action
  }
}

public extension DeepLink {
  enum Action: Equatable {

    case openid4vp
    case credentialOffer
    case external

    var name: String {
      return switch self {
      case .openid4vp:
        "openid4vp"
      case .credentialOffer:
        "credential-offer"
      case .external:
        "external"
      }
    }

    public static func parseType(with scheme: String) -> Action? {
      switch scheme {
      case _ where scheme.contains(openid4vp.name):
        return .openid4vp
      case _ where scheme.contains(credentialOffer.name):
        return .credentialOffer
      default:
        return .external
      }
    }
  }
}

public extension NSNotification {
  static let OpenId4VP = Notification.Name.init("OpenId4VP")
  static let OpenId4VCI = Notification.Name.init("OpenId4VCI")
}
