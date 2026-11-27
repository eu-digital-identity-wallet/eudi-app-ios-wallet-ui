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
import Cuckoo
@testable import logic_core
@testable import logic_ui
@testable import logic_business
@testable import feature_dashboard
@testable import logic_test
@testable import feature_test

final class TestDocumentTabViewModel: EudiTest {

  private var interactor: MockDocumentTabInteractor!
  private var filterResults: AsyncStream<DocumentFiltersPartialState>.Continuation!

  override func setUp() {
    super.setUp()
    interactor = MockDocumentTabInteractor()
    let (stream, continuation) = AsyncStream.makeStream(of: DocumentFiltersPartialState.self)
    filterResults = continuation
    stub(interactor) { mock in
      when(mock.onFilterChangeState()).thenReturn(stream)
      when(mock.fetchDocuments(shouldRefreshCounters: any())).thenReturn(.success(FilterableList(items: [])))
      when(mock.initializeFilters(filterableList: any())).thenDoNothing()
      when(mock.updateLists(filterableList: any())).thenDoNothing()
      when(mock.applyFilters()).thenDoNothing()
      when(mock.revertFilters()).thenDoNothing()
      when(mock.markIssuedDocumentsSeen(any())).thenReturn([])
    }
  }

  override func tearDown() {
    filterResults.finish()
    filterResults = nil
    interactor = nil
    super.tearDown()
  }

  @MainActor
  func testRefresh_WhenTheFiltersAreOpen_ThenTheListIsNotReloaded() async {
    // Given
    let viewModel = makeViewModel()
    viewModel.showFilters()

    // When
    viewModel.onAppear()
    viewModel.handleRefreshotification()
    try? await Task.sleep(seconds: 0.3)

    // Then
    verify(interactor, never()).fetchDocuments(shouldRefreshCounters: any())
  }

  @MainActor
  func testOnFiltersDismissed_WhenClosedWithoutApplying_ThenReloadsTheListOnce() async {
    // Given
    let viewModel = makeViewModel()
    viewModel.showFilters()
    viewModel.handleRefreshotification()

    // When
    viewModel.isFilterModalShowing = false
    viewModel.onFiltersDismissed()
    await waitUntil { viewModel.viewState.lifecycle == .active }

    // Then
    verify(interactor, times(1)).fetchDocuments(shouldRefreshCounters: any())
  }

  @MainActor
  func testApplyFilters_WhenTheFiltersAreOpen_ThenClosesThemAndTheDismissalDoesNotReloadAgain() async {
    // Given
    let viewModel = makeViewModel()
    viewModel.showFilters()

    // When
    viewModel.applyFilters()
    viewModel.onFiltersDismissed()
    await waitUntil { viewModel.viewState.lifecycle == .active }
    try? await Task.sleep(seconds: 0.2)

    // Then
    XCTAssertFalse(viewModel.isFilterModalShowing)
    verify(interactor, times(1)).fetchDocuments(shouldRefreshCounters: any())
  }

  @MainActor
  func testDeferredIssuance_WhenAnIssuedRowWasNotPointedOutYet_ThenHighlightsItBriefly() async {
    // Given
    let viewModel = makeShownViewModel()
    stubUnseen(["a"])

    // When
    show([document("a"), document("b")])
    await waitUntil { !viewModel.viewState.highlightedDocumentIds.isEmpty }

    // Then
    XCTAssertEqual(viewModel.viewState.highlightedDocumentIds, ["a"])

    // When
    await waitUntil(seconds: 5) { viewModel.viewState.highlightedDocumentIds.isEmpty }

    // Then
    XCTAssertTrue(viewModel.viewState.highlightedDocumentIds.isEmpty)
  }

  @MainActor
  func testDeferredIssuance_WhenTheTabIsHidden_ThenNothingIsMarkedSeenOrHighlighted() async {
    // Given
    let viewModel = makeShownViewModel()
    viewModel.onDisappear()
    stubUnseen(["a"])

    // When
    show([document("a")])
    await waitUntil { !viewModel.viewState.documents.isEmpty }
    try? await Task.sleep(seconds: 0.1)

    // Then
    verify(interactor, never()).markIssuedDocumentsSeen(any())
    XCTAssertTrue(viewModel.viewState.highlightedDocumentIds.isEmpty)
  }

  @MainActor
  func testDeferredIssuance_WhenTheListIsShown_ThenOnlyTheIssuedRowsAreMarkedSeen() async {
    // Given
    let viewModel = makeShownViewModel()

    // When
    show([document("a", state: .pending), document("b", state: .failed), document("c")])
    await waitUntil { !viewModel.viewState.documents.isEmpty }
    try? await Task.sleep(seconds: 0.1)

    // Then
    verify(interactor).markIssuedDocumentsSeen(equal(to: ["c"]))
  }

  @MainActor
  func testDeferredIssuance_WhenNothingIssuedIsShown_ThenNothingIsMarkedSeen() async {
    // Given
    let viewModel = makeShownViewModel()

    // When
    show([document("a", state: .pending)])
    await waitUntil { !viewModel.viewState.documents.isEmpty }
    try? await Task.sleep(seconds: 0.1)

    // Then
    verify(interactor, never()).markIssuedDocumentsSeen(any())
  }

