/*
 * Copyright (c) 2026 European Commission
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
  public let transactionDate: Date
  public let transactionCategory: TransactionCategory
  public let transactionType: TransactionType

  init(
    id: String,
    name: String,
    status: TransactionStatus,
    transactionDate: Date,
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
      mainContent: .text(.custom(name)),
      overlineText: self.status.statusTitle,
      supportingText: self.formattedTransactionDate(),
      supportingTextColor: Theme.shared.color.primaryLabel,
      overlineTextColor: self.status == .completed ? Theme.shared.color.green : Theme.shared.color.red,
      trailingContent: .textWithIcon(
        Theme.shared.image.chevronRight,
        Theme.shared.color.accent,
        self.transactionType.typeTitle
      )
    )
  }

  private func formattedTransactionDate() -> LocalizableStringKey {
    transactionDate.formattedForTransactionDisplay()
  }
}

public enum TransactionStatus: Sendable, Equatable {
  case completed
  case notCompleted

  var statusTitle: LocalizableStringKey {
    switch self {
    case .completed:
      return .completed
    case .notCompleted:
      return .notCompleted
    }
  }
}

public enum TransactionType: Sendable, Equatable {
  case presentation
  case issuance
  case reissuance
  case deletion
  case signing
  case dataDeletionRequest
  case dpaReport

  var typeTitle: LocalizableStringKey {
    switch self {
    case .presentation:
      return .presentation
    case .issuance:
      return .issuance
    case .reissuance:
      return .reissuance
    case .deletion:
      return .deletion
    case .signing:
      return .signing
    case .dataDeletionRequest:
      return .transactionTypeDataDeletionRequest
    case .dpaReport:
      return .transactionTypeDpaReport
    }
  }
}

extension TransactionLogDomain {
  var transactionType: TransactionType {
    switch self {
    case .presentation: .presentation
    case .credentialIssuance: .issuance
    case .credentialReissuance: .reissuance
    case .credentialDeletion: .deletion
    case .signingSealing: .signing
    case .dataDeletionRequest: .dataDeletionRequest
    case .dpaReport: .dpaReport
    }
  }

  var transactionStatus: TransactionStatus {
    result.mapToTransactionStatus()
  }

  var isVisibleInTransactionList: Bool {
    switch self {
    case .presentation, .credentialIssuance, .credentialReissuance, .credentialDeletion, .signingSealing:
      true
    case .dataDeletionRequest, .dpaReport:
      false
    }
  }

  var partyName: String? {
    let name: String? = switch self {
    case .presentation(let log): log.party.name
    case .credentialIssuance(let log): log.details.issuer.name
    case .credentialReissuance(let log): log.details.issuer.name
    case .credentialDeletion(let log): log.issuer.name
    case .signingSealing(let log): log.service.name
    case .dataDeletionRequest(let log): log.party.name
    case .dpaReport(let log): log.dpaName
    }
    return name?.nonBlank
  }

  var transactionTitle: String {
    let name: String? = switch self {
    case .presentation, .dataDeletionRequest, .dpaReport:
      partyName
    case .credentialIssuance(let log):
      partyName ?? log.details.credentials.first?.identifier.rawValue
    case .credentialReissuance(let log):
      partyName ?? log.details.credentials.first?.identifier.rawValue
    case .credentialDeletion(let log):
      partyName ?? log.credential.identifier.rawValue
    case .signingSealing(let log):
      partyName ?? log.fileName?.nonBlank
    }
    return name ?? transactionType.typeTitle.toString
  }

  var searchTags: [String] {
    let tags: [String?] = switch self {
    case .presentation(let log):
      [partyName, log.intermediary?.name]
    case .signingSealing(let log):
      [partyName, log.fileName]
    case .credentialDeletion(let log):
      [partyName, log.credential.identifier.rawValue]
    case .credentialIssuance, .credentialReissuance:
      [partyName]
    case .dataDeletionRequest, .dpaReport:
      []
    }
    return tags
      .compactMap { $0?.nonBlank }
      .reduce(into: [String]()) { unique, tag in
        if !unique.contains(tag) { unique.append(tag) }
      }
  }

  func transformToTransactionUI() -> TransactionTabUIModel? {
    guard isVisibleInTransactionList else { return nil }
    return .init(
      id: id,
      name: transactionTitle,
      status: transactionStatus,
      transactionDate: time,
      transactionType: transactionType
    )
  }
}

extension TransactionResultDomain {
  func mapToTransactionStatus() -> TransactionStatus {
    switch self {
    case .completed:
      return .completed
    case .notCompleted:
      return .notCompleted
    }
  }
}

private extension String {
  var nonBlank: String? {
    let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
    return trimmed.isEmpty ? nil : trimmed
  }
}
