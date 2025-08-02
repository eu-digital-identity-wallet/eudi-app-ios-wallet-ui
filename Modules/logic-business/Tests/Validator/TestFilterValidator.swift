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
}
