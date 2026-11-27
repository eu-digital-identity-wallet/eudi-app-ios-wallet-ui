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
import WalletStorage
import logic_storage
@testable import logic_core
@testable import logic_test

final class TestDeferredIssuanceSchedule: EudiTest {

  private let now = Date(timeIntervalSince1970: 1_000)
  private let schedule = DeferredIssuanceSchedule(config: .stub)

  func testNextAttempt_WhenTheIssuerGaveAnInterval_ThenWaitsThatLong() {
    // Then
    XCTAssertEqual(
      schedule.nextAttempt(after: now, interval: 42),
      now.addingTimeInterval(42)
    )
  }

  func testNextAttempt_WhenTheIntervalIsLong_ThenWaitsAllOfIt() {
    // Then
    XCTAssertEqual(
      schedule.nextAttempt(after: now, interval: 86_400),
      now.addingTimeInterval(86_400)
    )
  }

  func testNextAttempt_WhenTheIntervalIsShort_ThenWaitsAllOfItAndNoMore() {
    // Then
    for interval: TimeInterval in [0.5, 2] {
      XCTAssertEqual(
        schedule.nextAttempt(after: now, interval: interval),
        now.addingTimeInterval(interval),
        "\(interval)"
      )
    }
  }

  func testNextAttempt_WhenTheIntervalIsZeroOrLess_ThenWaitsAsIfTheIssuerGaveNone() {
    // Given
    let schedule = DeferredIssuanceSchedule(config: config(initialPollingDelaySeconds: 30))

    // Then
    for interval: TimeInterval in [0, -10, .infinity, .nan] {
      XCTAssertEqual(
        schedule.nextAttempt(after: now, interval: interval),
        now.addingTimeInterval(30),
        "\(interval)"
      )
    }
  }

  func testNextAttempt_WhenTheIssuerGaveNoInterval_ThenWaitsTheDefaultInitialDelay() {
    // Then
    XCTAssertEqual(
      schedule.nextAttempt(after: now, interval: nil),
      now.addingTimeInterval(5)
    )
  }

  func testNextAttempt_WhenTheIssuerGaveNoInterval_ThenWaitsTheConfiguredInitialDelay() {
    // Given
    let schedule = DeferredIssuanceSchedule(config: config(initialPollingDelaySeconds: 30))

    // Then
    XCTAssertEqual(schedule.nextAttempt(after: now, interval: nil), now.addingTimeInterval(30))
    XCTAssertEqual(schedule.nextAttempt(after: now, interval: 10), now.addingTimeInterval(10))
  }

  func testNextAttempt_WhenTheConfiguredInitialDelayIsShort_ThenWaitsAllOfItAndNoMore() {
    // Given
    let schedule = DeferredIssuanceSchedule(config: config(initialPollingDelaySeconds: 1))

    // Then
    XCTAssertEqual(schedule.nextAttempt(after: now, interval: nil), now.addingTimeInterval(1))
  }

  func testPending_WhenTheIntervalIsShort_ThenKeepsItAsGiven() {
    // When
    let entry = schedule.pending(identifier: "pid", interval: 2, at: now)

    // Then
    XCTAssertEqual(
      entry,
      DeferredIssuance(
        identifier: "pid",
        nextAttemptAt: now.addingTimeInterval(2),
        interval: 2,
        state: .pending
      )
    )
  }

  func testPending_WhenTheIntervalIsZeroOrLess_ThenStoresNone() {
    // Then
    for interval: TimeInterval in [0, -10] {
      XCTAssertNil(schedule.pending(identifier: "pid", interval: interval, at: now).interval, "\(interval)")
    }
  }

  func testBeforeRequest_WhenThereIsAValidLastInterval_ThenWaitsItAndKeepsIt() {
    // When
    let entry = schedule.beforeRequest(identifier: "pid", lastInterval: 60, at: now)

    // Then
    XCTAssertEqual(
      entry,
      DeferredIssuance(identifier: "pid", nextAttemptAt: now.addingTimeInterval(60), interval: 60, state: .pending)
    )
  }

  func testBeforeRequest_WhenThereIsNoValidLastInterval_ThenWaitsTheConfiguredInitialDelay() {
    // Given
    let schedule = DeferredIssuanceSchedule(config: config(initialPollingDelaySeconds: 30))

    for lastInterval: TimeInterval? in [nil, 0] {
      // When
      let entry = schedule.beforeRequest(identifier: "pid", lastInterval: lastInterval, at: now)

      // Then
      XCTAssertEqual(entry.nextAttemptAt, now.addingTimeInterval(30), "\(String(describing: lastInterval))")
      XCTAssertNil(entry.interval, "\(String(describing: lastInterval))")
    }
  }

