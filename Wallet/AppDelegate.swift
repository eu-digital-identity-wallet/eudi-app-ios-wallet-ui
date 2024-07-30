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
import UIKit
import logic_assembly

class AppDelegate: UIResponder, UIApplicationDelegate {

  private lazy var prefsController: PrefsController = DIGraph.resolver.force(PrefsController.self)
  private lazy var keyChainController: KeyChainController = DIGraph.resolver.force(KeyChainController.self)
  private lazy var walletKitController: WalletKitController = DIGraph.resolver.force(WalletKitController.self)
  private lazy var analyticsController: AnalyticsController = DIGraph.resolver.force(AnalyticsController.self)

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {

    // Initialize Reporting
    initializeReporting()

    // Check firt run and clear keychain from previous installations
    manageStorage()

    return true
  }

  func application(
    _ application: UIApplication,
    shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplication.ExtensionPointIdentifier
  ) -> Bool {
    switch extensionPointIdentifier {
    case UIApplication.ExtensionPointIdentifier.keyboard: return false
    default: return true
    }
  }

  private func initializeReporting() {
    analyticsController.initialize()
  }

  private func manageStorage() {
    if !prefsController.getBool(forKey: .runAtLeastOnce) {
      clearDocuments()
      keyChainController.clear()
      prefsController.setValue(true, forKey: .runAtLeastOnce)
    }
  }

  private func clearDocuments() {
    Task {
      await walletKitController.clearAllDocuments()
    }
  }
}
