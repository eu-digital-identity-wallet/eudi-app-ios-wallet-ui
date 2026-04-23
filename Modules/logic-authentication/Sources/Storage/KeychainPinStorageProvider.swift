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
import CommonCrypto
import logic_business

final class KeychainPinStorageProvider: PinStorageProvider {

  private let keyChainController: KeyChainController

  init(keyChainController: KeyChainController) {
    self.keyChainController = keyChainController
  }

  func hasPin() -> Bool {
    guard
      let salt = keyChainController.getData(key: KeyIdentifier.devicePinSalt),
      let hash = keyChainController.getData(key: KeyIdentifier.devicePinHash),
      let iterationsString = keyChainController.getValue(key: KeyIdentifier.devicePinIterations),
      let iterations = Int(iterationsString),
      !salt.isEmpty,
      !hash.isEmpty,
      iterations > 0
    else {
      return false
    }

    return true
  }

  func setPin(with pin: String) {

    guard !pin.isEmpty else { return }

    let salt = randomSalt(length: Constants.saltSize)

    let hash = derivePinHash(
      pin: pin,
      salt: salt,
      iterations: Constants.defaultIterations,
      outputLength: Constants.derivedKeyLength
    )

    keyChainController.storeValue(key: KeyIdentifier.devicePinSalt, value: salt)
    keyChainController.storeValue(key: KeyIdentifier.devicePinHash, value: hash)
    keyChainController.storeValue(
      key: KeyIdentifier.devicePinIterations,
      value: String(Constants.defaultIterations)
    )
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

private extension KeychainPinStorageProvider {

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
