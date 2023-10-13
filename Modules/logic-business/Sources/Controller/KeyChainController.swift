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
import KeychainAccess

public enum KeychainWrapper: String {
  case deviceVendorId
  case devicePin
}

public protocol KeyChainControllerType {
  func storeValue(key: KeychainWrapper, value: String)
  func getValue(key: KeychainWrapper) -> String?
  func removeObject(key: KeychainWrapper)
  func validateKeyChainBiometry() throws
  func clearKeyChainBiometry()
}

public final class KeyChainController: KeyChainControllerType {

  private let biometryKey = "eu.europa.ec.euidi.biometric.access"

  public init() {}

  private lazy var keyChain: Keychain = {
    Keychain()
  }()

  public func storeValue(key: KeychainWrapper, value: String) {
    keyChain[key.rawValue] = value
  }

  public func getValue(key: KeychainWrapper) -> String? {
    keyChain[key.rawValue]
  }

  public func removeObject(key: KeychainWrapper) {
    try? keyChain.remove(key.rawValue)
  }

  public func validateKeyChainBiometry() throws {
    try setBiometricKey()
    try isBiometricKeyValid()
  }

  public func clearKeyChainBiometry() {
    try? self.keyChain.remove(self.biometryKey)
  }
}

private extension KeyChainController {
  func setBiometricKey() throws {
    try self.keyChain
      .accessibility(
        .whenPasscodeSetThisDeviceOnly,
        authenticationPolicy: [.touchIDAny]
      )
      .set(UUID().uuidString, key: self.biometryKey)
  }

  func isBiometricKeyValid() throws {

    let item = try self.keyChain
      .get(self.biometryKey)

    if item != nil {
      clearKeyChainBiometry()
    }
  }
}
