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
import Foundation
import logic_core
import logic_business
import logic_resources

public struct TransactionActionHistoryUiModel: Equatable, Sendable {
  public let title: LocalizableStringKey
  public let disclaimer: LocalizableStringKey
  public let message: LocalizableStringKey
  public let authorityLabel: LocalizableStringKey?
  public let authorityName: LocalizableStringKey?
  public let entries: [TransactionActionHistoryEntryUi]
}

public struct TransactionActionHistoryEntryUi: Identifiable, Equatable, Sendable {
  public let id: String
  public let method: LocalizableStringKey
  public let date: LocalizableStringKey
}

extension TransactionActionHistoryUiModel {
  static func mock() -> TransactionActionHistoryUiModel {
    .init(
      title: .transactionHistoryReportTitle(["Relying party"]),
      disclaimer: .transactionHistoryReportDisclaimer,
      message: .transactionHistoryReportMessage,
      authorityLabel: .transactionActionAuthorityLabel,
      authorityName: .custom("Data protection authority"),
      entries: []
    )
  }
}

extension TransactionLogDomain.Presentation {

  func toActionHistoryUiModel(
    action: TransactionDataProtectionAction,
    actions: [TransactionLogDomain]
  ) -> TransactionActionHistoryUiModel {
    let partyName = party.name ?? LocalizableStringKey.transactionDetailsRelyingPartyLabel.toString
    let entries = actions.compactMap { $0.toActionHistoryEntry(for: action) }
    switch action {
    case .requestDataDeletion:
      return .init(
        title: .transactionHistoryDeletionTitle([partyName]),
        disclaimer: .transactionHistoryDeletionDisclaimer,
        message: .transactionHistoryDeletionMessage,
        authorityLabel: nil,
        authorityName: nil,
        entries: entries
      )
    case .reportSuspiciousTransaction:
      let authorityName = entries.isEmpty ? nil : registration?.dpa?.name?.nonBlankValue
      return .init(
        title: .transactionHistoryReportTitle([partyName]),
        disclaimer: .transactionHistoryReportDisclaimer,
        message: .transactionHistoryReportMessage,
        authorityLabel: authorityName == nil ? nil : .transactionActionAuthorityLabel,
        authorityName: authorityName.map { .custom($0) },
        entries: entries
      )
    }
  }
}

private extension TransactionLogDomain {

  func toActionHistoryEntry(for action: TransactionDataProtectionAction) -> TransactionActionHistoryEntryUi? {
    let channel: TransactionActionChannel?
    switch (self, action) {
    case (.dataDeletionRequest(let log), .requestDataDeletion):
      channel = log.channel
    case (.dpaReport(let log), .reportSuspiciousTransaction):
      channel = log.channel
    default:
      return nil
    }
    return .init(
      id: id,
      method: channel?.historyTitle ?? .transactionHistoryChannelOther,
      date: .custom(time.formattedForDocumentDetails())
    )
  }
}
