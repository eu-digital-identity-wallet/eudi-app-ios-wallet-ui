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

/// The PIN lockout, kept in the Keychain. Its time is the monotonic clock and the boot it was read in
/// (`MonotonicClock`), not the wall clock, so moving the device's date forward does not end a lockout early, and a
/// restart begins the lockout again in full. A lockout that has run its course is cleared, keeping its level, so a
/// later restart does not begin it again. A counter that cannot be read counts as a lockout of the longest
/// configured duration, so a failed read never gives extra attempts.
final class KeychainPinThrottleProvider: PinThrottleProvider {

  private let keyChainController: KeyChainController
  private let authenticationConfig: AuthenticationConfig
  private let now: @Sendable () -> TimeInterval
  private let bootSessionIdentifier: @Sendable () -> String

  init(
    keyChainController: KeyChainController,
    authenticationConfig: AuthenticationConfig,
    now: @escaping @Sendable () -> TimeInterval = { MonotonicClock.now() },
    bootSessionIdentifier: @escaping @Sendable () -> String = { MonotonicClock.bootSessionIdentifier }
  ) {
    self.keyChainController = keyChainController
    self.authenticationConfig = authenticationConfig
    self.now = now
    self.bootSessionIdentifier = bootSessionIdentifier
  }

  func getState() -> PinLockoutState {
    guard
      let startedAt = try? readDouble(forKey: .pinLockoutStartedAtUptime),
      let duration = try? readDouble(forKey: .pinLockoutDuration),
      let bootSession = try? readString(forKey: .pinLockoutBootSession)
    else {
      return unreadableStateLockout()
    }

    guard startedAt > 0, duration > 0 else {
      return .idle
    }

    let current = now()
    guard bootSession == bootSessionIdentifier(), current >= startedAt else {
      startLockout(duration: duration)
      return .active(remaining: duration, total: duration)
    }

    let elapsed = current - startedAt
    guard elapsed < duration else {
      clearLockout()
      return .idle
    }
    return .active(remaining: duration - elapsed, total: duration)
  }

  func recordFailure() -> PinLockoutState {
    guard
      let currentAttempts = try? readInt(forKey: .pinFailedAttempts),
      let currentLevel = try? readInt(forKey: .pinLockoutLevel)
    else {
      return unreadableStateLockout()
    }
    let newAttempts = currentAttempts + 1
    let maxAttempts = authenticationConfig.maxFailedPinAttempts

    if newAttempts < maxAttempts {
      setInt(newAttempts, forKey: .pinFailedAttempts)
      clearLockoutIfEnded()
      return .idle
    }

    let durations = authenticationConfig.pinLockoutDurations
    let duration: TimeInterval
    if durations.isEmpty {
      duration = 0
    } else {
      duration = durations[min(currentLevel, durations.count - 1)]
    }

    setInt(0, forKey: .pinFailedAttempts)
    setInt(currentLevel + 1, forKey: .pinLockoutLevel)
    startLockout(duration: duration)

    return .active(remaining: duration, total: duration)
  }

  func recordSuccess() {
    setInt(0, forKey: .pinFailedAttempts)
    setInt(0, forKey: .pinLockoutLevel)
    clearLockout()
    keyChainController.removeObject(key: KeyIdentifier.pinLockoutStartedAt)
    keyChainController.removeObject(key: KeyIdentifier.pinLockoutEndsAt)
  }
}

extension KeychainPinThrottleProvider {

  enum KeyIdentifier: String, KeyChainWrapper {

    var value: String { rawValue }

    case pinFailedAttempts
    case pinLockoutLevel
    case pinLockoutStartedAtUptime
    case pinLockoutDuration
    case pinLockoutBootSession
    /// Wall-clock values of builds before the monotonic lockout; removed when the attempts are cleared.
    case pinLockoutStartedAt
    case pinLockoutEndsAt
  }
}

private extension KeychainPinThrottleProvider {

  func startLockout(duration: TimeInterval) {
    setDouble(now(), forKey: .pinLockoutStartedAtUptime)
    setDouble(duration, forKey: .pinLockoutDuration)
    keyChainController.storeValue(key: KeyIdentifier.pinLockoutBootSession, value: bootSessionIdentifier())
  }

  /// Clears a lockout that has run its course in this boot, so that a later restart does not begin it again.
  func clearLockoutIfEnded() {
    guard
      let startedAt = try? readDouble(forKey: .pinLockoutStartedAtUptime),
      let duration = try? readDouble(forKey: .pinLockoutDuration),
      let bootSession = try? readString(forKey: .pinLockoutBootSession),
      startedAt > 0,
      bootSession == bootSessionIdentifier()
    else { return }
    let current = now()
    if current >= startedAt, current - startedAt >= duration {
      clearLockout()
    }
  }

  func clearLockout() {
    setDouble(0, forKey: .pinLockoutStartedAtUptime)
    setDouble(0, forKey: .pinLockoutDuration)
    keyChainController.removeObject(key: KeyIdentifier.pinLockoutBootSession)
  }

  func unreadableStateLockout() -> PinLockoutState {
    let longest = authenticationConfig.pinLockoutDurations.max() ?? 0
    return .active(remaining: longest, total: longest)
  }

  /// Empty when the value is missing; throws when the Keychain could not be read.
  func readString(forKey key: KeyIdentifier) throws -> String {
    try keyChainController.fetchValue(key: key) ?? ""
  }

  /// Zero when the value is missing or not a number; throws when the Keychain could not be read.
  func readInt(forKey key: KeyIdentifier) throws -> Int {
    try keyChainController.fetchValue(key: key).flatMap { Int($0) } ?? 0
  }

  /// Zero when the value is missing or not a number; throws when the Keychain could not be read.
  func readDouble(forKey key: KeyIdentifier) throws -> Double {
    try keyChainController.fetchValue(key: key).flatMap { Double($0) } ?? 0
  }

  func setInt(_ value: Int, forKey key: KeyIdentifier) {
    keyChainController.storeValue(key: key, value: String(value))
  }

  func setDouble(_ value: Double, forKey key: KeyIdentifier) {
    keyChainController.storeValue(key: key, value: String(value))
  }
}
