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

public enum TransactionCategory: Hashable, Equatable, Sendable {
  case today
  case thisWeek
  case month(dateTime: String)

  public var title: LocalizableStringKey {
    switch self {
    case .today:
      return LocalizableStringKey.today
    case .thisWeek:
      return LocalizableStringKey.thisWeek
    case .month(let dateTime):
      return LocalizableStringKey.custom(dateTime)
    }
  }

  public var order: Int {
    switch self {
    case .today:
      return 0
    case .thisWeek:
      return 1
    case .month(let dateTime):
      if let date = Date.monthYearFormatter.date(from: dateTime) {
        let calendar = Calendar.current
        let yearMonth = calendar.dateComponents([.year, .month], from: date)
        let year = yearMonth.year ?? 0
        let month = yearMonth.month ?? 0
        return (year * 12 + month)
      }
      return 2
    }
  }

  public static func category(for dateString: String) -> TransactionCategory {
    guard let date = Date.date(from: dateString) else {
      return .month(dateTime: "")
    }

    if date.isToday() {
      return .today
    } else if date.isThisWeek() {
      return .thisWeek
    } else {
      return .month(dateTime: date.formattedMonthYear())
    }
  }
}
