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
import Combine
@testable import logic_business
@testable import logic_test
import Testing

final class TestFilterValidator: EudiTest {
  var filterValidator: FilterValidator!

  override func setUp() {
    super.setUp()
    self.filterValidator = FilterValidatorImpl()
  }

  override func tearDown() {
    filterValidator = nil
    super.tearDown()
  }

  func testInitializeValidator() async {
    // Given
    let expectedFilters = filtersWithSingleSelection
    let expectedFilterableList = filterableList

    await filterValidator.initializeValidator(
      filters: expectedFilters,
      filterableList: expectedFilterableList
    )

    // When
    guard let filterValidatorImpl = filterValidator as? FilterValidatorImpl else {
      XCTFail("FilterValidator should be of type FilterValidatorImpl")
      return
    }
    let appliedFilters = await filterValidatorImpl.appliedFiltersForTesting

    // Then
    XCTAssertEqual(
      appliedFilters.filterGroups.count,
      expectedFilters.filterGroups.count
    )
  }

  func testInitializeValidator_whenApplyFilters_ThenEmitsFilterApplyResult() async {
    // Given
    let expectedFilters = filtersWithSingleSelection
    let expectedFilterableList = filterableList
    var stream = filterValidator.getFilterResultStream().makeAsyncIterator()

    // When
    await filterValidator.initializeValidator(
      filters: expectedFilters,
      filterableList: expectedFilterableList
    )

    await filterValidator.applyFilters(sortOrder: .ascending)

    guard let partial = await stream.next() else {
      return XCTFail("Expected a .success but got no events")
    }

    switch partial {
    case .success(let result):
      switch result {
      case .filterApplyResult(_, let updatedFilters, _):
        XCTAssertEqual(updatedFilters.filterGroups.count, expectedFilters.filterGroups.count)
      default:
        XCTFail("Unexpected result type received: \(result)")
      }
    default:
      XCTFail("Expected success, got \(partial)")
    }
  }

  func testInitializeValidator_WhenCalledTwiceWithSameAppliedFilters_ThenEmitsMergedFilterUpdate() async {
    // Given
    let expectedFilters = filtersWithSingleSelection
    let expectedFilterableList = filterableList

    var stream = filterValidator.getFilterResultStream().makeAsyncIterator()

    // When
    await filterValidator.initializeValidator(
      filters: expectedFilters,
      filterableList: expectedFilterableList
    )
    await filterValidator.initializeValidator(
      filters: expectedFilters,
      filterableList: expectedFilterableList
    )

    await filterValidator.applyFilters(sortOrder: .ascending)

    guard let partial = await stream.next() else {
      return XCTFail("Expected a .success but got no events")
    }

    switch partial {
    case .success(let result):
      switch result {
      case .filterApplyResult(_, let updatedFilters, _):
        XCTAssertEqual(updatedFilters.filterGroups.count, expectedFilters.filterGroups.count)
      default:
        XCTFail("Unexpected result type received: \(result)")
      }
    case .completion:
      XCTFail("Expected a filter update result but received completion.")
    }
  }

  func testInitializeValidator_WhenCalledTwiceWithDifferentFilters_ThenEmitsMergedFilterUpdate() async {
    // Given
    let initialFilters = filtersWithMultipleSelectionSize3
    let updatedFilters = filtersWithMultipleSelectionSize4
    let expectedFilterableList = filterableList
    var stream = filterValidator.getFilterResultStream().makeAsyncIterator()

    // When
    await filterValidator.initializeValidator(
      filters: initialFilters,
      filterableList: expectedFilterableList
    )
    await filterValidator.initializeValidator(
      filters: updatedFilters,
      filterableList: expectedFilterableList
    )

    await filterValidator.applyFilters(sortOrder: .ascending)

    guard let partial = await stream.next() else {
      return XCTFail("Expected a .success but got no events")
    }

    switch partial {
    case .success(let result):
      switch result {
      case .filterApplyResult(_, let updatedFilters, _):
        XCTAssertEqual(
          updatedFilters.filterGroups.first?.filters.first?.selected,
          initialFilters.filterGroups.first?.filters.first?.selected
        )
      default:
        XCTFail("Unexpected result type received: \(result)")
      }
    case .completion:
      XCTFail("Expected a filter update result but received completion.")
    }
  }

