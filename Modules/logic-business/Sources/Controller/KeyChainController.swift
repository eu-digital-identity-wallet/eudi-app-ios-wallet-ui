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
import Foundation
import Security
import os
import LocalAuthentication
@preconcurrency import KeychainAccess

public protocol KeyChainWrapper {
  var value: String { get }
}

public protocol KeyChainController: Sendable {
  func storeValue(key: KeyChainWrapper, value: String)
  func storeValue(key: KeyChainWrapper, value: Data)
  func getValue(key: KeyChainWrapper) -> String?
  func getData(key: KeyChainWrapper) -> Data?
  /// Reads a string, telling a missing item (`nil`) apart from a failed read, which throws
  /// `KeyChainError.readFailed`.
  func fetchValue(key: KeyChainWrapper) throws -> String?
  /// Reads data, telling a missing item (`nil`) apart from a failed read, which throws
  /// `KeyChainError.readFailed`.
  func fetchData(key: KeyChainWrapper) throws -> Data?
  /// Writes a string; a failed write, which `storeValue` ignores, throws `KeyChainError.writeFailed`.
  func saveValue(key: KeyChainWrapper, value: String) throws
  /// Writes data; a failed write, which `storeValue` ignores, throws `KeyChainError.writeFailed`.
  func saveValue(key: KeyChainWrapper, value: Data) throws
  func removeObject(key: KeyChainWrapper)
  /// Writes the biometric probe, bound to the biometric enrolment of this moment (`.biometryCurrentSet`), when the
  /// user turns biometric unlock on; a probe already there is replaced.
  func storeBiometricProbe() throws
  /// Reads the probe with `context`, which has already evaluated the biometric policy, so the read does not prompt
  /// again. After a new enrolment the probe can no longer be read, as Android's key is invalidated by enrolment; a
  /// missing or unreadable probe throws `KeyChainError.itemNotFound`, and the PIN is needed.
  func validateKeyChainBiometry(with context: LAContext) throws
  func clearKeyChainBiometry()
  @discardableResult func clear() -> Bool
}

final class KeyChainControllerImpl: KeyChainController {

  private let biometryKey = "eu.europa.ec.euidi.biometric.access"
  private let configLogic: ConfigLogic
  private let keyChain: Keychain
  /// Whether the items of an earlier build have moved to `accessibility`; until then every read retries the move.
  private let isPreviousClassMoved = OSAllocatedUnfairLock(initialState: false)

  public init(configLogic: ConfigLogic) {
    self.configLogic = configLogic
    let accessGroup = configLogic.keyChainConfig.keychainAccessGroup
    let service = configLogic.keyChainConfig.documentStorageServiceName
    keyChain = Keychain(
      service: service,
      accessGroup: accessGroup
    )
    .accessibility(Self.accessibility)
    moveItemsFromThePreviousClassIfNeeded()
  }

  public func storeValue(key: KeyChainWrapper, value: String) {
    keyChain[key.value] = value
  }

  public func storeValue(key: KeyChainWrapper, value: Data) {
    keyChain[data: key.value] = value
  }

  public func getValue(key: KeyChainWrapper) -> String? {
    moveItemsFromThePreviousClassIfNeeded()
    return keyChain[key.value]
  }

  func getData(key: KeyChainWrapper) -> Data? {
    moveItemsFromThePreviousClassIfNeeded()
    return try? keyChain.getData(key.value)
  }

  public func fetchValue(key: KeyChainWrapper) throws -> String? {
    moveItemsFromThePreviousClassIfNeeded()
    do {
      return try keyChain.getString(key.value)
    } catch {
      throw KeyChainError.readFailed(status: keyChainStatus(of: error))
    }
  }

  public func fetchData(key: KeyChainWrapper) throws -> Data? {
    moveItemsFromThePreviousClassIfNeeded()
    do {
      return try keyChain.getData(key.value)
    } catch {
      throw KeyChainError.readFailed(status: keyChainStatus(of: error))
    }
  }

  public func saveValue(key: KeyChainWrapper, value: String) throws {
    do {
      try keyChain.set(value, key: key.value)
    } catch {
      throw KeyChainError.writeFailed(status: keyChainStatus(of: error))
    }
  }

  public func saveValue(key: KeyChainWrapper, value: Data) throws {
    do {
      try keyChain.set(value, key: key.value)
    } catch {
      throw KeyChainError.writeFailed(status: keyChainStatus(of: error))
    }
  }

  public func removeObject(key: KeyChainWrapper) {
    try? keyChain.remove(key.value)
  }

  public func storeBiometricProbe() throws {
    clearKeyChainBiometry()
    try setBiometricKey(value: UUID().uuidString)
  }

  public func validateKeyChainBiometry(with context: LAContext) throws {
    let item = try self.keyChain
      .authenticationContext(context)
      .get(self.biometryKey)
    try Self.validateBiometricItem(item)
  }

