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

public protocol AuthenticationConfig: Sendable {

  /// Number of consecutive wrong PIN attempts allowed before the user is locked out.
  var maxFailedPinAttempts: Int { get }

  /// Lockout durations (in seconds) applied each time the user reaches `maxFailedPinAttempts`.
  /// The list indexes by lockout level (0 = first lockout). Once the user exceeds the
  /// size of the list, the last entry is reused for every subsequent lockout.
  var pinLockoutDurations: [TimeInterval] { get }

  /// Seconds in the background after which the wallet locks: returning to it then requires login.
  var backgroundLockTimeout: TimeInterval { get }

  /// Seconds without interaction after which the wallet locks, on every screen.
  var idleLockTimeout: TimeInterval { get }

  /// Replaces `backgroundLockTimeout` while an issuance, presentation or signing is in progress, since
  /// these can send the user to a website and back. It also caps how long another screen, such as the
  /// RQES SDK's or the issuer's sign-in, may cover the wallet's own: the idle timeout pauses meanwhile, and
  /// the wallet locks when a cover this long ends, or once the issuer's sign-in has lasted this long.
  var protectedFlowLockTimeout: TimeInterval { get }

  /// PINs refused as too easy to guess, besides one digit repeated and ascending or descending runs: the Android
  /// wallet's list. Add the PINs your policy names.
  var commonPins: Set<String> { get }

  /// Whether the wallet can be set up, and logged in to, only on a device with a passcode. When false, a device
  /// without one gets a warning on the PIN screen at setup and on the login screen, and the user goes on, as on
  /// Android.
  var requireDeviceSecure: Bool { get }
}

struct AuthenticationConfigImpl: AuthenticationConfig {

  public let maxFailedPinAttempts: Int = 3
  public let pinLockoutDurations: [TimeInterval] = [30, 90, 300]
  public let backgroundLockTimeout: TimeInterval = 60
  public let idleLockTimeout: TimeInterval = 300
  public let protectedFlowLockTimeout: TimeInterval = 600
  public let commonPins: Set<String> = [
    "123123", "121212", "112233", "123321", "102030", "147258", "159753", "789456", "696969", "000123"
  ]
  public let requireDeviceSecure: Bool = false
}

public extension AuthenticationConfig {

  /// True for a PIN that is easy to guess: one digit repeated, an ascending or descending run of digits, or one of
  /// `commonPins`, as the Android wallet's `isWeakPin`.
  func isWeakPin(_ pin: String) -> Bool {
    let digits = pin.compactMap(\.wholeNumberValue)
    guard !digits.isEmpty, digits.count == pin.count else { return false }
    let steps = zip(digits.dropFirst(), digits).map { $0 - $1 }
    let isRepeated = steps.allSatisfy { $0 == 0 }
    let isAscending = steps.allSatisfy { $0 == 1 }
    let isDescending = steps.allSatisfy { $0 == -1 }
    return isRepeated || isAscending || isDescending || commonPins.contains(pin)
  }
}
