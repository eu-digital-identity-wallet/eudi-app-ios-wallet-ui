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

public protocol BookmarkStorageController: StorageController where Value == Bookmark {}

final class BookmarkStorageControllerImpl: BookmarkStorageController {

  private let swiftDataService: SwiftDataService

  init(swiftDataService: SwiftDataService) {
    self.swiftDataService = swiftDataService
  }

  func store(_ value: Bookmark) async throws {
    try await swiftDataService.write(value.toSdModel())
  }

  func store(_ values: [Bookmark]) async throws {
    try await swiftDataService.writeAll(values.toSdModels())
  }

  func update(_ value: Bookmark) async throws {
    try await swiftDataService.write(value.toSdModel())
  }

  func retrieve(_ identifier: String) async throws -> Bookmark {
    let bookmark = try await swiftDataService.read(SDBookmark.self, id: identifier) {
      $0.toBookmark()
    }
    guard let bookmark else {
      throw StorageError.itemNotFound
    }
    return bookmark
  }

  func retrieveAll() async throws -> [Bookmark] {
    let bookmarks = try await swiftDataService.readAll(SDBookmark.self) { $0.toBookmark() }
    guard !bookmarks.isEmpty else {
      throw StorageError.itemsNotFound
    }
    return bookmarks
  }

  func delete(_ identifier: String) async throws {
    try await swiftDataService.delete(SDBookmark.self, id: identifier)
  }

  func deleteAll() async throws {
    try await swiftDataService.deleteAll(of: SDBookmark.self)
  }
}