  public func clearKeyChainBiometry() {
    try? self.keyChain.remove(self.biometryKey)
  }

  /// Removes the app's keychain service, every generic-password item in the wallet's access group (document
  /// storage included) and every key item there, such as WalletKit's DPoP keys, so that no key an issuer has seen
  /// outlives a reset or a reinstall.
  @discardableResult
  public func clear() -> Bool {
    try? keyChain.removeAll()
    let isDocumentStorageCleared = clearDocumentStorage()
    return clearKeys() && isDocumentStorageCleared
  }
}

private extension KeyChainControllerImpl {

  /// Moves the items to this device's class until a move completes. The Keychain call runs outside the lock: two
  /// callers may both run it, which is harmless, as the update is the same.
  func moveItemsFromThePreviousClassIfNeeded() {
    guard !isPreviousClassMoved.withLock({ $0 }) else { return }
    let status = Self.moveItemsFromThePreviousClass(
      service: configLogic.keyChainConfig.documentStorageServiceName,
      accessGroup: configLogic.keyChainConfig.keychainAccessGroup
    )
    guard Self.isMoveComplete(status) else { return }
    isPreviousClassMoved.withLock { $0 = true }
  }
  /// The keychain status a KeychainAccess error carries, or `errSecInternalError` for any other error.
  func keyChainStatus(of error: Error) -> OSStatus {
    (error as? Status)?.rawValue ?? errSecInternalError
  }

  /// Deletes every key item in the wallet's access group, WalletKit's DPoP keys among them; true when the delete
  /// succeeded or found none.
  func clearKeys() -> Bool {
    var query: [String: Any] = [
      kSecClass as String: kSecClassKey,
      kSecUseDataProtectionKeychain as String: true
    ]
    let accessGroup = configLogic.keyChainConfig.keychainAccessGroup
    if !accessGroup.isEmpty {
      query[kSecAttrAccessGroup as String] = accessGroup
    }
    let status = SecItemDelete(query as CFDictionary)
    return status == errSecSuccess || status == errSecItemNotFound
  }

  func clearDocumentStorage() -> Bool {
    var query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecUseDataProtectionKeychain as String: true
    ]
    let accessGroup = configLogic.keyChainConfig.keychainAccessGroup
    if !accessGroup.isEmpty {
      query[kSecAttrAccessGroup as String] = accessGroup
    }
    let status = SecItemDelete(query as CFDictionary)
    return status == errSecSuccess || status == errSecItemNotFound
  }

  func setBiometricKey(value: String) throws {
    try self.keyChain
      .accessibility(
        .whenPasscodeSetThisDeviceOnly,
        authenticationPolicy: Self.biometricProbePolicy
      )
      .set(value, key: self.biometryKey)
  }

}

extension KeyChainControllerImpl {

  /// The probe's policy: readable only with the biometric enrolment present when it was written.
  static var biometricProbePolicy: AuthenticationPolicy { [.biometryCurrentSet] }

  /// The class of every item this controller writes, except the biometric probe: readable only while the device is
  /// unlocked, and backed up only under a key bound to this device, so the PIN salt and verifier never reach another
  /// device.
  static var accessibility: Accessibility { .whenUnlockedThisDeviceOnly }

  /// The items of `service` that a build before `accessibility` wrote as `.whenUnlocked`.
  static func previousClassQuery(service: String, accessGroup: String) -> [String: Any] {
    var query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: service,
      kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
    ]
    if !accessGroup.isEmpty {
      query[kSecAttrAccessGroup as String] = accessGroup
    }
    return query
  }

  /// The update that moves those items to `accessibility`.
  static func thisDeviceOnlyAttributes() -> [String: Any] {
    [kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly]
  }

  /// Moves the items an earlier build wrote as `.whenUnlocked` to `accessibility`.
  /// wallet-storage's items are written as `.whenPasscodeSetThisDeviceOnly` and are not touched.
  static func moveItemsFromThePreviousClass(service: String, accessGroup: String) -> OSStatus {
    SecItemUpdate(
      previousClassQuery(service: service, accessGroup: accessGroup) as CFDictionary,
      thisDeviceOnlyAttributes() as CFDictionary
    )
  }

  /// Done once the update succeeds or finds nothing; while the device is locked it fails, and the next read, at the
  /// latest the PIN check at login, tries again.
  static func isMoveComplete(_ status: OSStatus) -> Bool {
    status == errSecSuccess || status == errSecItemNotFound
  }

  /// Accepts the biometric probe only when the keychain returned it; a missing item fails. Internal so that unit
  /// tests can check the rule without a biometry-protected item.
  static func validateBiometricItem(_ item: String?) throws {
    guard let item, !item.isEmpty else {
      throw KeyChainError.itemNotFound
    }
  }
}
