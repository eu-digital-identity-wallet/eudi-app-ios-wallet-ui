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
import KeychainAccess

public protocol KeychainWrapper {
  var value: String { get }
}

public protocol KeyChainController {
  func storeValue(key: KeychainWrapper, value: String)
  func getValue(key: KeychainWrapper) -> String?
  func removeObject(key: KeychainWrapper)
  func validateKeyChainBiometry() throws
  func clearKeyChainBiometry()
  func clear()
}

final class KeyChainControllerImpl: KeyChainController {

  private let biometryKey = "eu.europa.ec.euidi.biometric.access"

  private lazy var keyChain: Keychain = {
    Keychain()
  }()

  public func storeValue(key: KeychainWrapper, value: String) {
    keyChain[key.value] = value
  }

  public func getValue(key: KeychainWrapper) -> String? {
    keyChain[key.value]
  }

  public func removeObject(key: KeychainWrapper) {
    try? keyChain.remove(key.value)
  }

  public func validateKeyChainBiometry() throws {
    try setBiometricKey()
    try isBiometricKeyValid()
  }

  public func clearKeyChainBiometry() {
    try? self.keyChain.remove(self.biometryKey)
  }

  public func clear() {
    try? keyChain.removeAll()
  }
}

private extension KeyChainControllerImpl {
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
