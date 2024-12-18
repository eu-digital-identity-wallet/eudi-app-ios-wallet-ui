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
import logic_ui

struct DocumentListView: View {
  @State private var searchText = ""

  let items: [DocumentUIModel]
  let action: (DocumentUIModel) -> Void
  let isLoading: Bool

  init(
    items: [DocumentUIModel],
    isLoading: Bool,
    action: @escaping (DocumentUIModel) -> Void) {
      self.items = items
      self.action = action
      self.isLoading = isLoading
    }

  var body: some View {
    List {
      ForEach(items) { item in
        WrapCardView {
          WrapListItemView(
            listItem: ListItemData(
              mainText: item.value.title,
              supportingText: LocalizableString.shared.get(with: .validUntil([item.value.expiresAt ?? ""])),
              trailingContent: .icon(Theme.shared.image.chevronRight)
            )
          ) {
            action(item)
          }
        }
        .listRowSeparator(.hidden)
      }
    }
    .listStyle(.plain)
    .clipped()
    .background(Theme.shared.color.background)
    .searchable(
      searchText: $searchText,
      items: items,
      placeholder: LocalizableString.shared.get(with: .search)
    ) { _ in }
  }
}

#Preview {
  DocumentListView(
    items: DocumentUIModel.mocks(),
    isLoading: false
  ) { _ in }
}
