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
import logic_business
@testable import logic_assembly
@testable import logic_core
@testable import logic_authentication
@testable import logic_ui
@testable import logic_test

final class TestSessionLockController: EudiTest {

  private var sessionController: MockSessionController!
  private var routerHost: MockRouterHost!
  private var userInteractionController: MockUserInteractionController!
  private var walletKitController: MockWalletKitController!
  private var sessionStatusProvider: MockWalletSessionStatusProvider!
  private var calls: RecordingCallLog!
  private var statusUpdates: RecordingCallLog!

  override func setUp() {
    super.setUp()
    sessionController = MockSessionController()
    routerHost = MockRouterHost()
    userInteractionController = MockUserInteractionController()
    walletKitController = MockWalletKitController()
    sessionStatusProvider = MockWalletSessionStatusProvider()
    calls = RecordingCallLog()
    statusUpdates = RecordingCallLog()
    let calls = calls!
    let statusUpdates = statusUpdates!
    stub(sessionController) { mock in
      when(mock.setCovered(any())).then { calls.record("setCovered(\($0))") }
      when(mock.recordBackground(isProtectedFlow: any())).then { calls.record("recordBackground(\($0))") }
      when(mock.lockIfExpired()).then { calls.record("lockIfExpired"); return false }
      when(mock.recordInteraction()).then { calls.record("recordInteraction") }
      when(mock.isUnlocked.get).thenReturn(false)
    }
    stub(routerHost) { mock in
      when(mock.isInProtectedFlow()).thenReturn(true)
      when(mock.requireLoginIfLocked()).then { calls.record("requireLoginIfLocked") }
    }
    stub(userInteractionController) { mock in
      when(mock.start(onInteraction: any())).thenDoNothing()
    }
    stub(walletKitController) { mock in
      when(mock.stopPresentation()).thenDoNothing()
    }
    stub(sessionStatusProvider) { mock in
      when(mock.update(isUnlocked: any(), isInForeground: any())).then {
        statusUpdates.record("update(\($0), \($1))")
      }
    }
  }

  override func tearDown() {
    sessionController = nil
    routerHost = nil
    userInteractionController = nil
    walletKitController = nil
    sessionStatusProvider = nil
    statusUpdates = nil
    calls = nil
    super.tearDown()
  }

  @MainActor
  func testSceneDidEnterBackground_WhenCalled_ThenRecordsTheCoverBeforeTheBackground() {
    // Given
    let controller = makeController(isCovered: true)

    // When
    controller.sceneDidEnterBackground()

    // Then
    XCTAssertEqual(calls.entries, ["setCovered(true)", "recordBackground(true)"])
  }

  @MainActor
  func testSceneDidEnterBackground_WhenNothingCoversAnOrdinaryScreen_ThenRecordsBoth() {
    // Given
    stub(routerHost) { mock in
      when(mock.isInProtectedFlow()).thenReturn(false)
    }
    let controller = makeController(isCovered: false)

    // When
    controller.sceneDidEnterBackground()

    // Then
    XCTAssertEqual(calls.entries, ["setCovered(false)", "recordBackground(false)"])
  }

  @MainActor
  func testSceneDidBecomeActive_WhenCalled_ThenAppliesTheTimeoutAndSendsALockedWalletToLogin() {
    // Given
    let controller = makeController()

    // When
    controller.sceneDidBecomeActive()

    // Then
    XCTAssertEqual(calls.entries, ["lockIfExpired", "requireLoginIfLocked"])
  }

  @MainActor
  func testSceneDidEnterBackground_WhenTheWalletIsUnlocked_ThenItIsNoLongerActive() {
    // Given
    stub(sessionController) { mock in
      when(mock.isUnlocked.get).thenReturn(true)
    }
    let controller = makeController()

    // When
    controller.sceneDidEnterBackground()

    // Then
    XCTAssertEqual(statusUpdates.entries, ["update(true, false)"])
  }

