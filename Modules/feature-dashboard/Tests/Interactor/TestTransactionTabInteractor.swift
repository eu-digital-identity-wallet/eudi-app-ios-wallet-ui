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

  
  func testOnFilterChangeState_WhenStreamYieldsCompletion_ThenForwardsCancelledAndFinishes() async {
    // Given: the underlying FilterValidator stream completes; the interactor's
    // .completion handler (lines 183-185) yields .cancelled and finishes.
    stub(filterValidator) { stub in
      when(stub.getFilterResultStream()).thenReturn(AsyncStream { continuation in
        continuation.yield(.completion)
        continuation.finish()
      })
    }

    // When
    let resultStream = await interactor.onFilterChangeState()
    var iterator = resultStream.makeAsyncIterator()
    let first = await iterator.next()

    // Then: the first (and only) emitted value is .cancelled.
    if case .cancelled = first {
      XCTAssertTrue(true)
    } else {
      XCTFail("Expected .cancelled, got \(String(describing: first))")
    }
  }

  func testInitializeFilters_WhenTransactionsHaveRelyingParty_ThenRelyingPartyGroupIsPopulated() async {
    // Given: transactions with two distinct relying parties and one with no
    // relying-party name. addDynamicFilters → addRelyingPartyName should
    // produce a FILTER_BY_RELYING_PARY_NAME group containing the "none" item
    // plus two named items, sorted alphabetically.
    let txUiA = TransactionTabUIModel(
      id: "1",
      name: "Verifier A",
      status: .completed,
      transactionDate: "1 Jan 2026 10:00",
      transactionCategory: .category(for: "1 Jan 2026 10:00"),
      transactionType: .presentation
    )
    let txUiB = TransactionTabUIModel(
      id: "2",
      name: "Verifier B",
      status: .completed,
      transactionDate: "1 Jan 2026 11:00",
      transactionCategory: .category(for: "1 Jan 2026 11:00"),
      transactionType: .presentation
    )
    let txUiNone = TransactionTabUIModel(
      id: "3",
      name: "",
      status: .completed,
      transactionDate: "1 Jan 2026 12:00",
      transactionCategory: .category(for: "1 Jan 2026 12:00"),
      transactionType: .presentation
    )
    let filterable = FilterableList(items: [
      FilterableItem(
        payload: txUiA,
        attributes: TransactionFilterableAttributes(
          sortingKey: "verifier a", searchTags: ["a"],
          relyingPartyName: "Verifier A"
        )
      ),
      FilterableItem(
        payload: txUiB,
        attributes: TransactionFilterableAttributes(
          sortingKey: "verifier b", searchTags: ["b"],
          relyingPartyName: "Verifier B"
        )
      ),
      FilterableItem(
        payload: txUiNone,
        attributes: TransactionFilterableAttributes(
          sortingKey: "none", searchTags: ["none"],
          relyingPartyName: nil
        )
      )
    ])

    var capturedFilters: Filters?
    stub(filterValidator) { mock in
      when(mock.initializeValidator(filters: any(), filterableList: any()))
        .then { (filters, _) in
          capturedFilters = filters
        }
    }

    // When
    await interactor.initializeFilters(
      filterableList: filterable,
      minStartDate: Date(),
      maxEndDate: Date()
    )

    // Then
    let relyingPartyGroup = capturedFilters?.filterGroups.first {
      $0.id == FilterIds.FILTER_BY_RELYING_PARY_NAME
    }
    XCTAssertNotNil(relyingPartyGroup)
    let filterIds = relyingPartyGroup?.filters.map(\.id) ?? []
    XCTAssertTrue(filterIds.contains(FilterIds.FILTER_BY_RELYING_PARTY_NONE))
    XCTAssertTrue(filterIds.contains("Verifier A"))
    XCTAssertTrue(filterIds.contains("Verifier B"))
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

    // The interactor exposes an AsyncStream(bufferingPolicy: .bufferingNewest(1)),
    // so emitting both events back-to-back would drop the first. Drive input via
    // a controllable stream and read each forwarded event before emitting the next.
    let (inputStream, inputContinuation) = AsyncStream<FilterResultPartialState>.makeStream()
    stub(filterValidator) { stub in
      when(stub.getFilterResultStream()).thenReturn(inputStream)
    }

    let resultStream = await interactor.onFilterChangeState()
    var iterator = resultStream.makeAsyncIterator()

    // When / Then: emit one event, observe one forwarded event, repeat.
    inputContinuation.yield(.success(filterApplyResult))
    let first = await iterator.next()

    if case let .filterApplyResult(transactions, sections, _) = first {
      XCTAssertTrue(transactions.isEmpty)
      XCTAssertEqual(sections.count, 0)
    } else {
      XCTFail("Expected .filterApplyResult, but got \(String(describing: first))")
    }

    inputContinuation.yield(.success(filterUpdateResult))
    let second = await iterator.next()

    if case let .filterUpdateResult(sections) = second {
      XCTAssertEqual(sections.count, 0)
    } else {
      XCTFail("Expected .filterUpdateResult, but got \(String(describing: second))")
    }

    inputContinuation.finish()
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
