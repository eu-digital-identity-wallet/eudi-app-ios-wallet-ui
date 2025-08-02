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
import OrderedCollections
@testable import logic_core
@testable import logic_test
@testable import feature_test
@testable import feature_dashboard
@testable import logic_business

final class TestDocumentTabInteractor: EudiTest {
  
  var interactor: DocumentTabInteractor!
  var walletKitController: MockWalletKitController!
  var filterValidator: MockFilterValidator!
  var configLogic: MockConfigLogic!
  
  override func setUp() {
    self.walletKitController = MockWalletKitController()
    self.configLogic = MockConfigLogic()
    self.filterValidator = MockFilterValidator()
    self.interactor = DocumentTabInteractorImpl(
      walletKitController: walletKitController,
      filterValidator: filterValidator
    )
  }
  
  override func tearDown() {
    self.interactor = nil
    self.walletKitController = nil
    self.configLogic = nil
  }
  
  func testHasDeferredDocuments_WhenWalletKitControllerReturnsDeferredDocuments_ThenReturnsTrue() {
    // Given
    stubFetchDeferredDocuments(
      with: [
        .init(
          docType: nil,
          docDataFormat: .cbor,
          data: Data(),
          docKeyInfo: nil,
          createdAt: nil,
          metadata: nil,
          displayName: "",
          status: .deferred
        )
      ]
    )
    
    // When
    let result = interactor.hasDeferredDocuments()
    
    // Then
    XCTAssertTrue(result)
  }
  
  func testHasDeferredDocuments_WhenWalletKitControllerReturnsNoDeferredDocuments_ThenReturnsFalse() {
    // Given
    stubFetchDeferredDocuments(with: [])
    
    // When
    let result = interactor.hasDeferredDocuments()
    
    // Then
    XCTAssertFalse(result)
  }
  
  func testFetchDocuments_WhenWalletKitControllerReturnsEmptyDocuments_ThenReturnsError() async {
    // Given
    stubFetchRevokedDocuments(with: [])
    stubFetchDocuments(with: [])
    stubFetchIssuedDocuments(with: [])
    stubFetchDocumentsWithExclusion(with: [])
    stubFetchMainPidDocument(with: nil)

    // When
    let state = await interactor.fetchDocuments(failedDocuments: [])
    
    // Then
    switch state {
    case .failure(let error):
      XCTAssertEqual(error.localizedDescription, WalletCoreError.unableFetchDocuments.localizedDescription)
    default:
      XCTFail("Wrong state \(state)")
    }
  }
  
  func testFetchDocuments_WhenWalletKitControllerReturnsData_ThenReturnsUiModels() async throws {
    // Given
    var documentsCategories: DocumentCategories {
      [
        .Government: [],
        .Travel: [],
        .Finance: [],
        .Education: [],
        .Health: [],
        .SocialSecurity: [],
        .Retail: [],
        .Other: []
      ]
    }
    let expectedPid = Constants.createEuPidModel(credentialsUsageCounts: try .init(total: 10, remaining: 10))
    let expectedMdl = Constants.createIsoMdlModel()
    
    stubFetchRevokedDocuments(
      with: []
    )
    stubFetchDocuments(
      with: [
        expectedPid,
        expectedMdl
      ]
    )
    stubFetchIssuedDocuments(
      with: [
        expectedPid,
        expectedMdl
      ]
    )
    stubFetchDocumentCategories(with: documentsCategories)
    stubFetchDocumentsWithExclusion(with: [expectedMdl])
    stubFetchMainPidDocument(with: expectedPid)
    stubIsDocumentLowOnCredentials()
    
    // When
    let state = await interactor.fetchDocuments(failedDocuments: [])
    
    // Then
    switch state {
    case .success:
      XCTAssertTrue(true)
    default:
      XCTFail("Wrong state \(state)")
    }
  }
  
  func testDeleteDeferredDocument_WhenWalletKitControllerDeleteSucceedsAndNoDocumentsRemain_ThenReturnsNoDocuments() async {
    // Given
    stubDeleteSucceedsNoDocuments()
    
    // When
    let result = await interactor.deleteDeferredDocument(with: "some-id")
    
    // Then
    XCTAssertEqual(result, .noDocuments)
  }
  
  func testDeleteDeferredDocument_WhenWalletKitControllerDeleteFails_ThenReturnsFailure() async {
    // Given
    stubDeleteFails()
    
    // When
    let result = await interactor.deleteDeferredDocument(with: "some-id")
    
    // Then
    switch result {
    case .failure(let error):
      XCTAssertNotNil(error)
    default:
      XCTFail("Expected failure")
    }
  }

  func testDeleteDeferredDocument_WhenWalletKitControllerDeleteSucceeds_ThenReturnsDocuments() async {
    // Given
    let expectedDocument = Constants.createEuPidModel()
    stub(walletKitController) { mock in
      when(mock.deleteDocument(with: any(), status: any())).thenDoNothing()
      when(mock.fetchAllDocuments()).thenReturn([expectedDocument])
    }

    // When
    let result = await interactor.deleteDeferredDocument(with: "some-id")

    // Then
    XCTAssertEqual(result, .success)
  }

