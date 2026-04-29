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

public extension Bundle {
  /// Gets the main app bundle identifier, working correctly in both main app and extension contexts.
  /// In extensions, this derives the main app bundle ID by removing the extension suffix.
  /// In the main app, this returns the bundle identifier directly.
  static func getMainAppBundleID() -> String {
    guard let bundleID = Bundle.main.bundleIdentifier else {
      return ""
    }

    // Check if we're in an extension by looking for common extension bundle patterns
    // Extensions typically have bundle IDs like: main.app.bundle.id.ExtensionName
    // We detect this by checking if the bundle path contains ".appex" or if the bundle ID
    // has more components than expected (indicating it's an extension)

    let isExtension = Bundle.main.bundlePath.contains(".appex")

    if isExtension {
      // In an extension, derive the main app bundle ID by dropping the last component
      let components = bundleID.split(separator: ".")
      if components.count > 1 {
        return components.dropLast().joined(separator: ".")
      }
    }

    // In the main app, return the bundle identifier as-is
    return bundleID
  }

  /// Gets the document storage service name using the main app bundle ID.
  static func getDocumentStorageServiceName() -> String {
    let mainAppBundleID = getMainAppBundleID()
    guard !mainAppBundleID.isEmpty else {
      return "eudi.document.storage"
    }
    return "\(mainAppBundleID).eudi.document.storage"
  }

  /// Gets the keychain access group by writing a temporary probe item and reading back the
  /// access group the OS assigned. When no `kSecAttrAccessGroup` is specified, the OS places
  /// the item in the app's default keychain group, which is the first entry in the
  /// `keychain-access-groups` entitlement — already fully resolved by Xcode (e.g.
  /// `AZXQE7588Y.eu.europa.ec.euidi.dev`). This works correctly on both simulator and device.
  static func getKeychainAccessGroup() -> String {
    let probeAccount = "eu.europa.ec.euidi.access.group.probe"

    let deleteQuery: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: probeAccount
    ]
    SecItemDelete(deleteQuery as CFDictionary)

    let addQuery: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: probeAccount,
      kSecValueData as String: Data("probe".utf8)
    ]

    guard SecItemAdd(addQuery as CFDictionary, nil) == errSecSuccess else {
      return getMainAppBundleID()
    }

    let readQuery: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: probeAccount,
      kSecMatchLimit as String: kSecMatchLimitOne,
      kSecReturnAttributes as String: true
    ]

    var result: CFTypeRef?
    let accessGroup: String
    if SecItemCopyMatching(readQuery as CFDictionary, &result) == errSecSuccess,
       let attributes = result as? [String: Any],
       let group = attributes[kSecAttrAccessGroup as String] as? String,
       !group.isEmpty {
      accessGroup = group
    } else {
      accessGroup = getMainAppBundleID()
    }

    SecItemDelete(deleteQuery as CFDictionary)
    return accessGroup
  }
}
