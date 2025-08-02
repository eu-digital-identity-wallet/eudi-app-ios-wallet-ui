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
import Foundation

public protocol FilterAction: Sendable {
  func applyFilter(
    sortOrder: SortOrderType,
    filterableItems: FilterableList,
    filter: FilterItem
  ) -> FilterableList

  func applyFilterGroup(
    filterableItems: FilterableList,
    filterGroup: FilterGroup
  ) -> FilterableList
}

public struct Sort<T: FilterableAttributes, R: Comparable>: FilterAction {
  public func applyFilterGroup(filterableItems: FilterableList, filterGroup: any FilterGroup) -> FilterableList {
    filterableItems
  }

  public let predicate: @Sendable (T) -> R?

  public init(
    predicate: @Sendable @escaping (T) -> R?
  ) {
    self.predicate = predicate
  }

  public func applyFilter(
    sortOrder: SortOrderType,
    filterableItems: FilterableList,
    filter: FilterItem
  ) -> FilterableList {
    let sortedItems = filterableItems.items.sorted {
      guard let lhs = $0.attributes as? T, let rhs = $1.attributes as? T else { return false }
      guard let lhsValue = predicate(lhs), let rhsValue = predicate(rhs) else { return false }

      if let lhsString = lhsValue as? String, let rhsString = rhsValue as? String {
        return sortOrder == .ascending
        ? lhsString.localizedCaseInsensitiveCompare(rhsString) == .orderedAscending
        : lhsString.localizedCaseInsensitiveCompare(rhsString) == .orderedDescending
      }

      return sortOrder == .ascending ? lhsValue < rhsValue : lhsValue > rhsValue
    }

    return FilterableList(items: sortedItems)
  }
}

public struct Filter<T: FilterableAttributes>: FilterAction {

  public let predicate: @Sendable (T, FilterItem) -> Bool

  public init(
    predicate: @Sendable @escaping (T, FilterItem) -> Bool
  ) {
    self.predicate = predicate
  }

  public func applyFilter(
    sortOrder: SortOrderType,
    filterableItems: FilterableList,
    filter: FilterItem
  ) -> FilterableList {
    let filteredItems = filterableItems.items.filter {
      if let attributes = $0.attributes as? T {
        let result = predicate(attributes, filter)
        return result
      } else {
        return false
      }
    }

    return filterableItems.copy(items: filteredItems)
  }

  public func applyFilterGroup(filterableItems: FilterableList, filterGroup: any FilterGroup) -> FilterableList {
    filterableItems
  }
}