  func testApplyFilters_WhenFilterValidatorApplyFilters_ThenApplyFiltersWasCalled() async {
    // Given
    stubInitializeValidator()
    stubApplyFilters()
    
    // When
    await interactor.applyFilters()
    
    // Then
    verify(filterValidator).applyFilters(sortOrder: Self.sortOrderAscending)
  }
  
  func testUpdateLists_WhenDocumentsFetchedAndStateIsSuccess_ThenUsesFilterValidatorUpdateLists() async {
    // Given
    stubInitializeValidator()
    stubUpdateLists()
    
    //Then
    await interactor.updateLists(
      filterableList: Self.mockFilterablelist
    )
    
    verify(filterValidator).updateLists(
      sortOrder: Self.sortOrderAscending,
      filterableList: Self.mockFilterablelist
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
  
  func testApplySearch_WhenFilterValidatorApplySearch_ThenUsesFilterValidator() async {
    // Given
    stubInitializeValidator()
    stubApplySearch()
    
    // When
    await interactor.applySearch(query: "search")
    
    // Then
    verify(filterValidator).applySearch(query: equal(to: "search"))
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
    var results = [DocumentFiltersPartialState]()
    
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

  func testRetrieveLogFileUrl_WhenWallketKitRetriveLogFileUrl_ThenVerify() async {
    // Given
    let expectedUrl = URL(string: "https://example.com")!
    stub(walletKitController) { stub in
      stub.retrieveLogFileUrl().thenReturn(expectedUrl)
    }

    // When
    let _ = interactor.retrieveLogFileUrl()

    // Then
    verify(walletKitController).retrieveLogFileUrl()
  }

  func testRequestDeferredIssuance_WhenAllIssuanceSucceeds_ThenReturnsIssuedModels() async {
    // Given
    let issuedDoc = Constants.createEuPidModel()

    stubFetchDeferredDocuments(
      with: [
        .init(
          docType: nil,
          docDataFormat: .cbor,
          data: Data(),
          docKeyInfo: nil,
          createdAt: nil,
          metadata: nil,
          displayName: "",
          status: .deferred
        )
      ]
    )
    stubFetchRevokedDocuments(with: [])
    stubFetchDocumentCategories(with: [:])
    stub(walletKitController) { stub in
      when(stub.requestDeferredIssuance(with: any())).thenReturn(issuedDoc)
    }

    // When
    let result = await interactor.requestDeferredIssuance()

    // Then
    switch result {
    case .completion(let issued, let failed):
      XCTAssertEqual(issued.count, 1)
      XCTAssertEqual(failed.count, 0)
    default:
      XCTFail("Expected completion with success")
    }
  }

  func testRequestDeferredIssuance_WhenIssuanceFails_ThenReturnsFailedIds() async {
    // Given
    let expectedId = "fail-id"
    stubFetchDeferredDocuments(
      with: [
        .init(
          id: expectedId,
          docType: nil,
          docDataFormat: .cbor,
          data: Data(),
          docKeyInfo: nil,
          createdAt: nil,
          metadata: nil,
          displayName: "",
          status: .deferred
        )
      ]
    )
    stubFetchRevokedDocuments(with: [])
    stubFetchDocumentCategories(with: [:])
    stub(walletKitController) { stub in
      when(stub.requestDeferredIssuance(with: any())).thenThrow(WalletCoreError.unableFetchDocument)
    }

    // When
    let result = await interactor.requestDeferredIssuance()

    // Then
    switch result {
    case .completion(let issued, let failed):
      XCTAssertEqual(issued.count, 0)
      XCTAssertEqual(failed, [expectedId])
    default:
      XCTFail("Expected completion with failed")
    }
  }

  func testRequestDeferredIssuance_WhenNoDeferredDocuments_ThenReturnsEmptyIssuedAndFailed() async {
    // Given
    let issuedDoc = Constants.createEuPidModel()
    stubFetchDeferredDocuments(with: [])
    stubFetchRevokedDocuments(with: [])
    stubFetchDocumentCategories(with: [:])
    stub(walletKitController) { stub in
      when(stub.requestDeferredIssuance(with: any())).thenReturn(issuedDoc)
    }

    // When
    let result = await interactor.requestDeferredIssuance()

    // Then
    switch result {
    case .completion(let issued, let failed):
      XCTAssertTrue(issued.isEmpty)
      XCTAssertTrue(failed.isEmpty)
    default:
      XCTFail("Expected completion with empty arrays")
    }
  }

  func testInitializeFilters_WhenCalled_ThenInitializesFilterValidatorWithCorrectArguments() async {
    // Given
    stubInitializeValidator()

    // When
    await interactor.initializeFilters(filterableList: Self.mockFilterablelist)

    // Then
    verify(filterValidator).initializeValidator(
      filters: any(),
      filterableList: equal(to: Self.mockFilterablelist)
    )
  }

  func testFetchDocuments_WhenWalletKitControllerReturnsDataWithNilUsageCount_ThenReturnsUiModels() async {
    // Given
    var documentsCategories: DocumentCategories {
      [
        .Government: [],
        .Travel: [],
        .Finance: [],
        .Education: [],
        .Health: [],
        .SocialSecurity: [],
        .Retail: [],
        .Other: []
      ]
    }
    let expectedPid = Constants.createEuPidModel()
    let expectedMdl = Constants.createIsoMdlModel()
    
    stubFetchRevokedDocuments(
      with: []
    )
    stubFetchDocuments(
      with: [
        expectedPid,
        expectedMdl
      ]
    )
    stubFetchIssuedDocuments(
      with: [
        expectedPid,
        expectedMdl
      ]
    )
    stubFetchDocumentCategories(with: documentsCategories)
    stubFetchDocumentsWithExclusion(with: [expectedMdl])
    stubFetchMainPidDocument(with: expectedPid)
    stubIsDocumentLowOnCredentials()

    // When
    let state = await interactor.fetchDocuments(failedDocuments: [])

    // Then
    switch state {
    case .success:
      XCTAssertTrue(true)
    default:
      XCTFail("Wrong state \(state)")
    }
  }
}

private extension TestDocumentTabInteractor {
  
  static let sortOrderAscending: SortOrderType = .ascending
  
  static let mockDocumentTabUIModel: DocumentTabUIModel = .init(
    id: "document-ui-model-id",
    value:
        .init(
          id: "pid-document-id",
          heading: "Digital Credentials Issuer",
          title: "PID",
          createdAt: Date(),
          expiresAt: "",
          hasExpired: false,
          state: .issued,
          image: .none,
          documentCategory: .Government),
    listItem: .init(mainText: .custom("PID"))
  )
  
  static let mockDocumentFilterableAttributes: DocumentFilterableAttributes =
    .init(
      sortingKey: "pid",
      searchTags: ["Digital Credentials Issuer","PID"]
    )
  
  static let mockFilterablelist: FilterableList = .init(items: [
    FilterableItem (
      payload: TestDocumentTabInteractor.mockDocumentTabUIModel,
      attributes: TestDocumentTabInteractor.mockDocumentFilterableAttributes)
  ])
  
  func stubFetchDocuments(with documents: [DocClaimsDecodable]) {
    stub(walletKitController) { mock in
      when(mock.fetchAllDocuments()).thenReturn(documents)
    }
  }
  
  func stubFetchIssuedDocuments(with documents: [DocClaimsDecodable]) {
    stub(walletKitController) { mock in
      when(mock.fetchIssuedDocuments()).thenReturn(documents)
    }
  }
  
  func stubFetchDeferredDocuments(with documents: [WalletStorage.Document]) {
    stub(walletKitController) { mock in
      when(mock.fetchDeferredDocuments()).thenReturn(documents)
    }
  }
  
  func stubFetchDocumentsWithExclusion(with documents: [DocClaimsDecodable]) {
    stub(walletKitController) { mock in
      when(mock.fetchIssuedDocuments(excluded: any())).thenReturn(documents)
    }
  }
  
  func stubFetchMainPidDocument(with document: DocClaimsDecodable?) {
    stub(walletKitController) { mock in
      when(mock.fetchMainPidDocument()).thenReturn(document)
    }
  }
  
  func stubFetchDocumentCategories(with categories: OrderedDictionary<DocumentCategory, [DocumentTypeIdentifier]>) {
    stub(walletKitController) { mock in
      when(mock.getDocumentCategories()).thenReturn(categories)
    }
  }
  
  func stubFetchRevokedDocuments(with revokedDocuments: [String]) {
    stub(walletKitController) { mock in
      when(mock.fetchRevokedDocuments()).thenReturn(revokedDocuments)
    }
  }
  
  func stubDeleteSucceedsNoDocuments() {
    stub(walletKitController) { mock in
      when(mock.fetchAllDocuments()).thenReturn([])
      when(mock.deleteDocument(with: any(), status: any())).thenDoNothing()
    }
  }
  
  func stubDeleteFails() {
    stub(walletKitController) { mock in
      when(mock.deleteDocument(with: any(), status: any()))
        .thenThrow(WalletCoreError.unableFetchDocument)
      when(mock.fetchAllDocuments()).thenReturn([])
    }
  }

  func stubIsDocumentLowOnCredentials(hasLowOnCredentials: Bool = true) {
    stub(walletKitController) { stub in
      when(stub.isDocumentLowOnCredentials(document: any()))
        .thenReturn(hasLowOnCredentials)
    }
  }

  func stubInitializeValidator() {
    stub(filterValidator) { mock in
      when(mock.initializeValidator(
        filters: any(),
        filterableList: Self.mockFilterablelist)
      )
      .thenDoNothing()
    }
  }
  
  func stubApplyFilters() {
    stub(filterValidator) { mock in
      when(mock.applyFilters(sortOrder: Self.sortOrderAscending))
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
  
  func stubApplySearch() {
    stub(filterValidator) { mock in
      when(mock.applySearch(
        query: equal(to: "search"))
      )
      .thenDoNothing()
    }
  }
}
