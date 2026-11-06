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

import XCTest
import logic_storage
@testable import logic_core
@testable import logic_test

final class TestBookmarkStorageControllerExtensions: EudiTest {

  func testCarryBookmark_WhenTheOriginalWasBookmarked_ThenEveryRenewedDocumentIsBookmarked() async {
    let storage = RecordingBookmarkStorageController()

    await storage.carryBookmark(wasBookmarked: true, to: ["new1", "new2"])

    let stored = await storage.storedIdentifiers
    XCTAssertEqual(stored, ["new1", "new2"])
  }

  func testCarryBookmark_WhenTheOriginalWasNotBookmarked_ThenNothingIsBookmarked() async {
    let storage = RecordingBookmarkStorageController()

    await storage.carryBookmark(wasBookmarked: false, to: ["new1"])

    let stored = await storage.storedIdentifiers
    XCTAssertEqual(stored, [])
  }

  func testCarryBookmark_WhenOneBookmarkCannotBeStored_ThenTheOthersAreStillStored() async {
    let storage = RecordingBookmarkStorageController(failingIdentifier: "new1")

    await storage.carryBookmark(wasBookmarked: true, to: ["new1", "new2"])

    let stored = await storage.storedIdentifiers
    XCTAssertEqual(stored, ["new2"])
  }
}

private extension TestBookmarkStorageControllerExtensions {

  /// A store that records the bookmarks written to it and can refuse one of them.
  actor RecordingBookmarkStorageController: BookmarkStorageController {

    private let failingIdentifier: String?
    private(set) var storedIdentifiers: [String] = []

    init(failingIdentifier: String? = nil) {
      self.failingIdentifier = failingIdentifier
    }

    func store(_ value: Bookmark) async throws {
      if value.identifier == failingIdentifier {
        throw logic_storage.StorageError.itemNotFound
      }
      storedIdentifiers.append(value.identifier)
    }

    func store(_ values: [Bookmark]) async throws {}
    func update(_ value: Bookmark) async throws {}

    func retrieve(_ identifier: String) async throws -> Bookmark {
      throw logic_storage.StorageError.itemNotFound
    }

    func retrieveAll() async throws -> [Bookmark] {
      throw logic_storage.StorageError.itemsNotFound
    }

    func delete(_ identifier: String) async throws {}
    func deleteAll() async throws {}
  }
}
