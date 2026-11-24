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

final class TestRevokedDocumentExtensions: EudiTest {

  func testRevocationStatus_WhenStatusIsMissingOrUnknown_ThenIsUnrecognised() {
    // When
    let missing = RevokedDocument(identifier: "a").revocationStatus
    let unknown = RevokedDocument(identifier: "a", status: "unknown").revocationStatus

    // Then
    XCTAssertEqual(missing, .unrecognised)
    XCTAssertEqual(unknown, .unrecognised)
  }

  func testRevocationStatus_WhenStatusIsStored_ThenMapsIt() {
    // When
    let suspended = RevokedDocument(identifier: "a", status: "suspended").revocationStatus
    let revoked = RevokedDocument(identifier: "a", status: "revoked").revocationStatus
    let unrecognised = RevokedDocument(identifier: "a", status: "unrecognised").revocationStatus

    // Then
    XCTAssertEqual(suspended, .suspended)
    XCTAssertEqual(revoked, .revoked)
    XCTAssertEqual(unrecognised, .unrecognised)
  }

  func testRetrieveRevocationStatuses_WhenStoreIsEmpty_ThenIsEmpty() async throws {
    // Given
    let storage = StubRevokedDocumentStorageController(failure: logic_storage.StorageError.itemsNotFound)

    // When
    let statuses = try await storage.retrieveRevocationStatuses()

    // Then
    XCTAssertEqual(statuses, [:])
  }

  func testRetrieveRevocationStatuses_WhenReadFails_ThenThrows() async {
    // Given
    let storage = StubRevokedDocumentStorageController(failure: logic_storage.StorageError.itemNotFound)

    // When
    do {
      _ = try await storage.retrieveRevocationStatuses()

      // Then
      XCTFail("Expected the read error")
    } catch {
      XCTAssertNotNil(error as? logic_storage.StorageError)
    }
  }

  func testRetrieveRevocationStatuses_WhenRecordsMixStatuses_ThenMapsEachAndKeepsTheFirstDuplicate() async throws {
    // Given
    let storage = StubRevokedDocumentStorageController(records: [
      RevokedDocument(identifier: "a"),
      RevokedDocument(identifier: "b", status: "suspended"),
      RevokedDocument(identifier: "b", status: "revoked")
    ])

    // When
    let statuses = try await storage.retrieveRevocationStatuses()

    // Then
    XCTAssertEqual(statuses, ["a": .unrecognised, "b": .suspended])
  }
}

private extension TestRevokedDocumentExtensions {

  /// A store that returns fixed records or fails every read; it records nothing.
  actor StubRevokedDocumentStorageController: RevokedDocumentStorageController {

    private let records: [RevokedDocument]
    private let failure: (any Error)?

    init(records: [RevokedDocument] = [], failure: (any Error)? = nil) {
      self.records = records
      self.failure = failure
    }

    func store(_ value: RevokedDocument) async throws {}
    func store(_ values: [RevokedDocument]) async throws {}
    func update(_ value: RevokedDocument) async throws {}

    func retrieve(_ identifier: String) async throws -> RevokedDocument {
      guard let record = records.first(where: { $0.identifier == identifier }) else {
        throw logic_storage.StorageError.itemNotFound
      }
      return record
    }

    func retrieveAll() async throws -> [RevokedDocument] {
      if let failure {
        throw failure
      }
      return records
    }

    func delete(_ identifier: String) async throws {}
    func deleteAll() async throws {}
  }
}
