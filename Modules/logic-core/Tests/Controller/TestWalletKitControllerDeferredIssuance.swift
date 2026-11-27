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
import WalletStorage
@testable import logic_core
@testable import logic_test

final class TestWalletKitControllerDeferredIssuance: EudiTest {

  private var storage: StubDeferredIssuanceStorageController!
  private var controller: WalletKitControllerImpl!

  override func setUp() {
    super.setUp()
    storage = StubDeferredIssuanceStorageController()
    controller = TestWalletKitControllerOffer.makeController(
      issuer: "https://issuer.example",
      deferredIssuanceStorageController: storage
    )
  }

  override func tearDown() {
    controller = nil
    storage = nil
    super.tearDown()
  }

  func testFetchFailedDeferredDocumentIds_WhenTheIssuerRefusedSome_ThenReturnsOnlyThose() async {
    // Given
    await storage.setEntries([entry("a", state: .pending), entry("b", state: .failed), entry("c", state: .failed)])

    // When
    let ids = await controller.fetchFailedDeferredDocumentIds()

    // Then
    XCTAssertEqual(ids, ["b", "c"])
  }

  func testFetchFailedDeferredDocumentIds_WhenAnUntrustedDocumentIsLeft_ThenReturnsItWithTheFailedOnes() async {
    // Given
    await storage.setEntries([entry("a", state: .pending), entry("b", state: .failed), entry("c", state: .untrusted)])

    // When
    let ids = await controller.fetchFailedDeferredDocumentIds()

    // Then
    XCTAssertEqual(ids, ["b", "c"])
  }

  func testFetchFailedDeferredDocumentIds_WhenThereIsNoEntry_ThenReturnsNone() async {
    // When
    let ids = await controller.fetchFailedDeferredDocumentIds()

    // Then
    XCTAssertEqual(ids, [])
  }

  func testFetchFailedDeferredDocumentIds_WhenTheEntriesCannotBeRead_ThenReturnsNoneSoTheyShowAsPending() async {
    // Given
    await storage.setEntries([entry("b", state: .failed)])
    await storage.setFailsReads(true)

    // When
    let ids = await controller.fetchFailedDeferredDocumentIds()

    // Then
    XCTAssertEqual(ids, [])
  }

  func testRequestDeferredIssuance_WhenTheDocumentIsNoLongerStored_ThenWritesNothingAndSaysItWasDeleted() async {
    // Given
    let document = WalletStorage.Document(
      id: "gone",
      docType: "",
      docDataFormat: .cbor,
      data: Data(),
      docKeyInfo: nil,
      createdAt: nil,
      metadata: nil,
      displayName: "",
      status: .deferred
    )

    // When
    do {
      _ = try await controller.requestDeferredIssuance(with: document)

      // Then
      XCTFail("Expected DeferredDocumentDeletedError")
    } catch {
      XCTAssertEqual(error as? DeferredDocumentDeletedError, DeferredDocumentDeletedError())
    }
    let entries = await storage.entries
    XCTAssertTrue(entries.isEmpty)
    let failed = await controller.fetchFailedDeferredDocumentIds()
    XCTAssertEqual(failed, [])
  }

  func testDeleteDocument_WhenADeferredRequestForItIsUnderWay_ThenWaitsForTheRequestToEnd() async {
    // Given
    let gate = await controller.deferredRequestGate
    _ = await gate.beginRequest(for: "a")
    let controller = controller!
    let deletion = Task { try? await controller.deleteDocument(with: "a", status: .deferred) }
    let early = expectation(description: "early")
    early.isInverted = true
    let deleted = expectation(description: "deleted")
    Task {
      await deletion.value
      early.fulfill()
      deleted.fulfill()
    }

    // When
    await fulfillment(of: [early], timeout: 0.3)
    let isDeleting = await gate.isDeleting("a")
    await gate.endRequest(for: "a")

    // Then
    await fulfillment(of: [deleted], timeout: 2)
    XCTAssertTrue(isDeleting)
  }

  func testClearAllDocuments_WhenADeferredRequestIsUnderWay_ThenWaitsForTheRequestToEnd() async {
    // Given
    let gate = await controller.deferredRequestGate
    _ = await gate.beginRequest(for: "a")
    let controller = controller!
    let clearing = Task { try? await controller.clearAllDocuments() }
    let early = expectation(description: "early")
    early.isInverted = true
    let cleared = expectation(description: "cleared")
    Task {
      await clearing.value
      early.fulfill()
      cleared.fulfill()
    }

    // When
    await fulfillment(of: [early], timeout: 0.3)
    await gate.endRequest(for: "a")

    // Then
    await fulfillment(of: [cleared], timeout: 2)
  }

  func testResumePendingIssuance_WhenTheIssuanceFails_ThenNoLongerHoldsTheDeferredRequests() async {
    // Given
    let pending = WalletStorage.Document(
      id: "pending",
      docType: "",
      docDataFormat: .cbor,
      data: Data(),
      docKeyInfo: nil,
      createdAt: nil,
      metadata: nil,
      displayName: "",
      status: .pending
    )

    // When
    let result = try? await controller.resumePendingIssuance(pendingDoc: pending, webUrl: nil)

    // Then
    let isIssuing = await controller.deferredRequestGate.isIssuing
    XCTAssertNil(result)
    XCTAssertFalse(isIssuing)
  }

  func testMarkIssuedDeferredDocumentsSeen_WhenNoneWasIssued_ThenReturnsNone() async {
    // When
    let ids = await controller.markIssuedDeferredDocumentsSeen(["a"])

    // Then
    XCTAssertEqual(ids, [])
  }

  func testMarkIssuedDeferredDocumentsSeen_WhenSomeShownWereIssued_ThenReturnsThemOnce() async {
    // Given
    await controller.recordUnseenIssuedDeferredDocument("a")
    await controller.recordUnseenIssuedDeferredDocument("b")

    // When
    let first = await controller.markIssuedDeferredDocumentsSeen(["a", "c"])
    let second = await controller.markIssuedDeferredDocumentsSeen(["a", "c"])

    // Then
    XCTAssertEqual(first, ["a"])
    XCTAssertEqual(second, [])
  }

  func testMarkIssuedDeferredDocumentsSeen_WhenAnIssuedDocumentIsNotShown_ThenKeepsItForLater() async {
    // Given
    await controller.recordUnseenIssuedDeferredDocument("a")

    // When
    let notShown = await controller.markIssuedDeferredDocumentsSeen(["z"])
    let shown = await controller.markIssuedDeferredDocumentsSeen(["a"])

    // Then
    XCTAssertEqual(notShown, [])
    XCTAssertEqual(shown, ["a"])
  }

  func testDeleteAllRecords_WhenEntriesAreStored_ThenRemovesEveryDeferredEntry() async throws {
    // Given
    await storage.setEntries([entry("a", state: .pending), entry("b", state: .failed)])

    // When
    try await controller.deleteAllRecords()

    // Then
    let entries = await storage.entries
    XCTAssertTrue(entries.isEmpty)
  }
}

private extension TestWalletKitControllerDeferredIssuance {

  func entry(_ id: String, state: DeferredIssuance.State) -> DeferredIssuance {
    DeferredIssuance(identifier: id, nextAttemptAt: Date(timeIntervalSince1970: 0), state: state)
  }
}
