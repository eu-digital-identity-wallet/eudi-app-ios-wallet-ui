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

/// Timing of deferred credential requests, shared by all deferred documents. In seconds, each above 0. The issuer's
/// interval is waited in full.
struct DeferredIssuanceConfig: Sendable, Equatable {

  /// Wait before the next request when the issuer sends no interval.
  let initialPollingDelay: TimeInterval
  /// Wait after a request that failed, whatever the issuer's interval.
  let failureRetryDelay: TimeInterval

  init(initialPollingDelay: TimeInterval, failureRetryDelay: TimeInterval) {
    precondition(initialPollingDelay.isFinite && initialPollingDelay > 0)
    precondition(failureRetryDelay.isFinite && failureRetryDelay > 0)
    self.initialPollingDelay = initialPollingDelay
    self.failureRetryDelay = failureRetryDelay
  }
}
