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

struct TransactionDetailsView<Router: RouterHost>: View {

  @State private var viewModel: TransactionDetailsViewModel<Router>

  init(with viewModel: TransactionDetailsViewModel<Router>) {
    self._viewModel = State(wrappedValue: viewModel)
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
      TransactionDetailsViewContainer(
        state: viewModel.viewState,
        onReportModal: { viewModel.onReportModal() },
        onRequestDataDeletion: { viewModel.onRequestDataDeletion() },
        onPreviousActions: { viewModel.onPreviousActions($0) }
      )
    }
    .alertView(
      isPresented: $viewModel.isDeletionModalShowing,
      title: .transactionDetailsDeleteTitle,
      message: .transactionDetailsDeleteMessage,
      actions: {
        Button(.transactionDetailsDeleteButton, role: .destructive) {
          viewModel.onDeleteTransaction()
        }
        .accessibilityElement()
        .accessibilityIdentifier(TransactionDetailsLocators.confirmDialogDeleteButton.id)

        Button(.cancelButton, role: .cancel) {}
          .accessibilityElement()
          .accessibilityIdentifier(TransactionDetailsLocators.confirmDialogCancelButton.id)
      }
    )
    .onAppear {
      Task { await viewModel.getTransactionDetails() }
    }
  }
}

private struct TransactionDetailsViewContainer: View {

  @Environment(\.openURL) private var openURL

  let state: TransactionDetailsViewState
  let onReportModal: () -> Void
  let onRequestDataDeletion: () -> Void
  let onPreviousActions: (TransactionDataProtectionAction) -> Void

  var body: some View {
    content()
  }

  @MainActor
  @ViewBuilder
  private func content() -> some View {
    ScrollView {
      VStack(alignment: .leading, spacing: SPACING_LARGE_MEDIUM) {

        if let transactionDetailsCardData = state.transactionDetailsUi?.transactionDetailsCardData {
          TransactionCardView(
            transactionDetailsCardData: transactionDetailsCardData,
            isLoading: state.isLoading
          )
        }

        ForEach(state.transactionDetailsUi?.sections ?? []) { section in
          sectionView(section)
        }

        if let actions = state.transactionDetailsUi?.presentationActions {
          presentationActions(actions)
        }
      }
      .padding(Theme.shared.dimension.padding)
      .padding(.bottom)
    }
  }

  @MainActor
  @ViewBuilder
  private func sectionView(_ section: TransactionDetailsSectionUi) -> some View {
    VStack(alignment: .leading, spacing: SPACING_SMALL) {
      Text(section.title)
        .typography(Theme.shared.font.bodySmall)
        .fontWeight(.semibold)
        .foregroundStyle(Theme.shared.color.secondaryLabel)
        .shimmer(isLoading: state.isLoading)

      if section.isEmpty {
        WrapCardView(backgroundColor: Theme.shared.color.groupedElevatedBackground) {
          WrapListItemView(
            listItem: .init(id: "\(section.id):empty", mainContent: .text(section.emptyText)),
            mainTextVerticalPadding: SPACING_SMALL,
            minHeight: false
          )
        }
        .shimmer(isLoading: state.isLoading)
      }

      if !section.fields.isEmpty {
        WrapCardView(backgroundColor: Theme.shared.color.groupedElevatedBackground) {
          VStack(spacing: SPACING_SMALL) {
            ForEach(section.fields) { field in
              WrapListItemView(
                listItem: field.listItem,
                minHeight: false
              ) {
                if let url = field.url {
                  openURL(url)
                }
              }
            }
          }
        }
        .shimmer(isLoading: state.isLoading)
      }

      ForEach(section.groups) { group in
        WrapExpandableListView(
          header: .init(
            mainContent: .text(.custom(group.title)),
            supportingText: .viewDetails
          ),
          items: group.listItems,
          backgroundColor: Theme.shared.color.groupedElevatedBackground,
          hideSensitiveContent: false,
          isLoading: state.isLoading
        )
      }
    }
  }

  @MainActor
  @ViewBuilder
  private func presentationActions(_ actions: TransactionPresentationActionsUi) -> some View {
    VStack(alignment: .leading, spacing: SPACING_LARGE_MEDIUM) {
      actionSection(
        title: .transactionDetailsRequestDeletionSection,
        message: .transactionDetailsRequestDeletionMessage,
        buttonStyle: .error,
        buttonTitle: .transactionDetailsRequestDeletionButton,
        isEnabled: !actions.deletionContacts.isEmpty,
        previous: actions.dataDeletionRequests > 0
          ? .transactionDetailsPreviousDeletionRequests([String(actions.dataDeletionRequests)])
          : nil,
        onAction: onRequestDataDeletion,
        onPrevious: { onPreviousActions(.requestDataDeletion) }
      )

      actionSection(
        title: .transactionDetailsReportSection,
        message: .transactionDetailsReportTransactionMessage,
        buttonStyle: .secondary,
        buttonTitle: .transactionDetailsReportTransactionButton,
        isEnabled: !actions.reportContacts.isEmpty,
        previous: actions.dpaReports > 0
          ? .transactionDetailsPreviousReports([String(actions.dpaReports)])
          : nil,
        onAction: onReportModal,
        onPrevious: { onPreviousActions(.reportSuspiciousTransaction) }
      )
    }
  }

  @MainActor
  @ViewBuilder
  private func actionSection(
    title: LocalizableStringKey,
    message: LocalizableStringKey,
    buttonStyle: ButtonViewStyle,
    buttonTitle: LocalizableStringKey,
    isEnabled: Bool,
    previous: LocalizableStringKey?,
    onAction: @escaping () -> Void,
    onPrevious: @escaping () -> Void
  ) -> some View {
    VStack(alignment: .leading, spacing: SPACING_MEDIUM_SMALL) {
      Text(title)
        .typography(Theme.shared.font.bodySmall)
        .fontWeight(.semibold)
        .foregroundStyle(Theme.shared.color.secondaryLabel)
        .shimmer(isLoading: state.isLoading)

      Text(message)
        .typography(Theme.shared.font.bodyMedium)
        .foregroundStyle(Theme.shared.color.primaryLabel)
        .shimmer(isLoading: state.isLoading)

      if let previous {
        Button(action: onPrevious) {
          HStack(spacing: SPACING_SMALL) {
            Text(previous)
              .typography(Theme.shared.font.bodyMedium)
              .fontWeight(.medium)
              .foregroundStyle(Theme.shared.color.accent)

            Theme.shared.image.chevronRight
              .renderingMode(.template)
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: 16, height: 16)
              .foregroundStyle(Theme.shared.color.accent)
          }
        }
        .disabled(state.isLoading)
        .shimmer(isLoading: state.isLoading)
      }

      WrapButtonView(
        style: buttonStyle,
        title: buttonTitle,
        isLoading: state.isLoading,
        isEnabled: isEnabled,
        onAction: onAction()
      )
    }
  }
}
