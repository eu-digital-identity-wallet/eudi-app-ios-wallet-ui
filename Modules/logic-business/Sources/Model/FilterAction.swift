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

protocol FilterAction: Sendable {
  func applyFilter(
    sortOrder: SortOrderType,
    filterableItems: FilterableList,
    filter: FilterItem
  ) -> FilterableList
}

struct Filter<T: FilterableAttributes>: FilterAction {
  var predicate: @Sendable (T, FilterItem) -> Bool

  func applyFilter(
    sortOrder: SortOrderType,
    filterableItems: FilterableList,
    filter: FilterItem
  ) -> FilterableList {
    let filteredItems = filterableItems.items.filter {
      guard let attributes = $0.attributes as? T else { return false }
      return predicate(attributes, filter)
    }
    return FilterableList(items: filteredItems)
  }
}

struct Sort<T: FilterableAttributes, R: Comparable>: FilterAction {
  var selector: @Sendable (T) -> R?

  func applyFilter(
    sortOrder: SortOrderType,
    filterableItems: FilterableList,
    filter: FilterItem
  ) -> FilterableList {
    let sortedItems = filterableItems.items.sorted {
      guard let lhs = $0.attributes as? T, let rhs = $1.attributes as? T else { return false }
      guard let lhsValue = selector(lhs), let rhsValue = selector(rhs) else { return false }
      return sortOrder == .ascending ? lhsValue < rhsValue : lhsValue > rhsValue
    }
    return FilterableList(items: sortedItems)
  }
}
