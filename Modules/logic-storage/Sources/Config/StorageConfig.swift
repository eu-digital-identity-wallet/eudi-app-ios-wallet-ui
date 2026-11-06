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
import SwiftData

protocol StorageConfig: Sendable {
  var databaseName: String { get }
  var databaseFolder: String { get }
  var databaseExtension: String { get }
  var schemas: Schema { get }
  var storeURL: URL { get }
  var modelConfiguration: ModelConfiguration { get }
}

final class StorageConfigImpl: StorageConfig {

  var databaseName: String { "eudi_wallet" }

  var databaseExtension: String { "store" }

  var databaseFolder: String { "Storage" }

  var schemas: Schema {
    Schema(
      [
        SDBookmark.self,
        SDTransactionLog.self,
        SDRevokedDocument.self,
        SDFailedReIssuedDocument.self,
        SDStatusRefreshFailure.self
      ]
    )
  }

  var storeURL: URL {
    let base = sharedContainerURL ?? FileManager.default.urls(
      for: .applicationSupportDirectory,
      in: .userDomainMask
    ).first ?? FileManager.default.temporaryDirectory

    var dir = base.appendingPathComponent(
      databaseFolder,
      isDirectory: true
    )

    try? FileManager.default.createDirectory(
      at: dir,
      withIntermediateDirectories: true
    )
    dir.excludeFromBackup()

    return dir
      .appendingPathComponent(databaseName)
      .appendingPathExtension(databaseExtension)
  }

  var modelConfiguration: ModelConfiguration {
    ModelConfiguration(url: storeURL)
  }
}

private extension StorageConfigImpl {
  var sharedContainerURL: URL? {
    let identifier = appGroupIdentifier
    guard !identifier.isEmpty else { return nil }
    return FileManager.default.containerURL(
      forSecurityApplicationGroupIdentifier: identifier
    )
  }

  var appGroupIdentifier: String {
    Bundle.getAppGroupIdentifier() ?? ""
  }
}

private extension URL {

  /// Keeps the history, revocation records and bookmarks out of iCloud backup and device-to-device transfer, as the
  /// Android wallet's backup rules do (owner, 19 October 2026). A restore to the same device brings the documents
  /// back from the Keychain without their revocation records until the first check after login.
  mutating func excludeFromBackup() {
    var values = URLResourceValues()
    values.isExcludedFromBackup = true
    try? setResourceValues(values)
  }
}
