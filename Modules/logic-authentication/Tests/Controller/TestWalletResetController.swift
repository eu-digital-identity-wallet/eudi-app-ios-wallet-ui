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
import Cuckoo
import logic_business
@testable import logic_core
@testable import logic_authentication
@testable import logic_test

final class TestWalletResetController: EudiTest {

  private var walletKitController: MockWalletKitController!
  private var walletWorkScheduler: MockWalletWorkScheduler!
  private var keyChainController: MockKeyChainController!
  private var prefsController: MockPrefsController!
  private var sessionController: MockSessionController!
  private var resetStatusProvider: WalletResetStatusProviderImpl!
  private var calls: RecordingStepLog!
  private var controller: WalletResetControllerImpl!

  override func setUp() {
    super.setUp()
    walletKitController = MockWalletKitController()
    walletWorkScheduler = MockWalletWorkScheduler()
    keyChainController = MockKeyChainController()
    prefsController = MockPrefsController()
    sessionController = MockSessionController()
    resetStatusProvider = WalletResetStatusProviderImpl()
    calls = RecordingStepLog()
    stubEverySucceeding()
    controller = makeController()
  }

  override func tearDown() {
    controller = nil
    calls = nil
    resetStatusProvider = nil
    sessionController = nil
    prefsController = nil
    keyChainController = nil
    walletWorkScheduler = nil
    walletKitController = nil
    super.tearDown()
  }

  func testResetWallet_WhenEveryStepSucceeds_ThenRunsThemInOrderAndLocksTheSession() async throws {
    try await controller.resetWallet()

    XCTAssertEqual(
      calls.entries,
      ["stop", "documents", "records", "keychain", "preferences", "files", "generation", "lock"]
    )
    verify(walletWorkScheduler, never()).schedule()
    XCTAssertFalse(resetStatusProvider.isResetting)
  }

  func testResetWallet_WhenACheckIsStillRunning_ThenDeletesNothingAndRestartsTheChecks() async {
    stub(walletWorkScheduler) { mock in
      when(mock.stop()).thenReturn(false)
    }

    await assertResetFails()

    verify(walletKitController, never()).clearAllDocuments()
    verify(keyChainController, never()).clear()
    verify(walletWorkScheduler).schedule()
  }

  func testResetWallet_WhenAStepFails_ThenStopsThereAndRestartsTheChecks() async {
    stub(walletKitController) { mock in
      when(mock.deleteAllRecords()).thenThrow(WalletCoreError.unableToIssueAndStore)
    }

    await assertResetFails()

    verify(keyChainController, never()).clear()
    verify(walletWorkScheduler).schedule()
    XCTAssertFalse(resetStatusProvider.isResetting)
  }

  func testResetWallet_WhenDocumentsRemainAfterEveryPass_ThenFailsBeforeTheRecords() async {
    stub(walletKitController) { mock in
      when(mock.hasStoredDocuments()).thenReturn(true)
    }

    await assertResetFails()

    verify(walletKitController, times(2)).clearAllDocuments()
    verify(walletKitController, never()).deleteAllRecords()
  }

  func testResetWallet_WhenItRuns_ThenReportsItIsResetting() async throws {
    let wasResetting = OSAllocatedUnfairLock(initialState: false)
    stub(walletKitController) { mock in
      when(mock.clearAllDocuments()).then { [resetStatusProvider] in
        wasResetting.withLock { $0 = resetStatusProvider?.isResetting ?? false }
      }
    }

    try await controller.resetWallet()

    XCTAssertTrue(wasResetting.withLock { $0 })
    XCTAssertFalse(resetStatusProvider.isResetting)
  }

  func testResetWallet_WhenItRuns_ThenRemovesEveryPreferenceButTheLanguageAndTheCounters() async throws {
    let kept: Set<Prefs.Key> = [.language, .transactionLogRevision, .walletResetGeneration]

    try await controller.resetWallet()

    for key in Prefs.Key.allCases {
      if kept.contains(key) {
        verify(prefsController, never()).remove(forKey: equal(to: key))
      } else {
        verify(prefsController).remove(forKey: equal(to: key))
      }
    }
  }

  func testResetWallet_WhenAStepFails_ThenClearsTheResettingFlagBeforeRestartingTheChecks() async {
    let wasResettingAtRestart = OSAllocatedUnfairLock(initialState: true)
    stub(walletKitController) { mock in
      when(mock.deleteAllRecords()).thenThrow(WalletCoreError.unableToIssueAndStore)
    }
    stub(walletWorkScheduler) { mock in
      when(mock.schedule()).then { [resetStatusProvider] in
        wasResettingAtRestart.withLock { $0 = resetStatusProvider?.isResetting ?? true }
      }
    }

    await assertResetFails()

    XCTAssertFalse(wasResettingAtRestart.withLock { $0 })
  }

  func testResetWallet_WhenTheCallerIsCancelled_ThenTheResetRunsToTheEnd() async throws {
    let ranCancelled = OSAllocatedUnfairLock(initialState: false)
    controller = makeController(clearCachedData: { ranCancelled.withLock { $0 = Task.isCancelled } })

    let caller = Task { [controller] in try await controller?.resetWallet() }
    caller.cancel()
    try await caller.value

    XCTAssertFalse(ranCancelled.withLock { $0 })
    verify(sessionController).lock()
  }

