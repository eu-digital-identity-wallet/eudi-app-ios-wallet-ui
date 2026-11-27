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
import OrderedCollections
@testable import logic_core
@testable import logic_test
@testable import feature_test
@testable import feature_dashboard
@testable import logic_business

final class TestDocumentTabInteractor: EudiTest {
  
  var interactor: DocumentTabInteractor!
  var walletKitController: MockWalletKitController!
  var prefsController: MockPrefsController!
  var filterValidator: MockFilterValidator!
  var configLogic: MockConfigLogic!
  
  override func setUp() {
    self.walletKitController = MockWalletKitController()
    stub(walletKitController) { mock in
      when(mock.issuerLogoOrigins()).thenReturn(IssuerLogoOrigins(logoOriginsByIssuer: [:]))
    }
    self.prefsController = MockPrefsController()
    self.configLogic = MockConfigLogic()
    self.filterValidator = MockFilterValidator()
    stub(walletKitController) { mock in
      when(mock.fetchAllDocuments()).thenReturn([])
      when(mock.fetchFailedDeferredDocumentIds()).thenReturn([])
    }
    self.interactor = DocumentTabInteractorImpl(
      walletKitController: walletKitController,
      prefsController: prefsController,
      filterValidator: filterValidator,
      configLogic: configLogic
    )
    
    stubConfigLogic()
  }
  
  override func tearDown() {
    self.interactor = nil
    self.walletKitController = nil
    self.prefsController = nil
    self.configLogic = nil
  }
  
  func testFetchDocuments_WhenWalletKitControllerReturnsEmptyDocuments_ThenReturnsError() async {
    // Given
    stubFetchRevokedDocumentStatuses(with: [:])
    stubFetchDocuments(with: [])
    stubFetchIssuedDocuments(with: [])
    stubFetchMainPidDocument(with: nil)
    stubRefreshCounters()
    
    stubIsBatchCounterEnabled()

    // When
    let state = await interactor.fetchDocuments(shouldRefreshCounters: false)
    
    // Then
    switch state {
    case .failure(let error):
      XCTAssertEqual(error.localizedDescription, WalletCoreError.unableFetchDocuments.localizedDescription)
    default:
      XCTFail("Wrong state \(state)")
    }
    
    verify(walletKitController, times(0)).refreshUsageCounters()
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
    
    stubFetchRevokedDocumentStatuses(with: [:])
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
    stubFetchMainPidDocument(with: expectedPid)
    stubIsDocumentLowOnCredentials()
    stubRefreshCounters()
    stubIsBatchCounterEnabled()
    
    // When
    let state = await interactor.fetchDocuments(shouldRefreshCounters: true)
    
    // Then
    switch state {
    case .success:
      XCTAssertTrue(true)
    default:
      XCTFail("Wrong state \(state)")
    }
    
    verify(walletKitController).refreshUsageCounters()
  }
  
  func testFetchDocuments_WhenOneIsRevokedAndOneSuspended_ThenEachShowsItsState() async {
    // Given
    let pid = Constants.createEuPidModel()
    let mdl = Constants.createIsoMdlModel()
    stubFetchRevokedDocumentStatuses(with: [pid.id: .suspended, mdl.id: .revoked])
    stubFetchDocuments(with: [pid, mdl])
    stubFetchIssuedDocuments(with: [pid, mdl])
    stubFetchDocumentCategories(with: [:])
    stubFetchMainPidDocument(with: pid)
    stubIsDocumentLowOnCredentials()
    stubRefreshCounters()
    stubIsBatchCounterEnabled()

    // When
    let state = await interactor.fetchDocuments(shouldRefreshCounters: false)

    // Then
    guard case .success(let list) = state else {
      return XCTFail("Wrong state \(state)")
    }
    let states = Dictionary(uniqueKeysWithValues: list.items.compactMap { item in
      (item.payload as? DocumentTabUIModel).map { ($0.id, $0.value.state) }
    })
    XCTAssertEqual(states, [pid.id: .suspended, mdl.id: .revoked])
    XCTAssertTrue(list.items.allSatisfy { ($0.attributes as? DocumentFilterableAttributes)?.isRevoked == true })
  }

