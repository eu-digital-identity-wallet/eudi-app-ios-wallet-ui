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

public struct WalletSecurityConfig: ConfigSecurityLogic {

  let configLogic: ConfigLogic

  public var blockRootAccess: Bool {
    false
  }

  public var blockEmulator: Bool {
    false
  }

  public var blockDebugMode: Bool {
    false
  }

  public var blockReverseEngineering: Bool {
    false
  }

  public var blockScreenCapture: Bool {
    false
  }

  public var blockUnsecureWebContent: Bool {
    false
  }

  public var bindToDevice: Bool {
    false
  }

  public var profileInformation: (bundleId: String, signature: String)? {
    nil
  }

  public var useNetworkLogger: Bool {
    configLogic.appBuildType == .DEBUG
  }

  public var networkLoggerExclusionList: [String] = [
    "https://region1.app-measurement.com",
    "https://app-measurement.com",
    "https://firebaselogging-pa.googleapis.com",
    "https://fcmtoken.googleapis.com",
    "https://static.realm.io"
  ]
}
