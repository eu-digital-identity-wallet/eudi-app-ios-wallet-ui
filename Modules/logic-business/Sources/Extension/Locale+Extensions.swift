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

public extension Locale {

  static let serviceDateFormatters = [
    "yyyy-MM-dd'T'HH:mm:ss.SSS",
    "yyyy-MM-dd'T'HH:mm:ss",
    "yyyy-MM-dd'T'HH:mm:ss.SSSZ",
    "yyyy-MM-dd'T'HH:mm:ssZ",
    "yyyy-MM-dd",
    "dd/MM/yyyy"
  ]

  private var userSelectedLocale: Locale {
    guard let identifier = DIGraph.resolver.resolve(PrefsController.self)?.getUserLocale() else {
      return Locale.current
    }
    return Locale(identifier: identifier)
  }

  var systemLanguageCode: String? {
    Locale.current.language.languageCode?.identifier
  }

  func localizedDateTime(
    date: String,
    uiFormatter: String,
    formatters: [String] = serviceDateFormatters
  ) -> String {

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = uiFormatter
    dateFormatter.locale = userSelectedLocale

    return parseDate(date: date, uiFormatter: dateFormatter, formatters: formatters)
  }

  func localizedDateTime(
    date: String,
    formatters: [String] = serviceDateFormatters,
    dateStyle: DateFormatter.Style = .short,
    timeStyle: DateFormatter.Style = .none
  ) -> String {

    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = dateStyle
    dateFormatter.timeStyle = timeStyle
    dateFormatter.locale = userSelectedLocale

    return parseDate(date: date, uiFormatter: dateFormatter, formatters: formatters)
  }

  func localizedDateTime(
    date: Date,
    uiFormatter: String
  ) -> String {
    let parseDateFormatter = DateFormatter()
    parseDateFormatter.dateFormat = uiFormatter
    return parseDateFormatter.string(from: date)
  }

  private func parseDate(
    date: String,
    uiFormatter: DateFormatter,
    formatters: [String] = serviceDateFormatters
  ) -> String {
    var current: Date?
    for formatter in formatters {
      let parseDateFormatter = DateFormatter()
      parseDateFormatter.dateFormat = formatter
      if let normalDate = parseDateFormatter.date(from: date) {
        current = normalDate
        break
      }
    }
    guard let parsedDate = current else {
      return date
    }
    return uiFormatter.string(from: parsedDate)
  }

  func parseDate(
    date: String,
    formatters: [String] = serviceDateFormatters
  ) -> Date? {
    for formatter in formatters {
      let parseDateFormatter = DateFormatter()
      parseDateFormatter.dateFormat = formatter
      if let normalDate = parseDateFormatter.date(from: date) {
        return normalDate
      }
    }
    return nil
  }
}
