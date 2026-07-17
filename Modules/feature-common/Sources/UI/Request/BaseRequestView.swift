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
import logic_ui
import logic_resources

public struct BaseRequestView<Router: RouterHost>: View {

  @State private var viewModel: BaseRequestViewModel<Router>

  public init(with router: Router, viewModel: BaseRequestViewModel<Router>) {
    self._viewModel = State(wrappedValue: viewModel)
  }

  public var body: some View {
    ContentScreenView(
      padding: .zero,
      canScroll: true,
      errorConfig: viewModel.viewState.error,
      navigationTitle: .dataSharingRequest,
      toolbarContent: viewModel.toolbarContent()
    ) {
      BaseRequestViewContainer(
        viewState: viewModel.viewState,
        onShare: viewModel.onShare,
        onSelectionChanged: { id in
          Task {
            await viewModel.onSelectionChanged(id: id)
          }
        },
        onCombinationSelected: { index in
          viewModel.onCombinationSelected(index: index)
        },
        onCombinationItemClick: { index, id in
          Task {
            await viewModel.onCombinationItemClick(combinationIndex: index, id: id)
          }
        }
      )
    }
    .confirmationDialog(
      .requestDataInfoNotice,
      isPresented: $viewModel.isRequestInfoModalShowing,
      actions: {
        Button(.okButton) {
          viewModel.onShowRequestInfoModal()
        }
      }, message: {
        Text(.requestDataSheetCaption)
      }
    )
    .confirmationDialog(
      viewModel.getTrustedRelyingParty(),
      isPresented: $viewModel.isVerifiedEntityModalShowing,
      actions: {
        Button(.okButton) {
          viewModel.onVerifiedEntityModal()
        }
      }, message: {
        Text(viewModel.getTrustedRelyingPartyInfo())
      }
    )
    .task {
      if !viewModel.viewState.initialized {
        await viewModel.doWork()
      }
    }
    .alertView(
      isPresented: $viewModel.itemsChanged,
      title: .custom(""),
      message: .incompleteRequestDataSelection,
      actions: {
        Button(.okButton) {}
      }
    )
    .sheetDialog(isPresented: $viewModel.isVerifierNotTrustedSheetShowing) {
      TrustBlockedSheetContent(
        title: .presentationBlockedTitle,
        message: .presentationBlockedMessage,
        onClose: { viewModel.onVerifierNotTrustedClose() }
      )
    }
  }
}

private struct BaseRequestViewContainer: View {

  let viewState: RequestViewState
  let onShare: () -> Void
  let onSelectionChanged: (String) -> Void
  var onCombinationSelected: (Int) -> Void = { _ in }
  var onCombinationItemClick: (Int, String) -> Void = { _, _ in }

  var body: some View {
    content()
  }

  @MainActor
  @ViewBuilder
  private func content() -> some View {
    let errorTitle =
      viewState.errorTitle
      ?? (viewState.items.isEmpty ? .requestDataNoDocument : nil)

    if let errorTitle {
      noDocumentsFound(errorTitle: errorTitle)
    } else {
      scrollableContent()
    }
  }

  @MainActor
  @ViewBuilder
  private func scrollableContent() -> some View {
    ScrollView {
      VStack(spacing: .zero) {
        ContentHeaderView(
          config: viewState.contentHeaderConfig,
          accessibilityDescription: BaseRequestLocators.description
        )
        .padding(.horizontal, Theme.shared.dimension.padding)

        ZStack {
          VStack(alignment: .leading, spacing: SPACING_MEDIUM) {

            if viewState.combinations.count > 1 {
              combinationsContent()
            } else {
              singleCombinationContent()
            }

            Text(.shareDataReview)
              .typography(Theme.shared.font.bodyMedium)
              .foregroundColor(Theme.shared.color.primaryLabel)
              .multilineTextAlignment(.leading)
              .shimmer(isLoading: viewState.isLoading)

            VSpacer.medium()
          }
          .padding(.top, Theme.shared.dimension.padding)
        }
        .padding(Theme.shared.dimension.padding)
      }
    }
    .safeAreaInset(edge: .bottom) {
      shareButton()
    }
  }

