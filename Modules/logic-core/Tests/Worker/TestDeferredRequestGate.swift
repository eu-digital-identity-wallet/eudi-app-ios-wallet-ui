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
@testable import logic_core
@testable import logic_test

final class TestDeferredRequestGate: EudiTest {

  private var gate: DeferredRequestGate!

  override func setUp() {
    super.setUp()
    gate = DeferredRequestGate()
  }

  override func tearDown() {
    gate = nil
    super.tearDown()
  }

  func testBeginRequest_WhenNothingElseRuns_ThenStarts() async {
    // When
    let started = await gate.beginRequest(for: "a")

    // Then
    XCTAssertTrue(started)
  }

  func testBeginRequest_WhenTheDocumentIsBeingDeleted_ThenDoesNotStart() async {
    // Given
    await gate.beginDeletion(of: "a")

    // When
    let started = await gate.beginRequest(for: "a")
    let otherStarted = await gate.beginRequest(for: "b")

    // Then
    XCTAssertFalse(started)
    XCTAssertTrue(otherStarted)
  }

  func testBeginRequest_WhenAllDocumentsAreBeingCleared_ThenDoesNotStart() async {
    // Given
    await gate.beginClearing()

    // When
    let started = await gate.beginRequest(for: "a")

    // Then
    XCTAssertFalse(started)
  }

  func testBeginRequest_WhenTheDocumentAlreadyHasARequest_ThenDoesNotStartAnother() async {
    // Given
    _ = await gate.beginRequest(for: "a")

    // When
    let started = await gate.beginRequest(for: "a")

    // Then
    XCTAssertFalse(started)
  }

  func testBeginRequest_WhenTheDeletionEnded_ThenStartsAgain() async {
    // Given
    await gate.beginDeletion(of: "a")
    await gate.endDeletion(of: "a")

    // When
    let started = await gate.beginRequest(for: "a")

    // Then
    XCTAssertTrue(started)
  }

  func testBeginDeletion_WhenARequestIsUnderWay_ThenWaitsForItToEnd() async {
    // Given
    _ = await gate.beginRequest(for: "a")
    let deleting = expectation(description: "deleting")
    let gate = gate!
    let deletion = Task {
      await gate.beginDeletion(of: "a")
      deleting.fulfill()
    }
    let early = expectation(description: "early")
    early.isInverted = true
    Task {
      await deletion.value
      early.fulfill()
    }
    await fulfillment(of: [early], timeout: 0.3)

    // When
    let seenWhileWaiting = await gate.isDeleting("a")
    await gate.endRequest(for: "a")

    // Then
    await fulfillment(of: [deleting], timeout: 2)
    XCTAssertTrue(seenWhileWaiting)
  }

  func testBeginDeletion_WhenTheRequestIsForAnotherDocument_ThenDoesNotWait() async {
    // Given
    _ = await gate.beginRequest(for: "b")

    // When
    await gate.beginDeletion(of: "a")

    // Then
    let isRequesting = await gate.isRequesting("b")
    XCTAssertTrue(isRequesting)
  }

  func testEndDeletion_WhenTwoDeletionsOverlap_ThenTheDocumentStaysDeletingUntilBothEnd() async {
    // Given
    await gate.beginDeletion(of: "a")
    await gate.beginDeletion(of: "a")

    // When
    await gate.endDeletion(of: "a")
    let afterFirst = await gate.isDeleting("a")
    await gate.endDeletion(of: "a")
    let afterSecond = await gate.isDeleting("a")

    // Then
    XCTAssertTrue(afterFirst)
    XCTAssertFalse(afterSecond)
  }

  /// Once "a" ends, the clearing still waits for "b".
  func testBeginClearing_WhenRequestsAreUnderWay_ThenWaitsForAllOfThem() async {
    // Given
    _ = await gate.beginRequest(for: "a")
    _ = await gate.beginRequest(for: "b")
    let gate = gate!
    let clearing = Task { await gate.beginClearing() }
    let early = expectation(description: "early")
    early.isInverted = true
    let cleared = expectation(description: "cleared")
    Task {
      await clearing.value
      early.fulfill()
      cleared.fulfill()
    }

    // When
    await gate.endRequest(for: "a")
    await fulfillment(of: [early], timeout: 0.3)
    await gate.endRequest(for: "b")

    // Then
    await fulfillment(of: [cleared], timeout: 2)
  }

  func testBeginRequest_WhenAnIssuanceIsUnderWay_ThenDoesNotStartUntilItEnds() async {
    // Given
    await gate.beginIssuance()

    // When
    let startedDuring = await gate.beginRequest(for: "a")
    let isIssuing = await gate.isIssuing
    await gate.endIssuance()
    let startedAfter = await gate.beginRequest(for: "a")

    // Then
    XCTAssertFalse(startedDuring)
    XCTAssertTrue(isIssuing)
    XCTAssertTrue(startedAfter)
  }

  func testBeginIssuance_WhenRequestsAreUnderWay_ThenWaitsForAllOfThem() async {
    // Given
    _ = await gate.beginRequest(for: "a")
    _ = await gate.beginRequest(for: "b")
    let gate = gate!
    let issuance = Task { await gate.beginIssuance() }
    let early = expectation(description: "early")
    early.isInverted = true
    let started = expectation(description: "started")
    Task {
      await issuance.value
      early.fulfill()
      started.fulfill()
    }

    // When
    await gate.endRequest(for: "a")
    await fulfillment(of: [early], timeout: 0.3)
    await gate.endRequest(for: "b")

    // Then
    await fulfillment(of: [started], timeout: 2)
  }

  func testEndIssuance_WhenTwoIssuancesOverlap_ThenRequestsWaitForTheLastOne() async {
    // Given
    await gate.beginIssuance()
    await gate.beginIssuance()

    // When
    await gate.endIssuance()
    let startedAfterOne = await gate.beginRequest(for: "a")
    await gate.endIssuance()
    let startedAfterBoth = await gate.beginRequest(for: "a")

    // Then
    XCTAssertFalse(startedAfterOne)
    XCTAssertTrue(startedAfterBoth)
  }
}