  func testUpdateList_WhenApplyFiltersCalled_ThenEmitsCorrectFilterUpdate() async {
    // Given
    let expectedFilters = filtersWithSingleSelection
    let expectedFilterableList = filterableList
    var stream = filterValidator.getFilterResultStream().makeAsyncIterator()

    // When
    await filterValidator.initializeValidator(
      filters: expectedFilters,
      filterableList: expectedFilterableList
    )

    await filterValidator.updateLists(
      sortOrder: .ascending,
      filterableList: expectedFilterableList
    )
    await filterValidator.applyFilters(sortOrder: .ascending)

    guard let partial = await stream.next() else {
      return XCTFail("Expected a .success but got no events")
    }

    switch partial {
    case .success(let result):
      switch result {
      case .filterApplyResult(_, let updatedFilters, _):
        XCTAssertEqual(
          updatedFilters.filterGroups.first?.filters.count,
          expectedFilters.filterGroups.first?.filters.count
        )
      default:
        XCTFail("Unexpected result type received: \(result)")
      }
    case .completion:
      XCTFail("Expected a filter update result but received completion.")
    }
  }

  func testUpdateFilters_WhenCalledAppliedFilters_ThenEmitsCorrectFilterUpdate() async {
    // Given
    let expectedFilters = filtersWithSingleSelection
    let expectedFilterableList = filterableList
    var stream = filterValidator.getFilterResultStream().makeAsyncIterator()

    // When
    await filterValidator.initializeValidator(
      filters: expectedFilters,
      filterableList: expectedFilterableList
    )

    await filterValidator.updateFilter(
      filterGroupId: singleSelectionGroup.id,
      filterId: filterItemsSingle[2].id
    )

    guard let partial = await stream.next() else {
      return XCTFail("Expected a .success but got no events")
    }

    switch partial {
    case .success(let result):
      switch result {
      case .filterUpdateResult(let updatedFilters):
          let updated = updatedFilters.filterGroups.first
          XCTAssertTrue(updated?.filters.first {
            $0.id == filterItemsSingle[2].id
          }?.selected ?? false)
      default:
        XCTFail("Unexpected result type received: \(result)")
      }
    case .completion:
      XCTFail("Expected a filter update result but received completion.")
    }
  }

  func testUpdateDateFilters_WhenCalledAppliedFilters_ThenEmitsCorrectFilterUpdate() async {
    // Given
    let expectedFilters = filtersWithSingleSelection
    let expectedFilterableList = filterableList
    var stream = filterValidator.getFilterResultStream().makeAsyncIterator()

    // When
    await filterValidator.initializeValidator(
      filters: expectedFilters,
      filterableList: expectedFilterableList
    )

    await filterValidator.updateDateFilters(
      filterGroupId: singleSelectionGroup.id,
      filterId: filterItemsSingle[2].id,
      startDate: Date(),
      endDate: Date()
    )

    guard let partial = await stream.next() else {
      return XCTFail("Expected a .success but got no events")
    }

    switch partial {
    case .success(let result):
      switch result {
      case .filterUpdateResult(let updatedFilters):
          let updated = updatedFilters.filterGroups.first
          XCTAssertTrue(updated?.filters.first {
            $0.id == filterItemsSingle[2].id
          }?.selected ?? false)
      default:
        XCTFail("Unexpected result type received: \(result)")
      }
    case .completion:
      XCTFail("Expected a filter update result but received completion.")
    }
  }

  func testApplyFilters_WhenFiltersHaveZeroSelections_ThenEmitsFilterApplyResult() async {
    // Given
    let expectedFilters = filtersWithMultipleSelectionNoSelection
    let expectedFilterableList = filterableList
    var stream = filterValidator.getFilterResultStream().makeAsyncIterator()

    // When
    await filterValidator.initializeValidator(
      filters: expectedFilters,
      filterableList: expectedFilterableList
    )

    await filterValidator.applyFilters(sortOrder: .ascending)

    guard let partial = await stream.next() else {
      return XCTFail("Expected a .success but got no events")
    }

    switch partial {
    case .success(let result):
      switch result {
      case .filterApplyResult:
        XCTAssertTrue(true)
      default:
        XCTFail("Unexpected result type received: \(result)")
      }
    case .completion:
      XCTFail("Expected a filter update result but received completion.")
    }
  }

