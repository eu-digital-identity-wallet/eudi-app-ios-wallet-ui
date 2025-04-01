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
  public let relyingPartyName: String?
  public let attestationName: String?
  public let transactionType: TransactionType?

  public init(
    id: String = UUID().uuidString,
    name: String,
    status: TransactionStatus,
    transactionDate: String,
    transactionCategory: TransactionCategory,
    relyingPartyName: String? = "Transactions without relying party",
    attestationName: String? = "Transactions without attestation name",
    transactionType: TransactionType? = .presentation
  ) {
    self.id = id
    self.name = name
    self.status = status
    self.transactionDate = transactionDate
    self.transactionCategory = TransactionCategory.category(for: transactionDate)
    self.relyingPartyName = relyingPartyName
    self.attestationName = attestationName
    self.transactionType = transactionType
  }

  public var listItem: ListItemData {
    return ListItemData(
      mainText: .custom(name),
      overlineText: .custom(status.rawValue),
      supportingText: .custom(formattedTransactionDate()),
      supportingTextColor: Theme.shared.color.onSurface,
      overlineTextColor: status == .completed ? Theme.shared.color.success : Theme.shared.color.error,
      trailingContent: .icon(
        Theme.shared.image.chevronRight,
        Theme.shared.color.onSurfaceVariant,
        transactionType?.rawValue ?? ""
      )
    )
  }

  static func mocks() -> [TransactionCategory: [TransactionUIModel]] {
    
    let now = Date()
    let twentyMinutesAgo = Calendar.gregorian.date(byAdding: .minute, value: -20, to: now) ?? now
    let yesterday = Calendar.gregorian.date(byAdding: .day, value: -1, to: now) ?? now
    
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
        transactionDate: yesterday.formattedString(),
        transactionCategory: .category(for: yesterday.formattedString()),
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
        name: "PID Presentation",
        status: .failed,
        transactionDate: "19 February 2025 05:40 PM",
        transactionCategory: .category(for: "19 February 2025 05:40 PM"),
        relyingPartyName: "Test relying party",
        attestationName: "PID Presentation"
      ),
      .init(
        name: "Identity Verification",
        status: .completed,
        transactionDate: "17 February 2025 11:55 AM",
        transactionCategory: .category(for: "17 February 2025 11:55 AM"),
        relyingPartyName: "Test relying party",
        attestationName: "Identity Verification",
        transactionType: .issuance
      ),
      .init(
        name: "Document Signing",
        status: .completed,
        transactionDate: "10 February 2025 01:15 PM",
        transactionCategory: .category(for: "10 February 2025 01:15 PM"),
        transactionType: .signing
      ),
      .init(
        name: "Data Sharing Request",
        status: .failed,
        transactionDate: "20 January 2025 04:30 PM",
        transactionCategory: .category(for: "20 January 2025 04:30 PM"),
        relyingPartyName: "Test relying party, other",
        attestationName: "Data Sharing Request"
      ),
      .init(
        name: "Document Signing",
        status: .completed,
        transactionDate: "20 December 2024 10:05 AM",
        transactionCategory: .category(for: "20 December 2024 10:05 AM"),
        transactionType: .signing
      ),
      .init(
        name: "PID Presentation",
        status: .completed,
        transactionDate: "01 March 2024 02:20 PM",
        transactionCategory: .category(for: "01 March 2024 02:20 PM"),
        relyingPartyName: "Test relying party",
        attestationName: "PID Presentation"
      ),
      .init(
        name: "Document Signing",
        status: .failed,
        transactionDate: "22 February 2024 09:45 AM",
        transactionCategory: .category(for: "22 February 2024 09:45 AM"),
        transactionType: .signing
      ),
      .init(
        name: "Identity Verification",
        status: .completed,
        transactionDate: "17 February 2024 11:30 AM",
        transactionCategory: .category(for: "17 February 2024 11:30 AM"),
        relyingPartyName: "Test relying party",
        attestationName: "Identity Verification"
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
      formatter.dateFormat = "dd MMM yyyy"
      return formatter.string(from: transactionDate)
    }
  }
}

public enum TransactionStatus: String, CaseIterable, Sendable {
  case completed = "Completed"
  case failed = "Failed"
}

public enum TransactionType: String, CaseIterable, Sendable {
  case signing = "e-Signature"
  case presentation = "Data Sharing"
  case issuance = "Issuance"
}
