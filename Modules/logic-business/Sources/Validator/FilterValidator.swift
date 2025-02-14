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

public protocol FilterValidator: Sendable {
  func getFilterResultStream() -> AsyncStream<FilterResultPartialState>
  func initializeValidator(filters: Filters, filterableList: FilterableList) async
  func updateLists(sortOrder: SortOrderType, filterableList: FilterableList) async
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
  private var hasDefaultFilters: Bool = false

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

  func initializeValidator (
    filters: Filters,
    filterableList: FilterableList
  ) async {
    defaultFilters = filters
    var mergedFilterGroups: [FilterGroup] = []

    for newFilterGroup in filters.filterGroups {
      if let existingFilterGroup = appliedFilters.filterGroups.first(where: { $0.id == newFilterGroup.id }) {
          mergedFilterGroups.append(mergeFilters(newFilterGroup: newFilterGroup, existingFilterGroup: existingFilterGroup))
      } else {
          mergedFilterGroups.append(newFilterGroup)
      }
    }

    appliedFilters = Filters(filterGroups: mergedFilterGroups, sortOrder: appliedFilters.sortOrder)

    self.initialList = filterableList
  }

  func applyFilters() async {

    if !snapshotFilters.isEmpty {
      appliedFilters = snapshotFilters.copy()
      snapshotFilters = Filters.emptyFilters()
    }

    var filteredList = appliedFilters.filterGroups.reduce(initialList) { currentList, group in
      switch group {
      case let multipleGroup as MultipleSelectionFilterGroup:
        return applyMultipleSelectionFilter(currentList, multipleGroup)
      case let singleGroup as SingleSelectionFilterGroup:
        return applySingleSelectionFilter(currentList, singleGroup)
      default:
        return currentList
      }
    }

    hasDefaultFilters = checkIfDefaultFiltersApplied(groups: appliedFilters.filterGroups)

    if !searchQuery.isEmpty {
      filteredList = filteredList.copy(
        items: filteredList.items.filter { item in
          item.attributes.searchTags.contains { searchTag in
            searchTag.range(of: searchQuery, options: .caseInsensitive) != nil
          }
        }
      )
    }

    self.filterResultSubject.send(
      .success(
        .filterApplyResult(
          filteredList: filteredList,
          updatedFilters: appliedFilters,
          hasDefaultFilters: hasDefaultFilters
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
        .filterUpdateResult(
          updatedFilters: snapshotFilters
        )
      )
    )
  }

  func revertFilters() async {
    snapshotFilters = Filters.emptyFilters()
    self.filterResultSubject.send(
      .success(
        .filterUpdateResult(
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
        .filterUpdateResult(
          updatedFilters: snapshotFilters
        )
      )
    )
  }

  func updateLists(sortOrder: SortOrderType, filterableList: FilterableList) async {
    self.initialList = filterableList.sortedByOrder(sortOrder: sortOrder) {
      $0.attributes.sortingKey
    }
  }

  private func applyMultipleSelectionFilter(
          _ currentList: FilterableList,
          _ group: MultipleSelectionFilterGroup
  ) -> FilterableList {
    return group.filters.contains { $0.selected } ?
    group.filterableAction.applyFilterGroup(filterableItems: currentList, filterGroup: group) :
    FilterableList(items: [])
  }

  private func applySingleSelectionFilter(
          _ currentList: FilterableList,
          _ group: SingleSelectionFilterGroup
  ) -> FilterableList {
    return group.filters.filter { $0.selected }
      .reduce(currentList) { innerCurrentList, filter in
        filter.filterableAction.applyFilter(
          sortOrder: appliedFilters.sortOrder,
          filterableItems: innerCurrentList,
          filter: filter
        )
      }
  }

  private func mergeFilters(
    newFilterGroup: FilterGroup,
    existingFilterGroup: FilterGroup
  ) -> FilterGroup {
    let mergedFilters = newFilterGroup.filters.map { newFilter in
      if let existingFilter = existingFilterGroup.filters.first(where: { $0.id == newFilter.id }) {
        return newFilter.copy(selected: existingFilter.selected)
      }
      return newFilter
    }

    switch newFilterGroup {
      case var multipleGroup as MultipleSelectionFilterGroup:
        multipleGroup.filters = mergedFilters
        return multipleGroup
      case var singleGroup as SingleSelectionFilterGroup:
        singleGroup.filters = mergedFilters
        return singleGroup
      default:
        return newFilterGroup
    }
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

  func checkIfDefaultFiltersApplied(groups: [FilterGroup]) -> Bool {
    let allFilters = groups.flatMap { $0.filters }

    let allSelectedAreDefault = allFilters.filter { $0.selected }.allSatisfy { $0.isDefault }

    let allUnselectedAreNotDefault = allFilters.filter { !$0.selected }.allSatisfy { !$0.isDefault }

    return allSelectedAreDefault && allUnselectedAreNotDefault
  }
}
