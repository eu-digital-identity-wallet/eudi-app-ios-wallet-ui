/*
 * Copyright (c) 2025 European Commission
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
import logic_resources
import logic_business

public struct TransactionDetailsCardData: Equatable, Identifiable, Sendable {

  @EquatableNoop
  public var id: String

  public let transactionTypeLabel: LocalizableStringKey
  public let transactionStatusLabel: LocalizableStringKey
  public let transactionIsCompleted: Bool
  public let transactionDate: LocalizableStringKey
  public let relyingPartyName: LocalizableStringKey?
  public let relyingPartyIsVerified: Bool?

  init(
    id: String = UUID().uuidString,
    transactionTypeLabel: LocalizableStringKey,
    transactionStatusLabel: LocalizableStringKey,
    transactionIsCompleted: Bool,
    transactionDate: LocalizableStringKey,
    relyingPartyName: LocalizableStringKey? = nil,
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

extension TransactionDetailsCardData {
  static func mock() -> TransactionDetailsCardData {
    TransactionDetailsCardData(
      transactionTypeLabel: .custom("Presentation"),
      transactionStatusLabel: .custom("EUDI remote verifier"),
      transactionIsCompleted: true,
      transactionDate: .custom("24 Apr 2025 10:30")
    )
  }
}