  @MainActor
  func testSceneDidBecomeActive_WhenTheWalletIsUnlocked_ThenItIsInFrontOnlyOnceTheTimeoutIsApplied() {
    // Given
    let calls = calls!
    stub(sessionController) { mock in
      when(mock.isUnlocked.get).thenReturn(true)
    }
    stub(sessionStatusProvider) { mock in
      when(mock.update(isUnlocked: any(), isInForeground: any())).then { calls.record("update(\($0), \($1))") }
    }
    let controller = makeController()
    controller.sceneDidEnterBackground()

    // When
    controller.sceneDidBecomeActive()

    // Then
    XCTAssertEqual(
      calls.entries,
      [
        "setCovered(false)",
        "recordBackground(true)",
        "update(true, false)",
        "lockIfExpired",
        "update(true, false)",
        "requireLoginIfLocked",
        "update(true, true)"
      ]
    )
  }

  @MainActor
  func testSceneDidBecomeActive_WhenTheTimeoutLockedTheWallet_ThenItStaysInactive() {
    // Given
    let controller = makeController()
    controller.sceneDidEnterBackground()

    // When
    controller.sceneDidBecomeActive()

    // Then
    XCTAssertEqual(statusUpdates.entries.last, "update(false, true)")
  }

  @MainActor
  func testCheckIdle_WhenTheUserHasLoggedIn_ThenTheWalletIsActive() {
    // Given
    stub(sessionController) { mock in
      when(mock.isUnlocked.get).thenReturn(true)
    }
    let controller = makeController()

    // When
    controller.checkIdle()

    // Then
    XCTAssertEqual(statusUpdates.entries, ["update(true, true)"])
  }

  @MainActor
  func testWillHandleLink_WhenALinkArrives_ThenAppliesTheTimeoutFirst() {
    // Given
    let controller = makeController()

    // When
    controller.willHandleLink()

    // Then
    XCTAssertEqual(calls.entries, ["lockIfExpired", "requireLoginIfLocked"])
  }

  @MainActor
  func testCheckIdle_WhenRun_ThenRefreshesTheCoverAndAppliesTheTimeout() {
    // Given
    let controller = makeController(isCovered: false)

    // When
    controller.checkIdle()

    // Then
    XCTAssertEqual(calls.entries, ["setCovered(false)", "lockIfExpired", "requireLoginIfLocked"])
  }

  @MainActor
  func testStart_WhenTheUserInteracts_ThenRecordsInteraction() {
    // Given
    var onInteraction: (@MainActor () -> Void)?
    stub(userInteractionController) { mock in
      when(mock.start(onInteraction: any())).then { onInteraction = $0 }
    }
    let controller = makeController()

    // When
    controller.start()
    onInteraction?()

    // Then
    XCTAssertEqual(calls.entries, ["recordInteraction"])
  }

  @MainActor
  func testStart_WhenTheAppIsInFront_ThenChecksTheIdleLimitRegularly() async {
    // Given
    let checked = expectation(description: "idle check")
    checked.assertForOverFulfill = false
    stub(sessionController) { mock in
      when(mock.lockIfExpired()).then { checked.fulfill(); return false }
    }
    let controller = makeController(idleCheckInterval: 0.02)

    // When
    controller.start()

    // Then
    await fulfillment(of: [checked], timeout: 2)
    withExtendedLifetime(controller) {}
  }

  @MainActor
  func testSceneDidBecomeActive_WhenTheAppReturns_ThenTheIdleCheckRestarts() async {
    // Given
    let controller = makeController(idleCheckInterval: 0.02)
    controller.start()
    controller.sceneDidEnterBackground()
    let checked = expectation(description: "the timeout on return, then an idle check")
    checked.expectedFulfillmentCount = 2
    checked.assertForOverFulfill = false
    stub(sessionController) { mock in
      when(mock.lockIfExpired()).then { checked.fulfill(); return false }
    }

    // When
    controller.sceneDidBecomeActive()

    // Then
    await fulfillment(of: [checked], timeout: 2)
    withExtendedLifetime(controller) {}
  }