  func testApplySearch_WhenInvalidSearchQuery_ThenEmitsFilterListEmptyResult() async {
    // Given
    let expectedFilters = filtersWithMultipleSelectionAllSelected
    let expectedFilterableList = filterableList
    var stream = filterValidator.getFilterResultStream().makeAsyncIterator()

    // When
    await filterValidator.initializeValidator(
      filters: expectedFilters,
      filterableList: expectedFilterableList
    )

    await filterValidator.applySearch(query: "invalid_search")

    guard let partial = await stream.next() else {
      return XCTFail("Expected a .success but got no events")
    }

    switch partial {
    case .success(let result):
      switch result {
      case .filterApplyResult(let filteredList, _, _):
        XCTAssertTrue(filteredList.items.isEmpty)
      default:
        XCTFail("Unexpected result type received: \(result)")
      }
    case .completion:
      XCTFail("Expected a filter update result but received completion.")
    }
  }

  func testApplySearchWhenQueryProvidedThenEmitsFilterApplyResult() async {
    // Given
    let expectedFilters = filtersWithMultipleSelectionAllSelected
    let expectedFilterableList = filterableList
    var stream = filterValidator.getFilterResultStream().makeAsyncIterator()

    // When
    await filterValidator.initializeValidator(
      filters: expectedFilters,
      filterableList: expectedFilterableList
    )

    await filterValidator.applySearch(query: "secondary text")

    guard let partial = await stream.next() else {
      return XCTFail("Expected a .success but got no events")
    }

    switch partial {
    case .success(let result):
      switch result {
      case .filterApplyResult(let filterableList, _, _):
        XCTAssertEqual(filterableList.items.count, 1)
      default:
        XCTFail("Unexpected result type received: \(result)")
      }
    case .completion:
      XCTFail("Expected a filter update result but received completion.")
    }
  }

  func testUpdateSortOrder_WhenUpdateSortOrderIsCalled_ThenFilterUpdateResultIsEmitted() async {
    // Given
    let expectedFilters = filtersWithSingleSelection
    let expectedFilterableList = filterableList
    var stream = filterValidator.getFilterResultStream().makeAsyncIterator()

    // When
    await filterValidator.initializeValidator(
      filters: expectedFilters,
      filterableList: expectedFilterableList
    )

    await filterValidator.updateSortOrder(sortOrder: .descending)

    guard let partial = await stream.next() else {
      return XCTFail("Expected a .success but got no events")
    }

    switch partial {
    case .success(let result):
      switch result {
      case .filterUpdateResult(let updatedFilters):
        XCTAssertEqual(updatedFilters.sortOrder, .descending)
      default:
        XCTFail("Unexpected result type received: \(result)")
      }
    case .completion:
      XCTFail("Expected a filter update result but received completion.")
    }
  }

  func testResetFilters_WhenResetFiltersIsCalled_ThenFiltersReset() async {
    // Given
    let expectedFilters = filtersWithMultipleSelection
    let expectedFilterableList = filterableList

    // When
    await filterValidator.initializeValidator(
      filters: expectedFilters,
      filterableList: expectedFilterableList
    )
    await filterValidator.updateFilter(
      filterGroupId: multipleSelectionGroup.id,
      filterId: filterItemsMultiple[2].id
    )

    await filterValidator.applyFilters(sortOrder: .ascending)

    var stream = filterValidator.getFilterResultStream().makeAsyncIterator()

    await filterValidator.resetFilters()

    guard let partial = await stream.next() else {
      return XCTFail("Expected a .success but got no events")
    }

    switch partial {
    case .success(let result):
      switch result {
      case .filterApplyResult(_, let updatedFilters, _):
        XCTAssertEqual(updatedFilters.filterGroups.count, expectedFilters.filterGroups.count)
      default:
        XCTFail("Unexpected result type received: \(result)")
      }
    case .completion:
      XCTFail("Expected a filter update result but received completion.")
    }
  }

  func testRevertFilters_WhenRevertFilterIsCalled_ThenFiltersResetToPreviousState() async {
    // Given
    let expectedFilters = filtersWithMultipleSelection
    let expectedFilterableList = filterableList

    // When
    await filterValidator.initializeValidator(
      filters: expectedFilters,
      filterableList: expectedFilterableList
    )
    await filterValidator.updateFilter(
      filterGroupId: multipleSelectionGroup.id,
      filterId: filterItemsMultiple[2].id
    )

    await filterValidator.applyFilters(sortOrder: .ascending)

    var stream = filterValidator.getFilterResultStream().makeAsyncIterator()
    
    await filterValidator.revertFilters()

    guard let partial = await stream.next() else {
      return XCTFail("Expected a .success but got no events")
    }

    switch partial {
    case .success(let result):
      switch result {
      case .filterUpdateResult(let updatedFilters):
        XCTAssertEqual(updatedFilters.filterGroups.count, expectedFilters.filterGroups.count)
      default:
        XCTFail("Unexpected result type received: \(result)")
      }
    case .completion:
      XCTFail("Expected a filter update result but received completion.")
    }
  }

