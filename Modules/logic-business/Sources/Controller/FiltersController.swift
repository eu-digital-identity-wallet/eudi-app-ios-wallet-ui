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
import Foundation
import Combine
import logic_resources
import Copyable

public protocol FiltersController: Sendable {

  var filterResultPublisher: AnyPublisher<FilterResult, Never> { get }

  func initializeFilters(filters: Filters, filterableList: FilterableList)
  func updateLists(filterableList: FilterableList)
  func applyFilters()
  func applySearch(query: String)
  func resetFilters()
  func revertFilters()
  func updateFilter(filterGroupId: String, filterId: String)
  func updateSortOrder(sortOrder: SortOrderType)
}

final class FiltersControllerImpl: FiltersController {

  var filterResultPublisher: AnyPublisher<FilterResult, Never> {
    return filterResultSubject.eraseToAnyPublisher()
  }

  nonisolated(unsafe) private var appliedFilters: Filters
  nonisolated(unsafe) private var defaultFilters: Filters
  nonisolated(unsafe) private var searchQuery: String = ""
  nonisolated(unsafe) private var initialList: FilterableList
  nonisolated(unsafe) private var filteredList: FilterableList
  nonisolated(unsafe) private var filterableList: FilterableList
  nonisolated(unsafe) private var snapshotFilters: Filters = Filters.emptyFilters()

  nonisolated(unsafe) private let filterResultSubject = PassthroughSubject<FilterResult, Never>()

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

  func initializeFilters (
    filters: Filters,
    filterableList: FilterableList
  ) {
      self.appliedFilters = filters
      self.defaultFilters = filters
      self.initialList = filterableList
      self.filterableList = filterableList
      self.filteredList = filterableList
  }

  func updateLists(filterableList: FilterableList) {
    self.filterResultSubject.send(
      FilterResult(
        filteredList: filterableList,
        updatedFilters: self.appliedFilters
      )
    )
  }

  func applyFilters() {
    var filteredItems = self.filterableList.items

    for filterGroup in appliedFilters.filterGroups {
      for filterItem in filterGroup.filters where filterItem.selected {
        filteredItems = filterItem.filterableAction.applyFilter(
          sortOrder: appliedFilters.sortOrder,
          filterableItems: FilterableList(items: filteredItems),
          filter: filterItem
        ).items
      }
    }

    self.filterResultSubject.send(
      FilterResult(
        filteredList: FilterableList(items: filteredItems),
        updatedFilters: self.appliedFilters
      )
    )
  }

  func applySearch(query: String) {
    let filteredItems = self.filterableList.items.filter { item in
      return item.attributes.searchText.contains(query)
    }

    self.filterResultSubject.send(
      FilterResult(
        filteredList: FilterableList(items: filteredItems),
        updatedFilters: self.appliedFilters
      )
    )
  }

  func resetFilters() {
    self.filterResultSubject.send(
      FilterResult(
        filteredList: self.initialList,
        updatedFilters: self.defaultFilters
      )
    )
  }

  func revertFilters() {
    let revertFilters = Filters.emptyFilters()
    self.filterResultSubject.send(
      FilterResult(
        filteredList: self.filteredList,
        updatedFilters: revertFilters
      )
    )
  }

  func updateFilter(filterGroupId: String, filterId: String) {
    let updatedFilterGroups = appliedFilters.filterGroups.map { group in
      if group.id == filterGroupId {
        if let targetFilter = group.filters.first(where: { $0.id == filterId }) {
          return group.copy(filters: group.filters.map { filter in
            filter.copy(selected: filter.id == targetFilter.id)
          })
        }
      }
      return group
    }

    let updatedFilters = Filters(filterGroups: updatedFilterGroups, sortOrder: appliedFilters.sortOrder)

    self.filterResultSubject.send(
      FilterResult(
        filteredList: filteredList,
        updatedFilters: updatedFilters
      ))
  }

  func updateSortOrder(sortOrder: SortOrderType) {
    let updatedFilters = appliedFilters.copy(sortOrder: sortOrder)

    self.filterResultSubject.send(
      FilterResult(
        filteredList: filteredList,
        updatedFilters: updatedFilters
      )
    )
  }
}
