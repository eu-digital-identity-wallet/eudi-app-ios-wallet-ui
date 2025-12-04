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

import Foundation
import logic_business
import logic_core
import EudiRQESUi

public struct DeepLink {}

public protocol DeepLinkController: Sendable {
  func hasDeepLink(url: URL) -> DeepLink.Executable?
  @MainActor func handleDeepLinkAction(
    routerHost: RouterHost,
    deepLinkExecutable: DeepLink.Executable,
    remoteSessionCoordinator: RemoteSessionCoordinator?
  )
  func getPendingDeepLinkAction() -> DeepLink.Executable?
  func cacheDeepLinkURL(url: URL)
  func removeCachedDeepLinkURL()
}

final class DeepLinkControllerImpl: DeepLinkController {

  private let prefsController: PrefsController
  private let urlSchemaController: UrlSchemaController

  init(
    prefsController: PrefsController,
    urlSchemaController: UrlSchemaController
  ) {
    self.prefsController = prefsController
    self.urlSchemaController = urlSchemaController
  }

  public func getPendingDeepLinkAction() -> DeepLink.Executable? {
    if let cachedLink = prefsController.getString(forKey: .cachedDeepLink),
       let url = cachedLink.toCompatibleUrl() {
      return hasDeepLink(url: url)
    }
    return nil
  }

  public func hasDeepLink(url: URL) -> DeepLink.Executable? {
    if let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
       let scheme = components.scheme,
       let action = DeepLink.Action.parseType(with: scheme, and: urlSchemaController) {
      return DeepLink.Executable(link: components, plainUrl: url, action: action)
    }
    return nil
  }

  public func handleDeepLinkAction(
    routerHost: RouterHost,
    deepLinkExecutable: DeepLink.Executable,
    remoteSessionCoordinator: RemoteSessionCoordinator?
  ) {

    var isVciExecutable: Bool {
      deepLinkExecutable.action == .credential_offer && routerHost.userIsLoggedInWithNoDocuments()
    }

    var isRqesPendingAction: Bool {
      deepLinkExecutable.action == .rqes
      && !routerHost.isScreenForeground(with: .featureDashboardModule(.dashboard))
    }

    var shouldPopToDashboardFirst: Bool {
      routerHost.userIsLoggedInWithDocuments()
      && isRqesPendingAction
    }

    guard
      !shouldPopToDashboardFirst && (routerHost.userIsLoggedInWithDocuments() || isVciExecutable)
    else {
      if let url = deepLinkExecutable.link.url {
        cacheDeepLinkURL(url: url)
      }
      if shouldPopToDashboardFirst {
        routerHost.popTo(
          with: .featureDashboardModule(.dashboard),
          inclusive: false
        )
      }
      return
    }

    removeCachedDeepLinkURL()

    switch deepLinkExecutable.action {
    case .openid4vp, .haip_vp:
      guard let remoteSessionCoordinator else {
        fatalError("DeepLink Action OpenId4VP Requires Remote Session Coordinator")
      }
      if !routerHost.isScreenForeground(
        with: .featurePresentationModule(
          .presentationRequest(
            presentationCoordinator: remoteSessionCoordinator,
            originator: .featureDashboardModule(.dashboard)
          )
        )
      ) {
        routerHost.push(
          with: .featurePresentationModule(
            .presentationRequest(
              presentationCoordinator: remoteSessionCoordinator,
              originator: .featureDashboardModule(.dashboard)
            )
          )
        )
      } else {
        NotificationCenter.default.post(
          name: NSNotification.PresentationVC,
          object: nil,
          userInfo: ["session": remoteSessionCoordinator]
        )
      }
    case .external:
      deepLinkExecutable.plainUrl.open()
    case .credential_offer, .haip_vci:
      let config = UIConfig.Generic(
        arguments: ["uri": deepLinkExecutable.plainUrl.absoluteString],
        navigationSuccessType: routerHost.userIsLoggedInWithDocuments()
        ? .popTo(.featureDashboardModule(.dashboard))
        : .push(.featureDashboardModule(.dashboard)),
        navigationCancelType: .pop
      )
      if !routerHost.isScreenForeground(with: .featureIssuanceModule(.credentialOfferRequest(config: config))) {
        routerHost.push(with: .featureIssuanceModule(.credentialOfferRequest(config: config)))
      } else {
        NotificationCenter.default.post(
          name: NSNotification.CredentialOffer,
          object: nil,
          userInfo: ["uri": deepLinkExecutable.plainUrl.absoluteString]
        )
      }
    case .rqes:

      guard let code = deepLinkExecutable.link.queryItems?.first(where: { $0.name == "code" })?.value else {
        return
      }

      Task { @MainActor in

        while UIApplication.shared.topViewController() == nil {
          try? await Task.sleep(for: .milliseconds(100))
        }

        guard let controller = UIApplication.shared.topViewController() else {
          return
        }

        try? await EudiRQESUi.instance().resume(
          on: controller,
          authorizationCode: code
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
}

public extension DeepLink {
  struct Executable: Equatable, Sendable {

    public let link: URLComponents
    public let plainUrl: URL
    public let action: DeepLink.Action

    public var requiresCoordinator: Bool {
      action == .openid4vp
    }
  }
}

public extension DeepLink {
  enum Action: String, Equatable, Sendable {

    case openid4vp
    case credential_offer
    case haip_vci
    case haip_vp
    case rqes
    case external

    private var name: String {
      return rawValue.replacingOccurrences(of: "_", with: "-")
    }

    private func getSchemas(
      with urlSchemaController: UrlSchemaController
    ) -> [String] {
      return urlSchemaController.retrieveSchemas(with: name)
    }

    static func parseType(
      with scheme: String,
      and urlSchemaController: UrlSchemaController
    ) -> Action? {
      switch scheme {
      case _ where openid4vp.getSchemas(with: urlSchemaController).contains(scheme),
        _ where haip_vp.getSchemas(with: urlSchemaController).contains(scheme):
        return .openid4vp
      case _ where credential_offer.getSchemas(with: urlSchemaController).contains(scheme),
        _ where haip_vci.getSchemas(with: urlSchemaController).contains(scheme):
        return .credential_offer
      case _ where rqes.getSchemas(with: urlSchemaController).contains(scheme):
        return .rqes
      default:
        return .external
      }
    }
  }
}

public extension NSNotification {
  static let PresentationVC = Notification.Name.init("PresentationVC")
  static let CredentialOffer = Notification.Name.init("CredentialOffer")
}