  @MainActor
  @ViewBuilder
  private func singleCombinationContent() -> some View {
    ForEach(viewState.items.indices, id: \.self) { index in
      documentSection(
        viewState.items[index],
        onItemClick: { onSelectionChanged($0) }
      )
      .accessibilityElement()
      .combineChilrenAccessibility(
        locator: BaseRequestLocators.requestedDocument(index.string)
      )
    }
  }

  @MainActor
  @ViewBuilder
  private func combinationsContent() -> some View {
    ForEach(viewState.combinations.indices, id: \.self) { index in
      WrapSelectableCardView(
        title: .requestCombinationTitle(["\(index + 1)", "\(viewState.combinations.count)"]),
        isSelected: index == viewState.selectedCombinationIndex,
        onSelected: { onCombinationSelected(index) },
        content: {
          VStack(alignment: .leading, spacing: SPACING_MEDIUM) {
            ForEach(viewState.combinations[index].indices, id: \.self) { sectionIndex in
              documentSection(
                viewState.combinations[index][sectionIndex],
                onItemClick: { onCombinationItemClick(index, $0) }
              )
            }
          }
        }
      )
      .accessibilityElement()
      .combineChilrenAccessibility(
        locator: BaseRequestLocators.requestedDocument(index.string)
      )
    }
  }

  @MainActor
  @ViewBuilder
  private func documentSection(
    _ section: RequestDataUiModel,
    onItemClick: @escaping (String) -> Void
  ) -> some View {
    WrapExpandableListView(
      header: .init(
        mainContent: .text(.custom(section.section.title)),
        supportingText: .viewDetails
      ),
      items: section.section.listItems,
      backgroundColor: Theme.shared.color.groupedElevatedBackground,
      hideSensitiveContent: false,
      isLoading: viewState.isLoading,
      onItemClick: { onItemClick($0.groupId) }
    )
  }

  @MainActor
  @ViewBuilder
  private func shareButton() -> some View {
    WrapButtonView(
      style: .primary,
      title: .shareButton,
      isLoading: viewState.isLoading,
      isEnabled: viewState.allowShare,
      onAction: onShare()
    )
    .combineChilrenAccessibility(
      locator: BaseRequestLocators.shareButton
    )
    .padding(.horizontal, SPACING_MEDIUM)
    .padding(.bottom, SPACING_LARGE_MEDIUM)
  }

  @MainActor
  @ViewBuilder
  private func noDocumentsFound(errorTitle: LocalizableStringKey) -> some View {
    VStack(spacing: .zero) {
      ContentHeaderView(
        config: viewState.contentHeaderConfig,
        accessibilityDescription: BaseRequestLocators.description
      )
      .padding(.horizontal, Theme.shared.dimension.padding)

      VStack(spacing: .zero) {
        Spacer()
        ContentEmptyView(
          title: errorTitle
        )
        Spacer()
      }
      .padding(.horizontal, Theme.shared.dimension.padding)
    }
  }
}

#Preview {
  let viewState = RequestViewState(
    isLoading: false,
    error: nil,
    errorTitle: nil,
    showMissingCredentials: false,
    items: RequestDataUiModel.mockData(),
    combinations: [RequestDataUiModel.mockData()],
    selectedCombinationIndex: 0,
    trustedRelyingPartyInfo: .requestDataVerifiedEntityMessage,
    relyingParty: .custom("relying party"),
    isTrusted: true,
    allowShare: true,
    originator: .featureDashboardModule(.dashboard),
    initialized: true,
    contentHeaderConfig: .init(
      appIconAndTextData: AppIconAndTextData(
        appIcon: ThemeManager.shared.image.logoEuDigitalIndentityWallet
      )
    )
  )

  ContentScreenView {
    BaseRequestViewContainer(
      viewState: viewState,
      onShare: {},
      onSelectionChanged: { _ in }
    )
  }
}
