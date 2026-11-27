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
    let started = await gate.beginRequest(for: "a")

    XCTAssertTrue(started)
  }

  func testBeginRequest_WhenTheDocumentIsBeingDeleted_ThenDoesNotStart() async {
    await gate.beginDeletion(of: "a")

    let started = await gate.beginRequest(for: "a")
    let otherStarted = await gate.beginRequest(for: "b")

    XCTAssertFalse(started)
    XCTAssertTrue(otherStarted)
  }

  func testBeginRequest_WhenAllDocumentsAreBeingCleared_ThenDoesNotStart() async {
    await gate.beginClearing()

    let started = await gate.beginRequest(for: "a")

    XCTAssertFalse(started)
  }

  func testBeginRequest_WhenTheDocumentAlreadyHasARequest_ThenDoesNotStartAnother() async {
    _ = await gate.beginRequest(for: "a")

    let started = await gate.beginRequest(for: "a")

    XCTAssertFalse(started)
  }

  func testBeginRequest_WhenTheDeletionEnded_ThenStartsAgain() async {
    await gate.beginDeletion(of: "a")
    await gate.endDeletion(of: "a")

    let started = await gate.beginRequest(for: "a")

    XCTAssertTrue(started)
  }

  func testBeginDeletion_WhenARequestIsUnderWay_ThenWaitsForItToEnd() async {
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

    let seenWhileWaiting = await gate.isDeleting("a")
    await gate.endRequest(for: "a")

    await fulfillment(of: [deleting], timeout: 2)
    XCTAssertTrue(seenWhileWaiting)
  }

  func testBeginDeletion_WhenTheRequestIsForAnotherDocument_ThenDoesNotWait() async {
    _ = await gate.beginRequest(for: "b")

    await gate.beginDeletion(of: "a")

    let isRequesting = await gate.isRequesting("b")
    XCTAssertTrue(isRequesting)
  }

  func testEndDeletion_WhenTwoDeletionsOverlap_ThenTheDocumentStaysDeletingUntilBothEnd() async {
    await gate.beginDeletion(of: "a")
    await gate.beginDeletion(of: "a")

    await gate.endDeletion(of: "a")
    let afterFirst = await gate.isDeleting("a")
    await gate.endDeletion(of: "a")
    let afterSecond = await gate.isDeleting("a")

    XCTAssertTrue(afterFirst)
    XCTAssertFalse(afterSecond)
  }

  func testBeginClearing_WhenRequestsAreUnderWay_ThenWaitsForAllOfThem() async {
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

    await gate.endRequest(for: "a")
    // Still waiting for "b".
    await fulfillment(of: [early], timeout: 0.3)
    await gate.endRequest(for: "b")

    await fulfillment(of: [cleared], timeout: 2)
  }
}