  @MainActor
  func testSceneDidEnterBackground_WhenTheIdleCheckRuns_ThenItStopsBeforeTheBackgroundIsRecorded() async throws {
    // Given
    let controller = makeController(idleCheckInterval: 0.02)
    controller.start()

    // When
    controller.sceneDidEnterBackground()
    try await Task.sleep(seconds: 0.2)

    // Then
    XCTAssertEqual(calls.entries.last, "recordBackground(true)")
    XCTAssertFalse(calls.entries.contains("lockIfExpired"))
    withExtendedLifetime(controller) {}
  }

  @MainActor
  func testSceneDidEnterBackground_WhenAnIdleCheckIsAlreadyDue_ThenItDoesNotRunAfterTheBackground() async throws {
    // Given
    let controller = makeController(idleCheckInterval: 0.02)
    controller.start()
    await Task.yield()
    blockMainActor(for: 0.2)

    // When
    controller.sceneDidEnterBackground()
    try await Task.sleep(seconds: 0.2)

    // Then
    XCTAssertEqual(calls.entries.last, "recordBackground(true)")
    withExtendedLifetime(controller) {}
  }

  @MainActor
  func testCheckIdle_WhenTheWalletWasUnlockedAndIsNowLocked_ThenTheRunningPresentationIsStopped() async {
    // Given
    let stopped = expectation(description: "presentation stopped")
    stub(walletKitController) { mock in
      when(mock.stopPresentation()).then { stopped.fulfill() }
    }
    stub(sessionController) { mock in
      when(mock.isUnlocked.get).thenReturn(true)
    }
    let controller = makeController()
    controller.checkIdle()
    stub(sessionController) { mock in
      when(mock.isUnlocked.get).thenReturn(false)
    }

    // When
    controller.checkIdle()

    // Then
    await fulfillment(of: [stopped], timeout: 5)
  }

  @MainActor
  func testCheckIdle_WhenTheWalletStaysUnlocked_ThenNoPresentationIsStopped() async {
    // Given
    let stopped = expectation(description: "presentation stopped")
    stopped.isInverted = true
    stub(walletKitController) { mock in
      when(mock.stopPresentation()).then { stopped.fulfill() }
    }
    stub(sessionController) { mock in
      when(mock.isUnlocked.get).thenReturn(true)
    }
    let controller = makeController()

    // When
    controller.checkIdle()
    controller.checkIdle()

    // Then
    await fulfillment(of: [stopped], timeout: 0.5)
  }

  @MainActor
  func testCheckIdle_WhenTheWalletWasNeverUnlocked_ThenNoPresentationIsStopped() async {
    // Given
    let stopped = expectation(description: "presentation stopped")
    stopped.isInverted = true
    stub(walletKitController) { mock in
      when(mock.stopPresentation()).then { stopped.fulfill() }
    }
    let controller = makeController()

    // When
    controller.checkIdle()
    controller.checkIdle()

    // Then
    await fulfillment(of: [stopped], timeout: 0.5)
  }
}

private extension TestSessionLockController {

  @MainActor
  func makeController(
    isCovered: Bool = false,
    idleCheckInterval: TimeInterval = 1_000
  ) -> SessionLockControllerImpl {
    SessionLockControllerImpl(
      sessionController: sessionController,
      routerHost: routerHost,
      userInteractionController: userInteractionController,
      walletKitController: walletKitController,
      sessionStatusProvider: sessionStatusProvider,
      isCovered: { isCovered },
      idleCheckInterval: idleCheckInterval
    )
  }

  /// Keeps the main thread busy, so that an idle check that falls due meanwhile waits for the main actor.
  @MainActor
  func blockMainActor(for seconds: TimeInterval) {
    Thread.sleep(forTimeInterval: seconds)
  }
}

private final class RecordingCallLog: Sendable {
  private let log = OSAllocatedUnfairLock<[String]>(initialState: [])

  var entries: [String] { log.withLock { $0 } }

  func record(_ entry: String) {
    log.withLock { $0.append(entry) }
  }
}
