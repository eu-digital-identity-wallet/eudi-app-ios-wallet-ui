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

public protocol QuickPinInteractor: Sendable {
  var maxFailedPinAttempts: Int { get }

  func setPin(newPin: String) async
  func isPinValid(pin: String) async -> QuickPinPartialState
  func changePin(currentPin: String, newPin: String) async -> QuickPinPartialState
  func hasPin() async -> Bool

  func getPinLockoutState() async -> PinLockoutState
  func recordPinFailure() async -> PinLockoutState
  func resetPinThrottle() async
}

final actor QuickPinInteractorImpl: QuickPinInteractor {

  private let pinStorageController: PinStorageController
  private let pinThrottleController: PinThrottleController
  private let authenticationConfig: AuthenticationConfig

  public let maxFailedPinAttempts: Int

  init(
    pinStorageController: PinStorageController,
    pinThrottleController: PinThrottleController,
    authenticationConfig: AuthenticationConfig
  ) {
    self.pinStorageController = pinStorageController
    self.pinThrottleController = pinThrottleController
    self.authenticationConfig = authenticationConfig
    self.maxFailedPinAttempts = authenticationConfig.maxFailedPinAttempts
  }

  public func setPin(newPin: String) {
    pinStorageController.setPin(with: newPin)
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
      self.setPin(newPin: newPin)
      return .success
    } else {
      return .failure(AuthenticationError.quickPinInvalid)
    }
  }

  public func hasPin() -> Bool {
    pinStorageController.hasPin()
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