  func testStillPending_WhenTheIssuerGaveAnInterval_ThenWaitsItWithTheMarginAndStoresItAsSent() {
    // When
    let entry = schedule.stillPending(identifier: "pid", interval: 42, lastInterval: 60, at: now)

    // Then
    XCTAssertEqual(
      entry,
      DeferredIssuance(identifier: "pid", nextAttemptAt: now.addingTimeInterval(43), interval: 42, state: .pending)
    )
  }

  func testStillPending_WhenTheIntervalIsShort_ThenWaitsItWithTheMarginAndNoMore() {
    // When
    let entry = schedule.stillPending(identifier: "pid", interval: 2, lastInterval: nil, at: now)

    // Then
    XCTAssertEqual(entry.nextAttemptAt, now.addingTimeInterval(3))
    XCTAssertEqual(entry.interval, 2)
  }

  func testStillPending_WhenTheIssuerGaveNone_ThenWaitsAndKeepsTheLastInterval() {
    for interval: TimeInterval? in [nil, 0, -1] {
      // When
      let entry = schedule.stillPending(identifier: "pid", interval: interval, lastInterval: 60, at: now)

      // Then
      XCTAssertEqual(entry.nextAttemptAt, now.addingTimeInterval(60), "\(String(describing: interval))")
      XCTAssertEqual(entry.interval, 60, "\(String(describing: interval))")
    }
  }

  func testStillPending_WhenThereIsNoValidIntervalAtAll_ThenWaitsTheConfiguredInitialDelay() {
    // Given
    let schedule = DeferredIssuanceSchedule(config: config(initialPollingDelaySeconds: 30))

    for lastInterval: TimeInterval? in [nil, 0] {
      // When
      let entry = schedule.stillPending(identifier: "pid", interval: 0, lastInterval: lastInterval, at: now)

      // Then
      XCTAssertEqual(entry.nextAttemptAt, now.addingTimeInterval(30), "\(String(describing: lastInterval))")
      XCTAssertNil(entry.interval, "\(String(describing: lastInterval))")
    }
  }

  func testEntries_WhenSomeDocumentsAreDeferred_ThenSchedulesOnlyThose() {
    // Given
    let documents = [
      document(id: "pid", status: .deferred),
      document(id: "mdl", status: .issued),
      document(id: "age", status: .deferred),
      document(id: "pending", status: .pending)
    ]

    // When
    let entries = schedule.entries(for: documents, at: now)

    // Then
    XCTAssertEqual(entries.map(\.identifier), ["pid", "age"])
    XCTAssertTrue(entries.allSatisfy { $0.state == .pending })
  }

  func testEntries_WhenTheIssuerGaveAnInterval_ThenWaitsItWithTheMarginAndStoresItAsSent() {
    // When
    let entries = schedule.entries(for: [document(id: "pid", status: .deferred, interval: 30)], at: now)

    // Then
    XCTAssertEqual(
      entries,
      [DeferredIssuance(identifier: "pid", nextAttemptAt: now.addingTimeInterval(31), interval: 30, state: .pending)]
    )
  }

  func testEntries_WhenNoDocumentIsDeferred_ThenSchedulesNothing() {
    // When
    let entries = schedule.entries(for: [document(id: "pid", status: .issued)], at: now)

    // Then
    XCTAssertTrue(entries.isEmpty)
  }

  func testEntries_WhenTheDeferredDocumentHoldsNoInterval_ThenAsksAgainAfterTheInitialDelay() {
    // When
    let entries = schedule.entries(for: [document(id: "pid", status: .deferred)], at: now)

    // Then
    XCTAssertEqual(entries.first?.interval, nil)
    XCTAssertEqual(entries.first?.nextAttemptAt, now.addingTimeInterval(5))
  }

  func testAfter_WhenTheRequestFailsAndTheIntervalIsShorter_ThenAsksAgainAfterTheFailureRetryDelayAndKeepsTheInterval() {
    // Given
    let entry = DeferredIssuance(identifier: "pid", nextAttemptAt: now, interval: 12)

    // When
    let next = schedule.after(.transient, of: entry, at: now.addingTimeInterval(100))

    // Then
    XCTAssertEqual(
      next,
      DeferredIssuance(
        identifier: "pid",
        nextAttemptAt: now.addingTimeInterval(130),
        interval: 12,
        state: .pending
      )
    )
  }

  func testAfter_WhenTheRequestFails_ThenWaitsTheFailureRetryDelayOrTheIssuerIntervalWhicheverIsLonger() {
    // Given
    let schedule = DeferredIssuanceSchedule(config: config(failureRetryDelaySeconds: 45))
    let expectedWaits: [(interval: TimeInterval?, wait: TimeInterval)] = [(nil, 45), (1, 45), (0, 45), (600, 600)]

    for (interval, wait) in expectedWaits {
      let entry = DeferredIssuance(identifier: "pid", nextAttemptAt: now, interval: interval)

      // When
      let next = schedule.after(.transient, of: entry, at: now)

      // Then
      XCTAssertEqual(next.nextAttemptAt, now.addingTimeInterval(wait), "\(String(describing: interval))")
      XCTAssertEqual(next.state, .pending)
      XCTAssertEqual(next.interval, interval)
    }
  }

