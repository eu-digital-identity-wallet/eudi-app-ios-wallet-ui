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

extension Date {

  static let monthYearFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM yyyy"
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter
  }()

  static let transactionDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd MMMM yyyy HH:mm a"
    formatter.locale = Locale(identifier: "en_US_POSIX")
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
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter.string(from: self.toLocal()).uppercased()
  }

  static func date(from string: String) -> Date? {
    return Date.transactionDateFormatter.date(from: string)
  }
}
