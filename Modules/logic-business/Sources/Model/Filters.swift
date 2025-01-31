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

public struct Filters: Sendable {
  public let filterGroups: [FilterGroup]
  public let sortOrder: SortOrderType

  public init(
    filterGroups: [FilterGroup],
    sortOrder: SortOrderType
  ) {
    self.filterGroups = filterGroups
    self.sortOrder = sortOrder
  }

  public var isEmpty: Bool {
    return filterGroups.isEmpty
  }

  public static func emptyFilters() -> Filters {
    return Filters(filterGroups: [], sortOrder: .ascending)
  }

  public func copy(sortOrder: SortOrderType) -> Filters {
    return Filters(filterGroups: self.filterGroups, sortOrder: sortOrder)
  }
}

public struct FilterGroup: Sendable {
  public var id: String
  public var name: String
  public var filters: [FilterItem]

  public init(
    id: String? = nil,
    name: String,
    filters: [FilterItem]
  ) {
    self.id = id ?? UUID().uuidString
    self.name = name
    self.filters = filters
  }

  func copy(filters: [FilterItem]) -> FilterGroup {
      return FilterGroup(id: self.id, name: self.name, filters: filters)
  }
}

public struct FilterItem: Sendable {
  public let id: String
  public let name: String
  public let selected: Bool
  public let filterableAction: FilterAction

  public init(
    id: String? = nil,
    name: String,
    selected: Bool,
    filterableAction: FilterAction
  ) {
    self.id = id ?? UUID().uuidString
    self.name = name
    self.selected = selected
    self.filterableAction = filterableAction
  }

  func copy(selected: Bool) -> FilterItem {
    return FilterItem(
      id: self.id,
      name: self.name,
      selected: selected,
      filterableAction: self.filterableAction
    )
  }
}

public struct FilterResult: Sendable {
  public var filteredList: FilterableList
  public var updatedFilters: Filters

  public init(
    filteredList: FilterableList,
    updatedFilters: Filters
  ) {
    self.filteredList = filteredList
    self.updatedFilters = updatedFilters
  }
}

public enum SortOrderType: Sendable {
  case ascending
  case descending
}