  func testApplyFilters_WhenReversibleWithMultipleSelection_ThenFilterApplyResultIsEmitted() async {
    // Given
    let expectedFilters = filtersWithReversibleMultipleSelection
    let expectedFilterableList = filterableList
    var stream = filterValidator.getFilterResultStream().makeAsyncIterator()

    // When
    await filterValidator.initializeValidator(
      filters: expectedFilters,
      filterableList: expectedFilterableList
    )

    await filterValidator.applyFilters(sortOrder: .ascending)

    guard let partial = await stream.next() else {
      return XCTFail("Expected a .success but got no events")
    }

    switch partial {
    case .success(let result):
      switch result {
      case .filterApplyResult(_, let updatedFilters, _):
        XCTAssertEqual(updatedFilters.filterGroups.count, expectedFilters.filterGroups.count)
      default:
        XCTFail("Unexpected result type received: \(result)")
      }
    case .completion:
      XCTFail("Expected a filter update result but received completion.")
    }
  }

  func testApplyFilters_WhenReversibleWithSingleSelection_ThenFilterApplyResultIsEmitted() async {
    // Given
    let expectedFilters = filtersWithReversibleSingleSelection
    let expectedFilterableList = filterableList
    var stream = filterValidator.getFilterResultStream().makeAsyncIterator()

    // When
    await filterValidator.initializeValidator(
      filters: expectedFilters,
      filterableList: expectedFilterableList
    )

    await filterValidator.applyFilters(sortOrder: .ascending)

    guard let partial = await stream.next() else {
      return XCTFail("Expected a .success but got no events")
    }

    switch partial {
    case .success(let result):
      switch result {
      case .filterApplyResult(_, let updatedFilters, _):
        XCTAssertEqual(updatedFilters.filterGroups.count, expectedFilters.filterGroups.count)
      default:
        XCTFail("Unexpected result type received: \(result)")
      }
    case .completion:
      XCTFail("Expected a filter update result but received completion.")
    }
  }

  func testUpdateFilters_WhenCalledAppliedFiltersWithReversibleSelection_ThenEmitsCorrectFilterUpdate() async {
    // Given
    let expectedFilters = filtersWithReversibleSingleSelection
    let expectedFilterableList = filterableList
    var stream = filterValidator.getFilterResultStream().makeAsyncIterator()

    // When
    await filterValidator.initializeValidator(
      filters: expectedFilters,
      filterableList: expectedFilterableList
    )

    await filterValidator.updateFilter(
      filterGroupId: reversibleSelectionGroup.id,
      filterId: filterItemsSingle[2].id
    )

    guard let partial = await stream.next() else {
      return XCTFail("Expected a .success but got no events")
    }

    switch partial {
    case .success(let result):
      switch result {
      case .filterUpdateResult(let updatedFilters):
          let updated = updatedFilters.filterGroups.first
          XCTAssertTrue(updated?.filters.first {
            $0.id == filterItemsSingle[2].id
          }?.selected ?? false)
      default:
        XCTFail("Unexpected result type received: \(result)")
      }
    case .completion:
      XCTFail("Expected a filter update result but received completion.")
    }
  }

  func testUpdateFilters_WhenCalledAppliedFiltersWithReversibleMultiSelection_ThenEmitsCorrectFilterUpdate() async {
    // Given
    let expectedFilters = filtersWithReversibleMultipleSelection
    let expectedFilterableList = filterableList
    var stream = filterValidator.getFilterResultStream().makeAsyncIterator()

    // When
    await filterValidator.initializeValidator(
      filters: expectedFilters,
      filterableList: expectedFilterableList
    )

    await filterValidator.updateFilter(
      filterGroupId: reversibleSelectionGroup.id,
      filterId: filterItemsSingle[2].id
    )

    guard let partial = await stream.next() else {
      return XCTFail("Expected a .success but got no events")
    }

    switch partial {
    case .success(let result):
      switch result {
      case .filterUpdateResult(let updatedFilters):
          let updated = updatedFilters.filterGroups.first
          XCTAssertTrue(updated?.filters.first {
            $0.id == filterItemsSingle[2].id
          }?.selected ?? false)
      default:
        XCTFail("Unexpected result type received: \(result)")
      }
    case .completion:
      XCTFail("Expected a filter update result but received completion.")
    }
  }

