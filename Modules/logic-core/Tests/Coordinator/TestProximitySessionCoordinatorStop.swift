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

final class TestProximitySessionCoordinatorStop: EudiTest {

  func testStopPresentation_WhenTheSessionHasATransfer_ThenItIsStoppedOnTheMainActor() async {
    let stopped = expectation(description: "transfer stopped")
    let coordinator = ProximitySessionCoordinatorImpl(
      session: .stoppableFixture { isMainThread in
        XCTAssertTrue(isMainThread)
        stopped.fulfill()
      }
    )

    coordinator.stopPresentation()

    await fulfillment(of: [stopped], timeout: 5)
  }

  func testDeinit_WhenACoordinatorIsReleasedWithoutAStop_ThenTheTransferIsLeftAlone() async {
    let stopped = expectation(description: "transfer stopped")
    stopped.isInverted = true
    var coordinator: ProximitySessionCoordinatorImpl? = .init(
      session: .stoppableFixture { _ in stopped.fulfill() }
    )
    XCTAssertNotNil(coordinator)

    coordinator = nil

    await fulfillment(of: [stopped], timeout: 0.5)
  }

  func testWaitForReaderDisconnect_WhenTheReaderHasLeft_ThenReturnsTrue() async {
    let coordinator = ProximitySessionCoordinatorImpl(
      session: .stoppableFixture(onStop: nil, isReaderDisconnected: true)
    )

    let hasLeft = await coordinator.waitForReaderDisconnect()

    XCTAssertTrue(hasLeft)
  }

  func testWaitForReaderDisconnect_WhenTheWaitIsCancelled_ThenReturnsFalse() async {
    let coordinator = ProximitySessionCoordinatorImpl(session: .stoppableFixture(onStop: nil))
    let wait = Task { await coordinator.waitForReaderDisconnect() }

    wait.cancel()

    let hasLeft = await wait.value
    XCTAssertFalse(hasLeft)
  }
}
