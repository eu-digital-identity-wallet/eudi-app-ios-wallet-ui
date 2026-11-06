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
import UIKit

public extension URL {

  /// True for an `https` link with a host, the only kind of address a relying party or an issuer may send the user
  /// to, and the only kind the wallet loads an image from. As Android's `isOpenableExternalLink`.
  var isHttpsWebLink: Bool {
    scheme?.lowercased() == "https" && !(host ?? "").isEmpty
  }

  /// This link if it `isHttpsWebLink`, otherwise nil.
  var httpsWebLink: URL? {
    isHttpsWebLink ? self : nil
  }

  /// True when `other` has the same host, compared case-insensitively, and the same port (443 when none is given).
  func hasSameOrigin(as other: URL) -> Bool {
    host?.lowercased() == other.host?.lowercased() && (port ?? 443) == (other.port ?? 443)
  }

  @MainActor func open() {
    if UIApplication.shared.canOpenURL(self) {
      UIApplication.shared.open(self)
    }
  }
}
