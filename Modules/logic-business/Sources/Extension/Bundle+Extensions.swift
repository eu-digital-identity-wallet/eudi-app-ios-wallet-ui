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

  /// Gets the keychain access group based on the main app bundle identifier.
  /// This tries to read the access group from an existing keychain item first.
  /// If no items exist, it constructs the access group from the bundle identifier.
  /// Always returns a non-nil value to ensure compatibility with APIs that require it.
  static func getKeychainAccessGroup() -> String {
    // Try to read ANY existing keychain item to get the access group
    // This is safer than trying to create an item, which requires proper entitlements
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecMatchLimit as String: kSecMatchLimitOne,
      kSecReturnAttributes as String: true
    ]

    var result: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &result)

    // If we found an existing item, read its access group
    if status == errSecSuccess,
       let attributes = result as? [String: Any],
       let accessGroup = attributes[kSecAttrAccessGroup as String] as? String,
       !accessGroup.isEmpty {
      return accessGroup
    }

    // If no existing items found, construct the access group from bundle identifier
    // The access group format in entitlements is: $(AppIdentifierPrefix){BundleID}
    // At runtime, we need to construct: {TeamID}.{BundleID}
    // We'll use the main app bundle ID as the base
    let mainAppBundleID = getMainAppBundleID()

    // Try to extract team ID from the current bundle identifier
    // Some bundle IDs include the team ID as a prefix: {TeamID}.{BundleID}
    if let bundleID = Bundle.main.bundleIdentifier {
      let components = bundleID.split(separator: ".")

      // Check if first component looks like a team ID (typically 10 characters, alphanumeric)
      if components.count > 2,
         let firstComponent = components.first,
         firstComponent.count == 10,
         firstComponent.allSatisfy({ $0.isLetter || $0.isNumber }) {
        // Construct access group with team ID prefix
        return "\(firstComponent).\(mainAppBundleID)"
      }
    }

    // Fallback: return the team ID and main app bundle ID as the access group
    return "\("Team ID".valueFromBundle).\(mainAppBundleID)"
  }
}
