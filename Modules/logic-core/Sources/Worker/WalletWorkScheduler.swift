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

/// The wallet's background work: the periodic revocation and re-issuance checks and the deferred credential requests.
/// As the Android wallet's `WalletWorkScheduler`, it is the only way in from outside `logic-core`; the workers
/// themselves stay internal.
public protocol WalletWorkScheduler: Sendable {
  /// Starts the periodic checks and the deferred credential requests, or starts them again after `stop()`. Work
  /// already running is kept. The dashboard calls it once the user has logged in, and a factory reset that fails calls
  /// it again; a call made while a factory reset runs starts nothing.
  func schedule() async
  /// Runs the revocation check soon, after one under way, when the original of a completed re-issue gained a
  /// revocation record while it was re-issued, so the new copy's status is read without waiting for the interval.
  /// It returns at once; nothing runs while the checks are stopped.
  func scheduleRevocationCheck(afterReIssueOf originalId: String) async
  /// Blocks new checks until `schedule()` starts them again, then, after any start under way, stops the periodic
  /// checks and the deferred credential requests and waits for a check under way to finish, all within
  /// `WalletKitConfig.workerStopTimeoutSeconds`. Returns false when one was still running then, as the Android
  /// wallet's `stop()`; the checks stay stopped either way.
  func stop() async -> Bool
}

/// Starts and stops the revocation and re-issuance checks and the deferred credential requests for the app, once per
/// process (`.container`).
final actor WalletWorkSchedulerImpl: WalletWorkScheduler {

  private let revocationWorkManager: RevocationWorkManager
  private let reIssuanceWorkManager: ReIssuanceWorkManager
  private let deferredIssuanceWorkManager: DeferredIssuanceWorkManager
  private let stopTimeout: TimeInterval
  private let resetStatusProvider: WalletResetStatusProvider
  /// Set by `stop()` before it stops anything and cleared by `schedule()`, as the Android wallet's `isStopped`.
  private var isStopped = false
  /// The starts of the latest `schedule()`, after those of the one before. `stop()` waits for them before it stops
  /// the checks, so a start under way when the reset begins cannot land after the stop, as the Android wallet's
  /// `schedule()` runs under the lock `stop()` takes.
  private var starting: Task<Void, Never>?

  init(
    revocationWorkManager: RevocationWorkManager,
    reIssuanceWorkManager: ReIssuanceWorkManager,
    deferredIssuanceWorkManager: DeferredIssuanceWorkManager,
    stopTimeout: TimeInterval,
    resetStatusProvider: WalletResetStatusProvider
  ) {
    self.revocationWorkManager = revocationWorkManager
    self.reIssuanceWorkManager = reIssuanceWorkManager
    self.deferredIssuanceWorkManager = deferredIssuanceWorkManager
    self.stopTimeout = stopTimeout
    self.resetStatusProvider = resetStatusProvider
  }

  func schedule() async {
    guard !resetStatusProvider.isResetting else { return }
    isStopped = false
    let previous = starting
    let current = Task { [revocationWorkManager, reIssuanceWorkManager, deferredIssuanceWorkManager] in
      await previous?.value
      await revocationWorkManager.start()
      await reIssuanceWorkManager.start()
      await deferredIssuanceWorkManager.start()
    }
    starting = current
    await current.value
  }

  func scheduleRevocationCheck(afterReIssueOf originalId: String) {
    guard !isStopped else { return }
    Task { [revocationWorkManager] in
      await revocationWorkManager.checkAfterReIssue(of: originalId)
    }
  }

  /// The stop and the timeout race; a stop still waiting when the time is up keeps running in the background, so
  /// the checks end stopped either way.
  func stop() async -> Bool {
    isStopped = true
    let (outcomes, continuation) = AsyncStream.makeStream(of: Bool.self)
    Task { [revocationWorkManager, reIssuanceWorkManager, deferredIssuanceWorkManager, starting] in
      await starting?.value
      async let revocationStopped: Void = revocationWorkManager.stop()
      async let reIssuanceStopped: Void = reIssuanceWorkManager.stop()
      async let deferredIssuanceStopped: Void = deferredIssuanceWorkManager.stop()
      _ = await (revocationStopped, reIssuanceStopped, deferredIssuanceStopped)
      continuation.yield(true)
    }
    let timeout = Task { [stopTimeout] in
      try? await Task.sleep(seconds: stopTimeout)
      continuation.yield(false)
    }
    var iterator = outcomes.makeAsyncIterator()
    let stopped = await iterator.next() ?? false
    timeout.cancel()
    continuation.finish()
    return stopped
  }
}
