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
import Foundation
import WalletStorage
import logic_storage

/// Timing of deferred credential requests, from `config`: wait the interval sent by the issuer, or
/// `initialPollingDelay` when it sends none, with no lower or upper limit. An interval of 0 or less counts as none:
/// OpenID4VCI reports a "still pending" answer without one as 0. An interval the issuer has just sent is waited with
/// `issuerIntervalMargin` on top; a fallback is waited as it is.
/// A failed request is asked again after `failureRetryDelay`, for as long as the document is deferred.
struct DeferredIssuanceSchedule: Sendable {

  /// Added to an interval the issuer has just sent: an issuer that rounds the time left down would
  /// otherwise be asked a moment too early, answer "still pending" and make the wallet wait a whole interval again.
  static let issuerIntervalMargin: TimeInterval = 1

  let config: DeferredIssuanceConfig

  /// nil when the issuer sent no interval, or one of 0 or less.
  static func validInterval(_ interval: TimeInterval?) -> TimeInterval? {
    guard let interval, interval.isFinite, interval > 0 else { return nil }
    return interval
  }

  func wait(interval: TimeInterval?) -> TimeInterval {
    Self.validInterval(interval) ?? config.initialPollingDelay
  }

  /// The wait after a failed request.
  var failureWait: TimeInterval {
    config.failureRetryDelay
  }

  func nextAttempt(after date: Date, interval: TimeInterval?) -> Date {
    date.addingTimeInterval(wait(interval: interval))
  }

  /// Stores a valid interval as the issuer sent it, and none otherwise.
  func pending(identifier: String, interval: TimeInterval?, at date: Date) -> DeferredIssuance {
    DeferredIssuance(
      identifier: identifier,
      nextAttemptAt: nextAttempt(after: date, interval: interval),
      interval: Self.validInterval(interval)
    )
  }

  /// Before a request: the next attempt waits the last valid interval, so an app closed before the answer arrives
  /// doesn't ask again at once when it opens.
  func beforeRequest(identifier: String, lastInterval: TimeInterval?, at date: Date) -> DeferredIssuance {
    pending(identifier: identifier, interval: lastInterval, at: date)
  }

  /// After a "still pending" answer: waits the interval it sent, or the last valid one the issuer sent before
  /// (`lastInterval`) when it sent none.
  func stillPending(
    identifier: String,
    interval: TimeInterval?,
    lastInterval: TimeInterval?,
    at date: Date
  ) -> DeferredIssuance {
    guard let interval = Self.validInterval(interval) else {
      return pending(identifier: identifier, interval: lastInterval, at: date)
    }
    return answered(identifier: identifier, interval: interval, at: date)
  }

  /// For documents the issuer has just deferred, whose interval is fresh.
  func entries(for documents: [WalletStorage.Document], at date: Date) -> [DeferredIssuance] {
    documents
      .filter { $0.status == .deferred }
      .map { document in
        guard let interval = Self.validInterval(document.deferredIssuanceInterval) else {
          return pending(identifier: document.id, interval: nil, at: date)
        }
        return answered(identifier: document.id, interval: interval, at: date)
      }
  }

  /// An issuer that can't be verified marks the entry untrusted, an access token that can no longer be used marks it
  /// failed. Any other failure asks again after `failureRetryDelay`, whatever the issuer's interval, and keeps that
  /// interval for the answers to come. A failure of the wallet itself restores the entry as it was before the request,
  /// and the caller waits `failureWait` in memory.
  func after(_ failure: DeferredRequestFailure, of entry: DeferredIssuance, at date: Date) -> DeferredIssuance {
    switch failure {
    case .untrusted:
      DeferredIssuance(
        identifier: entry.identifier,
        nextAttemptAt: entry.nextAttemptAt,
        interval: entry.interval,
        state: .untrusted
      )
    case .expired:
      DeferredIssuance(
        identifier: entry.identifier,
        nextAttemptAt: entry.nextAttemptAt,
        interval: entry.interval,
        state: .failed
      )
    case .local:
      entry
    case .transient:
      DeferredIssuance(
        identifier: entry.identifier,
        nextAttemptAt: date.addingTimeInterval(failureWait),
        interval: entry.interval
      )
    }
  }
}

private extension DeferredIssuanceSchedule {

  /// `interval` is valid and was just sent by the issuer: stored as sent, waited with `issuerIntervalMargin`.
  func answered(identifier: String, interval: TimeInterval, at date: Date) -> DeferredIssuance {
    DeferredIssuance(
      identifier: identifier,
      nextAttemptAt: date.addingTimeInterval(interval + Self.issuerIntervalMargin),
      interval: interval
    )
  }
}
