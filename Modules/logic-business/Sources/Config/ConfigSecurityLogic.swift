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
}
