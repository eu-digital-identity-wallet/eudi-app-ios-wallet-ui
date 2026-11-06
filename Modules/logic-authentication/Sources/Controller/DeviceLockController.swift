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
import LocalAuthentication

/// Whether the device has a passcode, as the Android wallet's `DeviceLockController` reads `isDeviceSecure`.
public protocol DeviceLockController: Sendable {
  func isDeviceSecure() -> Bool
}

/// Reads whether the device has a passcode from LocalAuthentication, with a new context for each check.
final class DeviceLockControllerImpl: DeviceLockController {

  private let contextProvider: @Sendable () -> LAContext

  /// - Parameter contextProvider: Creates the context for each check.
  init(contextProvider: @escaping @Sendable () -> LAContext = { LAContext() }) {
    self.contextProvider = contextProvider
  }

  /// A passcode is set when the system can evaluate `.deviceOwnerAuthentication`, the policy that falls back to it.
  func isDeviceSecure() -> Bool {
    contextProvider().canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
  }
}
