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
