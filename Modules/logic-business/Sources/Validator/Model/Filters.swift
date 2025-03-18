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
import Copyable
import logic_resources

public enum FilterGroupType: Sendable {
  case issuer
  case documentCategory
  case other
  case orderBy
}

@Copyable
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

  public var isNotEmpty: Bool {
    !filterGroups.isEmpty
  }

  public static func emptyFilters() -> Filters {
    return Filters(filterGroups: [], sortOrder: .ascending)
  }
}

public protocol FilterGroup: Sendable {
  var id: String { get }
  var name: String { get }
  var filters: [FilterItem] { get }
  var filterType: FilterGroupType { get }
}

@Copyable
public struct SingleSelectionFilterGroup: FilterGroup {
  public var id: String
  public var name: String
  public var filters: [FilterItem]
  public var filterType: FilterGroupType

  public init(
    id: String = UUID().uuidString,
    name: String,
    filters: [FilterItem],
    filterType: FilterGroupType
  ) {
    self.id = id
    self.name = name
    self.filters = filters
    self.filterType = filterType
  }
}

@Copyable
public struct MultipleSelectionFilterGroup: FilterGroup {
  public var id: String
  public var name: String
  public var filters: [FilterItem]
  public var filterableAction: FilterAction
  public var filterType: FilterGroupType

  public init(
    id: String = UUID().uuidString,
    name: String,
    filters: [FilterItem],
    filterableAction: FilterAction,
    filterType: FilterGroupType
  ) {
    self.id = id
    self.name = name
    self.filters = filters
    self.filterableAction = filterableAction
    self.filterType = filterType
  }
}

@Copyable
public struct FilterItem: Sendable {
  public let id: String
  public let name: String
  public let selected: Bool
  public let isDefault: Bool
  public let filterableAction: FilterAction

  public init(
    id: String = UUID().uuidString,
    name: String,
    selected: Bool,
    isDefault: Bool = false,
    filterableAction: FilterAction = DefaultFilterAction()
  ) {
    self.id = id
    self.name = name
    self.selected = selected
    self.isDefault = isDefault
    self.filterableAction = filterableAction
  }
}

public struct DefaultFilterAction: FilterAction {
  public func applyFilterGroup(filterableItems: FilterableList, filterGroup: any FilterGroup) -> FilterableList {
    filterableItems
  }

  public init() {}
  public func applyFilter(
    sortOrder: SortOrderType,
    filterableItems: FilterableList,
    filter: FilterItem
  ) -> FilterableList {
    return filterableItems
  }
}

public struct FilterMultipleAction<T: FilterableAttributes>: FilterAction {
  public func applyFilter(sortOrder: SortOrderType, filterableItems: FilterableList, filter: FilterItem) -> FilterableList {
    filterableItems
  }

  public let predicate: @Sendable (T, FilterItem) -> Bool

  public init(
    predicate: @Sendable @escaping (T, FilterItem) -> Bool
  ) {
    self.predicate = predicate
  }

  public func applyFilterGroup(
    filterableItems: FilterableList,
    filterGroup: FilterGroup
  ) -> FilterableList {
    let selectedFilters = filterGroup.filters.filter { $0.selected }

    guard !selectedFilters.isEmpty else { return filterableItems }

    let matchingItems = filterableItems.items.filter { item in
      guard let attributes = item.attributes as? T else { return false }
      return selectedFilters.contains { filter in predicate(attributes, filter) }
    }

    return FilterableList(items: matchingItems)
  }
}

public enum FilterResult: Sendable {
  case filterApplyResult(filteredList: FilterableList, updatedFilters: Filters, hasDefaultFilters: Bool)
  case filterUpdateResult(updatedFilters: Filters)
}

public enum SortOrderType: Sendable {
  case ascending
  case descending
}
