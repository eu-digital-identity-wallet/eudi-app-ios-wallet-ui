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
@testable import logic_test
@testable import logic_authentication
@testable import logic_business

final class TestKeychainPinThrottleProvider: EudiTest {

  private var storedValues: [String: String] = [:]
  private var isReadFailing = false
  private let clock = OSAllocatedUnfairLock(initialState: TimeInterval(1_000))
  private let bootSession = OSAllocatedUnfairLock(initialState: "boot-1")

  private var provider: PinThrottleProvider!
  private var keyChainController: MockKeyChainController!
  private var authenticationConfig: MockAuthenticationConfig!

  override func setUp() {
    super.setUp()
    self.storedValues = [:]
    self.isReadFailing = false
    self.keyChainController = MockKeyChainController()
    self.authenticationConfig = MockAuthenticationConfig()

    stubAuthenticationConfig(maxAttempts: 3, durations: [30, 90, 300])
    stubKeyChainController()

    let clock = self.clock
    let bootSession = self.bootSession
    self.provider = KeychainPinThrottleProvider(
      keyChainController: keyChainController,
      authenticationConfig: authenticationConfig,
      now: { clock.withLock { $0 } },
      bootSessionIdentifier: { bootSession.withLock { $0 } }
    )
  }

  override func tearDown() {
    self.provider = nil
    self.keyChainController = nil
    self.authenticationConfig = nil
    self.storedValues.removeAll()
    super.tearDown()
  }

  func testGetState_WhenNothingPersisted_ThenIdle() {
    XCTAssertEqual(provider.getState(), .idle)
  }

  func testGetState_WhenTheLockoutRuns_ThenCountsDownOnTheMonotonicClock() {
    for _ in 0..<3 { _ = provider.recordFailure() }

    advance(by: 5)
    XCTAssertEqual(provider.getState(), .active(remaining: 25, total: 30))

    advance(by: 26)
    XCTAssertEqual(provider.getState(), .idle)
  }

  /// The clock stays past the lockout's start, so that only the change of boot can restart it.
  func testGetState_WhenTheDeviceRestartedDuringALockout_ThenTheLockoutBeginsAgainInFull() {
    for _ in 0..<3 { _ = provider.recordFailure() }
    advance(by: 20)
    bootSession.withLock { $0 = "boot-2" }

    XCTAssertEqual(provider.getState(), .active(remaining: 30, total: 30))
    advance(by: 10)
    XCTAssertEqual(provider.getState(), .active(remaining: 20, total: 30))
  }

  func testGetState_WhenTheDeviceRestartsAfterTheLockoutRanItsCourse_ThenNoLockoutBegins() {
    for _ in 0..<3 { _ = provider.recordFailure() }
    advance(by: 30)
    XCTAssertEqual(provider.getState(), .idle)

    bootSession.withLock { $0 = "boot-2" }
    clock.withLock { $0 = 5 }

    XCTAssertEqual(provider.getState(), .idle)
    XCTAssertEqual(storedValues[KeychainPinThrottleProvider.KeyIdentifier.pinLockoutLevel.rawValue], "1")
  }

  /// A failure recorded while a lockout runs, such as one from the extension's PIN screen that read the state before
  /// the lockout began, keeps the lockout running.
  func testRecordFailure_WhenALockoutRuns_ThenItKeepsRunning() {
    for _ in 0..<3 { _ = provider.recordFailure() }
    advance(by: 10)

    _ = provider.recordFailure()

    XCTAssertEqual(provider.getState(), .active(remaining: 20, total: 30))
  }

  /// No screen read the state after the countdown; the next wrong PIN clears it.
  func testRecordFailure_WhenALockoutEndedUnseen_ThenARestartBeginsNoLockout() {
    for _ in 0..<3 { _ = provider.recordFailure() }
    advance(by: 30)

    XCTAssertEqual(provider.recordFailure(), .idle)
    bootSession.withLock { $0 = "boot-2" }
    clock.withLock { $0 = 5 }

    XCTAssertEqual(provider.getState(), .idle)
  }