  func testFetchDocuments_WhenTheRevocationRecordsCannotBeRead_ThenEveryDocumentShowsAsBlocked() async {
    // Given
    let pid = Constants.createEuPidModel()
    let mdl = Constants.createIsoMdlModel()
    stub(walletKitController) { mock in
      when(mock.fetchRevokedDocumentStatuses()).thenThrow(RuntimeError.genericError)
    }
    stubFetchDocuments(with: [pid, mdl])
    stubFetchIssuedDocuments(with: [pid, mdl])
    stubFetchDocumentCategories(with: [:])
    stubFetchMainPidDocument(with: pid)
    stubIsDocumentLowOnCredentials()
    stubRefreshCounters()
    stubIsBatchCounterEnabled()

    // When
    let state = await interactor.fetchDocuments(shouldRefreshCounters: false)

    // Then
    guard case .success(let list) = state else {
      return XCTFail("Wrong state \(state)")
    }
    let states = Dictionary(uniqueKeysWithValues: list.items.compactMap { item in
      (item.payload as? DocumentTabUIModel).map { ($0.id, $0.value.state) }
    })
    XCTAssertEqual(states, [pid.id: .revoked, mdl.id: .revoked])
  }

  func testFetchDocuments_WhenTheIssuerRefusedADeferredDocument_ThenItShowsAsFailedAndTheOthersAsBefore() async {
    let pid = Constants.createEuPidModel()
    let refused = deferredDocument(id: "refused")
    let pending = deferredDocument(id: "pending")
    stubFetchDocumentsForTheList([pid, refused, pending])
    stub(walletKitController) { mock in
      when(mock.fetchFailedDeferredDocumentIds()).thenReturn(["refused"])
    }

    let states = await fetchedStates()

    XCTAssertEqual(states, [pid.id: .issued, "refused": .failed, "pending": .pending])
  }

