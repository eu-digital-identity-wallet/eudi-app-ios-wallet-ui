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
import SwiftUI
import logic_resources
import logic_business

public enum ExpandableListItem: Identifiable, Hashable, Equatable {
  case single(SingleListItemData)
  case nested(NestedListItemData)

  public var id: String {
    switch self {
      case .single(let data):
        return data.id
      case .nested(let data):
        return data.id
    }
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }

  public static func == (lhs: ExpandableListItem, rhs: ExpandableListItem) -> Bool {
    return lhs.id == rhs.id
  }

  public struct SingleListItemData: Identifiable, Equatable {
    @EquatableNoop
    public var id: String
    public let collapsed: ListItemData

    public init(
      id: String = UUID().uuidString,
      collapsed: ListItemData
    ) {
      self.id = id
      self.collapsed = collapsed
    }
  }

  public struct NestedListItemData: Identifiable, Equatable {
    @EquatableNoop
    public var id: String
    public let collapsed: ListItemData
    public let expanded: [ExpandableListItem]
    public var isExpanded: Bool

    public init(
      id: String = UUID().uuidString,
      collapsed: ListItemData,
      expanded: [ExpandableListItem],
      isExpanded: Bool
    ) {
      self.id = id
      self.collapsed = collapsed
      self.expanded = expanded
      self.isExpanded = isExpanded
    }
  }
}

struct WrapExpandableListItem: View {
  let header: ListItemData
  let items: [ExpandableListItem]
  let onItemClick: ((ListItemData) -> Void)?
  let hideSensitiveContent: Bool
  let onExpandedChange: () -> Void
  let isExpanded: Bool

  var body: some View {
    WrapCardView {
      VStack(alignment: .leading) {
        ExpandableCardView(
          title: header.mainText,
          subtitle: .custom("View details")) {
            ForEach(items, id: \.id) { item in
              switch item {
              case .single(let singleData):
                WrapListItemView(listItem: singleData.collapsed) {
                  onItemClick?(singleData.collapsed)
                }
              case .nested(let nestedData):
                WrapExpandableListItem(
                  header: nestedData.collapsed,
                  items: nestedData.expanded,
                  onItemClick: onItemClick,
                  hideSensitiveContent: false,
                  onExpandedChange: { onExpandedChange() },
                  isExpanded: nestedData.isExpanded
                )
              }
            }
          }
      }
    }
  }
}

struct ParentView: View {
  @State private var expandableItems: [ExpandableListItem] = [
    .single(
      ExpandableListItem.SingleListItemData(
        collapsed: ListItemData(mainText: .custom("Single 1"))
      )
    ),
    .nested(
      ExpandableListItem.NestedListItemData(
        collapsed: ListItemData(mainText: .custom("Group 1")),
        expanded: [
          .single(
            ExpandableListItem.SingleListItemData(
              collapsed: ListItemData(mainText: .custom("Item 1"))
            )
          ),
          .single(
            ExpandableListItem.SingleListItemData(
              collapsed: ListItemData(mainText: .custom("Item 2"))
            )
          )
        ],
        isExpanded: true
      )
    ),
    .single(
      ExpandableListItem.SingleListItemData(
        collapsed: ListItemData(mainText: .custom("Single 2"))
      )
    ),
    .nested(
      ExpandableListItem.NestedListItemData(
        collapsed: ListItemData(mainText: .custom("Group 2")),
        expanded: [
          .single(
            ExpandableListItem.SingleListItemData(
              collapsed: ListItemData(mainText: .custom("Item 1"))
            )
          ),
          .single(
            ExpandableListItem.SingleListItemData(
              collapsed: ListItemData(mainText: .custom("Item 2"))
            )
          )
        ],
        isExpanded: false
      )
    )
  ]

  var body: some View {
    WrapExpandableListItem(
      header: ListItemData(mainText: .custom("Expandable List")),
      items: expandableItems,
      onItemClick: { _ in },
      hideSensitiveContent: false,
      onExpandedChange: { print("Expanded Changed") },
      isExpanded: false
    )
  }
}

#Preview {
  ParentView()
    .padding()
}
