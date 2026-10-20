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
        isRiskAcknowledged: $viewModel.isRiskAcknowledged,
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
    .alertView(
      isPresented: $viewModel.isTrustBlockedAlertShowing,
      title: .presentationBlockedTitle,
      message: .presentationBlockedMessage,
      actions: {
        Button(.close) { viewModel.onTrustBlockedClose() }
      }
    )
  }
}

private struct BaseRequestViewContainer: View {

  let viewState: RequestViewState
  @Binding var isRiskAcknowledged: Bool
  let onShare: () -> Void
  let onSelectionChanged: (String) -> Void
  var onCombinationSelected: (Int) -> Void = { _ in }
  var onCombinationItemClick: (Int, String) -> Void = { _, _ in }

  private var registrationWarning: RegistrationWarning? {
    guard viewState.initialized, !viewState.isLoading else { return nil }
    return viewState.registrationWarning
  }

  private var canShare: Bool {
    viewState.allowShare && (registrationWarning == nil || isRiskAcknowledged)
  }

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
      VStack(alignment: .leading, spacing: SPACING_MEDIUM) {

        if let registration = viewState.relyingPartyRegistration {
          RelyingPartyRegistrationView(data: registration)
            .shimmer(isLoading: viewState.isLoading)
        }

        titledSection(.requestRequestedDataTitle) {
          if viewState.combinations.count > 1 {
            combinationsContent()
          } else {
            singleCombinationContent()
          }
        }

        VSpacer.medium()
      }
      .padding(Theme.shared.dimension.padding)
    }
    .safeAreaInset(edge: .bottom, spacing: .zero) {
      bottomBar()
    }
  }

  @MainActor
  @ViewBuilder
  private func bottomBar() -> some View {
    VStack(spacing: SPACING_MEDIUM) {
      if let registrationWarning {
        WarningAcknowledgementView(
          message: registrationWarning.message,
          acknowledgementText: registrationWarning.acknowledgement,
          isAcknowledged: $isRiskAcknowledged
        )
        .padding(.horizontal, Theme.shared.dimension.padding)
      }

      shareButton()
    }
    .padding(.top, SPACING_MEDIUM)
    .background(Theme.shared.color.background)
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
    VStack(alignment: .leading, spacing: SPACING_MEDIUM) {
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

      if !section.transactionData.isEmpty {
        titledSection(.requestTransactionDataSectionTitle) {
          ForEach(section.transactionData) { transaction in
            transactionDataSection(transaction)
          }
        }
      }
    }
  }

  @MainActor
  @ViewBuilder
  private func titledSection<Content: View>(
    _ title: LocalizableStringKey,
    @ViewBuilder content: () -> Content
  ) -> some View {
    VStack(alignment: .leading, spacing: SPACING_SMALL) {
      Text(title)
        .typography(Theme.shared.font.bodyMedium)
        .fontWeight(.semibold)
        .foregroundColor(Theme.shared.color.primaryLabel)
        .shimmer(isLoading: viewState.isLoading)

      VStack(alignment: .leading, spacing: SPACING_MEDIUM) {
        content()
      }
    }
  }

  @MainActor
  @ViewBuilder
  private func transactionDataSection(_ transaction: PresentationListItemSection) -> some View {
    WrapExpandableListView(
      header: .init(
        mainContent: .text(.custom(transaction.title)),
        supportingText: .viewDetails
      ),
      items: transaction.listItems,
      backgroundColor: Theme.shared.color.groupedElevatedBackground,
      hideSensitiveContent: false,
      isLoading: viewState.isLoading
    )
  }

  @MainActor
  @ViewBuilder
  private func shareButton() -> some View {
    WrapButtonView(
      style: .primary,
      title: .shareButton,
      isLoading: viewState.isLoading,
      isEnabled: canShare,
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
      if let registration = viewState.relyingPartyRegistration {
        RelyingPartyRegistrationView(data: registration)
          .padding(.horizontal, Theme.shared.dimension.padding)
      }

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
    relyingParty: .custom("relying party"),
    isTrusted: true,
    allowShare: true,
    originator: .featureDashboardModule(.dashboard),
    initialized: true,
    relyingPartyRegistration: RelyingPartyRegistrationData(
      primary: RegisteredParty(
        name: .custom("NordicBank A/S"),
        identifier: .relyingPartyId(["rp:nordicbank:prod"]),
        isVerified: true
      ),
      privacyPolicyUrl: URL(string: "https://nordicbank.example/privacy"),
      intendedUse: .custom(
        "We will use your identity and age to verify you for a new current account. Your data will be used once to complete onboarding and to meet anti-money laundering requirements."
      )
    ),
    registrationWarning: nil
  )

  ContentScreenView {
    BaseRequestViewContainer(
      viewState: viewState,
      isRiskAcknowledged: .constant(false),
      onShare: {},
      onSelectionChanged: { _ in }
    )
  }
}
