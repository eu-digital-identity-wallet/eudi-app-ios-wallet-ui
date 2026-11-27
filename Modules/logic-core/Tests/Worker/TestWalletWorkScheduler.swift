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
import Cuckoo
@testable import logic_core
@testable import logic_test

final class TestWalletWorkScheduler: EudiTest {

  var revocationWorkManager: MockRevocationWorkManager!
  var reIssuanceWorkManager: MockReIssuanceWorkManager!
  var deferredIssuanceWorkManager: MockDeferredIssuanceWorkManager!
  var scheduler: WalletWorkSchedulerImpl!

  override func setUp() {
    revocationWorkManager = MockRevocationWorkManager()
    reIssuanceWorkManager = MockReIssuanceWorkManager()
    deferredIssuanceWorkManager = MockDeferredIssuanceWorkManager()
    stub(revocationWorkManager) { mock in
      when(mock.start()).thenDoNothing()
      when(mock.stop()).thenDoNothing()
    }
    stub(reIssuanceWorkManager) { mock in
      when(mock.start()).thenDoNothing()
      when(mock.stop()).thenDoNothing()
    }
    stub(deferredIssuanceWorkManager) { mock in
      when(mock.start()).thenDoNothing()
      when(mock.stop()).thenDoNothing()
    }
    scheduler = WalletWorkSchedulerImpl(
      revocationWorkManager: revocationWorkManager,
      reIssuanceWorkManager: reIssuanceWorkManager,
      deferredIssuanceWorkManager: deferredIssuanceWorkManager,
      stopTimeout: 5,
      resetStatusProvider: WalletResetStatusProviderImpl()
    )
  }

  override func tearDown() {
    revocationWorkManager = nil
    reIssuanceWorkManager = nil
    deferredIssuanceWorkManager = nil
    scheduler = nil
  }

  func testSchedule_WhenCalled_ThenStartsTheChecksAndTheDeferredRequests() async {
    // When
    await scheduler.schedule()

    // Then
    verify(revocationWorkManager).start()
    verify(reIssuanceWorkManager).start()
    verify(deferredIssuanceWorkManager).start()
  }

  func testSchedule_WhenAResetRuns_ThenStartsNothing() async {
    // Given
    let resetStatusProvider = WalletResetStatusProviderImpl()
    resetStatusProvider.setResetting(true)
    let resettingScheduler = WalletWorkSchedulerImpl(
      revocationWorkManager: revocationWorkManager,
      reIssuanceWorkManager: reIssuanceWorkManager,
      deferredIssuanceWorkManager: deferredIssuanceWorkManager,
      stopTimeout: 5,
      resetStatusProvider: resetStatusProvider
    )

    // When
    await resettingScheduler.schedule()

    // Then
    verify(revocationWorkManager, never()).start()
    verify(reIssuanceWorkManager, never()).start()
    verify(deferredIssuanceWorkManager, never()).start()
  }

  func testStop_WhenCalled_ThenStopsTheChecksAndTheDeferredRequests() async {
    // When
    let stopped = await scheduler.stop()

    // Then
    XCTAssertTrue(stopped)
    verify(revocationWorkManager).stop()
    verify(reIssuanceWorkManager).stop()
    verify(deferredIssuanceWorkManager).stop()
  }

  func testStop_WhenADeferredRequestOutlastsTheTimeout_ThenReportsItStillRunning() async {
    let gate = AsyncGate()
    let blockedScheduler = WalletWorkSchedulerImpl(
      revocationWorkManager: revocationWorkManager,
      reIssuanceWorkManager: reIssuanceWorkManager,
      deferredIssuanceWorkManager: StubDeferredIssuanceWorkManager(gate: gate),
      stopTimeout: 0.2,
      resetStatusProvider: WalletResetStatusProviderImpl()
    )

    let stopped = await blockedScheduler.stop()
    await gate.open()

    XCTAssertFalse(stopped)
  }

