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
@testable import logic_business
@testable import logic_test
import logic_resources

struct TestPayload: FilterableItemPayload {
  var id: String
  
  public let name: String
  
  public init(
    id: String = UUID().uuidString,
    name: String)
  {
    self.id = id
    self.name = name
  }
}

struct TestAttributes: FilterableAttributes {
  public var sortingKey: String
  public let searchTags: [String]
  public let name: String
  public init(
    sortingKey: String,
    searchTags: [String],
    name: String
  ) {
    self.sortingKey = sortingKey
    self.searchTags = searchTags
    self.name = name
  }
}

let filterItemSingle1 = FilterItem(
  id: "1",
  name: "PID",
  selected: true,
  isDefault: true,
  filterableAction: Filter<TestAttributes>(predicate: { attributes, filterItem in
    return attributes.name == filterItem.name
  })
)

let filterItemSingle2 = FilterItem(
  id: "2",
  name: "mDL",
  selected: false,
  filterableAction: Filter<TestAttributes>(predicate: { attributes, filterItem in
    return attributes.name == filterItem.name
  })
)

let filterItemSingle3 = FilterItem(
  id: "3",
  name: "Age Verification",
  selected: false,
  filterableAction: Filter<TestAttributes>(predicate: { attributes, filterItem in
    return attributes.name == filterItem.name
  })
)

let filterItemsSingle: [FilterItem] = [
  filterItemSingle1,
  filterItemSingle2,
  filterItemSingle3
]

let filterItemsMultipleSize3 = [
  FilterItem(id: "1", name: "PID", selected: false),
  FilterItem(id: "2", name: "mDL", selected: true),
  FilterItem(id: "3", name: "Age Verification", selected: true)
]

let filterItemsMultipleSize4 = [
  FilterItem(id: "1", name: "PID", selected: true),
  FilterItem(id: "2", name: "mDL", selected: true),
  FilterItem(id: "3", name: "Age Verification", selected: true),
  FilterItem(id: "4", name: "New Filter", selected: true)
]

let filterItemsMultiple = [
  FilterItem(id: "1", name: "PID", selected: false),
  FilterItem(id: "2", name: "mDL", selected: true),
  FilterItem(id: "3", name: "Age Verification", selected: true),
  FilterItem(id: "4", name: "Search Test", selected: false),
  FilterItem(id: "5", name: "NO OP", selected: false)
]

let filterItemsMultipleNoSelections = [
  FilterItem(id: "1", name: "PID", selected: false),
  FilterItem(id: "2", name: "mDL", selected: false),
  FilterItem(id: "3", name: "Age Verification", selected: false),
  FilterItem(id: "4", name: "Search Test", selected: false),
  FilterItem(id: "5", name: "NO OP", selected: false)
]

let filterItemsMultipleAllSelected = [
  FilterItem(id: "1", name: "PID", selected: true),
  FilterItem(id: "2", name: "mDL", selected: true),
  FilterItem(id: "3", name: "Age Verification", selected: true),
  FilterItem(id: "4", name: "Search Test", selected: true),
  FilterItem(id: "5", name: "NO OP", selected: true)
]

let singleSelectionGroup = SingleSelectionFilterGroup(
  id: "single_filter",
  name: "Document Selection",
  filters: filterItemsSingle,
  filterType: .other
)

let multipleSelectionGroupSize3 = MultipleSelectionFilterGroup(
  id: "multi_filter",
  name: "Multi Document Selection",
  filters: filterItemsMultipleSize3,
  filterableAction: Filter<TestAttributes>(predicate: { attributes, filterItem in
    return attributes.name == filterItem.name
  }),
  filterType: .other
)

let multipleSelectionGroupSize4 = MultipleSelectionFilterGroup(
  id: "multi_filter",
  name: "Multi Document Selection",
  filters: filterItemsMultipleSize4,
  filterableAction: FilterMultipleAction<TestAttributes>(predicate: { attributes, filterItem in
    return filterItem.name == attributes.name
  }),
  filterType: .other
)

