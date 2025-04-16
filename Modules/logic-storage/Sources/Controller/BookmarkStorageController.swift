/*
 * Copyright (c) 2023 European Commission
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
import RealmSwift

public protocol BookmarkStorageController: StorageController where Value == Bookmark {}

final class BookmarkStorageControllerImpl: BookmarkStorageController {

  private let realmConfig: Realm.Configuration

  init(storageConfig: StorageConfig) {
    self.realmConfig = storageConfig.realmConfiguration
  }

  func store(_ value: Bookmark) async throws {
    let actor = try await RealmService(realmConfig)
    try await actor.write(value.toRealmBookmark())
  }

  func store(_ values: [Bookmark]) async throws {
    let actor = try await RealmService(realmConfig)
    try await actor.writeAll(values.toRealmBookmarks())
  }

  func update(_ value: Bookmark) async throws {
    let actor = try await RealmService(realmConfig)
    try await actor.write(value.toRealmBookmark())
  }

  func retrieve(_ identifier: String) async throws -> Bookmark {
    let actor = try await RealmService(realmConfig)
    let bookmark = try await actor.read(RealmBookmark.self, id: identifier) {
      $0.toBookmark()
    }
    guard let bookmark else {
      throw StorageError.itemNotFound
    }
    return bookmark
  }

  func retrieveAll() async throws -> [Bookmark] {
    let actor = try await RealmService(realmConfig)
    let bookmarks = try await actor.readAll(RealmBookmark.self, map: { $0.toBookmark() })
    guard !bookmarks.isEmpty else {
      throw StorageError.itemsNotFound
    }
    return bookmarks
  }

  func delete(_ identifier: String) async throws {
    let actor = try await RealmService(realmConfig)
    try await actor.delete(RealmBookmark.self, id: identifier)
  }

  func deleteAll() async throws {
    let actor = try await RealmService(realmConfig)
    try await actor.deleteAll(of: RealmBookmark.self)
  }
}
