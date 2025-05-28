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
import logic_core
import logic_resources
import logic_business
import logic_ui

public struct TransactionTabUIModel: Identifiable, Sendable, Equatable, FilterableItemPayload {
  public let id: String
  public let name: String
  public let status: TransactionStatus
  public let transactionDate: String
  public let transactionCategory: TransactionCategory
  public let transactionType: TransactionType

  init(
    id: String,
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
      id: self.id,
      mainText: .custom(name),
      overlineText: self.status.statusTitle,
      supportingText: self.formattedTransactionDate(),
      supportingTextColor: Theme.shared.color.onSurface,
      overlineTextColor: self.status == .completed ? Theme.shared.color.success : Theme.shared.color.error,
      trailingContent: .icon(
        Theme.shared.image.chevronRight,
        Theme.shared.color.onSurfaceVariant,
        self.transactionType.typeTitle
      )
    )
  }

  private func formattedTransactionDate() -> LocalizableStringKey {
    Date.fromFormattedTransactionString(transactionDate)?.formattedForTransactionDisplay() ?? .custom(transactionDate)
  }
}

public enum TransactionStatus: Sendable, Equatable {
  case completed
  case failed

  var statusTitle: LocalizableStringKey {
    switch self {
    case .completed:
      return .completed
    case .failed:
      return .failed
    }
  }
}

public enum TransactionType: Sendable, Equatable {
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

extension TransactionLogItem {
  func transformToTransactionUI() -> TransactionTabUIModel {
    switch self.transactionLogData {
    case .presentation(let logData):
      return .init(
        id: self.id,
        name: logData.relyingParty.name,
        status: logData.status.mapToTransactionStatus(),
        transactionDate: logData.timestamp.formattedAsDayMonthYearTime(),
        transactionCategory: .category(for: logData.timestamp.formattedAsDayMonthYearTime()),
        transactionType: .presentation
      )
    case .issuance, .signing:
      return .init(
        id: self.id,
        name: "",
        status: .completed,
        transactionDate: "",
        transactionCategory: .category(for: ""),
        transactionType: .presentation
      )
    }
  }
}

extension TransactionLog.Status {
  func mapToTransactionStatus() -> TransactionStatus {
    switch self {
    case .completed:
      return .completed
    case .failed, .incomplete:
      return .failed
    }
  }
}
