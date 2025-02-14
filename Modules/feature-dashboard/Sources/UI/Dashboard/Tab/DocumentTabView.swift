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
import logic_core

struct DocumentTabView: View {
  let filteredItems: [DocumentCategory: [DocumentUIModel]]
  let action: (DocumentUIModel) -> Void
  let isLoading: Bool
  let filteredDocsCallback: (String) -> Void

  @Binding var searchQuery: String

  init(
    searchQuery: Binding<String>,
    filteredItems: [DocumentCategory: [DocumentUIModel]],
    isLoading: Bool,
    action: @escaping (DocumentUIModel) -> Void,
    filteredDocsCallback: @escaping (String) -> Void
  ) {
    self._searchQuery = searchQuery
    self.filteredItems = filteredItems
    self.action = action
    self.isLoading = isLoading
    self.filteredDocsCallback = filteredDocsCallback
  }

  var body: some View {
    VStack {
      if filteredItems.isEmpty && !searchQuery.isEmpty {
        contentUnavailableView()
      } else {
        if !filteredItems.isEmpty {
          List {
            ForEach(filteredItems.keys.sorted(by: { $0.order < $1.order }), id: \.self) { category in
              Section(header: Text(category.title)) {
                ForEach(filteredItems[category] ?? []) { item in
                  WrapCardView {
                    WrapListItemView(
                      listItem: item.listItem
                    ) {
                      action(item)
                    }
                  }
                  .listRowSeparator(.hidden)
                }
                .listRowInsets(.init(
                  top: SPACING_SMALL,
                  leading: SPACING_MEDIUM,
                  bottom: .zero,
                  trailing: SPACING_MEDIUM)
                )
              }
            }
          }
          .shimmer(isLoading: isLoading)
          .listStyle(.plain)
          .scrollIndicators(.hidden)
          .clipped()
        } else {
          contentUnavailableView()
        }

      }
    }
    .searchable(
      searchText: $searchQuery,
      backgroundColor: Theme.shared.color.background,
      onSearchTextChange: { _ in }
    )
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
  DocumentTabView(
    searchQuery: .constant(""),
    filteredItems: DocumentUIModel.mocks(),
    isLoading: false,
    action: { _ in },
    filteredDocsCallback: { _ in }
  )
}