  func testApplyFilters_WhenSingleSelectionGroupHasNoSelectedFilter_ThenEmitsEmptyList() async {
    // Given: SingleSelectionFilterGroup whose every filter is unselected
    let unselectedFilters: [FilterItem] = [
      FilterItem(id: "1", name: "PID", selected: false,
                 filterableAction: Filter<TestAttributes>(predicate: { $0.name == $1.name })),
      FilterItem(id: "2", name: "mDL", selected: false,
                 filterableAction: Filter<TestAttributes>(predicate: { $0.name == $1.name }))
    ]
    let group = SingleSelectionFilterGroup(
      id: "single_no_selection",
      name: "Empty Single Selection",
      filters: unselectedFilters,
      filterType: .other
    )
    let filters = Filters(filterGroups: [group], sortOrder: .ascending)
    var stream = filterValidator.getFilterResultStream().makeAsyncIterator()

    // When
    await filterValidator.initializeValidator(filters: filters, filterableList: filterableList)
    await filterValidator.applyFilters(sortOrder: .ascending)

    guard let partial = await stream.next() else {
      return XCTFail("Expected a .success but got no events")
    }

    // Then: applySingleSelectionFilter falls through to return .init(items: [])
    switch partial {
    case .success(.filterApplyResult(let filteredList, _, _)):
      XCTAssertTrue(filteredList.items.isEmpty)
    default:
      XCTFail("Unexpected result: \(partial)")
    }
  }

  func testApplyFilters_WhenReversibleSingleSelectionHasNoSelectedFilter_ThenReturnsOriginalList() async {
    // Given: ReversibleSingleSelectionFilterGroup with everything unselected.
    // applyReversibleSingleSelectionFilter should return the original list unchanged.
    let unselectedFilters: [FilterItem] = [
      FilterItem(id: "1", name: "PID", selected: false,
                 filterableAction: Filter<TestAttributes>(predicate: { $0.name == $1.name })),
      FilterItem(id: "2", name: "mDL", selected: false,
                 filterableAction: Filter<TestAttributes>(predicate: { $0.name == $1.name }))
    ]
    let group = ReversibleSingleSelectionFilterGroup(
      id: "rev_single_none",
      name: "Reversible Single Empty",
      filters: unselectedFilters,
      filterType: .other
    )
    let filters = Filters(filterGroups: [group], sortOrder: .ascending)
    var stream = filterValidator.getFilterResultStream().makeAsyncIterator()

    // When
    await filterValidator.initializeValidator(filters: filters, filterableList: filterableList)
    await filterValidator.applyFilters(sortOrder: .ascending)

    guard let partial = await stream.next() else {
      return XCTFail("Expected a .success but got no events")
    }

    // Then: result == initial list
    switch partial {
    case .success(.filterApplyResult(let filteredList, _, _)):
      XCTAssertEqual(filteredList.items.count, filterableList.items.count)
    default:
      XCTFail("Unexpected result: \(partial)")
    }
  }

  func testApplyFilters_WhenReversibleMultipleSelectionHasNoSelectedFilter_ThenReturnsOriginalList() async {
    // Given: ReversibleMultipleSelectionFilterGroup with everything unselected.
    // applyReversibleMultipleSelectionFilter returns the original list unchanged.
    let group = ReversibleMultipleSelectionFilterGroup(
      id: "rev_multi_none",
      name: "Reversible Multi Empty",
      filters: filterItemsMultipleNoSelections,
      filterableAction: FilterMultipleAction<TestAttributes>(predicate: { $1.name == $0.name }),
      filterType: .other
    )
    let filters = Filters(filterGroups: [group], sortOrder: .ascending)
    var stream = filterValidator.getFilterResultStream().makeAsyncIterator()

    // When
    await filterValidator.initializeValidator(filters: filters, filterableList: filterableList)
    await filterValidator.applyFilters(sortOrder: .ascending)

    guard let partial = await stream.next() else {
      return XCTFail("Expected a .success but got no events")
    }

    // Then
    switch partial {
    case .success(.filterApplyResult(let filteredList, _, _)):
      XCTAssertEqual(filteredList.items.count, filterableList.items.count)
    default:
      XCTFail("Unexpected result: \(partial)")
    }
  }

