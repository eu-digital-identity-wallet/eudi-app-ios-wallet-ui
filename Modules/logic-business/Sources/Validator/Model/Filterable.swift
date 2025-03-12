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

public protocol FilterableItemPayload: Sendable { }

@Copyable
public struct FilterableList: Sendable {
  public let items: [FilterableItem]

  public init (
    items: [FilterableItem]
  ) {
    self.items = items
  }
}

extension FilterableList {
  func sortedByOrder(
    sortOrder: SortOrderType,
    selector: (FilterableItem) -> String
  ) -> FilterableList {
    let sortedItems: [FilterableItem]
    switch sortOrder {
    case .ascending:
      sortedItems = self.items.sorted { selector($0) < selector($1) }
    case .descending:
      sortedItems = self.items.sorted { selector($0) > selector($1) }
    }
    return FilterableList(items: sortedItems)
  }
}

public struct FilterableItem: Sendable {
  public let payload: FilterableItemPayload
  public let attributes: FilterableAttributes

  public init (
    payload: FilterableItemPayload,
    attributes: FilterableAttributes
  ) {
    self.payload = payload
    self.attributes = attributes
  }
}

public protocol FilterableAttributes: Sendable {
  var sortingKey: String { get }
  var searchTags: [String] { get }
}
