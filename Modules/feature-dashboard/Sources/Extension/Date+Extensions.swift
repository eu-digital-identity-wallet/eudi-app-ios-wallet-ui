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

extension Date {

  static let transactionDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd MMMM yyyy HH:mm a"
    formatter.locale = Locale.current.userSelectedLocale
    return formatter
  }()

  static func date(from string: String) -> Date? {
    return Date.transactionDateFormatter.date(from: string)
  }

  static func fromFormattedTransactionString(_ string: String) -> Date? {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd MMM yyyy hh:mm a"
    formatter.locale = Locale.current.userSelectedLocale
    return formatter.date(from: string)
  }

  func formattedTimestamp() -> LocalizableStringKey {
    let formatter = DateFormatter()
    formatter.locale = Locale.current.userSelectedLocale
    formatter.dateFormat = "dd MMM yyyy hh:mm a"
    return .custom(formatter.string(from: self))
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
    formatter.locale = Locale.current.userSelectedLocale
    if calendar.isDateInToday(self) {
      formatter.dateFormat = "hh:mm a"
    } else {
      formatter.dateFormat = "dd MMM yyyy hh:mm a"
    }

    return .custom(formatter.string(from: self))
  }
}
