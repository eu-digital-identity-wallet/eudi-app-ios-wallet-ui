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
import Copyable
import logic_ui
import logic_resources
import logic_core

@Copyable
public struct TransactionDetailsUiModel: Equatable, Identifiable, Routable {

  public let id: String
  let transactionDetailsCardData: TransactionDetailsCardData
  let items: [ListItemSection<Sendable>]

  public var log: String {
    "transactionId: \(id)"
  }

  init(
    id: String,
    transactionDetailsCardData: TransactionDetailsCardData,
    items: [ListItemSection<Sendable>],
  ) {
    self.id = id
    self.transactionDetailsCardData = transactionDetailsCardData
    self.items = items
  }
}

public struct TransactionDetailsCardData: Equatable, Identifiable, Routable {
  public let id: String
  let transactionTypeLabel: String
  let transactionStatusLabel: String
  let transactionDate: String
  let relyingPartyName: String?
  let relyingPartyIsVerified: Bool?

  public var log: String {
    "id: \(id)"
  }

  init(
    id: String = UUID().uuidString,
    transactionTypeLabel: String,
    transactionStatusLabel: String,
    transactionDate: String,
    relyingPartyName: String? = nil,
    relyingPartyIsVerified: Bool? = false
  ) {
    self.id = id
    self.transactionTypeLabel = transactionTypeLabel
    self.transactionStatusLabel = transactionStatusLabel
    self.transactionDate = transactionDate
    self.relyingPartyName = relyingPartyName
    self.relyingPartyIsVerified = relyingPartyIsVerified
  }
}

extension TransactionLogItem {
  func toUiModel() -> TransactionDetailsUiModel {

    var relyingPartyData: TransactionLog.RelyingParty? {
      return switch self.transactionLogData {
      case .presentation(let log):
        log.relyingParty
      case .issuance, .signing:
        nil
      }
    }

    var items: [ListItemSection<Sendable>] {
      return switch self.transactionLogData {
      case .presentation(let log):
        log.documents.transformToTransactionListItemSections()
      case .issuance, .signing:
        []
      }
    }

    return .init(
      id: self.id,
      transactionDetailsCardData: TransactionDetailsCardData(
        transactionTypeLabel: "A",
        transactionStatusLabel: "A",
        transactionDate: "A",
        relyingPartyName: relyingPartyData?.name,
        relyingPartyIsVerified: relyingPartyData?.isVerified
      ),
      items: items
    )
  }
}
