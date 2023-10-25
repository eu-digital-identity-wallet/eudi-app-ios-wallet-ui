/*
 * Copyright (c) 2023 European Commission
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import Foundation
import UIKit
import netfox
import Firebase
import logic_business

class AppDelegate: UIResponder, UIApplicationDelegate {

  private lazy var configSecurityLogic = ConfigProvider.shared.getConfigSecurityLogic()

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {

    // Load firebase
    FirebaseApp.configure()
    FirebaseConfiguration.shared.setLoggerLevel(.min)

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
}
