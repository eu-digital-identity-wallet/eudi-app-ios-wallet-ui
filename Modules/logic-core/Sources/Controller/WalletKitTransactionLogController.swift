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
import logic_storage
import Foundation

final actor WalletKitTransactionLogControllerImpl: TransactionLogger {

  private let transactionLogStorageController: any TransactionLogStorageController

  init(transactionLogStorageController: any TransactionLogStorageController) {
    self.transactionLogStorageController = transactionLogStorageController
  }

  func log(transaction: EudiWalletKit.TransactionLog) async throws {
    do {

      let jsonResultData = try JSONEncoder().encode(transaction)
      let value = try jsonResultData.toJSONString()

      try await transactionLogStorageController.store(
        .init(identifier: UUID().uuidString, value: value)
      )
    } catch {
      throw error
    }
  }
}
