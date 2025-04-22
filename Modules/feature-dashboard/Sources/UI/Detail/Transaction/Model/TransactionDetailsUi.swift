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

@Copyable
public struct TransactionDetailsUi: Equatable, Identifiable, Routable {
  public var id: String
  public let transactionId: String
  public let transactionDetailsCardData: TransactionDetailsCardData
  public let transactionDetailsDataShared: TransactionDetailsDataSharedHolder
  public let transactionDetailsDataSigned: TransactionDetailsDataSignedHolder?

  public var log: String {
    "transactionId: \(transactionId)"
  }

  public init(
    id: String = UUID().uuidString,
    transactionId: String,
    transactionDetailsCardData: TransactionDetailsCardData,
    transactionDetailsDataShared: TransactionDetailsDataSharedHolder,
    transactionDetailsDataSigned: TransactionDetailsDataSignedHolder? = nil
  ) {
    self.id = id
    self.transactionId = transactionId
    self.transactionDetailsCardData = transactionDetailsCardData
    self.transactionDetailsDataShared = transactionDetailsDataShared
    self.transactionDetailsDataSigned = transactionDetailsDataSigned
  }
}

public struct TransactionDetailsCardData: Equatable, Identifiable, Routable {
  public let id: String
  public let transactionTypeLabel: String
  public let transactionStatusLabel: String
  public let transactionDate: String
  public let relyingPartyName: String?
  public let relyingPartyIsVerified: Bool?

  public var log: String {
    "id: \(id)"
  }

  public init(
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

public struct TransactionDetailsDataSharedHolder: Equatable, Identifiable, Routable {
  public let id: String
  public let dataSharedItems: [String]

  public var log: String {
    "id: \(id)"
  }

  public init(
    id: String = UUID().uuidString,
    dataSharedItems: [String]
  ) {
    self.id = id
    self.dataSharedItems = dataSharedItems
  }
}

public struct TransactionDetailsDataSignedHolder: Equatable, Identifiable, Routable {
  public let id: String
  public let dataSignedItems: [String]

  public var log: String {
    "id: \(id)"
  }

  public init(
    id: String = UUID().uuidString,
    dataSignedItems: [String]
  ) {
    self.id = id
    self.dataSignedItems = dataSignedItems
  }
}