  func testStop_WhenACheckOutlastsTheTimeout_ThenReportsItStillRunning() async {
    // Given
    let gate = AsyncGate()
    let blockedScheduler = WalletWorkSchedulerImpl(
      revocationWorkManager: revocationWorkManager,
      reIssuanceWorkManager: StubReIssuanceWorkManager(gate: gate),
      deferredIssuanceWorkManager: deferredIssuanceWorkManager,
      stopTimeout: 0.2,
      resetStatusProvider: WalletResetStatusProviderImpl()
    )

    // When
    let stopped = await blockedScheduler.stop()
    await gate.open()

    // Then
    XCTAssertFalse(stopped)
  }

  func testScheduleRevocationCheck_WhenTheCheckIsStillRunning_ThenReturnsAndTheCheckFinishesLater() async {
    // Given
    let gate = AsyncGate()
    let finished = expectation(description: "revocation check finished")
    let revocationWorkManager = RecordingRevocationWorkManager(gate: gate, finished: finished)
    let gatedScheduler = WalletWorkSchedulerImpl(
      revocationWorkManager: revocationWorkManager,
      reIssuanceWorkManager: reIssuanceWorkManager,
      deferredIssuanceWorkManager: deferredIssuanceWorkManager,
      stopTimeout: 5,
      resetStatusProvider: WalletResetStatusProviderImpl()
    )
    let returned = expectation(description: "scheduling returned")

    // When
    Task {
      await gatedScheduler.scheduleRevocationCheck(afterReIssueOf: "original")
      returned.fulfill()
    }
    await fulfillment(of: [returned], timeout: 2)
    await gate.open()

    // Then
    await fulfillment(of: [finished], timeout: 5)
    let checkedIds = await revocationWorkManager.checkedIds
    XCTAssertEqual(checkedIds, ["original"])
  }

  func testStop_WhenAScheduleIsStartingTheChecks_ThenTheReIssuanceStopsAfterItStarts() async {
    // Given
    let gate = AsyncGate()
    let entered = expectation(description: "the revocation start began")
    let reIssuance = RecordingReIssuanceWorkManager()
    let startingScheduler = WalletWorkSchedulerImpl(
      revocationWorkManager: StubRevocationWorkManager(gates: [gate], entered: entered),
      reIssuanceWorkManager: reIssuance,
      deferredIssuanceWorkManager: deferredIssuanceWorkManager,
      stopTimeout: 5,
      resetStatusProvider: WalletResetStatusProviderImpl()
    )

    // When
    let scheduling = Task { await startingScheduler.schedule() }
    await fulfillment(of: [entered], timeout: 2)
    let stopping = Task { await startingScheduler.stop() }
    try? await Task.sleep(seconds: 0.2)
    await gate.open()
    await scheduling.value
    let stopped = await stopping.value

    // Then
    XCTAssertTrue(stopped)
    let events = await reIssuance.events
    XCTAssertEqual(events, ["start", "stop"])
  }

  func testStop_WhenTwoSchedulesAreStartingTheChecks_ThenTheReIssuanceStopsAfterBoth() async {
    // Given
    let first = AsyncGate()
    let second = AsyncGate()
    let entered = expectation(description: "the first revocation start began")
    let reIssuance = RecordingReIssuanceWorkManager()
    let startingScheduler = WalletWorkSchedulerImpl(
      revocationWorkManager: StubRevocationWorkManager(gates: [first, second], entered: entered),
      reIssuanceWorkManager: reIssuance,
      deferredIssuanceWorkManager: deferredIssuanceWorkManager,
      stopTimeout: 5,
      resetStatusProvider: WalletResetStatusProviderImpl()
    )

    // When
    let firstScheduling = Task { await startingScheduler.schedule() }
    await fulfillment(of: [entered], timeout: 2)
    let secondScheduling = Task { await startingScheduler.schedule() }
    try? await Task.sleep(seconds: 0.2)
    let stopping = Task { await startingScheduler.stop() }
    try? await Task.sleep(seconds: 0.2)
    await second.open()
    try? await Task.sleep(seconds: 0.2)
    await first.open()
    await firstScheduling.value
    await secondScheduling.value
    let stopped = await stopping.value

    // Then
    XCTAssertTrue(stopped)
    let events = await reIssuance.events
    XCTAssertEqual(events, ["start", "start", "stop"])
  }

