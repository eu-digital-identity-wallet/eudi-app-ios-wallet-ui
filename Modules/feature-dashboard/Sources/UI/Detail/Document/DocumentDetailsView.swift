/*
 * Copyright (c) 2025 European Commission
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
import feature_common
import logic_resources

struct DocumentDetailsView<Router: RouterHost>: View {

  @State private var viewModel: DocumentDetailsViewModel<Router>

  init(with viewModel: DocumentDetailsViewModel<Router>) {
    self._viewModel = State(wrappedValue: viewModel)
  }

  var body: some View {
    ContentScreenView(
      padding: .zero,
      canScroll: true,
      errorConfig: viewModel.viewState.error,
      navigationTitle: .details,
      toolbarContent: viewModel.toolbarContent(),
      notificationActions: [
        .init(
          name: NSNotification.DocumentDetailsRefresh,
          callback: {
            guard let payload = $0 else { return }
            viewModel.handleRefreshNotification(for: payload)
          }
        ),
        .init(
          name: NSNotification.ReIssuanceDetailsRefresh,
          callback: {
            guard let payload = $0 else { return }
            viewModel.handleReIssuanceNotification(for: payload)
          }
        )
      ]
    ) {

      content(
        viewState: viewModel.viewState,
        isVisible: viewModel.isVisible,
        isDeletionModalShowing: $viewModel.isDeletionModalShowing
      ) {
        viewModel.onContinue()
      } onShowDeleteModal: {
        viewModel.onShowDeleteModal()
      } onDeleteDocument: {
        viewModel.onDeleteDocument()
      } issueNewDocument: {
        viewModel.issueNewDocument()
      } toggleIsVisible: {
        viewModel.toggleIsVisible()
      }
    }
    .alertView(
      isPresented: $viewModel.showReissuanceDialog,
      title: .custom(""),
      message: .custom(""),
      actions: {
        Button(.documentDetailsReIssueButton) {
          viewModel.issueNewDocument()
        }.disabled(
          viewModel.viewState.isRevoked
        )

        Button(.documentDetailsRemoveButton) {
          viewModel.onShowDeleteModal()
        }

        Button(.cancelButton, role: .cancel) {}
      }
    )
    .alertView(
      isPresented: $viewModel.showBookmarkAlert,
      title: viewModel.bookmarkAlertTitle(),
      message: viewModel.bookmarkAlertMessage(),
      actions: {
        Button(.close) {
          viewModel.showBookmarkAlert = false
        }
      }
    )
    .task {
      await viewModel.fetchDocumentDetails()
    }
  }
}

@MainActor
@ViewBuilder
private func content(
  viewState: DocumentDetailsViewState,
  isVisible: Bool,
  isDeletionModalShowing: Binding<Bool>,
  onContinue: @escaping () -> Void,
  onShowDeleteModal: @escaping () -> Void,
  onDeleteDocument: @escaping () -> Void,
  issueNewDocument: @escaping () -> Void,
  toggleIsVisible: @escaping () -> Void,
) -> some View {
  ScrollView {
    VStack(alignment: .leading, spacing: SPACING_LARGE_MEDIUM) {

      Text(viewState.document.documentName)
        .font(.largeTitle)
        .bold()
        .frame(maxWidth: .infinity, alignment: .leading)
        .shimmer(isLoading: viewState.isLoading)

      if let issuerDetailsCardDataUi = viewState.issuerDetailsCardDataUi {
        VStack(spacing: SPACING_SMALL) {

          Text(.genericIssuer)
            .typography(Theme.shared.font.bodySmall)
            .fontWeight(.semibold)
            .foregroundStyle(Theme.shared.color.onSurfaceVariant)
            .frame(maxWidth: .infinity, alignment: .leading)
            .shimmer(isLoading: viewState.isLoading)

          IssuerDetailsCardView(
            issuerDetails: issuerDetailsCardDataUi,
            isLoading: viewState.isLoading,
            onAction: issueNewDocument
          )
        }
        .zIndex(1)
      }

      VStack(spacing: SPACING_SMALL) {
        HStack {

          Text(.documentData)
            .typography(Theme.shared.font.bodySmall)
            .fontWeight(.semibold)
            .foregroundStyle(Theme.shared.color.onSurfaceVariant)
            .padding(.vertical, SPACING_SMALL)
            .shimmer(isLoading: viewState.isLoading)

          Spacer()

          Button {
            toggleIsVisible()
          } label: {
            (isVisible ? Theme.shared.image.eye : Theme.shared.image.eyeSlash)
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: 24, height: 24)
              .padding(.horizontal, SPACING_MEDIUM)
              .foregroundStyle(Theme.shared.color.onSurfaceVariant)
              .shimmer(isLoading: viewState.isLoading)
          }
          .accessibilityLocator(isVisible ? DocumentDetailsLocators.eyeSlash : DocumentDetailsLocators.eye)
        }

        WrapExpandableListView(
          items: viewState.document.documentFields,
          hideSensitiveContent: isVisible,
          isLoading: viewState.isLoading
        )
        .zIndex(0)
      }

      WrapButtonView(
        style: .error,
        title: .removeFromWallet,
        isLoading: viewState.isLoading,
        onAction: onShowDeleteModal()
      )
      .combineChilrenAccessibility(
        locator: DocumentDetailsLocators.deleteDocument
      )
      .confirmationDialog(
        .custom(""),
        isPresented: isDeletionModalShowing,
        actions: {
          Button(.documentDetailsRemoveButton, role: .destructive) {
            onDeleteDocument()
          }
          .accessibilityElement()
          .accessibilityIdentifier(DocumentDetailsLocators.confirmDialogDeleteButton.id)

          Button(.cancelButton) {
            onShowDeleteModal()
          }
          .accessibilityElement()
          .accessibilityIdentifier(DocumentDetailsLocators.confirmDialogDeleteButton.id)
        }, message: {
          Text(.deleteDocumentConfirmDialog)
        }
      )

      if let documentCredentialsInfo = viewState.documentCredentialsInfo {
        Text(documentCredentialsInfo.title)
          .font(Theme.shared.font.bodySmall.font)
          .padding(.vertical, SPACING_SMALL)
          .padding(.horizontal, SPACING_MEDIUM)
          .foregroundColor(Theme.shared.color.onSurfaceVariant)
          .frame(maxWidth: .infinity, alignment: .center)
          .shimmer(isLoading: viewState.isLoading)
      }
    }
    .padding(Theme.shared.dimension.padding)
    .padding(.bottom)
  }
}

#Preview {
  let viewState = DocumentDetailsViewState(
    document: DocumentUIModel.mock(),
    isLoading: false,
    error: nil,
    documentId: "",
    documentFieldsCount: DocumentUIModel.mock().documentFields.count,
    isBookmarked: true,
    isRevoked: false,
    documentCredentialsInfo: DocumentCredentialsInfoUi(
      availableCredentials: 5,
      totalCredentials: 10,
      title: .custom("instances remaining")
    ),
    issuerDetailsCardDataUi: IssuerDocumentDetailsCardUIModel(
      issuerName: .custom("issuer name"),
      issuerLogo: nil,
      documentState: .issued(
        issuanceDate: "issuanceDate",
        expirationDate: "expirationDate"
      )
    )
  )

  ContentScreenView(
    padding: .zero,
    canScroll: true
  ) {
    content(
      viewState: viewState,
      isVisible: true,
      isDeletionModalShowing: .constant(false),
      onContinue: {},
      onShowDeleteModal: {},
      onDeleteDocument: {},
      issueNewDocument: {},
      toggleIsVisible: {}
    )
  }
}
