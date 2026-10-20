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
import Foundation

public enum FilterResultPartialState: Sendable {
  case success(FilterResult)
  case completion
}
public protocol FilterValidator: Sendable {
  func getFilterResultStream() -> AsyncStream<FilterResultPartialState>
  func initializeValidator(filters: Filters, filterableList: FilterableList) async
  func updateLists(sortOrder: SortOrderType, filterableList: FilterableList) async
  func applyFilters(sortOrder: SortOrderType) async
  func applySearch(query: String) async
  func resetFilters() async
  func revertFilters() async
  func updateFilter(filterGroupId: String, filterId: String) async
  func updateDateFilters(filterGroupId: String, filterId: String, startDate: Date, endDate: Date) async
  func updateSortOrder(sortOrder: SortOrderType) async
  func updateSort(filterId: String) async
}

final actor FilterValidatorImpl: FilterValidator {

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

  func initializeValidator(
    filters: Filters,
    filterableList: FilterableList
  ) async {
    let previousDefaultFilters = defaultFilters
    defaultFilters = filters
    var mergedFilterGroups: [FilterGroup] = []

    for newFilterGroup in filters.filterGroups {
      if let existingFilterGroup = appliedFilters.filterGroups.first(where: { $0.id == newFilterGroup.id }) {
          mergedFilterGroups.append(
            mergeFilters(
              newFilterGroup: newFilterGroup,
              existingFilterGroup: existingFilterGroup,
              previousDefaultGroup: previousDefaultFilters.filterGroups.first(where: { $0.id == newFilterGroup.id })
            )
          )
      } else {
          mergedFilterGroups.append(newFilterGroup)
      }
    }

    let mergedSort: FilterSort? = {
      if appliedFilters.isEmpty {
        return filters.sort
      }
      return mergeSort(newSort: filters.sort, existingSort: appliedFilters.sort)
    }()

    appliedFilters = Filters(
      filterGroups: mergedFilterGroups,
      sortOrder: appliedFilters.isEmpty ? defaultFilters.sortOrder : appliedFilters.sortOrder,
      sort: mergedSort
    )

    self.initialList = filterableList
  }

  func applyFilters(sortOrder: SortOrderType = .ascending) async {

    if !snapshotFilters.isEmpty {
      appliedFilters = snapshotFilters.copy()
      snapshotFilters = Filters.emptyFilters(sortOrder: sortOrder)
    }

    var filteredList = appliedFilters.filterGroups.reduce(initialList) { currentList, group in
      switch group {
      case let multipleGroup as MultipleSelectionFilterGroup:
        return applyMultipleSelectionFilter(currentList, multipleGroup)
      case let reversingMultipleGroup as ReversibleMultipleSelectionFilterGroup:
        return applyReversibleMultipleSelectionFilter(currentList, reversingMultipleGroup)
      case let singleGroup as SingleSelectionFilterGroup:
        return applySingleSelectionFilter(currentList, singleGroup)
      case let reversingSingleGroup as ReversibleSingleSelectionFilterGroup:
        return applyReversibleSingleSelectionFilter(currentList, reversingSingleGroup)
      default:
        return currentList
      }
    }

    // Apply the active sort last so that the reduce above does not
    // disturb its ordering.
    filteredList = filteredList.applySort(filters: appliedFilters)

    hasDefaultFilters = checkIfDefaultFiltersApplied(
      groups: appliedFilters.filterGroups,
      sort: appliedFilters.sort
    )

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

  func updateDateFilters(filterGroupId: String, filterId: String, startDate: Date, endDate: Date) async {
    let filtersUpdate = snapshotFilters.isEmpty ? appliedFilters : snapshotFilters

    let updatedFilterGroups = filtersUpdate.filterGroups.map { group in
      return group.id == filterGroupId ? updateFilterInGroup(group: group, filterId: filterId, startDate: startDate, endDate: endDate) : group
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

  func updateSort(filterId: String) async {
    let filtersToUpdate = snapshotFilters.isEmpty ? appliedFilters : snapshotFilters

    guard let currentSort = filtersToUpdate.sort else {
      return
    }

    let updatedSortFilters = currentSort.filters.map { filter in
      filter.copy(selected: filter.id == filterId)
    }
    let updatedSort = currentSort.copy(filters: updatedSortFilters)

    snapshotFilters = filtersToUpdate.copy(sort: updatedSort)

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
    guard let selectedFilter = group.filters.first(where: { $0.selected }) else {
      return .init(items: [])
    }

    // Sorting is handled by `applySort` after the reduce above, so skip it
    // here to avoid having it overwritten by subsequent filter groups.
    if selectedFilter.filterableAction is SortFilterAction {
      return currentList
    }

    return selectedFilter.filterableAction.applyFilter(
      sortOrder: appliedFilters.sortOrder,
      filterableItems: currentList,
      filter: selectedFilter
    )
  }

  private func applyReversibleSingleSelectionFilter(
    _ currentList: FilterableList,
    _ group: ReversibleSingleSelectionFilterGroup
  ) -> FilterableList {
    guard let selectedFilter = group.filters.first(where: { $0.selected }) else {
      return currentList
    }

    if selectedFilter.filterableAction is SortFilterAction {
      return currentList
    }

    return selectedFilter.filterableAction.applyFilter(
      sortOrder: appliedFilters.sortOrder,
      filterableItems: currentList,
      filter: selectedFilter
    )
  }

  private func applyReversibleMultipleSelectionFilter(
    _ currentList: FilterableList,
    _ group: ReversibleMultipleSelectionFilterGroup
  ) -> FilterableList {
    return group.filters.contains { $0.selected } ?
    group.filterableAction.applyFilterGroup(filterableItems: currentList, filterGroup: group) :
    currentList
  }

  private func mergeFilters(
    newFilterGroup: FilterGroup,
    existingFilterGroup: FilterGroup,
    previousDefaultGroup: FilterGroup?
  ) -> FilterGroup {
    let mergedFilters = newFilterGroup.filters.map { newFilter -> FilterItem in
      guard let existingFilter = existingFilterGroup.filters.first(where: { $0.id == newFilter.id }) else {
        return newFilter
      }

      let previousDefaultFilter = previousDefaultGroup?.filters.first(where: { $0.id == newFilter.id })
      let userCustomizedDates = previousDefaultFilter.map {
        existingFilter.startDate != $0.startDate || existingFilter.endDate != $0.endDate
      } ?? true

      return newFilter.copy(
        selected: existingFilter.selected,
        startDate: userCustomizedDates ? existingFilter.startDate : newFilter.startDate,
        endDate: userCustomizedDates ? existingFilter.endDate : newFilter.endDate
      )
    }

    switch newFilterGroup {
    case var multipleGroup as MultipleSelectionFilterGroup:
      multipleGroup.filters = mergedFilters
      return multipleGroup
    case var reversibleMultipleGroup as ReversibleMultipleSelectionFilterGroup:
      reversibleMultipleGroup.filters = mergedFilters
      return reversibleMultipleGroup
    case var singleGroup as SingleSelectionFilterGroup:
      singleGroup.filters = mergedFilters
      return singleGroup
    case var reversibleSingleGroup as ReversibleSingleSelectionFilterGroup:
      reversibleSingleGroup.filters = mergedFilters
      return reversibleSingleGroup
    default:
      return newFilterGroup
    }
  }

  private func updateFilterInGroup(
    group: FilterGroup,
    filterId: String,
    startDate: Date? = nil,
    endDate: Date? = nil
  ) -> FilterGroup {
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
        if filter.id == FilterIds.FILTER_BY_TRANSACTION_DATE_RANGE {
          return updatedFilter.copy(startDate: startDate, endDate: endDate)
        }
        return updatedFilter.copy(selected: (filter.id == filterId))
      }
      return singleGroup
    }

    if var singleReversibleGroup = group as? ReversibleSingleSelectionFilterGroup {
      singleReversibleGroup.filters = singleReversibleGroup.filters.map { filter in
        return filter.id == filterId ? filter.copy(selected: !filter.selected) : filter
      }
      return singleReversibleGroup
    }

    if var multipleReversibleGroup = group as? ReversibleMultipleSelectionFilterGroup {
      multipleReversibleGroup.filters = multipleReversibleGroup.filters.map { filter in
        return filter.id == filterId ? filter.copy(selected: !filter.selected) : filter
      }
      return multipleReversibleGroup
    }

    return group
  }

  func checkIfDefaultFiltersApplied(groups: [FilterGroup], sort: FilterSort?) -> Bool {
    let allFilters: [FilterItem] = groups.flatMap { $0.filters } + (sort?.filters ?? [])

    let allSelectedAreDefault = allFilters.filter { $0.selected }.allSatisfy { $0.isDefault }

    let allUnselectedAreNotDefault = allFilters.filter { !$0.selected }.allSatisfy { !$0.isDefault }

    return allSelectedAreDefault && allUnselectedAreNotDefault
  }

  private func mergeSort(newSort: FilterSort?, existingSort: FilterSort?) -> FilterSort? {
    guard let newSort else { return nil }
    guard let existingSort else { return newSort }

    let mergedFilters = newSort.filters.map { newFilter -> FilterItem in
      if let existing = existingSort.filters.first(where: { $0.id == newFilter.id }) {
        return newFilter.copy(selected: existing.selected)
      }
      return newFilter
    }

    return newSort.copy(filters: mergedFilters)
  }
}

extension FilterValidatorImpl {
  var appliedFiltersForTesting: Filters {
    return appliedFilters
  }
}
