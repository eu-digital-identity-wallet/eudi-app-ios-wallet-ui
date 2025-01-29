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

struct Filters: Sendable {
  let filterGroups: [FilterGroup]
  let sortOrder: SortOrderType

  var isEmpty: Bool {
    return filterGroups.isEmpty
  }

  static func emptyFilters() -> Filters {
    return Filters(filterGroups: [], sortOrder: .ascending)
  }
}

struct FilterGroup {
    var id: String
    var name: String
    var filters: [FilterItem]
}

struct FilterItem: Sendable {
  let id: String
  let name: String
  let selected: Bool
  let filterableAction: FilterAction
}

public struct FilterResult: Sendable {
  var filteredList: FilterableList
  var updatedFilters: Filters
}

enum SortOrderType {
  case ascending
  case descending
}
