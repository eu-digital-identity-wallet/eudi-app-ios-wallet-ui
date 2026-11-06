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
import logic_business

public extension URL {

  /// True for an issuer logo the wallet may load: `https`, on one of `allowedOrigins` (the configured issuers' own
  /// and their `VciConfig.logoOrigins`), as the Android wallet's `issuerLogoOrNull`. The address comes from the
  /// issuer's metadata, so without this rule an issuer could have the wallet contact any host.
  func isAllowedIssuerLogo(allowedOrigins: [String]) -> Bool {
    guard isHttpsWebLink else { return false }
    return allowedOrigins.contains { origin in
      URL(string: origin).map { $0.isHttpsWebLink && $0.hasSameOrigin(as: self) } ?? false
    }
  }

  /// This logo if `isAllowedIssuerLogo(allowedOrigins:)`, otherwise nil, so the placeholder shows.
  func allowedIssuerLogo(allowedOrigins: [String]) -> URL? {
    isAllowedIssuerLogo(allowedOrigins: allowedOrigins) ? self : nil
  }
}