  func testResetWallet_WhenCalledWhileOneRuns_ThenJoinsIt() async throws {
    let gate = AsyncGate()
    let scheduler = RecordingWalletWorkScheduler(gate: gate)
    controller = makeController(walletWorkScheduler: scheduler)
    let first = Task { [controller] in try await controller?.resetWallet() }
    await scheduler.waitForFirstStop()

    let secondEnded = expectation(description: "second call ended before the first")
    secondEnded.isInverted = true
    let second = Task { [controller] in
      try await controller?.resetWallet()
      secondEnded.fulfill()
    }
    await fulfillment(of: [secondEnded], timeout: 0.5)
    await gate.open()
    try await first.value
    try await second.value

    let stops = await scheduler.stops
    XCTAssertEqual(stops, 1)
  }

  func testRemoveCachedData_WhenRun_ThenTheCachedFilesCookiesAndResponsesAreGone() throws {
    let fileManager = FileManager.default
    let files = fileManager.cachesAndTemporaryDirectories.map { $0.appendingPathComponent("reset-test") }
    try files.forEach { try Data("cached".utf8).write(to: $0) }
    let site = try XCTUnwrap(URL(string: "https://issuer.example/"))
    let cookie = try XCTUnwrap(
      HTTPCookie(properties: [.domain: "issuer.example", .path: "/", .name: "session", .value: "1"])
    )
    HTTPCookieStorage.shared.setCookie(cookie)
    let request = URLRequest(url: site)
    let response = try XCTUnwrap(HTTPURLResponse(url: site, statusCode: 200, httpVersion: nil, headerFields: nil))
    URLCache.shared.storeCachedResponse(CachedURLResponse(response: response, data: Data("page".utf8)), for: request)
    XCTAssertEqual(HTTPCookieStorage.shared.cookies(for: site), [cookie])
    XCTAssertNotNil(URLCache.shared.cachedResponse(for: request))

    WalletResetControllerImpl.removeCachedData()

    XCTAssertTrue(files.allSatisfy { !fileManager.fileExists(atPath: $0.path) })
    XCTAssertEqual(HTTPCookieStorage.shared.cookies(for: site) ?? [], [])
    XCTAssertNil(URLCache.shared.cachedResponse(for: request))
  }

}

private extension TestWalletResetController {

  func assertResetFails(file: StaticString = #filePath, line: UInt = #line) async {
    do {
      try await controller.resetWallet()
      XCTFail("Expected the reset to fail", file: file, line: line)
    } catch {}
  }

  func makeController(
    walletWorkScheduler: WalletWorkScheduler? = nil,
    clearCachedData: (@Sendable () -> Void)? = nil
  ) -> WalletResetControllerImpl {
    let calls = self.calls
    return WalletResetControllerImpl(
      walletKitController: walletKitController,
      walletWorkScheduler: walletWorkScheduler ?? self.walletWorkScheduler,
      keyChainController: keyChainController,
      prefsController: prefsController,
      sessionController: sessionController,
      resetStatusProvider: resetStatusProvider,
      clearCachedData: clearCachedData ?? { calls?.record("files") }
    )
  }

  func stubEverySucceeding() {
    let calls = self.calls!
    stub(walletWorkScheduler) { mock in
      when(mock.stop()).then { calls.record("stop"); return true }
      when(mock.schedule()).thenDoNothing()
    }
    stub(walletKitController) { mock in
      when(mock.clearAllDocuments()).then { calls.record("documents") }
      when(mock.hasStoredDocuments()).thenReturn(false)
      when(mock.deleteAllRecords()).then { calls.record("records") }
    }
    stub(keyChainController) { mock in
      when(mock.clear()).then { calls.record("keychain"); return true }
    }
    stub(prefsController) { mock in
      when(mock.remove(forKey: any())).then { key in
        if key == .runAtLeastOnce { calls.record("preferences") }
      }
      when(mock.getInt(forKey: any())).thenReturn(0)
      when(mock.setValue(any(), forKey: any())).then { _, key in
        if key == .walletResetGeneration { calls.record("generation") }
      }
    }
    stub(sessionController) { mock in
      when(mock.lock()).then { calls.record("lock") }
    }
  }
}

private final class RecordingStepLog: Sendable {
  private let log = OSAllocatedUnfairLock<[String]>(initialState: [])

  var entries: [String] { log.withLock { $0 } }

  func record(_ entry: String) {
    log.withLock { $0.append(entry) }
  }
}

private actor RecordingWalletWorkScheduler: WalletWorkScheduler {
  private let gate: AsyncGate
  private(set) var stops = 0
  private var firstStopWaiters: [CheckedContinuation<Void, Never>] = []

  init(gate: AsyncGate) {
    self.gate = gate
  }

  func schedule() async {}

  func scheduleRevocationCheck(afterReIssueOf originalId: String) async {}

  func stop() async -> Bool {
    stops += 1
    firstStopWaiters.forEach { $0.resume() }
    firstStopWaiters.removeAll()
    await gate.wait()
    return true
  }

  func waitForFirstStop() async {
    guard stops == 0 else { return }
    await withCheckedContinuation { firstStopWaiters.append($0) }
  }
}