  func testFetchDocuments_WhenAnIssuedDocumentKeepsARefusedEntry_ThenItShowsAsIssued() async {
    let pid = Constants.createEuPidModel()
    stubFetchDocumentsForTheList([pid])
    stub(walletKitController) { mock in
      when(mock.fetchFailedDeferredDocumentIds()).thenReturn([pid.id])
    }

    let states = await fetchedStates()

    XCTAssertEqual(states, [pid.id: .issued])
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
    
    stubFetchRevokedDocumentStatuses(with: [:])
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
    stubFetchMainPidDocument(with: expectedPid)
    stubIsDocumentLowOnCredentials()
    stubRefreshCounters()
    stubIsBatchCounterEnabled()
    
    // When
    let state = await interactor.fetchDocuments(shouldRefreshCounters: true)

    // Then
    switch state {
    case .success:
      XCTAssertTrue(true)
    default:
      XCTFail("Wrong state \(state)")
    }
    
    verify(walletKitController).refreshUsageCounters()
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

  func testMarkIssuedDocumentsSeen_ThenReturnsThoseTheControllerHadNotPointedOut() async {
    // Given
    stub(walletKitController) { mock in
      when(mock.markIssuedDeferredDocumentsSeen(equal(to: ["a", "b"]))).thenReturn(["a"])
    }

    // When
    let result = await interactor.markIssuedDocumentsSeen(["a", "b"])

    // Then
    XCTAssertEqual(result, ["a"])
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
    
    // When
    await interactor.updateLists(
      filterableList: Self.mockFilterablelist
    )
    
    // Then
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
    
    let (validatorStream, validator) = AsyncStream<FilterResultPartialState>.makeStream()
    stub(filterValidator) { stub in
      when(stub.getFilterResultStream()).thenReturn(validatorStream)
    }

    // When
    var results = await interactor.onFilterChangeState().makeAsyncIterator()
    validator.yield(.success(filterApplyResult))
    let first = await results.next()
    validator.yield(.success(filterUpdateResult))
    let second = await results.next()

    // Then
    guard case let .filterApplyResult(transactions, sections, _) = first else {
      return XCTFail("Expected .filterApplyResult, but got \(String(describing: first))")
    }
    XCTAssertTrue(transactions.isEmpty)
    XCTAssertEqual(sections.count, 0)
    guard case let .filterUpdateResult(updatedSections) = second else {
      return XCTFail("Expected .filterUpdateResult, but got \(String(describing: second))")
    }
    XCTAssertEqual(updatedSections.count, 0)
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

  /// The underlying FilterValidator stream completes, exercising the
  /// .completion branch (lines 118-120) which yields .cancelled and finishes.
  func testOnFilterChangeState_WhenStreamYieldsCompletion_ThenForwardsCancelledAndFinishes() async {
    // Given
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

    // Then
    if case .cancelled = first {
      XCTAssertTrue(true)
    } else {
      XCTFail("Expected .cancelled, got \(String(describing: first))")
    }
  }

  /// forcePidActivation=false AND fetchAllDocuments returns [] →
  /// the short-circuit evaluates to false so the function returns .success
  /// rather than .noDocuments.
  func testDeleteDeferredDocument_WhenEmptyDocumentsButForcePidActivationDisabled_ThenReturnsSuccess() async {
    // Given
    stub(configLogic) { mock in
      when(mock.forcePidActivation.get).thenReturn(false)
    }
    stub(walletKitController) { mock in
      when(mock.deleteDocument(with: any(), status: any())).thenDoNothing()
      when(mock.fetchAllDocuments()).thenReturn([])
    }

    // When
    let result = await interactor.deleteDeferredDocument(with: "any-id")

    // Then
    XCTAssertEqual(result, .success)
  }

  /// A FilterableList where the items have DocumentFilterableAttributes
  /// with distinct issuers and categories. addDynamicFilters → addIssuerFilter
  /// / addCategoriesFilter should produce non-empty filter items for each.
  func testAddDynamicFilters_WhenDocumentsHaveIssuerAndCategoryAttributes_ThenPopulatesIssuerAndCategoryGroups() async {
    // Given
    let docA = DocumentTabUIModel(
      id: "a-ui",
      value: .init(
        id: "a", heading: "Issuer A", title: "Doc A", createdAt: Date(),
        expiresAt: "", hasExpired: false, state: .issued,
        image: .none, documentCategory: .Government
      ),
      listItem: .init(mainContent: .text(.custom("Doc A")))
    )
    let docB = DocumentTabUIModel(
      id: "b-ui",
      value: .init(
        id: "b", heading: "Issuer B", title: "Doc B", createdAt: Date(),
        expiresAt: "", hasExpired: false, state: .issued,
        image: .none, documentCategory: .Education
      ),
      listItem: .init(mainContent: .text(.custom("Doc B")))
    )
    let filterable = FilterableList(items: [
      FilterableItem(
        payload: docA,
        attributes: DocumentFilterableAttributes(
          sortingKey: "a", searchTags: ["Issuer A"],
          issuer: "Issuer A", category: "Government"
        )
      ),
      FilterableItem(
        payload: docB,
        attributes: DocumentFilterableAttributes(
          sortingKey: "b", searchTags: ["Issuer B"],
          issuer: "Issuer B", category: "Education"
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
    await interactor.initializeFilters(filterableList: filterable)

    // Then
    let issuerGroup = capturedFilters?.filterGroups.first {
      $0.id == FilterIds.FILTER_BY_ISSUER_GROUP_ID
    }
    let categoryGroup = capturedFilters?.filterGroups.first {
      $0.id == FilterIds.FILTER_BY_DOCUMENT_CATEGORY_GROUP_ID
    }
    XCTAssertFalse(issuerGroup?.filters.isEmpty ?? true,
                   "Expected issuer filters to be populated dynamically")
    XCTAssertFalse(categoryGroup?.filters.isEmpty ?? true,
                   "Expected category filters to be populated dynamically")
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
    listItem: .init(mainContent: .text(.custom("PID")))
  )
  
  static let mockDocumentFilterableAttributes: DocumentFilterableAttributes =
    .init(
      sortingKey: "pid",
      searchTags: ["Digital Credentials Issuer","PID"],
      issuer: "Digital Credentials Issuer"
    )
  
  static let mockFilterablelist: FilterableList = .init(items: [
    FilterableItem (
      payload: TestDocumentTabInteractor.mockDocumentTabUIModel,
      attributes: TestDocumentTabInteractor.mockDocumentFilterableAttributes)
  ])
  
  /// Stubs the list with `documents`, none revoked or low on credentials.
  func stubFetchDocumentsForTheList(_ documents: [any DocClaimsDecodable]) {
    stubFetchRevokedDocumentStatuses(with: [:])
    stubFetchDocuments(with: documents)
    stubFetchDocumentCategories(with: [:])
    stubIsDocumentLowOnCredentials(hasLowOnCredentials: false)
    stubRefreshCounters()
    stubIsBatchCounterEnabled(false)
  }

  /// Listed document states by id.
  func fetchedStates() async -> [String: DocumentTabUIModel.Value.State] {
    guard case .success(let list) = await interactor.fetchDocuments(shouldRefreshCounters: false) else {
      XCTFail("Expected the documents")
      return [:]
    }
    return Dictionary(uniqueKeysWithValues: list.items.compactMap { item in
      (item.payload as? DocumentTabUIModel).map { ($0.id, $0.value.state) }
    })
  }

  func deferredDocument(id: String) -> any DocClaimsDecodable {
    WalletStorage.Document(
      id: id,
      docType: "",
      docDataFormat: .cbor,
      data: Data(),
      docKeyInfo: nil,
      createdAt: nil,
      metadata: nil,
      displayName: "Deferred \(id)",
      status: .deferred
    ).transformToDeferredDecodable()
  }

  func stubFetchDocuments(with documents: [any DocClaimsDecodable]) {
    stub(walletKitController) { mock in
      when(mock.fetchAllDocuments()).thenReturn(documents)
    }
  }
  
  func stubRefreshCounters() {
    stub(walletKitController) { mock in
      when(mock.refreshUsageCounters()).thenDoNothing()
    }
  }
  
  func stubFetchIssuedDocuments(with documents: [any DocClaimsDecodable]) {
    stub(walletKitController) { mock in
      when(mock.fetchIssuedDocuments()).thenReturn(documents)
    }
  }
  
  func stubFetchMainPidDocument(with document: (any DocClaimsDecodable)?) {
    stub(walletKitController) { mock in
      when(mock.fetchMainPidDocument()).thenReturn(document)
    }
  }
  
  func stubFetchDocumentCategories(with categories: OrderedDictionary<DocumentCategory, [DocumentTypeIdentifier]>) {
    stub(walletKitController) { mock in
      when(mock.getDocumentCategories()).thenReturn(categories)
    }
  }
  
  func stubFetchRevokedDocumentStatuses(with statuses: [String: DocumentRevocationStatus]) {
    stub(walletKitController) { mock in
      when(mock.fetchRevokedDocumentStatuses()).thenReturn(statuses)
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
  
  func stubConfigLogic() {
    stub(configLogic) { mock in
      when(mock.forcePidActivation.get).thenReturn(true)
    }
  }
  
  func stubIsBatchCounterEnabled(_ enabled: Bool = true) {
    stub(prefsController) { stub in
      when(stub.getBool(forKey: Prefs.Key.batchCounter)).thenReturn(enabled)
    }
  }
}
