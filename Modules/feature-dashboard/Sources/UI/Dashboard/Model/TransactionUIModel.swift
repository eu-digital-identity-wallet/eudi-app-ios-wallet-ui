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
import SwiftUI
import logic_core
import logic_resources
import logic_business
import logic_ui

public struct TransactionUIModel: Identifiable, Sendable, FilterableItemPayload {
  public let id: String
  public let name: String
  public let status: TransactionStatus
  public let transactionDate: String
  public let transactionCategory: TransactionCategory
  public let transactionType: TransactionType

  public init(
    id: String = UUID().uuidString,
    name: String,
    status: TransactionStatus,
    transactionDate: String,
    transactionCategory: TransactionCategory,
    relyingPartyName: String? = nil,
    transactionType: TransactionType
  ) {
    self.id = id
    self.name = name
    self.status = status
    self.transactionDate = transactionDate
    self.transactionCategory = TransactionCategory.category(for: transactionDate)
    self.transactionType = transactionType
  }

  public var listItem: ListItemData {
    return ListItemData(
      mainText: .custom(name),
      overlineText: status.statusTitle,
      supportingText: formattedTransactionDate(),
      supportingTextColor: Theme.shared.color.onSurface,
      overlineTextColor: status == .completed ? Theme.shared.color.success : Theme.shared.color.error,
      trailingContent: .icon(
        Theme.shared.image.chevronRight,
        Theme.shared.color.onSurfaceVariant,
        transactionType.typeTitle
      )
    )
  }

  static func mocks() -> [TransactionCategory: [TransactionUIModel]] {

    let now = Date()
    let twentyMinutesAgo = Calendar.gregorian.date(byAdding: .minute, value: -20, to: now) ?? now
    let threeHoursAgo = Calendar.gregorian.date(byAdding: .hour, value: -3, to: now) ?? now
    let twoDaysAgo = Calendar.gregorian.date(byAdding: .day, value: -2, to: now) ?? now
    let threeDaysAgo = Calendar.gregorian.date(byAdding: .day, value: -3, to: now) ?? now
    let threeDaysMinusFourHoursAgo = Calendar.gregorian.date(byAdding: .day, value: -3, to: now).flatMap {
        Calendar.gregorian.date(byAdding: .hour, value: -4, to: $0)
    } ?? now

    let transactions: [TransactionUIModel] = [
      .init(
        name: "Document Signing",
        status: .completed,
        transactionDate: twentyMinutesAgo.formattedString(),
        transactionCategory: .category(for: twentyMinutesAgo.formattedString()),
        transactionType: .signing
      ),
      .init(
        name: "Document Signing",
        status: .completed,
        transactionDate: threeHoursAgo.formattedString(),
        transactionCategory: .category(for: threeHoursAgo.formattedString()),
        transactionType: .signing
      ),
      .init(
        name: "Document Signing",
        status: .completed,
        transactionDate: twoDaysAgo.formattedString(),
        transactionCategory: .category(for: twoDaysAgo.formattedString()),
        transactionType: .signing
      ),
      .init(
        name: "Document Signing",
        status: .completed,
        transactionDate: threeDaysAgo.formattedString(),
        transactionCategory: .category(for: threeDaysAgo.formattedString()),
        transactionType: .signing
      ),
      .init(
        name: "Document Signing",
        status: .completed,
        transactionDate: threeDaysMinusFourHoursAgo.formattedString(),
        transactionCategory: .category(for: threeDaysMinusFourHoursAgo.formattedString()),
        transactionType: .signing
      ),
      .init(
        name: "Another Document Signing",
        status: .completed,
        transactionDate: "23 February 2025 09:20 AM",
        transactionCategory: .category(for: "23 February 2025 09:20 AM"),
        transactionType: .signing
      ),
      .init(
        name: "Document Signing",
        status: .completed,
        transactionDate: "20 February 2025 09:20 AM",
        transactionCategory: .category(for: "20 February 2025 09:20 AM"),
        transactionType: .signing
      ),
      .init(
        name: "Relying Party Name 1",
        status: .failed,
        transactionDate: "19 February 2025 05:40 PM",
        transactionCategory: .category(for: "19 February 2025 05:40 PM"),
        transactionType: .presentation
      ),
      .init(
        name: "Relying Party Name 2",
        status: .completed,
        transactionDate: "17 February 2025 11:55 AM",
        transactionCategory: .category(for: "17 February 2025 11:55 AM"),
        transactionType: .presentation
      ),
      .init(
        name: "Document Signing",
        status: .completed,
        transactionDate: "10 February 2025 01:15 PM",
        transactionCategory: .category(for: "10 February 2025 01:15 PM"),
        transactionType: .signing
      ),
      .init(
        name: "Relying Party Name 2",
        status: .failed,
        transactionDate: "20 January 2025 04:30 PM",
        transactionCategory: .category(for: "20 January 2025 04:30 PM"),
        transactionType: .presentation
      ),
      .init(
        name: "Document Signing",
        status: .completed,
        transactionDate: "20 December 2024 10:05 AM",
        transactionCategory: .category(for: "20 December 2024 10:05 AM"),
        transactionType: .signing
      ),
      .init(
        name: "Relying Party Name 1",
        status: .completed,
        transactionDate: "01 March 2024 02:20 PM",
        transactionCategory: .category(for: "01 March 2024 02:20 PM"),
        transactionType: .presentation
      ),
      .init(
        name: "Document Signing",
        status: .failed,
        transactionDate: "22 February 2024 09:45 AM",
        transactionCategory: .category(for: "22 February 2024 09:45 AM"),
        transactionType: .signing
      ),
      .init(
        name: "Relying Party Name 3",
        status: .completed,
        transactionDate: "17 February 2024 11:30 AM",
        transactionCategory: .category(for: "17 February 2024 11:30 AM"),
        transactionType: .presentation
      ),
      .init(
        name: "Issuance 1",
        status: .failed,
        transactionDate: "17 February 2024 12:30 AM",
        transactionCategory: .category(for: "17 February 2024 12:30 AM"),
        transactionType: .issuance
      ),
      .init(
        name: "Issuance 2",
        status: .completed,
        transactionDate: "18 February 2024 04:20 AM",
        transactionCategory: .category(for: "18 February 2024 04:20 AM"),
        transactionType: .issuance
      ),
      .init(
        name: "Old Document",
        status: .completed,
        transactionDate: "15 May 1999 10:30 AM",
        transactionCategory: .category(for: "15 May 1999 10:30 AM"),
        transactionType: .signing
      )
    ]

    return Dictionary(grouping: transactions, by: { $0.transactionCategory })
  }

//  func transformToTransactionUi(
//    with failedDocuments: [String] = [],
//    categories: TransactionCategory
//  ) -> TransactionUIModel {
//    return self
//  }