  func testInitializeValidator_WhenCalledTwiceWithReversibleSingle_ThenMergesSelections() async {
    // Given: same ReversibleSingleSelectionFilterGroup twice, exercises the
    // `case var reversibleSingleGroup as ReversibleSingleSelectionFilterGroup`
    // branch inside mergeFilters.
    let filters = filtersWithReversibleSingleSelection
    var stream = filterValidator.getFilterResultStream().makeAsyncIterator()

    // When
    await filterValidator.initializeValidator(filters: filters, filterableList: filterableList)
    await filterValidator.initializeValidator(filters: filters, filterableList: filterableList)
    await filterValidator.applyFilters(sortOrder: .ascending)

    guard let partial = await stream.next() else {
      return XCTFail("Expected a .success but got no events")
    }

    switch partial {
    case .success(.filterApplyResult(_, let updatedFilters, _)):
      XCTAssertEqual(updatedFilters.filterGroups.count, filters.filterGroups.count)
    default:
      XCTFail("Unexpected result: \(partial)")
    }
  }

  func testInitializeValidator_WhenCalledTwiceWithReversibleMultiple_ThenMergesSelections() async {
    // Given: same ReversibleMultipleSelectionFilterGroup twice, exercises the
    // `case var reversibleMultipleGroup as ReversibleMultipleSelectionFilterGroup`
    // branch inside mergeFilters.
    let filters = filtersWithReversibleMultipleSelection
    var stream = filterValidator.getFilterResultStream().makeAsyncIterator()

    // When
    await filterValidator.initializeValidator(filters: filters, filterableList: filterableList)
    await filterValidator.initializeValidator(filters: filters, filterableList: filterableList)
    await filterValidator.applyFilters(sortOrder: .ascending)

    guard let partial = await stream.next() else {
      return XCTFail("Expected a .success but got no events")
    }

    switch partial {
    case .success(.filterApplyResult(_, let updatedFilters, _)):
      XCTAssertEqual(updatedFilters.filterGroups.count, filters.filterGroups.count)
    default:
      XCTFail("Unexpected result: \(partial)")
    }
  }

  func testUpdateDateFilters_WhenFilterIdMatchesTransactionDateRange_ThenStartAndEndDatesAreSet() async {
    // Given: a SingleSelectionFilterGroup containing the date-range filter id.
    // updateDateFilters must set startDate/endDate on the matching filter
    // rather than toggling its selected flag.
    let start = Date(timeIntervalSince1970: 1_000_000)
    let end = Date(timeIntervalSince1970: 2_000_000)
    let dateRangeFilter = FilterItem(
      id: FilterIds.FILTER_BY_TRANSACTION_DATE_RANGE,
      name: "Date Range",
      selected: false,
      filterableAction: Filter<TestAttributes>(predicate: { _, _ in true })
    )
    let group = SingleSelectionFilterGroup(
      id: FilterIds.FILTER_BY_TRANSACTION_DATE_GROUP_ID,
      name: "Date Group",
      filters: [dateRangeFilter],
      filterType: .other
    )
    let filters = Filters(filterGroups: [group], sortOrder: .ascending)
    var stream = filterValidator.getFilterResultStream().makeAsyncIterator()

    // When
    await filterValidator.initializeValidator(filters: filters, filterableList: filterableList)
    await filterValidator.updateDateFilters(
      filterGroupId: group.id,
      filterId: FilterIds.FILTER_BY_TRANSACTION_DATE_RANGE,
      startDate: start,
      endDate: end
    )

    guard let partial = await stream.next() else {
      return XCTFail("Expected a .success but got no events")
    }

    switch partial {
    case .success(.filterUpdateResult(let updatedFilters)):
      let updatedFilter = updatedFilters.filterGroups.first?.filters.first {
        $0.id == FilterIds.FILTER_BY_TRANSACTION_DATE_RANGE
      }
      XCTAssertEqual(updatedFilter?.startDate, start)
      XCTAssertEqual(updatedFilter?.endDate, end)
    default:
      XCTFail("Unexpected result: \(partial)")
    }
  }
}
