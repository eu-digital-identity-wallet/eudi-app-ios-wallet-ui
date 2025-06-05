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
import feature_common
import logic_resources
import logic_core

struct TransactionDetailsView<Router: RouterHost>: View {

  @StateObject private var viewModel: TransactionDetailsViewModel<Router>

  init(with viewModel: TransactionDetailsViewModel<Router>) {
    self._viewModel = StateObject(wrappedValue: viewModel)
  }

  var body: some View {
    ContentScreenView(
      padding: .zero,
      canScroll: true,
      errorConfig: viewModel.viewState.error,
      navigationTitle: viewModel.viewState.title,
      isLoading: viewModel.viewState.isLoading,
      toolbarContent: viewModel.toolbarContent()
    ) {
      content(
        state: viewModel.viewState,
        onReportModal: viewModel.onReportModal,
        onShowDeleteModal: viewModel.onShowDeleteModal
      )
    }
    .task {
      await viewModel.getTransactionDetails()
    }
  }
}

@MainActor
@ViewBuilder
private func content(
  state: TransactionDetailsViewState,
  onReportModal: @escaping () -> Void,
  onShowDeleteModal: @escaping () -> Void
) -> some View {
  ScrollView {
    VStack(alignment: .leading, spacing: SPACING_LARGE_MEDIUM) {

      if let transactionDetailsCardData = state.transactionDetailsUi?.transactionDetailsCardData {
        TransactionCardView(
          transactionDetailsCardData: transactionDetailsCardData,
          isLoading: state.isLoading
        )
      }

      if let transactionDetailsDataSharedList = state.transactionDetailsUi?.items, !transactionDetailsDataSharedList.isEmpty {
        VStack(alignment: .leading, spacing: SPACING_SMALL) {
          Text(.transactionDetailsDataShare)
            .typography(Theme.shared.font.bodySmall)
            .fontWeight(.semibold)
            .foregroundStyle(Theme.shared.color.onSurfaceVariant)
            .shimmer(isLoading: state.isLoading)

          ForEach(transactionDetailsDataSharedList) { item in
            WrapExpandableListView(
              header: .init(
                mainText: .custom(item.title),
                supportingText: .viewDetails
              ),
              items: item.listItems,
              hideSensitiveContent: false,
              isLoading: state.isLoading
            )
          }
        }

        VStack(alignment: .leading, spacing: SPACING_MEDIUM) {
          VStack(alignment: .leading, spacing: SPACING_SMALL) {
            Text(.transactionDetailsRequestDeletionMessage)
              .font(Theme.shared.font.bodyLarge.font)
              .foregroundStyle(Theme.shared.color.onSurfaceVariant)
              .shimmer(isLoading: state.isLoading)

            WrapButtonView(
              style: .error,
              title: .transactionDetailsRequestDeletionButton,
              isLoading: state.isLoading,
              isEnabled: false,
              onAction: onShowDeleteModal()
            )
          }

          VStack(alignment: .leading, spacing: SPACING_SMALL) {
            Text(.transactionDetailsReportTransactionMessage)
              .font(Theme.shared.font.bodyLarge.font)
              .foregroundStyle(Theme.shared.color.onSurfaceVariant)
              .shimmer(isLoading: state.isLoading)

            WrapButtonView(
              style: .secondary,
              title: .transactionDetailsReportTransactionButton,
              isLoading: state.isLoading,
              isEnabled: false,
              onAction: onShowDeleteModal()
            )
          }
        }
      }
    }
    .padding(Theme.shared.dimension.padding)
    .padding(.bottom)
  }
}
