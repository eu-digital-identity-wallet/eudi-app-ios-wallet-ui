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
import logic_ui
import logic_business
import SwiftUI
import Combine
import LocalAuthentication

public protocol BiometryInteractorType {

  func authenticate() -> AnyPublisher<BiometricsState, Never>
  func openSettingsURL(action: @escaping () -> Void)
  var biometricsImage: Image? { get }
  var currentBiometricsMethod: String { get }
  var biometryType: LABiometryType { get }

  func isBiometryEnabled() -> Bool
  func setBiometrySelection(isEnabled: Bool)
  func isPinValid(with pin: String) -> QuickPinPartialState
}

public final class BiometryInteractor: SystemBiometricsInteractor, BiometryInteractorType {

  private lazy var prefsController: PrefsControllerType = PrefsController()
  private lazy var quickPinInteractor: QuickPinInteractorType = QuickPinInteractor()

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
