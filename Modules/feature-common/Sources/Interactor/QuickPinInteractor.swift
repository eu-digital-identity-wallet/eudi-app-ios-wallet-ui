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
import logic_business
import Combine
import Foundation

public enum QuickPinPartialState {
  case success
  case failure(Error)
}

public protocol QuickPinInteractorType {
  func setPin(newPin: String)
  func isPinValid(pin: String) -> QuickPinPartialState
  func changePin(currentPin: String, newPin: String) -> QuickPinPartialState
}

public final class QuickPinInteractor: QuickPinInteractorType {

  private lazy var keyChainController: KeyChainControllerType = KeyChainController()

  public init() {}

  public func setPin(newPin: String) {
    keyChainController.storeValue(key: .devicePin, value: newPin)
  }

  public func isPinValid(pin: String) -> QuickPinPartialState {
    if self.isCurrentPinValid(pin: pin) {
      return .success
    } else {
      return .failure(RuntimeError.quickPinInvalid)
    }
  }

  public func changePin(currentPin: String, newPin: String) -> QuickPinPartialState {
    if self.isCurrentPinValid(pin: currentPin) {
      self.setPin(newPin: newPin)
      return .success
    } else {
      return .failure(RuntimeError.quickPinInvalid)
    }
  }

  private func isCurrentPinValid(pin: String) -> Bool {
    return keyChainController.getValue(key: .devicePin) == pin
  }
}
