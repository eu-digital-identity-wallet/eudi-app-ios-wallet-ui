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
import logic_business

/// Whether the wallet is unlocked, and when it must lock again, with the Android wallet's rules.
///
/// The wallet starts locked. Login and PIN creation unlock it. It locks again after
/// `AuthenticationConfig.backgroundLockTimeout` in the background, or after
/// `AuthenticationConfig.idleLockTimeout` without interaction. While an issuance, presentation or signing
/// is in progress the background limit is `AuthenticationConfig.protectedFlowLockTimeout`, so that a visit
/// to the issuer's website does not end the session.
///
/// Another screen can cover the wallet's own: the RQES SDK's screens (`setCovered(_:)`) or a flow that
/// leaves the wallet's screens, such as the issuer's sign-in (`beginExternalFlow()`). The wallet cannot see
/// interaction there, so the idle timeout pauses and the background limit is the protected-flow one. When
/// the cover goes, the wallet locks if it was covered for at least the protected-flow timeout; otherwise
/// the idle timeout restarts. On Android only the RQES screens pause the idle timeout; on iOS the issuer's
/// sign-in shows inside the wallet's own scene, which stays active, so it pauses it too, for at most the
/// protected-flow timeout. A lock ends every cover.
///
/// Time comes from a monotonic clock that keeps running while the device sleeps, so neither changing the
/// device clock nor sleep extends a session.
public protocol SessionController: Sendable {

  /// True between a successful login or PIN creation and the next lock.
  @MainActor var isUnlocked: Bool { get }

  /// Called when the user has logged in or created the PIN. If the app left before the login completed, the background
  /// record is kept, so the background limit still applies when the app returns. A record from an earlier absence is
  /// already gone: `lockIfExpired()` clears it when the app returns while locked.
  @MainActor func unlock()

  /// Ends the session.
  @MainActor func lock()

  /// Records user interaction, which restarts the idle timeout.
  @MainActor func recordInteraction()

  /// Records that the app went to the background, and whether its screen then belonged to an issuance,
  /// presentation or signing in progress.
  @MainActor func recordBackground(isProtectedFlow: Bool)

  /// Locks the wallet, and returns true, if the time in the background since `recordBackground`, the time
  /// a flow marked by `beginExternalFlow()` has lasted or, while nothing covers the wallet, the time
  /// without interaction has reached its limit. The background limit is the protected-flow one when the
  /// screen was a protected one, or something covers the wallet on return, as on Android. Call it when the
  /// app returns, before a link it brings is handled, and regularly while it is in front. Time spent in
  /// the background does not count towards the idle limit.
  @discardableResult @MainActor func lockIfExpired() -> Bool

  /// Records whether the RQES SDK's screens, or another screen of the app, cover the wallet's own.
  @MainActor func setCovered(_ isCovered: Bool)

  /// Marks a flow that leaves the wallet's screens, such as the issuer's sign-in, as covering them until
  /// the matching `endExternalFlow(startedIn:)` or the next lock. Returns the lock period the flow began in.
  @discardableResult @MainActor func beginExternalFlow() -> Int

  /// Ends a flow that `beginExternalFlow()` marked in `lockPeriod`. A flow that began before the last lock is already
  /// over and is ignored, so its late end cannot end a flow begun since.
  @MainActor func endExternalFlow(startedIn lockPeriod: Int)
}

public extension SessionController {
  /// Runs `operation`, which may leave the wallet's screens (the issuer's sign-in), between
  /// `beginExternalFlow()` and `endExternalFlow(startedIn:)`, whether it succeeds or throws.
  func duringExternalFlow<T>(
    isolation: isolated (any Actor)? = #isolation,
    _ operation: () async throws -> T
  ) async rethrows -> T {
    let lockPeriod = await beginExternalFlow()
    do {
      let value = try await operation()
      await endExternalFlow(startedIn: lockPeriod)
      return value
    } catch {
      await endExternalFlow(startedIn: lockPeriod)
      throw error
    }
  }
}

/// The `SessionController` of the app, registered once per process.
@MainActor
final class SessionControllerImpl: SessionController {

  private let authenticationConfig: AuthenticationConfig
  private let now: @MainActor () -> TimeInterval

  private(set) var isUnlocked: Bool = false
  private var lastInteractionAt: TimeInterval = 0
  private var backgroundSince: TimeInterval?
  private var wasProtectedFlowWhenHidden: Bool = false
  private var isCoveredByScreen: Bool = false
  private var externalFlows: Int = 0
  private var currentLockPeriod: Int = 0
  private var externalFlowSince: TimeInterval?
  private var coveredSince: TimeInterval?

  private var isCovered: Bool {
    isCoveredByScreen || externalFlows > 0
  }

  /// `nonisolated` because Swinject's registration closure, which is not on the main actor, creates the controller;
  /// the initializer only stores the Sendable configuration and clock, so no main-actor state is touched.
  nonisolated init(
    authenticationConfig: AuthenticationConfig,
    now: @escaping @MainActor () -> TimeInterval = { MonotonicClock.now() }
  ) {
    self.authenticationConfig = authenticationConfig
    self.now = now
  }

  func unlock() {
    isUnlocked = true
    lastInteractionAt = now()
  }

  func lock() {
    isUnlocked = false
    backgroundSince = nil
    isCoveredByScreen = false
    externalFlows = 0
    currentLockPeriod += 1
    externalFlowSince = nil
    coveredSince = nil
  }

  func recordInteraction() {
    lastInteractionAt = now()
  }

  func recordBackground(isProtectedFlow: Bool) {
    backgroundSince = now()
    wasProtectedFlowWhenHidden = isProtectedFlow
  }

  func lockIfExpired() -> Bool {
    guard isUnlocked else {
      backgroundSince = nil
      return false
    }
    let current = now()
    if let since = backgroundSince {
      backgroundSince = nil
      let limit = wasProtectedFlowWhenHidden || isCovered
      ? authenticationConfig.protectedFlowLockTimeout
      : authenticationConfig.backgroundLockTimeout
      if current - since >= limit {
        lock()
        return true
      }
      lastInteractionAt = current
    }
    if let since = externalFlowSince, current - since >= authenticationConfig.protectedFlowLockTimeout {
      lock()
      return true
    }
    guard !isCovered else { return false }
    if current - lastInteractionAt >= authenticationConfig.idleLockTimeout {
      lock()
      return true
    }
    return false
  }

  func setCovered(_ isCovered: Bool) {
    updateCover { isCoveredByScreen = isCovered }
  }

  @discardableResult
  func beginExternalFlow() -> Int {
    let current = now()
    updateCover {
      externalFlows += 1
      if externalFlows == 1 {
        externalFlowSince = current
      }
    }
    return currentLockPeriod
  }

  func endExternalFlow(startedIn lockPeriod: Int) {
    guard lockPeriod == currentLockPeriod else { return }
    updateCover {
      externalFlows = max(0, externalFlows - 1)
      if externalFlows == 0 {
        externalFlowSince = nil
      }
    }
  }

  /// Applies `change` to the covers and notes when the wallet first became covered, or how long it was covered.
  private func updateCover(_ change: () -> Void) {
    let wasCovered = isCovered
    change()
    if !wasCovered, isCovered {
      coveredSince = now()
    } else if wasCovered, !isCovered, let since = coveredSince {
      coveredSince = nil
      let current = now()
      if current - since >= authenticationConfig.protectedFlowLockTimeout {
        lock()
      } else {
        lastInteractionAt = current
      }
    }
  }
}
