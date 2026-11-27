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
@testable import logic_storage
@testable import logic_test

final class TestDeferredIssuanceStorageController: EudiTest {

  private var controller: DeferredIssuanceStorageControllerImpl!

  override func setUp() {
    super.setUp()
    controller = DeferredIssuanceStorageControllerImpl(
      swiftDataService: SwiftDataServiceImpl(storageConfig: StubStorageConfig())
    )
  }

  override func tearDown() {
    controller = nil
    super.tearDown()
  }

  func testRetrieve_WhenAnIssuanceIsStored_ThenReturnsIt() async throws {
    let issuance = DeferredIssuance(
      identifier: "pid",
      nextAttemptAt: date(100),
      interval: 30,
      state: .failed
    )

    try await controller.store(issuance)

    let stored = try await controller.retrieve("pid")
    XCTAssertEqual(stored, issuance)
  }

  func testRetrieve_WhenTheIssuerCouldNotBeVerified_ThenReturnsItUntrusted() async throws {
    let issuance = DeferredIssuance(identifier: "pid", nextAttemptAt: date(100), state: .untrusted)

    try await controller.store(issuance)

    let stored = try await controller.retrieve("pid")
    XCTAssertEqual(stored, issuance)
  }

  func testRetrieve_WhenTheIssuerGaveNoInterval_ThenReturnsNone() async throws {
    try await controller.store(DeferredIssuance(identifier: "pid", nextAttemptAt: date(100)))

    let stored = try await controller.retrieve("pid")

    XCTAssertNil(stored.interval)
    XCTAssertEqual(stored.state, .pending)
  }

  func testRetrieve_WhenNothingIsStoredForTheDocument_ThenThrowsItemNotFound() async throws {
    try await controller.store(DeferredIssuance(identifier: "pid", nextAttemptAt: date(100)))

    do {
      _ = try await controller.retrieve("mdl")
      XCTFail("Expected itemNotFound")
    } catch StorageError.itemNotFound {
    }
  }

  func testUpdate_WhenTheDocumentIsStored_ThenReplacesItsEntry() async throws {
    try await controller.store(DeferredIssuance(identifier: "pid", nextAttemptAt: date(100), interval: 30))
    let updated = DeferredIssuance(
      identifier: "pid",
      nextAttemptAt: date(500),
      interval: 60,
      state: .failed
    )

    try await controller.update(updated)

    let stored = try await controller.retrieveAll()
    XCTAssertEqual(stored, [updated])
  }

  func testRetrieveAll_WhenSeveralAreStored_ThenReturnsEach() async throws {
    try await controller.store([
      DeferredIssuance(identifier: "pid", nextAttemptAt: date(100)),
      DeferredIssuance(identifier: "mdl", nextAttemptAt: date(200), interval: 10)
    ])

    let stored = try await controller.retrieveAll()

    XCTAssertEqual(Set(stored.map(\.identifier)), ["pid", "mdl"])
  }

  func testRetrieveAll_WhenNothingIsStored_ThenThrowsItemsNotFound() async throws {
    do {
      _ = try await controller.retrieveAll()
      XCTFail("Expected itemsNotFound")
    } catch StorageError.itemsNotFound {
    }
  }

  func testDelete_WhenADocumentIsDeleted_ThenTheOthersStay() async throws {
    try await controller.store([
      DeferredIssuance(identifier: "pid", nextAttemptAt: date(100)),
      DeferredIssuance(identifier: "mdl", nextAttemptAt: date(200))
    ])

    try await controller.delete("pid")

    let stored = try await controller.retrieveAll()
    XCTAssertEqual(stored.map(\.identifier), ["mdl"])
  }

  func testDeleteAll_ThenNothingIsLeft() async throws {
    try await controller.store([
      DeferredIssuance(identifier: "pid", nextAttemptAt: date(100)),
      DeferredIssuance(identifier: "mdl", nextAttemptAt: date(200))
    ])

    try await controller.deleteAll()

    do {
      _ = try await controller.retrieveAll()
      XCTFail("Expected itemsNotFound")
    } catch StorageError.itemsNotFound {
    }
  }

  func testToDeferredIssuance_WhenTheStateIsUnknown_ThenItIsPending() {
    let model = SDDeferredIssuance(
      identifier: "pid",
      nextAttemptAt: date(100),
      interval: nil,
      state: "a-later-state"
    )

    XCTAssertEqual(model.toDeferredIssuance().state, .pending)
  }
}

private extension TestDeferredIssuanceStorageController {

  func date(_ seconds: TimeInterval) -> Date {
    Date(timeIntervalSince1970: seconds)
  }
}
