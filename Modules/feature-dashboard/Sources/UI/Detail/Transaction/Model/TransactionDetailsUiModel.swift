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
import logic_ui
import logic_core
import logic_business

public struct TransactionDetailsUiModel: Equatable, Identifiable, Sendable {

  public let id: String
  public let transactionDetailsCardData: TransactionDetailsCardData
  public let items: [GenericListItemSection]
}

public struct TransactionDetailsCardData: Equatable, Identifiable, Sendable {

  @EquatableNoop
  public var id: String

  public let transactionTypeLabel: String
  public let transactionStatusLabel: String
  public let transactionIsCompleted: Bool
  public let transactionDate: String
  public let relyingPartyName: String?
  public let relyingPartyIsVerified: Bool?

  init(
    id: String = UUID().uuidString,
    transactionTypeLabel: String,
    transactionStatusLabel: String,
    transactionIsCompleted: Bool,
    transactionDate: String,
    relyingPartyName: String? = nil,
    relyingPartyIsVerified: Bool? = false
  ) {
    self.id = id
    self.transactionTypeLabel = transactionTypeLabel
    self.transactionStatusLabel = transactionStatusLabel
    self.transactionIsCompleted = transactionIsCompleted
    self.transactionDate = transactionDate
    self.relyingPartyName = relyingPartyName
    self.relyingPartyIsVerified = relyingPartyIsVerified
  }
}

extension TransactionLogItem {
  func toUiModel() -> TransactionDetailsUiModel {

    var transactionTypeLabel: TransactionType {
      return switch transactionLogData {
      case .presentation:
          .presentation
      case .issuance:
          .issuance
      case .signing:
          .signing
      }
    }

    var transactionStatus: TransactionStatus? {
      return switch transactionLogData {
      case .presentation(let log):
        log.status.mapToTransactionStatus()
      case .issuance, .signing:
        nil
      }
    }

    var transactionDateLabel: String {
      return switch transactionLogData {
      case .presentation(let log):
        log.timestamp.formattedTimestamp().toString
      case .issuance, .signing:
        ""
      }
    }

    var relyingPartyData: TransactionLog.RelyingParty? {
      return switch self.transactionLogData {
      case .presentation(let log):
        log.relyingParty
      case .issuance, .signing:
        nil
      }
    }

    var items: [GenericListItemSection] {
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
        transactionTypeLabel: transactionTypeLabel.typeTitle.toString,
        transactionStatusLabel: transactionStatus?.statusTitle.toString ?? "",
        transactionIsCompleted: transactionStatus == .completed,
        transactionDate: transactionDateLabel,
        relyingPartyName: relyingPartyData?.name,
        relyingPartyIsVerified: relyingPartyData?.isVerified
      ),
      items: items
    )
  }
}

extension DocClaimsDecodable {
  func transformToTransactionListItemSection() -> GenericListItemSection {
    return .init(
      id: self.id,
      title: self.displayName.ifNilOrEmpty { self.docType.orEmpty },
      listItems: self.parseClaim(
        documentId: self.id,
        isSensitive: false,
        input: self.docClaims
      )
    )
  }
}

extension Array where Element == DocClaimsDecodable {
  func transformToTransactionListItemSections() -> [GenericListItemSection] {
    return self.map { $0.transformToTransactionListItemSection() }
  }
}
