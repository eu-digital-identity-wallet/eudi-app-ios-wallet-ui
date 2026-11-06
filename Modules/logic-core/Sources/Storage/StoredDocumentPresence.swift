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
import logic_business

/// Tells whether wallet-storage's `KeyChainStorageService` holds a document, from the Keychain alone.
/// Each query looks for one document item in one status, `<serviceName>:pdoc:<status>` as
/// `KeyChainStorageService.makeQuery` names it (every document has one, deferred ones included), and
/// returns neither its attributes nor its data. Another `DataStorageService` needs its own check.
struct StoredDocumentPresence: Sendable {

  let serviceName: String
  let accessGroup: String
  let copyMatching: @Sendable ([String: Any]) -> OSStatus

  init(
    serviceName: String,
    accessGroup: String,
    copyMatching: @escaping @Sendable ([String: Any]) -> OSStatus = { SecItemCopyMatching($0 as CFDictionary, nil) }
  ) {
    self.serviceName = serviceName
    self.accessGroup = accessGroup
    self.copyMatching = copyMatching
  }

  /// `true` as soon as one status holds a document. A read error throws `KeyChainError.readFailed`.
  func hasDocuments() throws -> Bool {
    for documentStatus in WalletStorage.DocumentStatus.allCases {
      switch copyMatching(query(for: documentStatus)) {
      case errSecSuccess:
        return true
      case errSecItemNotFound:
        continue
      case let readStatus:
        throw KeyChainError.readFailed(status: readStatus)
      }
    }
    return false
  }

  func query(for documentStatus: WalletStorage.DocumentStatus) -> [String: Any] {
    var query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: [
        serviceName,
        SavedKeyChainDataType.docPresent.rawValue,
        documentStatus.rawValue
      ].joined(separator: ":"),
      kSecUseDataProtectionKeychain as String: true,
      kSecMatchLimit as String: kSecMatchLimitOne
    ]
    if !accessGroup.isEmpty {
      query[kSecAttrAccessGroup as String] = accessGroup
    }
    return query
  }
}
