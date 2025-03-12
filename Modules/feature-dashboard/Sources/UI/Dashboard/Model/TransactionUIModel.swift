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

  public init(
    id: String = UUID().uuidString,
    name: String,
    status: TransactionStatus,
    transactionDate: String,
    transactionCategory: TransactionCategory
  ) {
    self.id = id
    self.name = name
    self.status = status
    self.transactionDate = transactionDate
    self.transactionCategory = TransactionCategory.category(for: transactionDate)
  }

  public var listItem: ListItemData {
    return ListItemData(
      mainText: .custom(name),
      overlineText: .custom(status.rawValue),
      supportingText: .custom(formattedTransactionDate()),
      supportingTextColor: Theme.shared.color.onSurface,
      overlineTextColor: status == .completed ? Theme.shared.color.success : Theme.shared.color.error,
      trailingContent: .icon(Theme.shared.image.chevronRight, Theme.shared.color.onSurfaceVariant)
    )
  }

  static func mocks() -> [TransactionCategory: [TransactionUIModel]] {
    let transactions: [TransactionUIModel] = [
      .init(
        name: "Document Signing",
        status: .completed,
        transactionDate: "02 Mar 2025 09:20 AM",
        transactionCategory: .category(for: "02 Mar 2025 09:20 PM")
      ),
      .init(
        name: "Document Signing",
        status: .completed,
        transactionDate: "11 Mar 2025 09:20 AM",
        transactionCategory: .category(for: "11 Mar 2025 09:20 AM")
      ),
      .init(
        name: "Data Sharing Request",
        status: .completed,
        transactionDate: "03 Mar 2025 09:20 AM",
        transactionCategory: .category(for: "03 Mar 2025 08:20 PM")
      ),
      .init(
        name: "Data Sharing Request",
        status: .completed,
        transactionDate: "10 Mar 2025 09:20 AM",
        transactionCategory: .category(for: "10 Mar 2025 09:20 AM")
      ),
      .init(
        name: "Another Document Signing",
        status: .completed,
        transactionDate: "06 Mar 2025 09:20 AM",
        transactionCategory: .category(for: "06 Mar 2025 09:20 AM")
      ),
      .init(
        name: "New Document Signing",
        status: .completed,
        transactionDate: "24 Feb 2025 11:07 AM",
        transactionCategory: .category(for: "24 Feb 2025 11:07 AM")
      ),
      .init(
        name: "Another Document Signing",
        status: .completed,
        transactionDate: "14 Jan 2025 11:07 AM",
        transactionCategory: .category(for: "14 Jan 2025 11:07 AM")
      ),
      .init(
        name: "A Document",
        status: .completed,
        transactionDate: "12 Mar 2025 11:07 AM",
        transactionCategory: .category(for: "12 Mar 2025 11:07 AM")
      ),
      .init(
        name: "B Document",
        status: .completed,
        transactionDate: "12 Mar 2025 12:00 PM",
        transactionCategory: .category(for: "12 Mar 2025 09:07 AM")
      ),
      .init(
        name: "PID Presentation",
        status: .failed,
        transactionDate: "03 Jul 2024 11:07 AM",
        transactionCategory: .category(for: "03 Jul 2024 11:07 AM")
      ),
      .init(
        name: "Other PID Presentation",
        status: .completed,
        transactionDate: "03 Apr 2024 11:07 AM",
        transactionCategory: .category(for: "03 Apr 2024 09:07 AM")
      ), .init(
        name: "PID Presentation",
        status: .completed,
        transactionDate: "04 Apr 2024 11:07 AM",
        transactionCategory: .category(for: "04 Apr 2024 10:07 AM")
      )
    ]

    return Dictionary(grouping: transactions, by: { $0.transactionCategory })
  }

  func transformToTransactionUi(
    with failedDocuments: [String] = [],
    categories: TransactionCategory
  ) -> TransactionUIModel {
    return self
  }

  private func formattedTransactionDate() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd MMM yyyy hh:mm a"
    formatter.locale = Locale(identifier: "en_US_POSIX")

    guard let transactionDate = formatter.date(from: transactionDate) else {
      return transactionDate
    }

    let now = Date()
    let calendar = Calendar.current

    if let diff = calendar.dateComponents([.minute], from: transactionDate, to: now).minute {
      if diff < 0 {
        return "Unknown Date"
      } else if diff == 60 {
        return "\(diff) minutes ago"
      } else if diff < 60 {
        return "\(diff) minute\(diff == 1 ? "" : "s") ago"
      }
    }

    if calendar.isDateInToday(transactionDate) {
      formatter.dateFormat = "h:mm a"
      return formatter.string(from: transactionDate)
    } else {
      formatter.dateFormat = "dd MMM yyyy h:mm a"
      return formatter.string(from: transactionDate)
    }
  }
}

public enum TransactionStatus: String, CaseIterable, Sendable {
  case completed = "Completed"
  case failed = "Failed"
}