  func testGetState_WhenTheClockIsBeforeTheLockoutStarted_ThenTheLockoutBeginsAgainInFull() {
    for _ in 0..<3 { _ = provider.recordFailure() }
    clock.withLock { $0 = 10 }

    XCTAssertEqual(provider.getState(), .active(remaining: 30, total: 30))
  }

  func testGetState_WhenTheKeychainCannotBeRead_ThenLocksForTheLongestDuration() {
    isReadFailing = true

    XCTAssertEqual(provider.getState(), .active(remaining: 300, total: 300))
  }

  func testRecordFailure_WhenTheKeychainCannotBeRead_ThenLocksForTheLongestDurationAndWritesNothing() {
    isReadFailing = true

    XCTAssertEqual(provider.recordFailure(), .active(remaining: 300, total: 300))
    XCTAssertTrue(storedValues.isEmpty)
  }

  func testRecordFailure_WhenBelowThreshold_ThenIdleAndCounterIncremented() {
    XCTAssertEqual(provider.recordFailure(), .idle)
    XCTAssertEqual(readInt(forKey: .pinFailedAttempts), 1)

    XCTAssertEqual(provider.recordFailure(), .idle)
    XCTAssertEqual(readInt(forKey: .pinFailedAttempts), 2)

    XCTAssertEqual(readInt(forKey: .pinLockoutLevel), 0)
    XCTAssertNil(storedValues[KeychainPinThrottleProvider.KeyIdentifier.pinLockoutStartedAtUptime.rawValue])
  }

  func testRecordFailure_WhenThirdFailure_ThenStartsFirstLockoutWith30s() {
    _ = provider.recordFailure()
    _ = provider.recordFailure()
    let result = provider.recordFailure()

    XCTAssertEqual(result, .active(remaining: 30, total: 30))
    XCTAssertEqual(readInt(forKey: .pinFailedAttempts), 0)
    XCTAssertEqual(readInt(forKey: .pinLockoutLevel), 1)
    XCTAssertEqual(readDouble(forKey: .pinLockoutStartedAtUptime), 1_000)
    XCTAssertEqual(readDouble(forKey: .pinLockoutDuration), 30)
    XCTAssertEqual(storedValues[KeychainPinThrottleProvider.KeyIdentifier.pinLockoutBootSession.rawValue], "boot-1")
  }

  func testRecordFailure_WhenSecondLockoutBatch_ThenEscalatesTo90s() {
    for _ in 0..<3 { _ = provider.recordFailure() }
    for _ in 0..<2 { _ = provider.recordFailure() }
    let result = provider.recordFailure()

    XCTAssertEqual(result, .active(remaining: 90, total: 90))
    XCTAssertEqual(readInt(forKey: .pinFailedAttempts), 0)
    XCTAssertEqual(readInt(forKey: .pinLockoutLevel), 2)
  }

  func testRecordFailure_WhenThirdLockoutBatch_ThenEscalatesTo300s() {
    var lastResult: PinLockoutState = .idle
    for _ in 0..<9 {
      lastResult = provider.recordFailure()
    }

    XCTAssertEqual(lastResult, .active(remaining: 300, total: 300))
    XCTAssertEqual(readInt(forKey: .pinLockoutLevel), 3)
  }

  func testRecordFailure_WhenLevelExceedsDurations_ThenReusesLastDuration() {
    var lastResult: PinLockoutState = .idle
    for _ in 0..<12 {
      lastResult = provider.recordFailure()
    }

    XCTAssertEqual(lastResult, .active(remaining: 300, total: 300))
    XCTAssertEqual(readInt(forKey: .pinLockoutLevel), 4)
  }

  func testRecordFailure_WhenDurationsEmpty_ThenReturnsActiveWithZeroDuration() {
    stubAuthenticationConfig(maxAttempts: 3, durations: [])

    _ = provider.recordFailure()
    _ = provider.recordFailure()
    let result = provider.recordFailure()

    XCTAssertEqual(result, .active(remaining: 0, total: 0))
  }

