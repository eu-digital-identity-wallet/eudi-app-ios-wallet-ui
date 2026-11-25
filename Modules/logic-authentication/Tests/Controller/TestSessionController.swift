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
@testable import logic_authentication
@testable import logic_test

final class TestSessionController: EudiTest {

  private var config: MockAuthenticationConfig!

  override func setUp() {
    super.setUp()
    config = MockAuthenticationConfig()
    stub(config) { mock in
      when(mock.backgroundLockTimeout.get).thenReturn(60)
      when(mock.idleLockTimeout.get).thenReturn(300)
      when(mock.protectedFlowLockTimeout.get).thenReturn(600)
    }
  }

  override func tearDown() {
    config = nil
    super.tearDown()
  }

  @MainActor
  func testIsUnlocked_WhenCreated_ThenIsLockedAndNothingExpires() {
    // Given
    let (controller, clock) = makeController()

    // When
    clock.now += 10_000

    // Then
    XCTAssertFalse(controller.isUnlocked)
    XCTAssertFalse(controller.lockIfExpired())
  }

  @MainActor
  func testLockIfExpired_WhenAwayForLessThanTheBackgroundLimit_ThenStaysUnlocked() {
    // Given
    let (controller, clock) = makeController()
    controller.unlock()
    controller.recordBackground(isProtectedFlow: false)

    // When
    clock.now += 59

    // Then
    XCTAssertFalse(controller.lockIfExpired())
    XCTAssertTrue(controller.isUnlocked)
  }

  @MainActor
  func testLockIfExpired_WhenAwayForTheBackgroundLimit_ThenLocks() {
    // Given
    let (controller, clock) = makeController()
    controller.unlock()
    controller.recordBackground(isProtectedFlow: false)

    // When
    clock.now += 60

    // Then
    XCTAssertTrue(controller.lockIfExpired())
    XCTAssertFalse(controller.isUnlocked)
  }

  @MainActor
  func testLockIfExpired_WhenAwayDuringAProtectedFlow_ThenWaitsForTheProtectedLimit() {
    // Given
    let (controller, clock) = makeController()
    controller.unlock()
    controller.recordBackground(isProtectedFlow: true)

    // When
    clock.now += 599

    // Then
    XCTAssertFalse(controller.lockIfExpired())

    // When
    controller.recordBackground(isProtectedFlow: true)
    clock.now += 600

    // Then
    XCTAssertTrue(controller.lockIfExpired())
    XCTAssertFalse(controller.isUnlocked)
  }

  @MainActor
  func testLockIfExpired_WhenAwayWhileCovered_ThenWaitsForTheProtectedLimit() {
    // Given
    let (controller, clock) = makeController()
    controller.unlock()
    controller.setCovered(true)
    controller.recordBackground(isProtectedFlow: false)

    // When
    clock.now += 599

    // Then
    XCTAssertFalse(controller.lockIfExpired())

    // When
    controller.recordBackground(isProtectedFlow: false)
    clock.now += 600

    // Then
    XCTAssertTrue(controller.lockIfExpired())
    XCTAssertFalse(controller.isUnlocked)
  }

  @MainActor
  func testLockIfExpired_WhenIdleForLessThanTheIdleLimit_ThenStaysUnlocked() {
    // Given
    let (controller, clock) = makeController()
    controller.unlock()

    // When
    clock.now += 299

    // Then
    XCTAssertFalse(controller.lockIfExpired())
    XCTAssertTrue(controller.isUnlocked)
  }

  @MainActor
  func testLockIfExpired_WhenIdleForTheIdleLimit_ThenLocks() {
    // Given
    let (controller, clock) = makeController()
    controller.unlock()

    // When
    clock.now += 300

    // Then
    XCTAssertTrue(controller.lockIfExpired())
    XCTAssertFalse(controller.isUnlocked)
  }