  private func formattedTransactionDate() -> LocalizableStringKey {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd MMM yyyy hh:mm a"
    formatter.locale = Locale(identifier: "en_US_POSIX")

    guard let transactionDate = formatter.date(from: transactionDate) else {
      return LocalizableStringKey.custom(transactionDate)
    }

    let now = Date()
    let calendar = Calendar.current

    if let diff = calendar.dateComponents([.minute], from: transactionDate, to: now).minute {
      if diff < 0 {
        return LocalizableStringKey.unknownDate
      } else if diff == 60 {
        return LocalizableStringKey.minutesAgo([String(diff)])
      } else if diff < 60 {
        if diff == 1 {
          return LocalizableStringKey.minuteAgo([String(diff)])
        } else {
          return LocalizableStringKey.minutesAgo([String(diff)])
        }
      }
    }

    if calendar.isDateInToday(transactionDate) {
      formatter.dateFormat = "hh:mm a"
      return LocalizableStringKey.custom(formatter.string(from: transactionDate))
    } else {
      formatter.dateFormat = "dd MMM yyyy hh:mm a"
      return LocalizableStringKey.custom(formatter.string(from: transactionDate))
    }
  }
}

public enum TransactionStatus: Sendable {
  case incomplete
  case completed
  case failed

  var statusTitle: LocalizableStringKey {
    switch self {
    case .completed:
      return .completed
    case .failed, .incomplete:
      return .failed
    }
  }
}

extension TransactionLog.Status {
  func mapToTransactionStatus() -> TransactionStatus {
    return .completed
  }
}

public enum TransactionType: Sendable {
  case presentation
  case issuance
  case signing

  var typeTitle: LocalizableStringKey {
    switch self {
    case .presentation:
      return .presentation
    case .issuance:
      return .issuance
    case .signing:
      return .signing
    }
  }
}

extension TransactionLogData {
  func transformToTransactionUI() -> TransactionUIModel {
    switch self {
    case .presentation(let logData):
      return .init(
        name: logData.relyingParty.name,
        status: logData.status.mapToTransactionStatus(),
        transactionDate: "logData.timestamp",
        transactionCategory: .category(for: "logData.timestamp"),
        transactionType: .presentation
      )
    case .issuance, .signing:
      return .init(
        name: "",
        status: .completed,
        transactionDate: "",
        transactionCategory: .category(for: ""),
        transactionType: .presentation
      )
    }
  }
}
