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
  case success(transactionDetailsDomain: TransactionDetailsDomain)
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
    let transactionDetailsDomain = TransactionDetailsDomain(
      transactionName: "A transaction name",
      transactionId: "randomId",
      sharedDataClaimItems: [
        TransactionClaimItem(
          transactionId: "0",
          value: "John",
          readableName: "given_name"
        ),
        TransactionClaimItem(
          transactionId: "1",
          value: "Doe",
          readableName: "family_name"
        )
      ],
      signedDataClaimItems: [
        TransactionClaimItem(
          transactionId: "0",
          value: "John",
          readableName: "given_name"
        ),
        TransactionClaimItem(
          transactionId: "1",
          value: "Doe",
          readableName: "family_name"
        )
      ]
    )

    return .success(
      transactionDetailsDomain: transactionDetailsDomain
    )
  }
}
