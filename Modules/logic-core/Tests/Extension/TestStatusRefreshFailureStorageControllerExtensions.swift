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

final class TestStatusRefreshFailureStorageControllerExtensions: EudiTest {

  func testRetrieveIdentifiers_WhenStoreIsEmpty_ThenIsEmpty() async throws {
    let storage = StubStatusRefreshFailureStorageController(failure: logic_storage.StorageError.itemsNotFound)

    let identifiers = try await storage.retrieveIdentifiers()

    XCTAssertEqual(identifiers, [])
  }

  func testRetrieveIdentifiers_WhenReadFails_ThenThrows() async {
    let storage = StubStatusRefreshFailureStorageController(failure: logic_storage.StorageError.itemNotFound)

    do {
      _ = try await storage.retrieveIdentifiers()
      XCTFail("Expected the read error")
    } catch {
      XCTAssertNotNil(error as? logic_storage.StorageError)
    }
  }

  func testRetrieveIdentifiers_WhenRecordsAreStored_ThenReturnsTheirDocuments() async throws {
    let storage = StubStatusRefreshFailureStorageController(records: [
      StatusRefreshFailure(identifier: "a"),
      StatusRefreshFailure(identifier: "b")
    ])

    let identifiers = try await storage.retrieveIdentifiers()

    XCTAssertEqual(identifiers, ["a", "b"])
  }
}

private extension TestStatusRefreshFailureStorageControllerExtensions {

  /// A store that returns fixed records or fails every read; it records nothing.
  actor StubStatusRefreshFailureStorageController: StatusRefreshFailureStorageController {

    private let records: [StatusRefreshFailure]
    private let failure: (any Error)?

    init(records: [StatusRefreshFailure] = [], failure: (any Error)? = nil) {
      self.records = records
      self.failure = failure
    }

    func store(_ value: StatusRefreshFailure) async throws {}
    func store(_ values: [StatusRefreshFailure]) async throws {}
    func update(_ value: StatusRefreshFailure) async throws {}

    func retrieve(_ identifier: String) async throws -> StatusRefreshFailure {
      guard let record = records.first(where: { $0.identifier == identifier }) else {
        throw logic_storage.StorageError.itemNotFound
      }
      return record
    }

    func retrieveAll() async throws -> [StatusRefreshFailure] {
      if let failure {
        throw failure
      }
      return records
    }

    func delete(_ identifier: String) async throws {}
    func deleteAll() async throws {}
  }
}
