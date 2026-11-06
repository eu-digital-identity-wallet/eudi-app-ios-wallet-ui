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

import Foundation

public struct DeepLink {}

public extension DeepLink {
  struct Executable: Equatable, Sendable {

    public let link: URLComponents
    public let plainUrl: URL
    public let action: DeepLink.Action
  }
}

public extension DeepLink {
  enum Action: String, Equatable, Sendable {

    case openid4vp
    case credential_offer
    case haip_vci
    case haip_vp
    case rqes

    private var name: String {
      return rawValue.replacingOccurrences(of: "_", with: "-")
    }

    private func getSchemas(
      with urlSchemaController: UrlSchemaController
    ) -> [String] {
      return urlSchemaController.retrieveSchemas(with: name)
    }

    /// The wallet flow a link of `scheme` starts, or nil when it starts none. Such a link is not handled at
    /// all, as on Android, so it can neither be opened nor replace a link kept for after login.
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
        return nil
      }
    }
  }
}
