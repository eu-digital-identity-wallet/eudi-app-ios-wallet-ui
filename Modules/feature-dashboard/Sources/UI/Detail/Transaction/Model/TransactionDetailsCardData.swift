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
import logic_resources

public struct TransactionDetailsCardData: Equatable, Sendable {

  public let transactionTypeLabel: LocalizableStringKey
  public let transactionStatusLabel: LocalizableStringKey
  public let transactionIsCompleted: Bool
  public let transactionDate: LocalizableStringKey
  public let partyName: LocalizableStringKey?
  public let partyType: LocalizableStringKey?
  public let nonCompletionReason: LocalizableStringKey?
  public let details: [[TransactionDetailsFieldUi]]

  init(
    transactionTypeLabel: LocalizableStringKey,
    transactionStatusLabel: LocalizableStringKey,
    transactionIsCompleted: Bool,
    transactionDate: LocalizableStringKey,
    partyName: LocalizableStringKey? = nil,
    partyType: LocalizableStringKey? = nil,
    nonCompletionReason: LocalizableStringKey? = nil,
    details: [[TransactionDetailsFieldUi]] = []
  ) {
    self.transactionTypeLabel = transactionTypeLabel
    self.transactionStatusLabel = transactionStatusLabel
    self.transactionIsCompleted = transactionIsCompleted
    self.transactionDate = transactionDate
    self.partyName = partyName
    self.partyType = partyType
    self.nonCompletionReason = nonCompletionReason
    self.details = details
  }
}

extension TransactionDetailsCardData {
  static func mock() -> TransactionDetailsCardData {
    TransactionDetailsCardData(
      transactionTypeLabel: .custom("Presentation"),
      transactionStatusLabel: .custom("Completed"),
      transactionIsCompleted: true,
      transactionDate: .custom("24 Apr 2025 10:30"),
      partyName: .custom("EUDI remote verifier")
    )
  }
}