  @MainActor
  func testLockIfExpired_WhenCovered_ThenTheIdleTimeoutPauses() {
    // Given
    let (controller, clock) = makeController()
    controller.unlock()
    controller.setCovered(true)

    // When
    clock.now += 3_000

    // Then
    XCTAssertFalse(controller.lockIfExpired())
    XCTAssertTrue(controller.isUnlocked)
  }

  @MainActor
  func testSetCovered_WhenTheCoverGoesBeforeTheProtectedLimit_ThenTheIdleTimeoutRestarts() {
    // Given
    let (controller, clock) = makeController()
    controller.unlock()
    controller.setCovered(true)
    clock.now += 599

    // When
    controller.setCovered(false)
    clock.now += 299

    // Then
    XCTAssertTrue(controller.isUnlocked)
    XCTAssertFalse(controller.lockIfExpired())
  }

  @MainActor
  func testSetCovered_WhenTheCoverGoesAfterTheProtectedLimit_ThenLocks() {
    // Given
    let (controller, clock) = makeController()
    controller.unlock()
    controller.setCovered(true)
    clock.now += 600

    // When
    controller.setCovered(false)

    // Then
    XCTAssertFalse(controller.isUnlocked)
  }

  @MainActor
  func testExternalFlow_WhenInProgress_ThenCoversTheWalletUntilItsLastEnd() {
    // Given
    let (controller, clock) = makeController()
    controller.unlock()
    let first = controller.beginExternalFlow()
    let second = controller.beginExternalFlow()
    clock.now += 400

    // When
    controller.endExternalFlow(startedIn: first)

    // Then
    XCTAssertFalse(controller.lockIfExpired())

    // When
    controller.endExternalFlow(startedIn: second)
    clock.now += 300

    // Then
    XCTAssertTrue(controller.lockIfExpired())
    XCTAssertFalse(controller.isUnlocked)
  }

  @MainActor
  func testDuringExternalFlow_WhenTheOperationRuns_ThenTheIdleTimeoutPausesUntilItEnds() async {
    // Given
    let (controller, clock) = makeController()
    controller.unlock()
    var lockedDuringTheOperation = true

    // When
    await controller.duringExternalFlow {
      clock.now += 400
      lockedDuringTheOperation = controller.lockIfExpired()
    }
    clock.now += 299

    // Then
    XCTAssertFalse(lockedDuringTheOperation)
    XCTAssertFalse(controller.lockIfExpired())
    XCTAssertTrue(controller.isUnlocked)
  }

  @MainActor
  func testLockIfExpired_WhenAnExternalFlowLastsTheProtectedLimit_ThenLocks() {
    // Given
    let (controller, clock) = makeController()
    controller.unlock()
    controller.beginExternalFlow()

    // When
    clock.now += 599

    // Then
    XCTAssertFalse(controller.lockIfExpired())

    // When
    clock.now += 1

    // Then
    XCTAssertTrue(controller.lockIfExpired())
    XCTAssertFalse(controller.isUnlocked)
  }

  @MainActor
  func testLock_WhenAnExternalFlowIsInProgress_ThenTheFlowEnds() {
    // Given
    let (controller, clock) = makeController()
    controller.unlock()
    controller.beginExternalFlow()

    // When
    controller.lock()
    controller.unlock()

    clock.now += 300

    // Then
    XCTAssertTrue(controller.lockIfExpired())
  }

  /// The sign-in the lock interrupted ends late, after a new one began: the new one still covers the wallet.
  @MainActor
  func testEndExternalFlow_WhenAFlowFromBeforeTheLockEnds_ThenALaterFlowStillCovers() {
    // Given
    let (controller, clock) = makeController()
    controller.unlock()
    let interrupted = controller.beginExternalFlow()
    controller.lock()
    controller.unlock()
    _ = controller.beginExternalFlow()

    // When
    controller.endExternalFlow(startedIn: interrupted)
    clock.now += 400

    // Then
    XCTAssertFalse(controller.lockIfExpired())
  }

