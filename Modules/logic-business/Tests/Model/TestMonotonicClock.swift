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
@testable import logic_business
@testable import logic_test

final class TestMonotonicClock: EudiTest {

  func testNow_WhenReadTwice_ThenNeverGoesBack() {
    let first = MonotonicClock.now()
    let second = MonotonicClock.now()

    XCTAssertGreaterThan(first, 0)
    XCTAssertGreaterThanOrEqual(second, first)
  }

  func testBootSessionIdentifier_WhenReadTwice_ThenIsTheSameNonEmptyValue() {
    XCTAssertFalse(MonotonicClock.bootSessionIdentifier.isEmpty)
    XCTAssertEqual(MonotonicClock.bootSessionIdentifier, MonotonicClock.bootSessionIdentifier)
  }

  func testNow_WhenTimePasses_ThenAdvancesInSeconds() async throws {
    let start = MonotonicClock.now()

    try await Task.sleep(seconds: 0.05)
    let elapsed = MonotonicClock.now() - start

    XCTAssertGreaterThanOrEqual(elapsed, 0.04)
    XCTAssertLessThan(elapsed, 5)
  }

  func testNow_WhenRead_ThenIsTheMonotonicClockInSeconds() {
    let reference = TimeInterval(clock_gettime_nsec_np(CLOCK_MONOTONIC)) / 1_000_000_000

    XCTAssertEqual(MonotonicClock.now(), reference, accuracy: 1)
  }
}
