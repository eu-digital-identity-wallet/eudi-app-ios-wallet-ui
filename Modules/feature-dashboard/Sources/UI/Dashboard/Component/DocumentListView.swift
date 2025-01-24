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

  let filteredItems: [DocumentUIModel]
  let action: (DocumentUIModel) -> Void
  let isLoading: Bool
  let filteredDocsCallback: (String) -> Void

  init(
    filteredItems: [DocumentUIModel],
    isLoading: Bool,
    action: @escaping (DocumentUIModel) -> Void,
    filteredDocsCallback: @escaping (String) -> Void
  ) {
    self.filteredItems = filteredItems
    self.action = action
    self.isLoading = isLoading
    self.filteredDocsCallback = filteredDocsCallback
  }

  var body: some View {
    VStack {
      if filteredItems.isEmpty && !searchText.isEmpty {
        contentUnavailableView()
      } else {
        if !filteredItems.isEmpty {
          List {
            ForEach(filteredItems) { item in
              WrapCardView {
                WrapListItemView(
                  listItem: item.listItem
                ) {
                  action(item)
                }
              }
              .listRowSeparator(.hidden)
            }
          }
          .shimmer(isLoading: isLoading)
          .listStyle(.plain)
          .clipped()
        } else {
          contentUnavailableView()
        }

      }
    }
    .searchable(
      searchText: $searchText,
      placeholder: LocalizableString.shared.get(with: .search),
      backgroundColor: Theme.shared.color.background
    ) { searchText in
      filteredDocsCallback(searchText)
    }
    .background(Theme.shared.color.background)
  }

  @ViewBuilder
  private func contentUnavailableView() -> some View {
    VStack(spacing: SPACING_SMALL) {
      Text(.noResults)
        .typography(Theme.shared.font.titleLarge)
        .fontWeight(.bold)

      Text(.noResultsDescription)
        .typography(Theme.shared.font.bodyLarge)
        .foregroundStyle(Theme.shared.color.onSurface)
        .multilineTextAlignment(.center)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    .padding(.top, SPACING_LARGE_MEDIUM)
    .padding(.horizontal, SPACING_MEDIUM)
  }
}

#Preview {
  DocumentListView(
    filteredItems: DocumentUIModel.mocks(),
    isLoading: false,
    action: { _ in },
    filteredDocsCallback: { _ in }
  )
}
