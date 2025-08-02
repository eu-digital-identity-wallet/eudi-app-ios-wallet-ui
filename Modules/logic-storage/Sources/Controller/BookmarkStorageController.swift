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
import RealmSwift

public protocol BookmarkStorageController: StorageController where Value == Bookmark {}

final class BookmarkStorageControllerImpl: BookmarkStorageController {

  private let realmService: RealmService

  init(realmService: RealmService) {
    self.realmService = realmService
  }

  func store(_ value: Bookmark) async throws {
    try await realmService.write(value.toRealmBookmark())
  }

  func store(_ values: [Bookmark]) async throws {
    try await realmService.writeAll(values.toRealmBookmarks())
  }

  func update(_ value: Bookmark) async throws {
    try await realmService.write(value.toRealmBookmark())
  }

  func retrieve(_ identifier: String) async throws -> Bookmark {
    let bookmark = try await realmService.read(RealmBookmark.self, id: identifier) {
      $0.toBookmark()
    }
    guard let bookmark else {
      throw StorageError.itemNotFound
    }
    return bookmark
  }

  func retrieveAll() async throws -> [Bookmark] {
    let bookmarks = try await realmService.readAll(RealmBookmark.self) { $0.toBookmark() }
    guard !bookmarks.isEmpty else {
      throw StorageError.itemsNotFound
    }
    return bookmarks
  }

  func delete(_ identifier: String) async throws {
    try await realmService.delete(RealmBookmark.self, id: identifier)
  }

  func deleteAll() async throws {
    try await realmService.deleteAll(of: RealmBookmark.self)
  }
}
