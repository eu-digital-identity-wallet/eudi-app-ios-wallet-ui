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

public enum TransactionCategory: Hashable, Equatable, Sendable {

  case month(dateTime: String)

  public var title: LocalizableStringKey {
    switch self {
    case .month(let dateTime):
      switch dateTime {
      case LocalizableStringKey.today.toString:
        return .today
      case LocalizableStringKey.thisWeek.toString:
        return .thisWeek
      default:
        return LocalizableStringKey.custom(dateTime)
      }
    }
  }

  public var order: Int {
    switch self {
    case .month(let dateTime):
      switch dateTime {
      case LocalizableStringKey.today.toString:
        return Int.max - 2
      case LocalizableStringKey.thisWeek.toString:
        return Int.max - 3
      default:
        if let date = Date.monthYearFormatter.date(from: dateTime) {
          return date.monthYearOrder
        }
        return 0
      }
    }
  }

  public static func category(for dateString: String) -> TransactionCategory {
    guard let date = Date.date(from: dateString) else {
      return .month(dateTime: LocalizableStringKey.custom("").toString)
    }

    if date.isToday() {
      return .month(dateTime: LocalizableStringKey.today.toString)
    } else if date.isThisWeek() {
      return .month(dateTime: LocalizableStringKey.thisWeek.toString)
    } else {
      return .month(dateTime: date.formattedMonthYear())
    }
  }
}