  func testAfter_WhenTheFailureRetryDelayIsShort_ThenAsksAgainAfterAllOfItAndNoMore() {
    // Given
    let schedule = DeferredIssuanceSchedule(config: config(failureRetryDelaySeconds: 1))
    let entry = DeferredIssuance(identifier: "pid", nextAttemptAt: now)

    // When
    let next = schedule.after(.transient, of: entry, at: now)

    // Then
    XCTAssertEqual(next.nextAttemptAt, now.addingTimeInterval(1))
  }

  func testAfter_WhenRequestsKeepFailing_ThenKeepsAskingAtTheSamePace() {
    // Given
    var entry = DeferredIssuance(identifier: "pid", nextAttemptAt: now, interval: 10)
    var date = now

    // Then
    for _ in 0..<100 {
      entry = schedule.after(.transient, of: entry, at: date)
      XCTAssertEqual(entry.state, .pending)
      XCTAssertEqual(entry.nextAttemptAt, date.addingTimeInterval(30))
      date = entry.nextAttemptAt
    }
  }

  func testAfter_WhenTheWalletItselfFails_ThenLeavesTheEntryAsItWas() {
    // Given
    let entry = DeferredIssuance(identifier: "pid", nextAttemptAt: now, interval: 60)

    // When
    let next = schedule.after(.local, of: entry, at: now.addingTimeInterval(100))

    // Then
    XCTAssertEqual(next, entry)
  }

  func testFailureWait_WhenAFailureRetryDelayIsConfigured_ThenIsThatDelay() {
    // Then
    XCTAssertEqual(DeferredIssuanceSchedule(config: config(failureRetryDelaySeconds: 45)).failureWait, 45)
    XCTAssertEqual(DeferredIssuanceSchedule(config: config(failureRetryDelaySeconds: 1)).failureWait, 1)
  }

  func testAfter_WhenTheTransactionHasExpired_ThenStopsAskingAndMarksItFailed() {
    // Given
    let entry = DeferredIssuance(identifier: "pid", nextAttemptAt: now, interval: 60)

    // When
    let next = schedule.after(.expired, of: entry, at: now.addingTimeInterval(100))

    // Then
    XCTAssertEqual(
      next,
      DeferredIssuance(identifier: "pid", nextAttemptAt: now, interval: 60, state: .failed)
    )
  }

  func testAfter_WhenTheIssuerCannotBeVerified_ThenStopsAskingAndKeepsTheRest() {
    // Given
    let entry = DeferredIssuance(identifier: "pid", nextAttemptAt: now, interval: 60)

    // When
    let next = schedule.after(.untrusted, of: entry, at: now.addingTimeInterval(100))

    // Then
    XCTAssertEqual(
      next,
      DeferredIssuance(identifier: "pid", nextAttemptAt: now, interval: 60, state: .untrusted)
    )
  }

  func testWait_WhenTheIssuerGaveNoInterval_ThenIsTheConfiguredInitialDelay() {
    // Then
    XCTAssertEqual(schedule.wait(interval: nil), 5)
    XCTAssertEqual(DeferredIssuanceSchedule(config: config(initialPollingDelaySeconds: 45)).wait(interval: nil), 45)
  }
}

private extension TestDeferredIssuanceSchedule {

  func config(initialPollingDelaySeconds: TimeInterval = 5, failureRetryDelaySeconds: TimeInterval = 30) -> DeferredIssuanceConfig {
    DeferredIssuanceConfig(initialPollingDelaySeconds: initialPollingDelaySeconds, failureRetryDelaySeconds: failureRetryDelaySeconds)
  }

  /// `interval` is stored as WalletKit stores a deferred response, so `deferredIssuanceInterval` reads it back.
  func document(
    id: String,
    status: WalletStorage.DocumentStatus,
    interval: TimeInterval? = nil
  ) -> WalletStorage.Document {
    let data = interval.map {
      Data(
        """
        {"deferredCredentialEndpoint": "https://issuer.example/deferred", "transactionId": {"value": "tx"},
        "publicKeys": [], "timeStamp": 0, "interval": \($0)}
        """.utf8
      )
    }
    return WalletStorage.Document(
      id: id,
      docType: "",
      docDataFormat: .cbor,
      data: data ?? Data(),
      docKeyInfo: nil,
      createdAt: nil,
      metadata: nil,
      displayName: "",
      status: status
    )
  }
}
