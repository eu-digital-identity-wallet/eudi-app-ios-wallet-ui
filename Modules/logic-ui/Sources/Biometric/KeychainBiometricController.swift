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
import Foundation

protocol KeychainBiometricControllerType {
  func isAccessControlValid() -> Bool
  func setAccessControl()
}

final class KeychainBiometricController: KeychainBiometricControllerType {

  private let biometricsKeychainLabel = "eu.europa.ec.euidi.biometric.access"

  private lazy var configLogic: ConfigLogic = ConfigProvider.shared.getConfigLogic()

  private let bundleId: String

  init() {
    guard let bundleId = Bundle.main.bundleIdentifier else {
      fatalError("KeychainBiometricController:: cannot obtain bundle identifier")
    }
    self.bundleId = bundleId
  }

  func setAccessControl() {
    guard let query = self.getAccessControlInsertionDictionary() else {
      return
    }
    SecItemAdd(query, nil)
  }

  func isAccessControlValid() -> Bool {
    var queryResult: AnyObject?
    let status = SecItemCopyMatching(self.getAccessControlSearchQuery(), &queryResult)
    return status == noErr
  }

  private func getAccessControlInsertionDictionary() -> CFDictionary? {
    guard
      let accessControl = SecAccessControlCreateWithFlags(
        nil, kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly, .biometryCurrentSet, nil
      )
    else {
      return nil
    }
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrLabel as String: self.biometricsKeychainLabel,
      kSecAttrAccount as String: self.bundleId,
      kSecValueData as String: "\(self.bundleId)_\(self.configLogic.appBuildType.rawValue)".data(using: .utf8)! as NSData,
      kSecAttrAccessControl as String: accessControl as Any
    ]
    return query as CFDictionary
  }

  private func getAccessControlSearchQuery() -> CFDictionary {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecReturnData as String: true,
      kSecMatchLimit as String: kSecMatchLimitOne,
      kSecAttrAccount as String: self.bundleId,
      kSecAttrLabel as String: self.biometricsKeychainLabel
    ]
    return query as CFDictionary
  }
}
