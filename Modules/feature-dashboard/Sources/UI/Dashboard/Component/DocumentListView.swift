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
        VStack(spacing: SPACING_SMALL) {
          Text(.noResults)
            .typography(Theme.shared.font.titleMedium)
            .fontWeight(.bold)

          Text(.noResultsDescription)
            .typography(Theme.shared.font.headlineSmall)
            .foregroundStyle(Theme.shared.color.onSurface)
            .multilineTextAlignment(.center)

          Spacer()
        }
        .padding(.top, SPACING_LARGE_MEDIUM)
        .padding(.horizontal, SPACING_MEDIUM)
      } else {
        List {
          ForEach(filteredItems) { item in
            WrapCardView {
              WrapListItemView(
                listItem: ListItemData(
                  mainText: item.value.title,
                  overlineText: item.value.heading,
                  supportingText: item.supportingText(),
                  supportingTextColor: item.supportingColor(),
                  leadingIcon: (
                    item.value.image?.url,
                    item.value.image?.placeholder
                  ),
                  trailingContent: .icon(item.indicatorImage(), item.supportingColor())
                )
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
}

private extension DocumentUIModel {
  func supportingText() -> String {
    switch value.state {
      case .issued:
        return expiry.orEmpty
      case .pending:
        return LocalizableString.shared.get(with: .pending)
      case .failed:
        return LocalizableString.shared.get(with: .issuanceFailed)
    }
  }

  func supportingColor() -> Color {
    switch value.state {
      case .issued:
        return Theme.shared.color.onSurfaceVariant
      case .pending:
        return Theme.shared.color.warning
      case .failed:
        return Theme.shared.color.error
    }
  }

  func indicatorImage() -> Image {
    switch value.state {
      case .issued:
        return Theme.shared.image.chevronRight
      case .pending:
        return Theme.shared.image.clockIndicator
      case .failed:
        return Theme.shared.image.errorIndicator
    }
  }

  var expiry: String? {
    guard let expiresAt = value.expiresAt else {
      return nil
    }
    return LocalizableString.shared.get(with: .validUntil([expiresAt])).replacingOccurrences(of: "\n", with: "")
  }
}

#Preview {
  DocumentListView(
    filteredItems: DocumentUIModel.mocks(),
    isLoading: false,
    action: { filteredDocs in
      print("Filtered documents updated: \(filteredDocs)")
    }
  ) { _ in }
}
