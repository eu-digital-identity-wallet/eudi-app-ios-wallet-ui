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
import logic_resources
import feature_common
import logic_business
import logic_core

public enum TransactionDetailsInteractorPartialState: Sendable {
  case success(transactionDetailsUi: TransactionDetailsUi)
  case failure(error: String)
}

public protocol TransactionDetailsInteractor: Sendable {
  func getTransactionDetails(transactionId: String) async -> TransactionDetailsInteractorPartialState
}

final class TransactionDetailsInteractorImpl: TransactionDetailsInteractor {

  private let walletController: WalletKitController

  init(
    walletController: WalletKitController
  ) {
    self.walletController = walletController
  }

  public func getTransactionDetails(transactionId: String) async -> TransactionDetailsInteractorPartialState {
    do {
      let transaction = try await walletController.fetchTransactionLog(with: transactionId)

      let relyingPartyData: TransactionLog.RelyingParty?

      switch transaction {
        case .issuance:
          relyingPartyData = nil
        case .presentation(let log):
          relyingPartyData = log.relyingParty
        case .signing:
          relyingPartyData = nil
      }

      let transactionDetailsUi = TransactionDetailsUi(
        transactionId: transactionId,
        transactionDetailsCardData: TransactionDetailsCardData(
          transactionTypeLabel: "A",
          transactionStatusLabel: "A",
          transactionDate: "A",
          relyingPartyName: relyingPartyData?.name,
          relyingPartyIsVerified: relyingPartyData?.isVerified
        ),
        transactionDetailsDataShared: TransactionDetailsDataSharedHolder(dataSharedItems: []),
        transactionDetailsDataSigned: nil
      )
      return .success(
        transactionDetailsUi: transactionDetailsUi
      )
    } catch {
      print(error)
      return .failure(error: WalletCoreError.unableToFetchTransactionLog.localizedDescription)
    }
  }
}
