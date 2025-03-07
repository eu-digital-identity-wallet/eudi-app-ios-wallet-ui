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

public struct WrapExpandableListView: View {

  private let header: ListItemData
  private let items: [ExpandableListItem]
  private let backgroundColor: Color
  private let onItemClick: (ListItemData) -> Void
  private let hideSensitiveContent: Bool

  public init(
    header: ListItemData,
    items: [ExpandableListItem],
    backgroundColor: Color = Theme.shared.color.surfaceContainer,
    hideSensitiveContent: Bool,
    onItemClick: @escaping (ListItemData) -> Void
  ) {
    self.header = header
    self.items = items
    self.backgroundColor = backgroundColor
    self.hideSensitiveContent = hideSensitiveContent
    self.onItemClick = onItemClick
  }

  public var body: some View {
    WrapCardView {
      VStack(alignment: .leading) {
        ExpandableCardView(
          backgroundColor: backgroundColor,
          title: header.mainText,
          subtitle: header.supportingText
        ) {
          ForEach(items, id: \.id) { item in
            switch item {
            case .single(let singleData):
              WrapListItemView(listItem: singleData.collapsed) {
                onItemClick(singleData.collapsed)
              }
            case .nested(let nestedData):
              WrapExpandableListView(
                header: nestedData.collapsed,
                items: nestedData.expanded,
                hideSensitiveContent: hideSensitiveContent,
                onItemClick: onItemClick
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
        documentId: "",
        nameSpace: nil,
        path: [],
        collapsed: ListItemData(
          mainText: .custom("Single 1"),
          trailingContent: .checkbox(
            true,
            true,
            { _ in }
          )
        )
      )
    ),
    .nested(
      ExpandableListItem.NestedListItemData(
        collapsed: ListItemData(mainText: .custom("Group 1")),
        expanded: [
          .single(
            ExpandableListItem.SingleListItemData(
              documentId: "",
              nameSpace: nil,
              path: [],
              collapsed: ListItemData(mainText: .custom("Item 1"))
            )
          ),
          .single(
            ExpandableListItem.SingleListItemData(
              documentId: "",
              nameSpace: nil,
              path: [],
              collapsed: ListItemData(mainText: .custom("Item 2"))
            )
          )
        ],
        isExpanded: true
      )
    ),
    .single(
      ExpandableListItem.SingleListItemData(
        documentId: "",
        nameSpace: nil,
        path: [],
        collapsed: ListItemData(mainText: .custom("Single 2"))
      )
    ),
    .nested(
      ExpandableListItem.NestedListItemData(
        collapsed: ListItemData(mainText: .custom("Group 2")),
        expanded: [
          .single(
            ExpandableListItem.SingleListItemData(
              documentId: "",
              nameSpace: nil,
              path: [],
              collapsed: ListItemData(mainText: .custom("Item 1"))
            )
          ),
          .single(
            ExpandableListItem.SingleListItemData(
              documentId: "",
              nameSpace: nil,
              path: [],
              collapsed: ListItemData(mainText: .custom("Item 2"))
            )
          )
        ],
        isExpanded: false
      )
    )
  ]

  var body: some View {
    WrapExpandableListView(
      header: ListItemData(
        mainText: .custom("Expandable List"),
        supportingText: .custom("View details")
      ),
      items: expandableItems,
      hideSensitiveContent: false,
      onItemClick: { _ in }
    )
  }
}

#Preview {
  ParentView()
    .padding()
}