  @MainActor
  func testLockIfExpired_WhenTheCoverEndedWhileAway_ThenTheBackgroundLimitApplies() {
    // Given
    let (controller, clock) = makeController()
    controller.unlock()
    let lockPeriod = controller.beginExternalFlow()
    controller.recordBackground(isProtectedFlow: false)
    controller.endExternalFlow(startedIn: lockPeriod)

    // When
    clock.now += 60

    // Then
    XCTAssertTrue(controller.lockIfExpired())
  }

  @MainActor
  func testDuringExternalFlow_WhenTheOperationThrows_ThenTheFlowStillEnds() async {
    // Given
    let (controller, clock) = makeController()
    controller.unlock()

    // When
    _ = try? await controller.duringExternalFlow { () async throws -> Int in
      clock.now += 400
      throw URLError(.cancelled)
    }
    clock.now += 300

    // Then
    XCTAssertTrue(controller.lockIfExpired())
  }

  @MainActor
  func testRecordInteraction_WhenTheUserTouches_ThenTheIdleTimeoutRestarts() {
    // Given
    let (controller, clock) = makeController()
    controller.unlock()
    clock.now += 200

    // When
    controller.recordInteraction()
    clock.now += 200

    // Then
    XCTAssertFalse(controller.lockIfExpired())
  }

  @MainActor
  func testLockIfExpired_WhenTheAppReturns_ThenTimeAwayDoesNotCountTowardsIdle() {
    // Given
    let (controller, clock) = makeController()
    controller.unlock()
    clock.now += 200
    controller.recordBackground(isProtectedFlow: false)

    // When
    clock.now += 50

    // Then
    XCTAssertFalse(controller.lockIfExpired())

    // When
    clock.now += 200

    // Then
    XCTAssertFalse(controller.lockIfExpired())
  }

  @MainActor
  func testLockIfExpired_WhenTheAppReturnedOnce_ThenTheBackgroundRecordIsUsedUp() {
    // Given
    let (controller, clock) = makeController()
    controller.unlock()
    controller.recordBackground(isProtectedFlow: false)

    // When
    clock.now += 30

    // Then
    XCTAssertFalse(controller.lockIfExpired())

    // When
    clock.now += 40

    // Then
    XCTAssertFalse(controller.lockIfExpired())
  }

  @MainActor
  func testLockIfExpired_WhenLoggedInWhileAwayForTheBackgroundLimit_ThenLocks() {
    // Given
    let (controller, clock) = makeController()
    controller.recordBackground(isProtectedFlow: false)
    controller.unlock()

    // When
    clock.now += 60

    // Then
    XCTAssertTrue(controller.lockIfExpired())
    XCTAssertFalse(controller.isUnlocked)
  }

  @MainActor
  func testLockIfExpired_WhenLoggedInWhileAwayForLessThanTheBackgroundLimit_ThenStaysUnlocked() {
    // Given
    let (controller, clock) = makeController()
    controller.recordBackground(isProtectedFlow: false)
    controller.unlock()

    // When
    clock.now += 59

    // Then
    XCTAssertFalse(controller.lockIfExpired())
    XCTAssertTrue(controller.isUnlocked)
  }

  @MainActor
  func testUnlock_WhenTheAppReturnedLockedBeforeLogin_ThenTheEarlierBackgroundIsForgotten() {
    // Given
    let (controller, clock) = makeController()
    controller.recordBackground(isProtectedFlow: false)

    // When
    clock.now += 120

    // Then
    XCTAssertFalse(controller.lockIfExpired())

    // When
    controller.unlock()

    // Then
    XCTAssertFalse(controller.lockIfExpired())
    XCTAssertTrue(controller.isUnlocked)
  }
}

private extension TestSessionController {

  @MainActor
  func makeController() -> (SessionControllerImpl, StubClock) {
    let clock = StubClock()
    return (SessionControllerImpl(authenticationConfig: config) { clock.now }, clock)
  }
}

@MainActor
private final class StubClock {
  var now: TimeInterval = 1_000
}
