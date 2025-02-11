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
import Combine
import Foundation
import logic_resources

public enum FilterResultPartialState: Sendable {
  case success(FilterResult)
  case completion
}

//protocol FilterValidator {
//    func onFilterStateChange() -> AnyPublisher<FilterValidatorPartialState, Never>
//    func initializeValidator(filters: Filters, filterableList: FilterableList)
//    func updateLists(sortOrder: SortOrder, filterableList: FilterableList)
//    func applyFilters()
//    func applySearch(query: String)
//    func resetFilters()
//    func revertFilters()
//    func updateFilter(filterGroupId: String, filterId: String)
//    func updateSortOrder(sortOrder: SortOrder)
//}

public protocol FilterValidator: Sendable {
  func getFilterResultStream() -> AsyncStream<FilterResultPartialState>
  func initializeFilters(filters: Filters, filterableList: FilterableList) async
  func updateFilterList(filterableList: FilterableList, filters: Filters) async
  func applyFilters() async
  func applySearch(query: String) async
  func resetFilters() async
  func revertFilters() async
  func updateFilter(filterGroupId: String, filterId: String) async
  func updateSortOrder(sortOrder: SortOrderType) async
}

actor FilterValidatorImpl: FilterValidator {

  private var appliedFilters: Filters
  private var defaultFilters: Filters
  private var searchQuery: String = ""
  private var initialList: FilterableList
  private var filteredList: FilterableList
  private var filterableList: FilterableList
  private var snapshotFilters: Filters = Filters.emptyFilters()

  private let filterResultSubject: SendablePassthroughSubject<FilterResultPartialState> = .init()

  init(
    filters: Filters? = nil,
    initialFilters: Filters? = nil,
    initialList: FilterableList? = nil,
    filterableList: FilterableList? = nil,
    filteredList: FilterableList? = nil
  ) {
    self.appliedFilters = filters ?? Filters.emptyFilters()
    self.defaultFilters = initialFilters ?? Filters.emptyFilters()
    self.initialList = initialList ?? FilterableList(items: [])
    self.filterableList = filterableList ?? FilterableList(items: [])
    self.filteredList = filteredList ?? FilterableList(items: [])
  }

  deinit {
    filterResultSubject.send(.completion)
    filterResultSubject.complete()
  }

  nonisolated func getFilterResultStream() -> AsyncStream<FilterResultPartialState> {
    return filterResultSubject.getAsyncStream()
  }

  func initializeFilters (
    filters: Filters,
    filterableList: FilterableList
  ) async {
    self.appliedFilters = filters
    self.defaultFilters = filters
    self.initialList = filterableList.copy(items: filterableList.items.sorted(by: { item1, item2 in
      switch filters.sortOrder {
        case .ascending:
          return item1.attributes.sortingKey < item2.attributes.sortingKey
        case .descending:
          return item1.attributes.sortingKey > item2.attributes.sortingKey
      }
    }))
  }

  func applyFilters() async {

    if !snapshotFilters.isEmpty {
      appliedFilters = snapshotFilters.copy()
      snapshotFilters = Filters.emptyFilters()
    }

    let newList = appliedFilters.filterGroups
      .flatMap { $0.filters }
      .filter { $0.selected }
      .reduce(initialList) { partialResult, filter in
        let filteredResult = filter.filterableAction.applyFilter(
          sortOrder: appliedFilters.sortOrder,
          filterableItems: partialResult,
          filter: filter
        )

        if !searchQuery.isEmpty {
          let copiedResult = filteredResult.copy(
            items: filteredResult.items.filter { item in
              item.attributes.searchText.lowercased().contains(searchQuery.lowercased())
            }
          )
          return copiedResult
        }

        return filteredResult
      }

    self.filterResultSubject.send(
      .success(
        FilterResult(
          filteredList: newList,
          updatedFilters: appliedFilters
        )
      )
    )
  }

  func resetFilters() async {
    appliedFilters = defaultFilters
    snapshotFilters = Filters.emptyFilters()
    await applyFilters()
  }

  func updateFilter(filterGroupId: String, filterId: String) async {
    let filtersUpdate = snapshotFilters.isEmpty ? appliedFilters : snapshotFilters

    let updatedFilterGroups = filtersUpdate.filterGroups.map { group in
      return group.id == filterGroupId ? updateFilterInGroup(group: group, filterId: filterId) : group
    }

    let sortOrder = updatedFilterGroups
      .filter { $0.filterType == .orderBy }
      .flatMap { $0.filters }
      .first { $0.selected }?.id == FilterIds.ORDER_BY_ASCENDING
    ? SortOrderType.ascending
    : SortOrderType.descending

    let updatedFilters = filtersUpdate.copy(
      filterGroups: updatedFilterGroups,
      sortOrder: sortOrder
    )

    snapshotFilters = updatedFilters

    self.filterResultSubject.send(
      .success(
        FilterResult(
          filteredList: filteredList,
          updatedFilters: snapshotFilters
        )
      )
    )
  }

  private func updateFilterInGroup(group: FilterGroup, filterId: String) -> FilterGroup {
    if var multipleGroup = group as? MultipleSelectionFilterGroup {
      multipleGroup.filters = multipleGroup.filters.map { filter in
        let updatedFilter = filter
        if filter.id == filterId {
          return updatedFilter.copy(selected: !filter.selected)
        }
        return updatedFilter
      }

      return multipleGroup
    }

    if var singleGroup = group as? SingleSelectionFilterGroup {
      singleGroup.filters = singleGroup.filters.map { filter in
        let updatedFilter = filter
        return updatedFilter.copy(selected: (filter.id == filterId))
      }
      return singleGroup
    }

    return group
  }

  func revertFilters() async {
    snapshotFilters = Filters.emptyFilters()
    self.filterResultSubject.send(
      .success(
        FilterResult(
          filteredList: initialList,
          updatedFilters: appliedFilters
        )
      )
    )
  }

  func applySearch(query: String) async {
    searchQuery = query
    await applyFilters()
  }

  func updateSortOrder(sortOrder: SortOrderType) async {
    let filterToUpdateOrderChange = snapshotFilters.isEmpty ? appliedFilters : snapshotFilters
    snapshotFilters = filterToUpdateOrderChange.copy(sortOrder: sortOrder)

    self.filterResultSubject.send(
      .success(
        FilterResult(
          filteredList: filteredList,
          updatedFilters: snapshotFilters
        )
      )
    )
  }

  func updateFilterList(filterableList: FilterableList, filters: Filters) async {
    self.initialList = filterableList
    self.defaultFilters = filters
  }
}
