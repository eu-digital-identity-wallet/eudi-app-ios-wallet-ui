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

public protocol ConfigSecurityLogic {

  /**
   * Check root access on startup for release builds.
   */
  var blockRootAccess: Bool { get }

  /**
   * Block running on emulator on startup for release builds.
   */
  var blockEmulator: Bool { get }

  /**
   * Block debug mode on startup for release builds.
   */
  var blockDebugMode: Bool { get }

  /**
   * Check reverse engineering tools on startup for release builds.
   */
  var blockReverseEngineering: Bool { get }

  /**
   * Block screen capture for release builds.
   */
  var blockScreenCapture: Bool { get }

  /**
   * Block unsecure web content.
   */
  var blockUnsecureWebContent: Bool { get }

  /**
   * Bind the application to the first device of installation.
   */
  var bindToDevice: Bool { get }

  /**
   * Check provision signature and bundleId on startup for release builds.
   */
  var profileInformation: (bundleId: String, signature: String)? { get }

  /**
   * Use network logger for debug builds.
   */
  var useNetworkLogger: Bool { get }

  /**
   * Networking logging debug panel
   */
  var networkLoggerExclusionList: [String] { get }
}