  func testRecordSuccess_ClearsAllPersistedStateAndTheWallClockValuesOfEarlierBuilds() {
    storedValues[KeychainPinThrottleProvider.KeyIdentifier.pinLockoutStartedAt.rawValue] = "1700000000"
    storedValues[KeychainPinThrottleProvider.KeyIdentifier.pinLockoutEndsAt.rawValue] = "1700000030"
    for _ in 0..<5 { _ = provider.recordFailure() }
    XCTAssertGreaterThan(readInt(forKey: .pinLockoutLevel), 0)

    provider.recordSuccess()

    XCTAssertEqual(readInt(forKey: .pinFailedAttempts), 0)
    XCTAssertEqual(readInt(forKey: .pinLockoutLevel), 0)
    XCTAssertEqual(readDouble(forKey: .pinLockoutStartedAtUptime), 0)
    XCTAssertEqual(readDouble(forKey: .pinLockoutDuration), 0)
    XCTAssertNil(storedValues[KeychainPinThrottleProvider.KeyIdentifier.pinLockoutBootSession.rawValue])
    XCTAssertNil(storedValues[KeychainPinThrottleProvider.KeyIdentifier.pinLockoutStartedAt.rawValue])
    XCTAssertNil(storedValues[KeychainPinThrottleProvider.KeyIdentifier.pinLockoutEndsAt.rawValue])
    XCTAssertEqual(provider.getState(), .idle)
  }

  func testRecordSuccess_AfterReset_NextLockoutStartsAt30sAgain() {
    for _ in 0..<3 { _ = provider.recordFailure() }
    provider.recordSuccess()

    for _ in 0..<2 { _ = provider.recordFailure() }
    let result = provider.recordFailure()

    XCTAssertEqual(result, .active(remaining: 30, total: 30))
    XCTAssertEqual(readInt(forKey: .pinLockoutLevel), 1)
  }

  func testGetState_WhenStoredValuesAreNonNumeric_ThenIdle() {
    storedValues[KeychainPinThrottleProvider.KeyIdentifier.pinLockoutStartedAtUptime.rawValue] = "not-a-number"
    storedValues[KeychainPinThrottleProvider.KeyIdentifier.pinLockoutDuration.rawValue] = "also-bad"

    XCTAssertEqual(provider.getState(), .idle)
  }

  func testRecordFailure_WhenStoredCounterIsNonNumeric_ThenTreatsAsZero() {
    storedValues[KeychainPinThrottleProvider.KeyIdentifier.pinFailedAttempts.rawValue] = "garbage"

    XCTAssertEqual(provider.recordFailure(), .idle)
    XCTAssertEqual(readInt(forKey: .pinFailedAttempts), 1)
  }
}

private extension TestKeychainPinThrottleProvider {

  func advance(by seconds: TimeInterval) {
    clock.withLock { $0 += seconds }
  }

  func stubAuthenticationConfig(maxAttempts: Int, durations: [TimeInterval]) {
    stub(authenticationConfig) { mock in
      when(mock.maxFailedPinAttempts.get).thenReturn(maxAttempts)
      when(mock.pinLockoutDurations.get).thenReturn(durations)
    }
  }

  func stubKeyChainController() {
    stub(keyChainController) { mock in
      when(mock.storeValue(key: any(), value: any(String.self))).then { [weak self] (key, value) in
        self?.storedValues[key.value] = value
      }
      when(mock.fetchValue(key: any())).then { [weak self] key in
        guard let self else { return nil }
        if self.isReadFailing { throw KeyChainError.readFailed(status: errSecInteractionNotAllowed) }
        return self.storedValues[key.value]
      }
      when(mock.removeObject(key: any())).then { [weak self] key in
        self?.storedValues.removeValue(forKey: key.value)
      }
    }
  }

  func readInt(forKey key: KeychainPinThrottleProvider.KeyIdentifier) -> Int {
    Int(storedValues[key.rawValue] ?? "0") ?? 0
  }

  func readDouble(forKey key: KeychainPinThrottleProvider.KeyIdentifier) -> Double {
    Double(storedValues[key.rawValue] ?? "0") ?? 0
  }
}
