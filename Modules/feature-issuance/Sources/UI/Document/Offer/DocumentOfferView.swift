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
import feature_common

struct DocumentOfferView<Router: RouterHost>: View {

  @State private var viewModel: DocumentOfferViewModel<Router>

  init(with viewModel: DocumentOfferViewModel<Router>) {
    self._viewModel = State(wrappedValue: viewModel)
  }

  var body: some View {
    ContentScreenView(
      errorConfig: viewModel.viewState.error,
      navigationTitle: .addDocumentRequest,
      toolbarContent: viewModel.toolbarContent(),
      notificationActions: [
        .init(
          name: NSNotification.CredentialOffer,
          callback: {
            guard let payload = $0 else { return }
            viewModel.handleNotification(with: payload)
          }
        )
      ]
    ) {
      DocumentOfferViewContainer(
        viewState: viewModel.viewState,
        onIssueDocuments: viewModel.onIssueDocuments
      )
    }
    .sheetDialog(isPresented: $viewModel.isIssuerNotTrustedSheetShowing) {
      TrustBlockedSheetContent(
        title: .issuanceBlockedTitle,
        message: .issuanceBlockedMessage,
        onClose: { viewModel.isIssuerNotTrustedSheetShowing = false }
      )
    }
    .task {
      await viewModel.initialize()
    }
  }
}

private struct DocumentOfferViewContainer: View {

  let viewState: DocumentOfferViewState
  let onIssueDocuments: () -> Void

  var body: some View {
    content()
  }

  @MainActor
  @ViewBuilder
  private func content() -> some View {
    if viewState.documentOfferUiModel.uiOffers.isEmpty {
      noDocumentsFound()
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
          accessibilityDescription: DocumentOfferLocators.headerDescription
        )

        VStack(alignment: .leading, spacing: SPACING_MEDIUM) {

          ForEach(viewState.documentOfferUiModel.uiOffers) { cell in
            WrapCardView(
              backgroundColor: Theme.shared.color.groupedElevatedBackground
            ) {
              DocumentOfferCellView(
                cellModel: cell,
                isLoading: viewState.isLoading
              )
            }
          }

          Text(.shareDataReview)
            .typography(Theme.shared.font.bodyMedium)
            .foregroundColor(Theme.shared.color.primaryLabel)
            .multilineTextAlignment(.leading)
            .shimmer(isLoading: viewState.isLoading)

          VSpacer.medium()
        }
      }
    }
    .safeAreaInset(edge: .bottom) {
      issueButton()
    }
  }

  @MainActor
  @ViewBuilder
  private func issueButton() -> some View {
    WrapButtonView(
      style: .primary,
      title: .issueButton,
      isLoading: viewState.isLoading,
      isEnabled: viewState.allowIssue,
      onAction: onIssueDocuments()
    )
    .combineChilrenAccessibility(
      locator: DocumentOfferLocators.issueButton
    )
  }

  @MainActor
  @ViewBuilder
  private func noDocumentsFound() -> some View {
    VStack(spacing: .zero) {
      ContentHeaderView(
        config: viewState.contentHeaderConfig
      )
      Spacer()
      ContentEmptyView(
        title: .requestCredentialOfferNoDocument
      )
      Spacer()
    }
  }
}

#Preview {
  let viewState = DocumentOfferViewState(
    isLoading: false,
    documentOfferUiModel: DocumentOfferUIModel.mock(),
    error: nil,
    config: UIConfig.Generic(
      arguments: ["uri": "uri"],
      navigationSuccessType: .push(.featureDashboardModule(.dashboard)),
      navigationCancelType: .pop
    ),
    offerUri: "offer uri",
    allowIssue: true,
    initialized: true,
    contentHeaderConfig: .init(
      appIconAndTextData: AppIconAndTextData(
        appIcon: ThemeManager.shared.image.logoEuDigitalIndentityWallet
      )
    )
  )

  ContentScreenView {
    DocumentOfferViewContainer(
      viewState: viewState,
      onIssueDocuments: {}
    )
  }
}

#Preview("No document") {
  let viewState = DocumentOfferViewState(
    isLoading: false,
    documentOfferUiModel: .init(
      issuerName: LocalizableStringKey.unknownIssuer.toString,
      issuerLogo: nil,
      txCode: nil,
      uiOffers: [],
      docOffers: []
    ),
    error: nil,
    config: UIConfig.Generic(
      arguments: ["uri": "uri"],
      navigationSuccessType: .push(.featureDashboardModule(.dashboard)),
      navigationCancelType: .pop
    ),
    offerUri: "offer uri",
    allowIssue: true,
    initialized: true,
    contentHeaderConfig: .init(
      appIconAndTextData: AppIconAndTextData(
        appIcon: ThemeManager.shared.image.logoEuDigitalIndentityWallet
      )
    )
  )

  ContentScreenView {
    DocumentOfferViewContainer(
      viewState: viewState,
      onIssueDocuments: {}
    )
  }
}
