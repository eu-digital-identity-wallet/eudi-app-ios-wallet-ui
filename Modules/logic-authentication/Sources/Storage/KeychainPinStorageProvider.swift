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
import CommonCrypto
import logic_business

final class KeychainPinStorageProvider: PinStorageProvider {

  private let keyChainController: KeyChainController

  init(keyChainController: KeyChainController) {
    self.keyChainController = keyChainController
  }

  /// Whether a complete PIN record exists. A missing or partial record is `false`.
  /// - Throws: `KeyChainError.readFailed` when the record cannot be read, so that an unreadable PIN is
  ///   never taken for a new wallet.
  func hasPin() throws -> Bool {
    let salt = try keyChainController.fetchData(key: KeyIdentifier.devicePinSalt)
    let hash = try keyChainController.fetchData(key: KeyIdentifier.devicePinHash)
    let iterationsString = try keyChainController.fetchValue(key: KeyIdentifier.devicePinIterations)

    guard
      let salt,
      let hash,
      let iterationsString,
      let iterations = Int(iterationsString),
      !salt.isEmpty,
      !hash.isEmpty,
      iterations > 0
    else {
      return false
    }

    return true
  }

  /// Writes the salt, hash and iteration count together. If a write fails, the previous record is
  /// put back, or the partial one removed, and the error is thrown. The record left behind is the
  /// previous one or none, never a mix of the two.
  /// - Throws: `AuthenticationError.quickPinInvalid` for an empty PIN, which is never stored;
  ///   `KeyChainError.readFailed` before anything is written, or `KeyChainError.writeFailed`.
  func setPin(with pin: String) throws {

    guard !pin.isEmpty else { throw AuthenticationError.quickPinInvalid }

    let previousSalt = try keyChainController.fetchData(key: KeyIdentifier.devicePinSalt)
    let previousHash = try keyChainController.fetchData(key: KeyIdentifier.devicePinHash)
    let previousIterations = try keyChainController.fetchValue(key: KeyIdentifier.devicePinIterations)

    let salt = randomSalt(length: Constants.saltSize)

    let hash = derivePinHash(
      pin: pin,
      salt: salt,
      iterations: Constants.defaultIterations,
      outputLength: Constants.derivedKeyLength
    )

    do {
      try keyChainController.saveValue(key: KeyIdentifier.devicePinSalt, value: salt)
      try keyChainController.saveValue(key: KeyIdentifier.devicePinHash, value: hash)
      try keyChainController.saveValue(
        key: KeyIdentifier.devicePinIterations,
        value: String(Constants.defaultIterations)
      )
    } catch {
      restoreRecord(salt: previousSalt, hash: previousHash, iterations: previousIterations)
      throw error
    }
  }

  func isPinValid(with pin: String) -> Bool {

    guard !pin.isEmpty else { return false }

    guard
      let salt = keyChainController.getData(key: KeyIdentifier.devicePinSalt),
      let expectedHash = keyChainController.getData(key: KeyIdentifier.devicePinHash),
      let iterationsString = keyChainController.getValue(key: KeyIdentifier.devicePinIterations),
      let iterations = Int(iterationsString),
      iterations > 0
    else {
      return false
    }

    let candidateHash = derivePinHash(
      pin: pin,
      salt: salt,
      iterations: iterations,
      outputLength: expectedHash.count
    )

    return constantTimeEquals(expectedHash, candidateHash)
  }
}

extension KeychainPinStorageProvider {

  enum KeyIdentifier: String, KeyChainWrapper {

    var value: String { rawValue }

    case devicePinSalt
    case devicePinHash
    case devicePinIterations
  }

  enum Constants {
    static let saltSize = 32
    static let defaultIterations = 210_000
    static let derivedKeyLength = 32
  }
}

private extension KeychainPinStorageProvider {

  /// Puts the previous record back. If that fails too, removes all three items, so that the start-up
  /// gate sees no PIN rather than a record that no PIN matches.
  func restoreRecord(salt: Data?, hash: Data?, iterations: String?) {
    do {
      try restore(key: KeyIdentifier.devicePinSalt, value: salt)
      try restore(key: KeyIdentifier.devicePinHash, value: hash)
      try restore(key: KeyIdentifier.devicePinIterations, value: iterations)
    } catch {
      keyChainController.removeObject(key: KeyIdentifier.devicePinSalt)
      keyChainController.removeObject(key: KeyIdentifier.devicePinHash)
      keyChainController.removeObject(key: KeyIdentifier.devicePinIterations)
    }
  }

  /// Writes `value` back, or removes the item when there was none.
  func restore(key: KeyIdentifier, value: Data?) throws {
    if let value {
      try keyChainController.saveValue(key: key, value: value)
    } else {
      keyChainController.removeObject(key: key)
    }
  }

  /// Writes `value` back, or removes the item when there was none.
  func restore(key: KeyIdentifier, value: String?) throws {
    if let value {
      try keyChainController.saveValue(key: key, value: value)
    } else {
      keyChainController.removeObject(key: key)
    }
  }

  func randomSalt(length: Int) -> Data {
    var bytes = [UInt8](repeating: 0, count: length)
    let status = SecRandomCopyBytes(kSecRandomDefault, length, &bytes)
    precondition(status == errSecSuccess, "Failed to generate secure random salt")
    return Data(bytes)
  }

  func derivePinHash(
    pin: String,
    salt: Data,
    iterations: Int,
    outputLength: Int
  ) -> Data {

    let passwordData = Data(pin.utf8)

    let key = pbkdf2SHA256(
      password: passwordData,
      salt: salt,
      rounds: iterations,
      outputLength: outputLength
    )

    return key
  }

  func constantTimeEquals(_ lhs: Data, _ rhs: Data) -> Bool {

    guard lhs.count == rhs.count else { return false }

    var diff: UInt8 = 0
    for i in 0..<lhs.count {
      diff |= lhs[i] ^ rhs[i]
    }

    return diff == 0
  }

  func pbkdf2SHA256(
    password: Data,
    salt: Data,
    rounds: Int,
    outputLength: Int
  ) -> Data {

    var derived = Data(count: outputLength)

    let result = derived.withUnsafeMutableBytes { derivedBytes in
      password.withUnsafeBytes { passwordBytes in
        salt.withUnsafeBytes { saltBytes in
          CCKeyDerivationPBKDF(
            CCPBKDFAlgorithm(kCCPBKDF2),
            passwordBytes.bindMemory(to: Int8.self).baseAddress,
            password.count,
            saltBytes.bindMemory(to: UInt8.self).baseAddress,
            salt.count,
            CCPseudoRandomAlgorithm(kCCPRFHmacAlgSHA256),
            UInt32(rounds),
            derivedBytes.bindMemory(to: UInt8.self).baseAddress,
            outputLength
          )
        }
      }
    }

    precondition(result == kCCSuccess, "PBKDF2 derivation failed")

    return derived
  }
}
