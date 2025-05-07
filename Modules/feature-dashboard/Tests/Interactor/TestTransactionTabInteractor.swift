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

final class TestTransactionTabInteractor: EudiTest {
  
  var interactor: TransactionTabInteractor!
  var walletKitController: MockWalletKitController!
  var filterValidator: MockFilterValidator!
  var configLogic: MockConfigLogic!
  
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
  
  func testFetchTransactions_WhenWalletKitControllerThrowsError_ThenReturnError() async {
    // Given
    stubFetchTransactionsWithError()
    
    do {
      // When
      let state = try await interactor.fetchTransactions()
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
  
  func testFetchTransactions_WhenWalletKitControllerReturnsEmpty_ThenReturnError() async {
    //Given
    stubFetchTransactions(with: [])
    
    do {
      // When
      let state = try await interactor.fetchTransactions()
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
  
  func testFetchTransactions_WhenWalletKitControllerReturnsData_ThenReturnUiModels() async {
    //Given
    stubFetchTransactions(with: [
      Constants.eudiRemoteVerifierMock
    ])
    
    do {
      // When
      let state = try await interactor.fetchTransactions()
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

  func testFetchTransactions_WhenInitializedWithFilterableList_ThenInitializesValidator() async {
    // Given
    stubFetchTransactions(with: [
      Constants.eudiRemoteVerifierMock,
      Constants.otherRelPartyMock
    ])
    
    stubInitializeValidator()
    
    do {
      // When
      let state = try await interactor.fetchTransactions()
      
      switch state {
      case .success(let filterableList, let minStartDate, let maxEndDate):
        await interactor.initializeFilters(
          filterableList: filterableList,
          minStartDate: minStartDate,
          maxEndDate: maxEndDate
        )
      case .failure(let error):
        XCTFail("Error: \(error)")
      }
      // Then
      verify(filterValidator).initializeValidator(filters: any(), filterableList: any())
      
      XCTAssertTrue(true)
    } catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testFetchTransactions_WhenEmptyFilterableList_ThenInitializesValidator() async {
    // Given
    stubFetchTransactions(with: [])
    stubInitializeValidator()
    
    do {
      // When
      let state = try await interactor.fetchTransactions()
      
      switch state {
      case .success(let filterableList, let minStartDate, let maxEndDate):
        await interactor.initializeFilters(
          filterableList: filterableList,
          minStartDate: minStartDate,
          maxEndDate: maxEndDate
        )
      case .failure(let error):
        XCTAssertEqual(error.localizedDescription, WalletCoreError.unableToFetchTransactionLog.localizedDescription)
        return
      }
    } catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testApplyFilters_WhenCalled_ThenUsesFilterValidator() async {
    // Given
    stubInitializeValidator()
    stubApplyFilters()
    
    // When
    await interactor.applyFilters()
    
    // Then
    verify(filterValidator).applyFilters(sortOrder: any())
  }
  
  func testUpdateLists_WhenCalled_ThenUsesFilterValidator() async {
    // Given
    stubFetchTransactions(with: [
      Constants.eudiRemoteVerifierMock,
      Constants.otherRelPartyMock
    ])
    stubInitializeValidator()
    stubUpdateLists()
    
    do {
      // When
      let state = try await interactor.fetchTransactions()
      
      switch state {
      case .success(let filterableList, let minStartDate, let maxEndDate):
        //Then
        await interactor.updateLists(filterableList: filterableList, minStartDate: minStartDate, maxEndDate: maxEndDate)
      case .failure(let error):
        XCTAssertEqual(error.localizedDescription, WalletCoreError.unableToFetchTransactionLog.localizedDescription)
        return
      }
    } catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testResetFilters_WhenCalled_ThenUsesFilterValidator() async {
    // Given
    stubInitializeValidator()
    stubResetFilters()
    
    // When
    await interactor.resetFilters()
    
    // Then
    verify(filterValidator).resetFilters()
  }
  
  func testRevertFilters_CallsFilterValidator() async {
    // Given
    stubInitializeValidator()
    stubRevertFilters()
    
    // When
    await interactor.revertFilters()
    
    // Then
    verify(filterValidator).revertFilters()
  }
  
  func testRevertFilters_WhenCalled_ThenUsesFilterValidator() async {
    // Given
    stubInitializeValidator()
    stubUpdateFilters()
    
    // When
    await interactor.updateFilters(
      sectionID: "",
      filterID: ""
    )
    
    // Then
    verify(filterValidator).updateFilter(
      filterGroupId: any(),
      filterId: any()
    )
  }
  
  func testUpdateDateFilters_WhenCalled_ThenUsesFilterValidator() async {
    // Given
    stubInitializeValidator()
    stubUpdateDateFilter()
    
    // When
    await interactor.updateDateFilters(
      sectionID: "",
      filterID: "",
      startDate: .now,
      endDate: .now
    )
    
    // Then
    verify(filterValidator).updateDateFilters(
      filterGroupId: any(),
      filterId: any(),
      startDate: any(),
      endDate: any()
    )
  }
  
  func testApplySearch_WhenCalled_ThenUsesFilterValidator() async {
    // Given
    stubInitializeValidator()
    stubApplySearch()
    
    // When
    await interactor.applySearch(query: "")
    
    // Then
    verify(filterValidator).applySearch(query: any())
  }

  func testOnFilterChangeState_WhenStreamEmitsResults_ThenProcessesResultsCorrectly() async {
    // Given
    let filterApplyResult: FilterResult = .filterApplyResult(
      filteredList: FilterableList(items: []),
      updatedFilters: Filters(
        filterGroups: [],
        sortOrder: .ascending
      ),
      hasDefaultFilters: true
    )
    let filterUpdateResult: FilterResult = .filterUpdateResult(
      updatedFilters: Filters(
        filterGroups: [],
        sortOrder: .ascending
      )
    )

    stub(filterValidator) { stub in
      when(stub.getFilterResultStream()).thenReturn(AsyncStream { continuation in
        continuation.yield(FilterResultPartialState.success(filterApplyResult))
        continuation.yield(FilterResultPartialState.success(filterUpdateResult))
        continuation.finish()
      })
    }

    // When
    let resultStream = await interactor.onFilterChangeState()
    var results = [TransactionFiltersPartialState]()

    Task {
      for try await result in resultStream {
        results.append(result)
      }

      // Then
      XCTAssertEqual(results.count, 2)
      if case let .filterApplyResult(transactions, sections, _) = results[0] {
        XCTAssertTrue(transactions.isEmpty)
        XCTAssertEqual(sections.count, 0)
      } else {
        XCTFail("Expected .filterApplyResult, but got \(results[0])")
      }

      if case let .filterUpdateResult(sections) = results[1] {
        XCTAssertEqual(sections.count, 0)
      } else {
        XCTFail("Expected .filterUpdateResult, but got \(results[1])")
      }
    }
  }
}

private extension TestTransactionTabInteractor {
  func stubFetchTransactionsWithError() {
    stub(walletKitController) { mock in
      when(mock.fetchTransactionLogs())
        .thenThrow(WalletCoreError.unableToFetchTransactionLog)
    }
  }
  
  func stubFetchTransactions(with transactions: [TransactionLogItem]) {
    stub(walletKitController) { mock in
      when(mock.fetchTransactionLogs())
        .thenReturn(transactions)
    }
  }
  
  func stubInitializeValidator() {
    stub(filterValidator) { mock in
      when(mock.initializeValidator(
        filters: any(),
        filterableList: any())
      )
      .thenDoNothing()
    }
  }
  
  func stubApplyFilters() {
    stub(filterValidator) { mock in
      when(mock.applyFilters(
        sortOrder: any())
      )
      .thenDoNothing()
    }
  }
  
  func stubUpdateLists() {
    stub(filterValidator) { mock in
      when(mock.updateLists(
        sortOrder: any(),
        filterableList: any())
      )
      .thenDoNothing()
    }
  }
  
  func stubResetFilters() {
    stub(filterValidator) { mock in
      when(mock.resetFilters()).thenDoNothing()
    }
  }
  
  func stubRevertFilters() {
    stub(filterValidator) { mock in
      when(mock.revertFilters()).thenDoNothing()
    }
  }
  
  func stubUpdateFilters() {
    stub(filterValidator) { mock in
      when(mock.updateFilter(
        filterGroupId: any(),
        filterId: any())
      )
      .thenDoNothing()
    }
  }
  
  func stubUpdateDateFilter() {
    stub(filterValidator) { mock in
      when(mock.updateDateFilters(
        filterGroupId: any(),
        filterId: any(),
        startDate: any(),
        endDate: any())
      )
      .thenDoNothing()
    }
  }
  
  func stubApplySearch() {
    stub(filterValidator) { mock in
      when(mock.applySearch(
        query: any())
      )
      .thenDoNothing()
    }
  }
}

