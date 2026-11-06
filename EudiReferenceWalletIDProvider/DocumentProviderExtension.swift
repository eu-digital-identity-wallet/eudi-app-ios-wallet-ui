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
import ExtensionKit
import IdentityDocumentServicesUI
import SwiftUI
import logic_assembly

@main
struct DocumentProviderExtension: IdentityDocumentProvider {

  private let screenCaptureController: ScreenCaptureController

  init() {
    _ = DocumentProviderDIContainer.shared
    self.screenCaptureController = DIGraph.shared.resolver.force(ScreenCaptureController.self)
    clearCachesAfterWalletReset()
  }

  var body: some IdentityDocumentRequestScene {
    ISO18013MobileDocumentRequestScene { context in
      RequestAuthorizationView(
        with: .init(
          context: context
        )
      )
      .onAppear {
        screenCaptureController.start()
      }
    }
  }

  func performRegistrationUpdates() async {  }

  /// After a factory reset in the app, clears this extension's own caches and temporary files, its WalletKit log
  /// among them, which the app cannot reach. The reset advances `Prefs.Key.walletResetGeneration`; the extension
  /// keeps the last value it saw in its own defaults.
  private func clearCachesAfterWalletReset() {
    let prefsController = DIGraph.shared.resolver.force(PrefsController.self)
    guard prefsController.recordWalletResetSeen(in: .standard) else { return }
    FileManager.default.removeContents(of: FileManager.default.cachesAndTemporaryDirectories)
  }
}