let multipleSelectionGroup = MultipleSelectionFilterGroup(
  id: "multi_filter",
  name: "Multi Document Selection",
  filters: filterItemsMultiple,
  filterableAction: FilterMultipleAction<TestAttributes>(predicate: { attributes, filterItem in
    return filterItem.name == attributes.name
  }),
  filterType: .other
)

let reversibleSelectionGroup = ReversibleSingleSelectionFilterGroup(
  id: "reversible_filter",
  name: "Reversible Document Selection",
  filters: filterItemsSingle,
  filterType: .other
)

let reversibleMultiSelectionGroup = ReversibleMultipleSelectionFilterGroup(
  id: "reversible_multi_filter",
  name: "Reversible Multi Document Selection",
  filters: filterItemsMultiple,
  filterableAction: FilterMultipleAction<TestAttributes>(predicate: { attributes, filterItem in
    return filterItem.name == attributes.name
  }),
  filterType: .other
)

let multipleSelectionGroupNoSelection = MultipleSelectionFilterGroup(
  id: "multi_filter_noselection",
  name: "Multi Document Selection",
  filters: filterItemsMultipleNoSelections,
  filterableAction: FilterMultipleAction<TestAttributes>(predicate: { attributes, filterItem in
    return filterItem.name == attributes.name
  }),
  filterType: .other
)

let multipleSelectionGroupAllSelected = MultipleSelectionFilterGroup(
  id: "multi_filter_all",
  name: "Multi Document Selection All",
  filters: filterItemsMultipleAllSelected,
  filterableAction: FilterMultipleAction<TestAttributes>(predicate: { attributes, filterItem in
    return filterItem.name == attributes.name
  }),
  filterType: .other
)

let filtersWithSingleSelection = Filters(
  filterGroups: [singleSelectionGroup],
  sortOrder: .ascending
)

let filtersWithMultipleSelectionSize3 = Filters(
  filterGroups: [multipleSelectionGroupSize3],
  sortOrder: .descending
)

let filtersWithMultipleSelectionSize4 = Filters(
  filterGroups: [multipleSelectionGroupSize4],
  sortOrder: .descending
)

let filtersWithMultipleSelection = Filters(
  filterGroups: [multipleSelectionGroup],
  sortOrder: .descending
)

let filtersWithReversibleSingleSelection = Filters(
  filterGroups: [reversibleSelectionGroup],
  sortOrder: .descending
)

let filtersWithReversibleMultipleSelection = Filters(
  filterGroups: [reversibleMultiSelectionGroup],
  sortOrder: .descending
)

let filtersWithMultipleSelectionNoSelection = Filters(
  filterGroups: [multipleSelectionGroupNoSelection],
  sortOrder: .descending
)

let filtersWithMultipleSelectionAllSelected = Filters(
  filterGroups: [multipleSelectionGroupAllSelected],
  sortOrder: .ascending
)

let filterableList = FilterableList(
  items: [
    FilterableItem(
      payload: TestPayload(name: "Item 1"),
      attributes: TestAttributes(sortingKey: "PID", searchTags: ["PID"], name: "PID")
    ),
    FilterableItem(
      payload: TestPayload(name: "Item 2"),
      attributes: TestAttributes(sortingKey: "PID", searchTags: ["mDL"], name: "mDL")
    ),
    FilterableItem(
      payload: TestPayload(name: "Item 3"),
      attributes: TestAttributes(sortingKey: "PID", searchTags: ["Age Verification"], name: "Age Verification")
    ),
    FilterableItem(
      payload: TestPayload(name: "Item 4"),
      attributes: TestAttributes(sortingKey: "PID", searchTags: ["PID", "PIDIssuer"], name: "PID")
    ),
    FilterableItem(
      payload: TestPayload(name: "Item 5"),
      attributes: TestAttributes(sortingKey: "PID", searchTags: [], name: "PID")
    ),
    FilterableItem(
      payload: TestPayload(name: "Item 6"),
      attributes: TestAttributes(sortingKey: "PID", searchTags: ["search text", "secondary text"], name: "Search Test")
    ),
    FilterableItem(
      payload: TestPayload(name: "Item 7"),
      attributes: TestAttributes(sortingKey: "PID", searchTags: ["no op"], name: "NO OP")
    )
  ]
)
