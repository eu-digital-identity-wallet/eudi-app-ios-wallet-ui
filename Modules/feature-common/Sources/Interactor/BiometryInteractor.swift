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
import logic_ui
import logic_authentication
import logic_business
import SwiftUI
import Combine
import LocalAuthentication

public protocol BiometryInteractor {

  func authenticate() -> AnyPublisher<BiometricsState, Never>
  func openSettingsURL(action: @escaping () -> Void)
  var biometricsImage: Image? { get }
  var currentBiometricsMethod: String { get }
  var biometryType: LABiometryType { get }

  func isBiometryEnabled() -> Bool
  func setBiometrySelection(isEnabled: Bool)
  func isPinValid(with pin: String) -> QuickPinPartialState
}

final class BiometryInteractorImpl: SystemBiometryInteractorImpl, BiometryInteractor {

  private let prefsController: PrefsController
  private let quickPinInteractor: QuickPinInteractor

  init(
    prefsController: PrefsController,
    quickPinInteractor: QuickPinInteractor,
    biometryController: SystemBiometryController,
    useTestDispatcher: Bool = false
  ) {
    self.prefsController = prefsController
    self.quickPinInteractor = quickPinInteractor
    super.init(with: biometryController, useTestDispatcher: useTestDispatcher)
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
