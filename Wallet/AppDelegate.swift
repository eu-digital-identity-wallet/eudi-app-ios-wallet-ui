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
import netfox
import logic_business

class AppDelegate: UIResponder, UIApplicationDelegate {

  private lazy var configSecurityLogic = ConfigProvider.shared.getConfigSecurityLogic()
  private lazy var prefsController: PrefsControllerType = PrefsController()
  private lazy var keyChainController: KeyChainControllerType = KeyChainController()
  private lazy var walletKitController: WalletKitControllerType = WalletKitController.shared

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {

    // Check firt run and clear keychain from previous installations
    manageStorage()

    // Initialize Network Logging
    initializeNetworkLogging()

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

  private func initializeNetworkLogging() {

    guard configSecurityLogic.useNetworkLogger else {
      return
    }

    configSecurityLogic.networkLoggerExclusionList.forEach { url in
      NFX.sharedInstance().ignoreURL(url)
    }
    NFX.sharedInstance().start()
  }

  private func manageStorage() {
    if !prefsController.getBool(forKey: .runAtLeastOnce) {
      keyChainController.clear()
      walletKitController.loadSampleData(dataFiles: ["null"])
      prefsController.setValue(true, forKey: .runAtLeastOnce)
    }
  }
}
