/*
 * Copyright (c) 2026 European Commission
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
import feature_common
import logic_resources
import logic_core

struct TransactionActionHistoryView<Router: RouterHost>: View {

  @State private var viewModel: TransactionActionHistoryViewModel<Router>

  init(with viewModel: TransactionActionHistoryViewModel<Router>) {
    self._viewModel = State(wrappedValue: viewModel)
  }

  var body: some View {
    ContentScreenView(
      padding: .zero,
      canScroll: true,
      errorConfig: viewModel.viewState.error,
      navigationTitle: viewModel.viewState.ui.title,
      isLoading: viewModel.viewState.isLoading,
      toolbarContent: viewModel.toolbarContent()
    ) {
      TransactionActionHistoryViewContainer(state: viewModel.viewState)
    }
    .task {
      await viewModel.getContent()
    }
  }
}

private struct TransactionActionHistoryViewContainer: View {

  let state: TransactionActionHistoryViewState

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: SPACING_LARGE_MEDIUM) {

        Text(state.ui.disclaimer)
          .typography(Theme.shared.font.bodyMedium)
          .fontWeight(.bold)
          .foregroundStyle(Theme.shared.color.primaryLabel)
          .shimmer(isLoading: state.isLoading)

        if let authorityLabel = state.ui.authorityLabel, let authorityName = state.ui.authorityName {
          WrapCardView(backgroundColor: Theme.shared.color.groupedBackground) {
            VStack(alignment: .leading, spacing: SPACING_EXTRA_SMALL) {
              Text(authorityLabel)
                .typography(Theme.shared.font.labelSmall)
                .fontWeight(.semibold)
                .foregroundStyle(Theme.shared.color.secondaryLabel)

              Text(authorityName)
                .typography(Theme.shared.font.bodyLarge)
                .fontWeight(.medium)
                .foregroundStyle(Theme.shared.color.primaryLabel)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.all, SPACING_MEDIUM)
          }
          .shimmer(isLoading: state.isLoading)
        }

        Text(state.ui.message)
          .typography(Theme.shared.font.bodyMedium)
          .foregroundStyle(Theme.shared.color.primaryLabel)
          .shimmer(isLoading: state.isLoading)

        if !state.ui.entries.isEmpty {
          VStack(spacing: SPACING_MEDIUM_SMALL) {
            ForEach(state.ui.entries) { entry in
              WrapCardView(backgroundColor: Theme.shared.color.groupedElevatedBackground) {
                WrapListItemView(
                  listItem: .init(
                    id: entry.id,
                    mainContent: .text(entry.method),
                    supportingText: entry.date
                  ),
                  minHeight: false
                )
              }
              .shimmer(isLoading: state.isLoading)
            }
          }
        }
      }
      .padding(Theme.shared.dimension.padding)
      .padding(.bottom)
    }
  }
}
