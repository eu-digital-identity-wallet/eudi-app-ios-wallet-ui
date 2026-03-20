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
import ExtensionKit
import IdentityDocumentServicesUI
import SwiftUI
import DcApi18013AnnexC
import logic_business
import logic_ui

@main
struct DocumentProviderExtension: IdentityDocumentProvider {
  private let dcApiHandler: DcApiHandler
  private let routerHost: RouterHost

  init() {
    _ = DocumentProviderDIContainer.shared
    self.dcApiHandler = DIGraph.shared.resolver.force(DcApiHandler.self)
    self.routerHost = DIGraph.shared.resolver.force(RouterHost.self)
  }

  var body: some IdentityDocumentRequestScene {
    ISO18013MobileDocumentRequestScene { context in
      if let documentRouter = routerHost as? DigitalCredentialProviderRouter {
        documentRouter.configureAuthorization(
          context: context,
          handler: dcApiHandler
        )
      }
      return routerHost.composeApplication()
        .ignoresSafeArea(edges: .bottom)
    }
  }

  func performRegistrationUpdates() async {  }
}