  func testScheduleRevocationCheck_WhenTheChecksAreStopped_ThenNoCheckRuns() async {
    // Given
    let gate = AsyncGate()
    await gate.open()
    let checked = expectation(description: "revocation check ran")
    checked.isInverted = true
    let recorder = RecordingRevocationWorkManager(gate: gate, finished: checked)
    let stoppedScheduler = WalletWorkSchedulerImpl(
      revocationWorkManager: recorder,
      reIssuanceWorkManager: reIssuanceWorkManager,
      deferredIssuanceWorkManager: deferredIssuanceWorkManager,
      stopTimeout: 5,
      resetStatusProvider: WalletResetStatusProviderImpl()
    )
    _ = await stoppedScheduler.stop()

    // When
    await stoppedScheduler.scheduleRevocationCheck(afterReIssueOf: "original")

    // Then
    await fulfillment(of: [checked], timeout: 0.5)
    let checkedIds = await recorder.checkedIds
    XCTAssertEqual(checkedIds, [])
  }

  func testScheduleRevocationCheck_WhenScheduledAgainAfterAStop_ThenTheCheckRuns() async {
    // Given
    let gate = AsyncGate()
    await gate.open()
    let checked = expectation(description: "revocation check ran")
    let gatedScheduler = WalletWorkSchedulerImpl(
      revocationWorkManager: RecordingRevocationWorkManager(gate: gate, finished: checked),
      reIssuanceWorkManager: reIssuanceWorkManager,
      deferredIssuanceWorkManager: deferredIssuanceWorkManager,
      stopTimeout: 5,
      resetStatusProvider: WalletResetStatusProviderImpl()
    )
    _ = await gatedScheduler.stop()
    await gatedScheduler.schedule()

    // When
    await gatedScheduler.scheduleRevocationCheck(afterReIssueOf: "original")

    // Then
    await fulfillment(of: [checked], timeout: 2)
  }
}

private actor RecordingRevocationWorkManager: RevocationWorkManager {
  private let gate: AsyncGate
  private let finished: XCTestExpectation
  private(set) var checkedIds: [String] = []

  init(gate: AsyncGate, finished: XCTestExpectation) {
    self.gate = gate
    self.finished = finished
  }

  func start() async {}

  func stop() async {}

  func checkAfterReIssue(of originalId: String) async {
    checkedIds.append(originalId)
    await gate.wait()
    finished.fulfill()
  }
}

private actor StubReIssuanceWorkManager: ReIssuanceWorkManager {
  private let gate: AsyncGate

  init(gate: AsyncGate) {
    self.gate = gate
  }

  func start() async {}

  func stop() async {
    await gate.wait()
  }
}

/// Holds `stop()` until its gate opens.
private actor StubDeferredIssuanceWorkManager: DeferredIssuanceWorkManager {
  private let gate: AsyncGate

  init(gate: AsyncGate) {
    self.gate = gate
  }

  func start() async {}

  func stop() async {
    await gate.wait()
  }

  func wake() async {}
}

/// Holds the n-th `start()` until its gate in `gates` opens, and fulfils `entered` when the first begins.
private actor StubRevocationWorkManager: RevocationWorkManager {
  private let gates: [AsyncGate]
  private let entered: XCTestExpectation
  private var starts = 0

  init(gates: [AsyncGate], entered: XCTestExpectation) {
    self.gates = gates
    self.entered = entered
  }

  func start() async {
    let index = starts
    starts += 1
    if index == 0 {
      entered.fulfill()
    }
    if index < gates.count {
      await gates[index].wait()
    }
  }

  func stop() async {}

  func checkAfterReIssue(of originalId: String) async {}
}

/// Records the order of its starts and stops.
private actor RecordingReIssuanceWorkManager: ReIssuanceWorkManager {
  private(set) var events: [String] = []

  func start() async {
    events.append("start")
  }

  func stop() async {
    events.append("stop")
  }
}
