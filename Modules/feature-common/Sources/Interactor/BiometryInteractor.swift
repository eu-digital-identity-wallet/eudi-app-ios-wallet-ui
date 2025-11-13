/*
 * Copyright (c) 2025 European Commission
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
  func authenticate() async -> BiometricsState
  func openSettings(action: @escaping @Sendable () -> Void) async
  func getBiometricsImage() async -> Image?
  func getBiometricsMethod() async -> String
  func getBiometryType() async -> LABiometryType
  func isBiometryEnabled() async -> Bool
  func setBiometrySelection(isEnabled: Bool) async
  func isPinValid(with pin: String) async -> QuickPinPartialState
}

final actor BiometryInteractorImpl: BiometryInteractor {

  private let prefsController: PrefsController
  private let quickPinInteractor: QuickPinInteractor
  private let biometryController: SystemBiometryController

  init(
    prefsController: PrefsController,
    quickPinInteractor: QuickPinInteractor,
    biometryController: SystemBiometryController
  ) {
    self.prefsController = prefsController
    self.quickPinInteractor = quickPinInteractor
    self.biometryController = biometryController
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

  public func authenticate() async -> BiometricsState {
    do {
      try await biometryController.requestBiometricUnlock()
      return .authenticated
    } catch let error as SystemBiometryError {
      return .failure(error)
    } catch {
      return .failure(.biometricError)
    }
  }

  public func openSettings(action: @escaping @Sendable () -> Void) async {
    await biometryController.openSettings(action: action)
  }

  public func isBiometryEnabled() -> Bool {
    prefsController.getBool(forKey: .biometryEnabled)
  }

  public func setBiometrySelection(isEnabled: Bool) {
    prefsController.setValue(isEnabled, forKey: .biometryEnabled)
  }

  public func isPinValid(with pin: String) async -> QuickPinPartialState {
    await quickPinInteractor.isPinValid(pin: pin)
  }
}
