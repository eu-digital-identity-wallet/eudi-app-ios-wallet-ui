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
import logic_business

public extension URL {

  /// Opens the link with the system (`open()`), the default opener of `openInBrowser(using:)` and of the screens
  /// that open a verifier's redirect.
  @MainActor static func openWithSystem(_ url: URL) {
    url.open()
  }

  /// Opens the link in the browser if it is an `https` link with a host, and does nothing otherwise. It
  /// never passes the link to the wallet's own link handling. The reference app claims no associated
  /// domains; one that does must keep its domains out of the links it opens this way, because iOS would
  /// hand such a link back to the wallet.
  @MainActor func openInBrowser(using open: @MainActor (URL) -> Void = URL.openWithSystem) {
    guard isHttpsWebLink else { return }
    open(self)
  }
}
