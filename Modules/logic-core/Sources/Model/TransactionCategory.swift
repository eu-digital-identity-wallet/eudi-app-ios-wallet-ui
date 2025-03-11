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

public enum TransactionCategory: Hashable, Equatable, Sendable {
  case today
  case thisWeek
  case month(dateTime: String)

  public var title: String {
    return switch self {
    case .today:
      "TODAY"
    case .thisWeek:
      "THIS WEEK"
    case .month(let dateTime):
      dateTime
    }
  }

  public var order: Int {
    return switch self {
    case .today:
      0
    case .thisWeek:
      1
    case .month:
      2
    }
  }

  public static func category(
    for dateString: String,
    using format: String = "dd MMM yyyy HH:mm a"
  ) -> TransactionCategory {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")

    guard let date = dateFormatter.date(from: dateString) else {
      return .month(dateTime: "")
    }

    if date.isToday() {
      return .today
    } else if date.isThisWeek() {
      return .thisWeek
    } else {
      let formattedMonthYear = date.formattedMonthYear()
      return .month(dateTime: formattedMonthYear)
    }
  }

  public static func sortMonths(_ categories: [TransactionCategory]) -> [TransactionCategory] {
    let sortedCategories = categories.sorted {
      switch ($0, $1) {
      case (.month(let dateTime1), .month(let dateTime2)):
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        guard let date1 = dateFormatter.date(from: dateTime1),
              let date2 = dateFormatter.date(from: dateTime2) else {
          return false
        }
        return date1 < date2
      default:
        return false
      }
    }
    return sortedCategories
  }
}
