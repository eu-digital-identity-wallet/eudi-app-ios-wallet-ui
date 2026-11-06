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
import os
import Security
@testable import logic_business
@testable import logic_core
@testable import logic_test

final class TestStoredDocumentPresence: EudiTest {

  func testHasDocuments_WhenNoStatusHasAnItem_ThenIsFalseAfterAQueryPerStatus() throws {
    let queries = RecordingKeychainQueries()
    let presence = StoredDocumentPresence(serviceName: "svc", accessGroup: "") { query in
      queries.record(query)
      return errSecItemNotFound
    }

    XCTAssertFalse(try presence.hasDocuments())
    XCTAssertEqual(queries.services, ["svc:pdoc:issued", "svc:pdoc:deferred", "svc:pdoc:pending"])
  }

  func testHasDocuments_WhenOnlyADeferredDocumentExists_ThenIsTrue() throws {
    let presence = StoredDocumentPresence(serviceName: "svc", accessGroup: "") { query in
      query[kSecAttrService as String] as? String == "svc:pdoc:deferred" ? errSecSuccess : errSecItemNotFound
    }

    XCTAssertTrue(try presence.hasDocuments())
  }

  func testHasDocuments_WhenAQueryFails_ThenThrowsTheReadError() {
    let presence = StoredDocumentPresence(serviceName: "svc", accessGroup: "") { _ in
      errSecInteractionNotAllowed
    }

    XCTAssertThrowsError(try presence.hasDocuments()) { error in
      XCTAssertEqual(error as? KeyChainError, .readFailed(status: errSecInteractionNotAllowed))
    }
  }

  func testQuery_WhenBuilt_ThenMatchesTheWalletStorageItemAndReturnsNothing() {
    let query = StoredDocumentPresence(serviceName: "svc", accessGroup: "").query(for: .issued)

    XCTAssertEqual(query[kSecAttrService as String] as? String, "svc:pdoc:issued")
    XCTAssertEqual(query[kSecClass as String] as? String, kSecClassGenericPassword as String)
    XCTAssertEqual(query[kSecUseDataProtectionKeychain as String] as? Bool, true)
    XCTAssertEqual(query[kSecMatchLimit as String] as? String, kSecMatchLimitOne as String)
    XCTAssertNil(query[kSecReturnData as String])
    XCTAssertNil(query[kSecReturnAttributes as String])
    XCTAssertNil(query[kSecAttrAccessGroup as String])
  }

  func testQuery_WhenAnAccessGroupIsConfigured_ThenUsesIt() {
    let query = StoredDocumentPresence(serviceName: "svc", accessGroup: "group").query(for: .pending)

    XCTAssertEqual(query[kSecAttrAccessGroup as String] as? String, "group")
  }
}

private extension TestStoredDocumentPresence {

  /// Records the service of every query the presence check makes.
  final class RecordingKeychainQueries: Sendable {

    private let recorded = OSAllocatedUnfairLock<[String]>(initialState: [])

    var services: [String] {
      recorded.withLock { $0 }
    }

    func record(_ query: [String: Any]) {
      let service = query[kSecAttrService as String] as? String ?? ""
      recorded.withLock { $0.append(service) }
    }
  }
}
