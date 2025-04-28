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
import logic_core
import OrderedCollections
@testable import feature_dashboard
@testable import logic_test
@testable import feature_test

/// Test Suite for `TransactionTabInteractorImpl`.
final class TestTransactionTabInteractor: EudiTest {
  
  // MARK: - Properties
  var interactor: TransactionTabInteractor!
  var walletKitController: MockWalletKitController!
  var filterValidator: MockFilterValidator!
  var configLogic: MockConfigLogic!
  
  // MARK: - Setup and Teardown
  override func setUp() {
    self.walletKitController = MockWalletKitController()
    self.configLogic = MockConfigLogic()
    self.filterValidator = MockFilterValidator()
    self.interactor = TransactionTabInteractorImpl(
      walletKitController: walletKitController,
      filterValidator: filterValidator
    )
  }
  
  override func tearDown() {
    self.interactor = nil
    self.walletKitController = nil
    self.configLogic = nil
  }
  
  // MARK: - Test Cases
  
  /// Test case that verifies the behavior when `walletKitController` throws an error.
  func testFetchTransactions_WhenWalletKitControllerThrowsError_ThenReturnError() async {
    // Given
    stubFetchTransactionsWithError()
    
    do {
      // When
      let state = try await interactor.fetchTransactions(failedTransactions: [])
      // Then
      switch state {
      case .failure(let error):
        XCTAssertEqual(error.localizedDescription, WalletCoreError.unableToFetchTransactionLog.localizedDescription)
      default:
        XCTFail("Wrong state: \(state)")
      }
    } catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  /// Test case that verifies the behavior when the `walletKitController` returns an empty list.
  func testFetchTransactions_WhenWalletKitControllerReturnsEmpty_ThenReturnError() async {
    //Given
    stubFetchTransactions(with: [])
    
    do {
      // When
      let state = try await interactor.fetchTransactions(failedTransactions: [])
      // Then
      switch state {
      case .failure(let error):
        XCTAssertEqual(error.localizedDescription, WalletCoreError.unableToFetchTransactionLog.localizedDescription)
      default:
        XCTFail("Wrong state: \(state)")
      }
    } catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  /// Test case that verifies the behavior when the `walletKitController` returns valid transaction data.
  func testFetchTransactions_WhenWalletKitControllerReturnsData_ThenReturnUiModels() async {
    //Given
    stubFetchTransactions(with: [
      Constants.eudiRemoteVerifierMock
    ])
    
    do {
      // When
      let state = try await interactor.fetchTransactions(failedTransactions: [])
      // Then
      switch state {
      case .success:
        XCTAssertTrue(true)
      default:
        XCTFail("Wrong state \(state)")
      }
    } catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  /// Test case that verifies the behavior when `fetchFilteredTransactions` returns an empty list.
  func testFetchFilteredTransactions_WhenWalletKitControllerReturnsEmptyList_ThenReturnNil() async {
    // Given
    stubFetchTransactions(with: [])
    
    do {
      // When
      let result = try await interactor.fetchFilteredTransactions(failedTransactions: [])
      
      // Then
      XCTAssertNil(result, "Expected nil when no transactions are found")
      
    } catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  /// Test case that verifies the behavior when `fetchFilteredTransactions` returns multiple items.
  func testFetchFilteredTransactions_WhenWalletKitControllerReturnsMultipleItems_ThenReturnFilteredList() async {
    // Given
    stubFetchTransactions(with: [
      Constants.eudiRemoteVerifierMock,
      Constants.otherRelPartyMock
    ])
    
    do {
      // When
      let result = try await interactor.fetchFilteredTransactions(failedTransactions: [])
      
      // Then
      XCTAssertNotNil(result, "Expected non-nil FilterableList")
      XCTAssertEqual(result?.items.count, 2, "Expected exactly two FilterableItems")
      
      result?.items.forEach { item in
        if let attributes = item.attributes as? TransactionFilterableAttributes {
          switch attributes.transactionType {
          case .presentation:
            XCTAssertTrue(true)
          case .issuance, .signing:
            XCTFail("Unexpected relying party name: \(String(describing: attributes.relyingPartyName))")
          default:
            XCTFail("Unexpected relying party name: \(String(describing: attributes.relyingPartyName))")
          }
        }
      }
      
    } catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
}

// MARK: - Private Extensions for Mock Data

private extension TestTransactionTabInteractor {
  
  /// Mocks a failing fetch of transactions with an error.
  func stubFetchTransactionsWithError() {
    stub(walletKitController) { mock in
      when(mock.fetchTransactionLogs()).thenThrow(WalletCoreError.unableToFetchTransactionLog)
    }
  }
  
  /// Mocks a successful fetch of transactions with provided data.
  func stubFetchTransactions(with transactions: [TransactionLogItem]) {
    stub(walletKitController) { mock in
      when(mock.fetchTransactionLogs()).thenReturn(transactions)
    }
  }
  
}

