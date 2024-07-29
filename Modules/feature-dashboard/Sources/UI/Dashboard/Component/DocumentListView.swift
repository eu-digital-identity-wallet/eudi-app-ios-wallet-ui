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
    ScrollView {
      LazyVGrid(
        columns: [GridItem(), GridItem()],
        spacing: SPACING_SMALL
      ) {
        ForEach(items) { item in
          switch item.value.state {
          case .issued:
            DocumentCellView(
              item: item,
              isLoading: isLoading,
              action: { item in
                action(item)
              }
            )
            .disabled(isLoading)
          case .pending:
            DocumentDeferredCellView(
              item: item,
              isLoading: isLoading,
              color: Theme.shared.color.warning,
              icon: Theme.shared.image.clockIndicator,
              status: .pending,
              action: { item in
                action(item)
              }
            )
            .disabled(isLoading)
          case .failed:
            DocumentDeferredCellView(
              item: item,
              isLoading: isLoading,
              color: Theme.shared.color.error,
              icon: Theme.shared.image.errorIndicator,
              status: .issuanceFailed,
              action: { item in
                action(item)
              }
            )
            .disabled(isLoading)
          }
        }
      }
      .padding(SPACING_LARGE)
    }
  }
}