  @MainActor
  func testDeferredIssuance_WhenNoIssuedRowIsUnseen_ThenNothingIsHighlighted() async {
    // Given
    let viewModel = makeShownViewModel()

    // When
    show([document("a"), document("b")])
    await waitUntil { !viewModel.viewState.documents.isEmpty }
    try? await Task.sleep(seconds: 0.4)

    // Then
    XCTAssertTrue(viewModel.viewState.highlightedDocumentIds.isEmpty)
  }

  @MainActor
  func testDeferredIssuance_WhenTheFiltersAreOpen_ThenHighlightsOnlyAfterTheyClose() async {
    // Given
    let viewModel = makeShownViewModel()
    stubUnseen(["a"])
    viewModel.showFilters()

    // When
    show([document("a")])
    await waitUntil { !viewModel.viewState.documents.isEmpty }
    try? await Task.sleep(seconds: 0.4)

    // Then
    XCTAssertTrue(viewModel.viewState.highlightedDocumentIds.isEmpty)
    verify(interactor, never()).markIssuedDocumentsSeen(any())

    // When
    viewModel.isFilterModalShowing = false
    show([document("a")])
    await waitUntil { !viewModel.viewState.highlightedDocumentIds.isEmpty }

    // Then
    XCTAssertEqual(viewModel.viewState.highlightedDocumentIds, ["a"])
  }

  @MainActor
  func testDeferredIssuance_WhenTwoIssuedRowsAreUnseen_ThenBothAreHighlighted() async {
    // Given
    let viewModel = makeShownViewModel()
    stubUnseen(["a", "b"])

    // When
    show([document("a"), document("b"), document("c")])
    await waitUntil { !viewModel.viewState.highlightedDocumentIds.isEmpty }

    // Then
    XCTAssertEqual(viewModel.viewState.highlightedDocumentIds, ["a", "b"])
  }

  @MainActor
  func testDeferredIssuance_WhenTheDocumentAwaitingDeletionIsShownIssued_ThenClosesTheDeletionDialog() async {
    // Given
    let viewModel = makeViewModel()
    viewModel.onDeleteDeferredDocument(with: document("a", state: .pending))

    // When
    show([document("a")])
    await waitUntil { !viewModel.isDeleteDeferredModalShowing }

    // Then
    XCTAssertFalse(viewModel.isDeleteDeferredModalShowing)
    XCTAssertNil(viewModel.viewState.pendingDeletionDocument)
  }

  @MainActor
  func testDeferredIssuance_WhenTheDocumentAwaitingDeletionIsNoLongerListed_ThenClosesTheDeletionDialog() async {
    // Given
    let viewModel = makeViewModel()
    viewModel.onDeleteDeferredDocument(with: document("a", state: .pending))

    // When
    show([document("b")])
    await waitUntil { !viewModel.isDeleteDeferredModalShowing }

    // Then
    XCTAssertFalse(viewModel.isDeleteDeferredModalShowing)
    XCTAssertNil(viewModel.viewState.pendingDeletionDocument)
  }

  @MainActor
  func testDeferredIssuance_WhenTheDocumentAwaitingDeletionIsStillPending_ThenKeepsTheDeletionDialog() async {
    // Given
    let viewModel = makeViewModel()
    viewModel.onDeleteDeferredDocument(with: document("a", state: .pending))

    // When
    show([document("a", state: .pending), document("b")])
    await waitUntil { !viewModel.viewState.documents.isEmpty }

    // Then
    XCTAssertTrue(viewModel.isDeleteDeferredModalShowing)
    XCTAssertEqual(viewModel.viewState.pendingDeletionDocument?.id, "a")
  }
}

private extension TestDocumentTabViewModel {

  @MainActor
  func makeViewModel() -> DocumentTabViewModel<MockRouterHost> {
    DocumentTabViewModel(router: MockRouterHost(), interactor: interactor, onUpdateToolbar: { _, _ in })
  }

  /// A view model whose tab is on screen, as issued documents are pointed out only then.
  @MainActor
  func makeShownViewModel() -> DocumentTabViewModel<MockRouterHost> {
    let viewModel = makeViewModel()
    viewModel.onAppear()
    return viewModel
  }

  func show(_ documents: [DocumentTabUIModel]) {
    filterResults.yield(.filterApplyResult([.Government: documents], [], true))
  }

  func stubUnseen(_ ids: Set<String>) {
    stub(interactor) { mock in
      when(mock.markIssuedDocumentsSeen(any())).then { $0.intersection(ids) }
    }
  }

  func document(_ id: String, state: DocumentTabUIModel.Value.State = .issued) -> DocumentTabUIModel {
    DocumentTabUIModel(
      id: id,
      value: .init(
        id: id, heading: "Issuer", title: "Doc \(id)", createdAt: Date(),
        expiresAt: "", hasExpired: false, state: state,
        image: .none, documentCategory: .Government
      ),
      listItem: .init(mainContent: .text(.custom("Doc \(id)")))
    )
  }

  @MainActor
  func waitUntil(seconds: TimeInterval = 1, _ condition: () -> Bool) async {
    for _ in 0..<Int(seconds / 0.02) where !condition() {
      try? await Task.sleep(seconds: 0.02)
    }
  }
}
