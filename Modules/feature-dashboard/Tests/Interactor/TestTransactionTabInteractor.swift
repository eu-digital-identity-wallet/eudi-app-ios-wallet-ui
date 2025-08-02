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
  
  func testFetchTransactions_WhenWalletKitControllerThrowsError_ThenReturnsExpectedError() async throws {
    // Given
    stubFetchTransactionsWithError()
    
    // When
    let state = try await interactor.fetchTransactions()
    
    // Then
    switch state {
    case .failure(let error):
      XCTAssertEqual(error.localizedDescription, WalletCoreError.unableToFetchTransactionLog.localizedDescription)
    default:
      XCTFail("Wrong state: \(state)")
    }
  }
  
  func testFetchTransactions_WhenWalletKitControllerReturnsEmptyTransactions_ThenReturnsExpectedError() async throws {
    //Given
    stubFetchTransactions(with: [])
    
    // When
    let state = try await interactor.fetchTransactions()
    
    // Then
    switch state {
    case .failure(let error):
      XCTAssertEqual(error.localizedDescription, WalletCoreError.unableToFetchTransactionLog.localizedDescription)
    default:
      XCTFail("Wrong state: \(state)")
    }
  }
  
  func testFetchTransactions_WhenWalletKitControllerReturnsData_ThenReturnsExpectedUIModels() async throws {
    //Given
    stubFetchTransactions(with: [
      Constants.eudiRemoteVerifierMock
    ])
    
    // When
    let state = try await interactor.fetchTransactions()
    
    // Then
    switch state {
    case .success:
      XCTAssertTrue(true)
    default:
      XCTFail("Wrong state \(state)")
    }
  }
  
  func testInitializeFilters_WhenInitializedWithFilterableList_ThenInitializesFilterValidator() async throws {
    // Given
    let filterableList = Self.mockFilterableList
    let minStartDate = Self.mockMinStartDate
    let maxEndDate = Self.mockMaxEndDate
    
    stubInitializeValidator()
    
    // When
    await interactor.initializeFilters(
      filterableList: filterableList,
      minStartDate: minStartDate,
      maxEndDate: maxEndDate
    )
    
    // Then
    verify(filterValidator).initializeValidator(
      filters: any(),
      filterableList: filterableList
    )
  }
  
  func testInitializeFilters_WhenWalletKitControllerReturnsEmptyTransactions_ThenInitializesFilterValidator() async throws {
    // Given
    let filterableList = Self.mockEmptyFilterableList
    let minStartDate = Self.mockMinStartDate
    let maxEndDate = Self.mockMaxEndDate
    
    stubInitializeValidatorWithEmptyList()
    
    // When
    await interactor.initializeFilters(
      filterableList: filterableList,
      minStartDate: minStartDate,
      maxEndDate: maxEndDate
    )
    
    // Then
    verify(filterValidator).initializeValidator(
      filters: any(),
      filterableList: filterableList
    )
  }
  
  func testApplyFilters_WhenFilterValidatorApplyFilters_ThenApplyFiltersWasCalled() async {
    // Given
    stubInitializeValidator()
    stubApplyFilters()
    
    // When
    await interactor.applyFilters()
    
    // Then
    verify(filterValidator).applyFilters(sortOrder: Self.sortOrderDescending)
  }
  
  func testUpdateLists_WhenTransactionsFetchedAndStateIsSuccess_ThenUsesFilterValidatorToUpdateLists() async throws {
    // Given
    stubInitializeValidator()
    stubUpdateLists()
    
    // When
    await interactor.updateLists(
      filterableList: Self.mockFilterableList,
      minStartDate: Self.mockMinStartDate,
      maxEndDate: Self.mockMaxEndDate
    )
     
    // Then
    verify(filterValidator).updateLists(
      sortOrder: Self.sortOrderDescending,
      filterableList: Self.mockFilterableList
    )
  }
  
  func testResetFilters_WhenFilterValidatorResetFilters_ThenResetFiltersWasCalled() async {
    // Given
    stubInitializeValidator()
    stubResetFilters()
    
    // When
    await interactor.resetFilters()
    
    // Then
    verify(filterValidator).resetFilters()
  }
  
  func testRevertFilters_WhenFilterValidatorRevertFilters_ThenRevertFiltersWasCalled() async {
    // Given
    stubInitializeValidator()
    stubRevertFilters()
    
    // When
    await interactor.revertFilters()
    
    // Then
    verify(filterValidator).revertFilters()
  }
  
  func testUpdateFilters_WhenFilterValidatorUpdateFilters_ThenUpdateFiltersWasCalled() async {
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
  
  func testUpdateDateFilters_WhenFilterValidatorUpdateDateFilters_ThenUpdateDateFiltersWasCalled() async {
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
  
  func testApplySearch_WhenFilterValidatorApplySearch_ThenUsesFilterValidator() async {
    // Given
    stubInitializeValidator()
    stubApplySearch()
    
    // When
    await interactor.applySearch(query: "PID")
    
    // Then
    verify(filterValidator).applySearch(query: equal(to: "PID"))
  }

  
  func testOnFilterChangeState_WhenStreamEmitsResults_ThenProcessesResultsAsExpected() async {
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
    
    // Then
    Task {
      for try await result in resultStream {
        results.append(result)
      }
      
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
  
  static let mockMaxEndDate = Date()
  static let mockMinStartDate = Date()
  static let sortOrderDescending: SortOrderType = .descending
  static let mockEmptyFilterableList: FilterableList = .init(items: [])
  
  static let mockTransactionTabUIModel: TransactionTabUIModel =
    .init(
      id: "transaction-id",
      name: "EUDI Remote Verifier",
      status: .completed,
      transactionDate: "15 May 2025 10:30 am",
      transactionCategory: .category(for: "15 May 2025 10:30 am"),
      transactionType: .presentation
    )
  
  static let mockTransactionFilterableAttributes: TransactionFilterableAttributes =
    .init(
      sortingKey: "eudi remote verifier",
      searchTags: ["EUDI Remote Verifier", "PID"]
    )
  
  static let mockFilterableList: FilterableList = .init(
    items: [
      FilterableItem (
        payload: TestTransactionTabInteractor.mockTransactionTabUIModel,
        attributes: TestTransactionTabInteractor.mockTransactionFilterableAttributes)
    ]
  )
  
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
        filterableList: Self.mockFilterableList)
      )
      .thenDoNothing()
    }
  }
  
  func stubInitializeValidatorWithEmptyList() {
    stub(filterValidator) { mock in
      when(mock.initializeValidator(
        filters: any(),
        filterableList: Self.mockEmptyFilterableList)
      )
      .thenDoNothing()
    }
  }
  
  func stubApplyFilters() {
    stub(filterValidator) { mock in
      when(mock.applyFilters(sortOrder: Self.sortOrderDescending))
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
      when(mock.resetFilters())
        .thenDoNothing()
    }
  }
  
  func stubRevertFilters() {
    stub(filterValidator) { mock in
      when(mock.revertFilters())
        .thenDoNothing()
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
        query: equal(to: "PID"))
      )
      .thenDoNothing()
    }
  }

}
