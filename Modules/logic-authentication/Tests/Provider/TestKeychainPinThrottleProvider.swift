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

@testable import logic_test
@testable import logic_authentication
@testable import logic_business

final class TestKeychainPinThrottleProvider: EudiTest {

  private var storedValues: [String: String] = [:]

  private var provider: PinThrottleProvider!
  private var keyChainController: MockKeyChainController!
  private var authenticationConfig: MockAuthenticationConfig!

  override func setUp() {
    super.setUp()
    self.storedValues = [:]
    self.keyChainController = MockKeyChainController()
    self.authenticationConfig = MockAuthenticationConfig()

    stubAuthenticationConfig(maxAttempts: 3, durations: [30, 90, 300])
    stubKeyChainController()

    self.provider = KeychainPinThrottleProvider(
      keyChainController: keyChainController,
      authenticationConfig: authenticationConfig
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

  func testGetState_WhenEndsAtZero_ThenIdle() {
    storeDouble(Date().timeIntervalSince1970 - 1, forKey: .pinLockoutStartedAt)
    storeDouble(0, forKey: .pinLockoutEndsAt)

    XCTAssertEqual(provider.getState(), .idle)
  }

  func testGetState_WhenNowExceedsEndsAt_ThenIdle() {
    let now = Date().timeIntervalSince1970
    storeDouble(now - 60, forKey: .pinLockoutStartedAt)
    storeDouble(now - 30, forKey: .pinLockoutEndsAt)

    XCTAssertEqual(provider.getState(), .idle)
  }

  func testGetState_WhenLockoutActive_ThenReturnsRemainingAndTotal() {
    let now = Date().timeIntervalSince1970
    storeDouble(now - 5, forKey: .pinLockoutStartedAt)
    storeDouble(now + 25, forKey: .pinLockoutEndsAt)

    guard case let .active(remaining, total) = provider.getState() else {
      XCTFail("Expected .active")
      return
    }
    XCTAssertEqual(total, 30, accuracy: 0.5)
    XCTAssertGreaterThan(remaining, 23)
    XCTAssertLessThanOrEqual(remaining, 26)
  }

  func testGetState_WhenClockMovedBackwardBeforeStartedAt_ThenReportsFullTotal() {
    let now = Date().timeIntervalSince1970
    let startedAt = now + 1_000
    storeDouble(startedAt, forKey: .pinLockoutStartedAt)
    storeDouble(startedAt + 30, forKey: .pinLockoutEndsAt)

    guard case let .active(remaining, total) = provider.getState() else {
      XCTFail("Expected .active")
      return
    }
    XCTAssertEqual(remaining, 30, accuracy: 0.1)
    XCTAssertEqual(total, 30, accuracy: 0.1)
  }

  func testRecordFailure_WhenBelowThreshold_ThenIdleAndCounterIncremented() {
    XCTAssertEqual(provider.recordFailure(), .idle)
    XCTAssertEqual(readInt(forKey: .pinFailedAttempts), 1)

    XCTAssertEqual(provider.recordFailure(), .idle)
    XCTAssertEqual(readInt(forKey: .pinFailedAttempts), 2)

    XCTAssertEqual(readInt(forKey: .pinLockoutLevel), 0)
    XCTAssertNil(storedValues[KeychainPinThrottleProvider.KeyIdentifier.pinLockoutStartedAt.rawValue])
    XCTAssertNil(storedValues[KeychainPinThrottleProvider.KeyIdentifier.pinLockoutEndsAt.rawValue])
  }

  func testRecordFailure_WhenThirdFailure_ThenStartsFirstLockoutWith30s() {
    _ = provider.recordFailure()
    _ = provider.recordFailure()
    let result = provider.recordFailure()

    XCTAssertEqual(result, .active(remaining: 30, total: 30))
    XCTAssertEqual(readInt(forKey: .pinFailedAttempts), 0)
    XCTAssertEqual(readInt(forKey: .pinLockoutLevel), 1)

    let startedAt = readDouble(forKey: .pinLockoutStartedAt)
    let endsAt = readDouble(forKey: .pinLockoutEndsAt)
    XCTAssertGreaterThan(startedAt, 0)
    XCTAssertEqual(endsAt - startedAt, 30, accuracy: 0.1)
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

  func testRecordSuccess_ClearsAllPersistedState() {
    for _ in 0..<5 { _ = provider.recordFailure() }
    XCTAssertGreaterThan(readInt(forKey: .pinLockoutLevel), 0)

    provider.recordSuccess()

    XCTAssertEqual(readInt(forKey: .pinFailedAttempts), 0)
    XCTAssertEqual(readInt(forKey: .pinLockoutLevel), 0)
    XCTAssertEqual(readDouble(forKey: .pinLockoutStartedAt), 0)
    XCTAssertEqual(readDouble(forKey: .pinLockoutEndsAt), 0)
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

  private func stubAuthenticationConfig(maxAttempts: Int, durations: [TimeInterval]) {
    stub(authenticationConfig) { mock in
      when(mock.maxFailedPinAttempts.get).thenReturn(maxAttempts)
      when(mock.pinLockoutDurations.get).thenReturn(durations)
    }
  }

  private func stubKeyChainController() {
    stub(keyChainController) { mock in
      when(mock.storeValue(key: any(), value: any(String.self))).then { [weak self] (key, value) in
        self?.storedValues[key.value] = value
      }
      when(mock.getValue(key: any())).then { [weak self] key in
        self?.storedValues[key.value]
      }
      when(mock.removeObject(key: any())).then { [weak self] key in
        self?.storedValues.removeValue(forKey: key.value)
      }
    }
  }

  private func storeDouble(_ value: Double, forKey key: KeychainPinThrottleProvider.KeyIdentifier) {
    storedValues[key.rawValue] = String(value)
  }

  private func readInt(forKey key: KeychainPinThrottleProvider.KeyIdentifier) -> Int {
    Int(storedValues[key.rawValue] ?? "0") ?? 0
  }

  private func readDouble(forKey key: KeychainPinThrottleProvider.KeyIdentifier) -> Double {
    Double(storedValues[key.rawValue] ?? "0") ?? 0
  }
}
