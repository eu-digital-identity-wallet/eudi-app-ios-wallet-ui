/*
 * Copyright (c) 2023 European Commission
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
import logic_resources

extension Date {
  func isWithinNextDays(_ days: Int) -> Bool {
    let calendar = Calendar.current

    guard let futureDate = calendar.date(byAdding: .day, value: days, to: Date()) else {
      return false
    }

    return self >= Date() && self <= futureDate
  }

  func isBeyondNextDays(_ days: Int) -> Bool {
    let calendar = Calendar.current

    guard let futureDate = calendar.date(byAdding: .day, value: days, to: Date()) else {
      return false
    }

    return self > futureDate
  }

  func isBeforeToday() -> Bool {
    let calendar = Calendar.current
    return calendar.compare(self, to: Date(), toGranularity: .day) == .orderedAscending
  }

  func isValid() -> Bool {
    return self >= Date()
  }

  func isExpired() -> Bool {
    return self < Date()
  }

  func formattedString() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd MMMM yyyy hh:mm a"
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter.string(from: self)
  }

  func isBetween(_ startDate: Date?, _ endDate: Date?) -> Bool? {
    guard let start = startDate, let end = endDate else {
      return startDate == nil && endDate == nil ? nil : false
    }

    guard start <= end else { return false }

    let calendar = Calendar.current
    let startOfDay = calendar.startOfDay(for: start)
    let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: end) ?? end

    if startOfDay == endOfDay {
      return calendar.isDate(self, inSameDayAs: startOfDay)
    }

    return (startOfDay...endOfDay).contains(self)
  }

  func formattedAsDayMonthYearTime() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "d MMMM yyyy hh:mm a"
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone.current
    return formatter.string(from: self)
  }

  static func fromFormattedTransactionString(_ string: String) -> Date? {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd MMM yyyy hh:mm a"
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter.date(from: string)
  }

  func formattedForTransactionDisplay() -> LocalizableStringKey {
    let now = Date()
    let calendar = Calendar.current

    if let diff = calendar.dateComponents([.minute], from: self, to: now).minute {
      if diff < 0 {
        return .unknownDate
      } else if diff == 0 {
        return .justNow
      } else if diff < 60 {
        return diff == 1 ? .minuteAgo([String(diff)]) : .minutesAgo([String(diff)])
      }
    }

    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    if calendar.isDateInToday(self) {
      formatter.dateFormat = "hh:mm a"
    } else {
      formatter.dateFormat = "dd MMM yyyy hh:mm a"
    }

    return .custom(formatter.string(from: self))
  }
}
