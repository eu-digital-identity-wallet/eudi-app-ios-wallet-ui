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

/// The device's monotonic time, which counts sleep and is not moved by changes to the date and time, and the boot it
/// belongs to: it starts again from zero at every boot.
public enum MonotonicClock {

  public static func now() -> TimeInterval {
    TimeInterval(clock_gettime_nsec_np(CLOCK_MONOTONIC)) / 1_000_000_000
  }

  /// Changes at every boot (`kern.bootsessionuuid`); empty when the system does not report it.
  public static var bootSessionIdentifier: String {
    var size = 0
    guard sysctlbyname("kern.bootsessionuuid", nil, &size, nil, 0) == 0, size > 0 else { return "" }
    var buffer = [UInt8](repeating: 0, count: size)
    guard sysctlbyname("kern.bootsessionuuid", &buffer, &size, nil, 0) == 0 else { return "" }
    return String(bytes: buffer.prefix { $0 != 0 }, encoding: .utf8) ?? ""
  }
}
