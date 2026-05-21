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

final class KeychainPinThrottleProvider: PinThrottleProvider {

  private let keyChainController: KeyChainController
  private let authenticationConfig: AuthenticationConfig

  init(
    keyChainController: KeyChainController,
    authenticationConfig: AuthenticationConfig
  ) {
    self.keyChainController = keyChainController
    self.authenticationConfig = authenticationConfig
  }

  func getState() -> PinLockoutState {
    let startedAt = getDouble(forKey: .pinLockoutStartedAt)
    let endsAt = getDouble(forKey: .pinLockoutEndsAt)

    guard startedAt > 0, endsAt > 0 else {
      return .idle
    }

    let total = max(endsAt - startedAt, 0)
    let now = Date().timeIntervalSince1970

    if now < startedAt {
      return .active(remaining: total, total: total)
    }

    if now >= endsAt {
      return .idle
    }

    return .active(remaining: endsAt - now, total: total)
  }

  func recordFailure() -> PinLockoutState {
    let currentAttempts = getInt(forKey: .pinFailedAttempts)
    let newAttempts = currentAttempts + 1
    let maxAttempts = authenticationConfig.maxFailedPinAttempts

    if newAttempts < maxAttempts {
      setInt(newAttempts, forKey: .pinFailedAttempts)
      return .idle
    }

    let currentLevel = getInt(forKey: .pinLockoutLevel)
    let durations = authenticationConfig.pinLockoutDurations
    let duration: TimeInterval
    if durations.isEmpty {
      duration = 0
    } else {
      duration = durations[min(currentLevel, durations.count - 1)]
    }

    let now = Date().timeIntervalSince1970
    let endsAt = now + duration

    setInt(0, forKey: .pinFailedAttempts)
    setInt(currentLevel + 1, forKey: .pinLockoutLevel)
    setDouble(now, forKey: .pinLockoutStartedAt)
    setDouble(endsAt, forKey: .pinLockoutEndsAt)

    return .active(remaining: duration, total: duration)
  }

  func recordSuccess() {
    setInt(0, forKey: .pinFailedAttempts)
    setInt(0, forKey: .pinLockoutLevel)
    setDouble(0, forKey: .pinLockoutStartedAt)
    setDouble(0, forKey: .pinLockoutEndsAt)
  }
}

extension KeychainPinThrottleProvider {

  enum KeyIdentifier: String, KeyChainWrapper {

    var value: String { rawValue }

    case pinFailedAttempts
    case pinLockoutLevel
    case pinLockoutStartedAt
    case pinLockoutEndsAt
  }
}

private extension KeychainPinThrottleProvider {

  func getInt(forKey key: KeyIdentifier) -> Int {
    guard let raw = keyChainController.getValue(key: key) else { return 0 }
    return Int(raw) ?? 0
  }

  func getDouble(forKey key: KeyIdentifier) -> Double {
    guard let raw = keyChainController.getValue(key: key) else { return 0 }
    return Double(raw) ?? 0
  }

  func setInt(_ value: Int, forKey key: KeyIdentifier) {
    keyChainController.storeValue(key: key, value: String(value))
  }

  func setDouble(_ value: Double, forKey key: KeyIdentifier) {
    keyChainController.storeValue(key: key, value: String(value))
  }
}
