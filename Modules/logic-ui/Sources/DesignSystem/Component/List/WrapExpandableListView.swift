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

public struct WrapExpandableListView<T: Sendable>: View {

  private let header: ListItemData?
  private let items: [ExpandableListItem<T>]
  private let backgroundColor: Color
  private let onItemClick: ((ListItemData) -> Void)?
  private let hideSensitiveContent: Bool
  private let hasHeader: Bool
  private let isLoading: Bool

  public init(
    header: ListItemData? = nil,
    items: [ExpandableListItem<T>],
    backgroundColor: Color = Theme.shared.color.surfaceContainer,
    hideSensitiveContent: Bool,
    hasHeader: Bool = true,
    isLoading: Bool = false,
    onItemClick: ((ListItemData) -> Void)? = nil
  ) {
    self.header = header
    self.items = items
    self.backgroundColor = backgroundColor
    self.hideSensitiveContent = hideSensitiveContent
    self.hasHeader = hasHeader
    self.isLoading = isLoading
    self.onItemClick = onItemClick
  }

  public var body: some View {
    WrapCardView {
      VStack(alignment: .leading) {
        if let header {
          ExpandableCardView(
            backgroundColor: backgroundColor,
            title: header.mainText,
            subtitle: header.supportingText,
            isLoading: isLoading
          ) {
            contentList()
          }
        } else {
          contentList()
        }
      }
      .shimmer(isLoading: isLoading)
    }
  }

  @ViewBuilder
  private func contentList() -> some View {
    ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
      expandableItemView(item)

      if index < items.count - 1 {
        ListDividerView()
      }
    }
  }

  @ViewBuilder
  private func expandableItemView(_ item: ExpandableListItem<T>) -> some View {
    switch item {
    case .single(let singleData):
      WrapListItemView(listItem: singleData.collapsed) {
        onItemClick?(singleData.collapsed)
      }
    case .nested(let nestedData):
      WrapExpandableListView(
        header: nestedData.collapsed,
        items: nestedData.expanded,
        backgroundColor: backgroundColor,
        hideSensitiveContent: hideSensitiveContent,
        onItemClick: onItemClick
      )
    }

  }
}

private struct WrapExpandableListPreviewView: View {
  @State private var expandableItems: [ExpandableListItem] = [
    .single(
      GenericExpandableItem.SingleListItemData(
        collapsed: ListItemData(
          mainText: .custom("Single 1"),
          trailingContent: .checkbox(
            true,
            true,
            { _ in }
          )
        ),
        domainModel: nil
      )
    ),
    .nested(
      GenericExpandableItem.NestedListItemData(
        collapsed: ListItemData(mainText: .custom("Group 1")),
        expanded: [
          .single(
            ExpandableListItem.SingleListItemData(
              collapsed: ListItemData(mainText: .custom("Item 1")),
              domainModel: nil
            )
          ),
          .single(
            GenericExpandableItem.SingleListItemData(
              collapsed: ListItemData(mainText: .custom("Item 2")),
              domainModel: nil
            )
          )
        ],
        isExpanded: true
      )
    ),
    .single(
      GenericExpandableItem.SingleListItemData(
        collapsed: ListItemData(mainText: .custom("Single 2")),
        domainModel: nil
      )
    ),
    .nested(
      ExpandableListItem.NestedListItemData(
        collapsed: ListItemData(mainText: .custom("Group 2")),
        expanded: [
          .single(
            ExpandableListItem.SingleListItemData(
              collapsed: ListItemData(mainText: .custom("Item 1")),
              domainModel: nil
            )
          ),
          .single(
            ExpandableListItem.SingleListItemData(
              collapsed: ListItemData(mainText: .custom("Item 2")),
              domainModel: nil
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
  WrapExpandableListPreviewView()
    .padding()
}
