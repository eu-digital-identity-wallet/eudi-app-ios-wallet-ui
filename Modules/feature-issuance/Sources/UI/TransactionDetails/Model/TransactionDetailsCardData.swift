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
import logic_resources

public struct TransactionDetailsCardData {
  public let transactionItemLabel: LocalizableStringKey
  public let transactionType: LocalizableStringKey
  public let relyingPartyName: LocalizableStringKey
  public let transactionDate: LocalizableStringKey
  public let status: LocalizableStringKey
  public let isVerified: Bool

  public init(
    transactionType: LocalizableStringKey,
    transactionItemLabel: LocalizableStringKey,
    relyingPartyName: LocalizableStringKey,
    transactionDate: LocalizableStringKey,
    status: LocalizableStringKey,
    isVerified: Bool = false
  ) {
    self.transactionItemLabel = transactionItemLabel
    self.transactionType = transactionType
    self.relyingPartyName = relyingPartyName
    self.transactionDate = transactionDate
    self.status = status
    self.isVerified = isVerified
  }
}
