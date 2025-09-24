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
import SwiftData

protocol StorageConfig: Sendable {
  var schemaVersion: UInt64 { get }
  var databaseName: String { get }
  var databaseFolder: String { get }
  var databaseExtension: String { get }
  var schemas: Schema { get }
  var storeURL: URL { get }
  var modelConfiguration: ModelConfiguration { get }
}

final class StorageConfigImpl: StorageConfig {

  var schemaVersion: UInt64 { 1 }

  var databaseName: String { "eudi_wallet" }

  var databaseExtension: String { "store" }

  var databaseFolder: String { "Storage" }

  var schemas: Schema {
    Schema(
      [
        SDBookmark.self,
        SDTransactionLog.self,
        SDRevokedDocument.self
      ]
    )
  }

  var storeURL: URL {

    let base = FileManager.default.urls(
      for: .applicationSupportDirectory,
      in: .userDomainMask
    ).first ?? FileManager.default.temporaryDirectory

    let dir = base.appendingPathComponent(
      databaseFolder,
      isDirectory: true
    )

    try? FileManager.default.createDirectory(
      at: dir,
      withIntermediateDirectories: true
    )

    return dir
      .appendingPathComponent(databaseName)
      .appendingPathExtension(databaseExtension)
  }

  var modelConfiguration: ModelConfiguration {
    ModelConfiguration(url: storeURL)
  }
}
