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
import logic_authentication

public enum QuickPinPartialState: Sendable {
  case success
  case failure(Error)
}

/// Whether the device has a passcode, for PIN setup and login: `missing` warns, `required` waits until one is set
/// (`AuthenticationConfig.requireDeviceSecure`).
public enum DeviceLockState: Sendable, Equatable {
  case secure
  case missing
  case required
}

public protocol QuickPinInteractor: Sendable {
  var maxFailedPinAttempts: Int { get }

  /// Refuses a PIN that is easy to guess (`AuthenticationConfig.isWeakPin`), as `checkNewPin` does, and any PIN while
  /// a passcode is required and missing (`AuthenticationConfig.requireDeviceSecure`).
  func setPin(newPin: String) async -> QuickPinPartialState
  /// Stores the new PIN of a set-up wallet, whose current PIN the update flow has checked (`isPinValid`). It refuses
  /// a PIN that is easy to guess but not a missing passcode, as on Android.
  func updatePin(newPin: String) async -> QuickPinPartialState
  /// Refuses a new PIN that is easy to guess with `AuthenticationError.quickPinWeak`, when it is entered.
  func checkNewPin(_ pin: String) async -> QuickPinPartialState
  func getDeviceLockState() async -> DeviceLockState
  func isPinValid(pin: String) async -> QuickPinPartialState
  func changePin(currentPin: String, newPin: String) async -> QuickPinPartialState
  func hasPin() async throws -> Bool

  func getPinLockoutState() async -> PinLockoutState
  func recordPinFailure() async -> PinLockoutState
  func resetPinThrottle() async

  /// Unlocks the wallet's session, after login or PIN creation.
  func unlockSession() async
}

final actor QuickPinInteractorImpl: QuickPinInteractor {

  private let pinStorageController: PinStorageController
  private let pinThrottleController: PinThrottleController
  private let authenticationConfig: AuthenticationConfig
  private let sessionController: SessionController
  private let deviceLockController: DeviceLockController

  public let maxFailedPinAttempts: Int

  init(
    pinStorageController: PinStorageController,
    pinThrottleController: PinThrottleController,
    authenticationConfig: AuthenticationConfig,
    sessionController: SessionController,
    deviceLockController: DeviceLockController
  ) {
    self.pinStorageController = pinStorageController
    self.pinThrottleController = pinThrottleController
    self.authenticationConfig = authenticationConfig
    self.sessionController = sessionController
    self.deviceLockController = deviceLockController
    self.maxFailedPinAttempts = authenticationConfig.maxFailedPinAttempts
  }

  public func unlockSession() async {
    await sessionController.unlock()
  }

  public func setPin(newPin: String) -> QuickPinPartialState {
    guard getDeviceLockState() != .required else {
      return .failure(AuthenticationError.deviceLockRequired)
    }
    return storePin(newPin)
  }

  public func updatePin(newPin: String) -> QuickPinPartialState {
    storePin(newPin)
  }

  public func checkNewPin(_ pin: String) -> QuickPinPartialState {
    authenticationConfig.isWeakPin(pin) ? .failure(AuthenticationError.quickPinWeak) : .success
  }

  public func getDeviceLockState() -> DeviceLockState {
    guard !deviceLockController.isDeviceSecure() else { return .secure }
    return authenticationConfig.requireDeviceSecure ? .required : .missing
  }

  /// Stores a new PIN unless it is easy to guess; changing the PIN of a set-up wallet skips the passcode check, as
  /// on Android.
  private func storePin(_ newPin: String) -> QuickPinPartialState {
    guard !authenticationConfig.isWeakPin(newPin) else {
      return .failure(AuthenticationError.quickPinWeak)
    }
    do {
      try pinStorageController.setPin(with: newPin)
      return .success
    } catch {
      return .failure(error)
    }
  }

  public func isPinValid(pin: String) -> QuickPinPartialState {
    if self.isCurrentPinValid(pin: pin) {
      return .success
    } else {
      return .failure(AuthenticationError.quickPinInvalid)
    }
  }

  public func changePin(currentPin: String, newPin: String) -> QuickPinPartialState {
    if self.isCurrentPinValid(pin: currentPin) {
      return self.storePin(newPin)
    } else {
      return .failure(AuthenticationError.quickPinInvalid)
    }
  }

  public func hasPin() throws -> Bool {
    try pinStorageController.hasPin()
  }

  public func getPinLockoutState() -> PinLockoutState {
    pinThrottleController.getState()
  }

  public func recordPinFailure() -> PinLockoutState {
    pinThrottleController.recordFailure()
  }

  public func resetPinThrottle() {
    pinThrottleController.recordSuccess()
  }

  private func isCurrentPinValid(pin: String) -> Bool {
    pinStorageController.isPinValid(with: pin)
  }
}
