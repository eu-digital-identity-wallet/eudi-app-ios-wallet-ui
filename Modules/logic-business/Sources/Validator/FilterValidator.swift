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
  func initializeFilters(filters: Filters, filterableList: FilterableList) async
  func updateLists(filterableList: FilterableList) async
  func applyFilters() async
  func applySearch(query: String) async
  func resetFilters() async
  func revertFilters() async
  func updateFilter(filterGroupId: String, filterId: String) async
  func updateSortOrder(sortOrder: SortOrderType) async
  func getFilterResultStream() -> AsyncStream<FilterResultPartialState>
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
    self.initialList = filterableList
    self.filterableList = filterableList
    self.filteredList = filterableList
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

        return filteredResult.copy(
          items: partialResult.items.filter({ item in
            item.attributes.searchText.contains(searchQuery)
          })
        )
      }

    self.filterResultSubject.send(
      .success(
        FilterResult(
          filteredList: FilterableList(items: newList.items),
          updatedFilters: self.appliedFilters
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
    let updatedFilterGroups = appliedFilters.filterGroups.map { group in
      if group.id.uuidString == filterGroupId {
        if let targetFilter = group.filters.first(where: { $0.id.uuidString == filterId }) {
          return group.copy(filters: group.filters.map { filter in
            filter.copy(selected: filter.id == targetFilter.id)
          })
        }
      }
      return group
    }

    let updatedFilters = Filters(filterGroups: updatedFilterGroups, sortOrder: appliedFilters.sortOrder)

    snapshotFilters = updatedFilters

    self.filterResultSubject.send(
      .success(
        FilterResult(
          filteredList: filteredList,
          updatedFilters: updatedFilters
        )
      )
    )
  }

  func revertFilters() async { }

  func applySearch(query: String) async { }

  func updateSortOrder(sortOrder: SortOrderType) async { }

  func updateLists(filterableList: FilterableList) async { }

}
