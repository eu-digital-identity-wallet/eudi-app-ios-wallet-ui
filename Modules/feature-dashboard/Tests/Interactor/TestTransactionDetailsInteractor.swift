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
import XCTest
@testable import logic_core
@testable import logic_test
@testable import feature_test
@testable import logic_business
@testable import feature_dashboard

final class TestTransactionDetailsInteractor: EudiTest {
  
  var interactor: TransactionDetailsInteractor!
  var walletKitController: MockWalletKitController!
  
  override func setUp() {
    self.walletKitController = MockWalletKitController()
    self.interactor = TransactionDetailsInteractorImpl(
      walletController: walletKitController
    )
  }
  
  override func tearDown() {
    self.interactor = nil
  }
  
  func testGetTransactionDetails_WhenWalletKitControllerReturnsTransactions_ThenReturnsExpectedUIModel() async {
    // Given
    let transactionId = Constants.eudiRemoteVerifierMock.id
    stubFetchTransaction()
    
    // When
    let result = await interactor.getTransactionDetails(
      transactionId: transactionId
    )
    
    // Then
    switch result {
    case .success(let uiModel):
      XCTAssertEqual(uiModel.id, transactionId)
    case .failure:
      XCTFail("Expected success, but got failure.")
    }
  }
  
  func testGetTransactionDetails_WhenWalletKitControllerReturnsTransactionsFailure_ThenReturnsExpectedError() async {
    // Given
    let transactionId = "nonexistentTransactionId"
    stubFetchTransactionFailure(for: transactionId)
    
    // When
    let result = await interactor.getTransactionDetails(
      transactionId: transactionId
    )
    
    // Then
    switch result {
    case .success:
      XCTFail("Expected failure, but got success.")
    case .failure(let error):
      XCTAssertEqual(error, WalletCoreError.unableToFetchTransactionLog.localizedDescription)
    }
  }
}

extension TestTransactionDetailsInteractor {
  func stubFetchTransaction() {
    stub(walletKitController) { stub in
      when(stub.fetchTransactionLog(with: equal(to: "transactionId1")))
        .thenReturn(Constants.eudiRemoteVerifierMock)
    }
  }
  
  func stubFetchTransactionFailure(for id: String) {
    stub(walletKitController) { stub in
      when(stub.fetchTransactionLog(with: equal(to: id)))
        .thenThrow(WalletCoreError.unableToFetchTransactionLog)
    }
  }
}
