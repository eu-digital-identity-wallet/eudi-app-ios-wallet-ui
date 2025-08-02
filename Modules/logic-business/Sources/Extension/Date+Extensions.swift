/*
 * Copyright (c) 2025 European Commission
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

public extension Date {

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
    formatter.locale = Locale.current.userSelectedLocale
    return formatter.string(from: self)
  }
}

public extension Date {

  static let monthYearFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM yyyy"
    formatter.locale = Locale.current.userSelectedLocale
    return formatter
  }()

  func toLocal() -> Date {
    let timeZone = TimeZone.current
    let seconds = timeZone.secondsFromGMT(for: self)
    return addingTimeInterval(TimeInterval(seconds))
  }

  func isToday() -> Bool {
    let calendar = Calendar.current
    let todayStart = calendar.startOfDay(for: Date())
    let todayEnd = calendar.date(byAdding: .day, value: 1, to: todayStart)!
    return self >= todayStart && self < todayEnd
  }

  func isThisWeek() -> Bool {
    let calendar = Calendar.current
    let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
    let endOfWeek = calendar.date(byAdding: .day, value: 7, to: startOfWeek)!
    return self.toLocal() >= startOfWeek && self.toLocal() < endOfWeek
  }

  func formattedMonthYear() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM yyyy"
    formatter.locale = Locale.current.userSelectedLocale
    return formatter.string(from: self.toLocal()).uppercased()
  }

  var monthYearOrder: Int {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month], from: self)
    let year = components.year ?? 0
    let month = components.month ?? 0
    return (year * 12 + month)
  }
}
