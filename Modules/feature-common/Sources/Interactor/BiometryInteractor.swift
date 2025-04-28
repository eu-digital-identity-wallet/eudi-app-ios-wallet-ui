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
import logic_ui
import logic_authentication
import LocalAuthentication

public enum BiometricsState: Equatable, Sendable {
  case idle
  case loading
  case authenticated
  case failure(SystemBiometryError)
}

public protocol BiometryInteractor: Sendable {

  func authenticate() -> AnyPublisher<BiometricsState, Never>
  @MainActor func openSettingsURL(action: @escaping () -> Void)
  var biometricsImage: Image? { get }
  var currentBiometricsMethod: String { get }
  var biometryType: LABiometryType { get }

  func isBiometryEnabled() -> Bool
  func setBiometrySelection(isEnabled: Bool)
  func isPinValid(with pin: String) -> QuickPinPartialState
}

final class BiometryInteractorImpl: BiometryInteractor {

  private let prefsController: PrefsController
  private let quickPinInteractor: QuickPinInteractor
  private let biometryController: SystemBiometryController

  private let useTestDispatcher: Bool

  init(
    prefsController: PrefsController,
    quickPinInteractor: QuickPinInteractor,
    biometryController: SystemBiometryController,
    useTestDispatcher: Bool = false
  ) {
    self.prefsController = prefsController
    self.quickPinInteractor = quickPinInteractor
    self.biometryController = biometryController
    self.useTestDispatcher = useTestDispatcher
  }

  public var biometryType: LABiometryType {
    biometryController.biometryType
  }

  public func authenticate() -> AnyPublisher<BiometricsState, Never> {

    let publisher = biometryController.requestBiometricUnlock()
      .map { BiometricsState.authenticated }
      .catch { error -> AnyPublisher<BiometricsState, Never> in
        return Just(BiometricsState.failure(error)).eraseToAnyPublisher()
      }

    if !self.useTestDispatcher {
      return publisher
        .subscribe(on: DispatchQueue.global(qos: .userInitiated))
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    } else {
      return publisher.eraseToAnyPublisher()
    }
  }

  public var biometricsImage: Image? {
    return switch biometryController.biometryType {
    case .faceID:
      Theme.shared.image.faceId
    case .touchID:
      Theme.shared.image.touchId
    default: nil
    }
  }

  public var currentBiometricsMethod: String {
    switch biometryController.biometryType {
    case .faceID:
      return "Face ID"
    case .touchID:
      return "Touch ID"
    default:
      return ""
    }
  }

  public func openSettingsURL(action: @escaping () -> Void) {
    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
    UIApplication.shared.open(url, options: [:]) { success in
      guard success else { return }
      action()
    }
  }

  public func isBiometryEnabled() -> Bool {
    prefsController.getBool(forKey: .biometryEnabled)
  }

  public func setBiometrySelection(isEnabled: Bool) {
    prefsController.setValue(isEnabled, forKey: .biometryEnabled)
  }

  public func isPinValid(with pin: String) -> QuickPinPartialState {
    quickPinInteractor.isPinValid(pin: pin)
  }

}
