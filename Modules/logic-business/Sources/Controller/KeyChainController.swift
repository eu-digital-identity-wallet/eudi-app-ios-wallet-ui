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
import Foundation
@preconcurrency import KeychainAccess

public protocol KeyChainWrapper {
  var value: String { get }
}

public protocol KeyChainController: Sendable {
  func storeValue(key: KeyChainWrapper, value: String)
  func storeValue(key: KeyChainWrapper, value: Data)
  func getValue(key: KeyChainWrapper) -> String?
  func getData(key: KeyChainWrapper) -> Data?
  func removeObject(key: KeyChainWrapper)
  func validateKeyChainBiometry() throws
  func clearKeyChainBiometry()
  func clear()
}

final class KeyChainControllerImpl: KeyChainController {

  private let biometryKey = "eu.europa.ec.euidi.biometric.access"
  private let keyChain: Keychain = Keychain()

  public func storeValue(key: KeyChainWrapper, value: String) {
    keyChain[key.value] = value
  }

  public func storeValue(key: KeyChainWrapper, value: Data) {
    keyChain[data: key.value] = value
  }

  public func getValue(key: KeyChainWrapper) -> String? {
    keyChain[key.value]
  }

  func getData(key: KeyChainWrapper) -> Data? {
    try? keyChain.getData(key.value)
  }

  public func removeObject(key: KeyChainWrapper) {
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
        authenticationPolicy: [.biometryAny]
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
