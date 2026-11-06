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
import logic_ui
import logic_authentication
import LocalAuthentication

public enum BiometricsState: Equatable, Sendable {
  case authenticated
  case failure(SystemBiometryError)
}

public protocol BiometryInteractor: Sendable {
  var maxFailedPinAttempts: Int { get }

  func authenticate() async -> BiometricsState
  func openSettings(action: @escaping @Sendable () -> Void) async
  func getBiometricsImage() async -> Image?
  func getBiometricsMethod() async -> String
  func getBiometryType() async -> LABiometryType
  func isBiometryEnabled() async -> Bool
  /// Turns biometric unlock on after a biometric check, keeping the choice only when the check passes, or off at
  /// once. The caller first confirms the user with the PIN, or, to turn it off, with the PIN or a biometric.
  func setBiometrySelection(isEnabled: Bool) async -> BiometricsState
  func isPinValid(with pin: String) async -> QuickPinPartialState

  func getPinLockoutState() async -> PinLockoutState
  func recordPinFailure() async -> PinLockoutState
  func resetPinThrottle() async

  /// Unlocks the wallet's session after a successful login.
  func unlockSession() async

  /// Whether the device has a passcode and whether the wallet requires one, under the rules setup applies
  /// (`QuickPinInteractor.getDeviceLockState()`), so that the login screen notices a passcode removed after setup.
  func getDeviceLockState() async -> DeviceLockState
}

final actor BiometryInteractorImpl: BiometryInteractor {

  private let prefsController: PrefsController
  private let quickPinInteractor: QuickPinInteractor
  private let biometryController: SystemBiometryController
  private let pinThrottleController: PinThrottleController
  private let authenticationConfig: AuthenticationConfig

  public let maxFailedPinAttempts: Int

  init(
    prefsController: PrefsController,
    quickPinInteractor: QuickPinInteractor,
    biometryController: SystemBiometryController,
    pinThrottleController: PinThrottleController,
    authenticationConfig: AuthenticationConfig
  ) {
    self.prefsController = prefsController
    self.quickPinInteractor = quickPinInteractor
    self.biometryController = biometryController
    self.pinThrottleController = pinThrottleController
    self.authenticationConfig = authenticationConfig
    self.maxFailedPinAttempts = authenticationConfig.maxFailedPinAttempts
  }

  public func unlockSession() async {
    await quickPinInteractor.unlockSession()
  }

  public func getDeviceLockState() async -> DeviceLockState {
    await quickPinInteractor.getDeviceLockState()
  }

  public func getBiometryType() async -> LABiometryType {
    await biometryController.getBiometryType()
  }

  public func getBiometricsImage() async -> Image? {
    switch await biometryController.getBiometryType() {
    case .faceID:
      Theme.shared.image.faceId
    case .touchID:
      Theme.shared.image.touchId
    default: nil
    }
  }

  public func getBiometricsMethod() async -> String {
    switch await biometryController.getBiometryType() {
    case .faceID:
      return "Face ID"
    case .touchID:
      return "Touch ID"
    default:
      return ""
    }
  }

  /// An install from before the enrolment binding has biometric unlock on but not bound; its first biometric login
  /// binds it, as Android binds its key at the first biometric success.
  public func authenticate() async -> BiometricsState {
    do {
      if isBiometryEnabled() && !prefsController.getBool(forKey: .biometricUnlockBound) {
        try await bindBiometricUnlock()
      } else {
        try await biometryController.requestBiometricUnlock()
      }
      return .authenticated
    } catch {
      return Self.biometricFailure(for: error)
    }
  }

  public func openSettings(action: @escaping @Sendable () -> Void) async {
    await biometryController.openSettings(action: action)
  }

  public func isBiometryEnabled() -> Bool {
    prefsController.getBool(forKey: .biometryEnabled)
  }

  public func setBiometrySelection(isEnabled: Bool) async -> BiometricsState {
    do {
      if isEnabled {
        try await bindBiometricUnlock()
      } else {
        try await biometryController.disableBiometricUnlock()
        prefsController.setValue(false, forKey: .biometricUnlockBound)
      }
      prefsController.setValue(isEnabled, forKey: .biometryEnabled)
      return .authenticated
    } catch {
      return Self.biometricFailure(for: error)
    }
  }

  public func isPinValid(with pin: String) async -> QuickPinPartialState {
    await quickPinInteractor.isPinValid(pin: pin)
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

  /// Binds biometric unlock to the current enrolment and records it.
  private func bindBiometricUnlock() async throws {
    try await biometryController.enableBiometricUnlock()
    prefsController.setValue(true, forKey: .biometricUnlockBound)
  }

  /// The failure state for `error`, a generic biometric error unless it is a `SystemBiometryError`.
  private static func biometricFailure(for error: Error) -> BiometricsState {
    .failure(error as? SystemBiometryError ?? .biometricError)
  }
}
