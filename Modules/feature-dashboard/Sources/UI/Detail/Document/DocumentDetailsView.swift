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
      notificationAction: .init(
        name: NSNotification.RevocationDocumentDetailsRefresh,
        callback: {
          guard let payload = $0 else { return }
          viewModel.handleRevocationNotification(for: payload)
        }
      )
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
      }
    }
    .alertView(
      isPresented: $viewModel.showAlert,
      title: viewModel.alertTitle(),
      message: viewModel.alertMessage(),
      buttonText: .close,
      onDismiss: {
        viewModel.showAlert = false
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
  issueNewDocument: @escaping () -> Void
) -> some View {
  ScrollView {
    VStack(alignment: .leading, spacing: SPACING_MEDIUM) {

      Text(viewState.document.documentName)
        .font(.largeTitle)
        .bold()
        .frame(maxWidth: .infinity, alignment: .leading)
        .shimmer(isLoading: viewState.isLoading)

      if viewState.isRevoked {
        RevokedDocumentView(
          message: .documentDetailsRevokedDocumentMessage
        )
      }

      if let credentialsInfo = viewState.documentCredentialsInfo {
        ExpandableDocumentCredentialsView(
          documentCredentialsInfo: credentialsInfo,
          onPrimaryButtonClicked: issueNewDocument
        )
      }

      VStack(spacing: .zero) {
        WrapExpandableListView(
          items: viewState.document.documentFields,
          hideSensitiveContent: isVisible,
          isLoading: viewState.isLoading
        )
      }

      if let issuer = viewState.document.issuer {
        VStack(spacing: SPACING_SMALL) {
          Text(.genericIssuer)
            .typography(Theme.shared.font.bodySmall)
            .fontWeight(.semibold)
            .foregroundStyle(Theme.shared.color.onSurfaceVariant)
            .frame(maxWidth: .infinity, alignment: .leading)
            .shimmer(isLoading: viewState.isLoading)

          CardViewWithLogoView(
            icon: .remoteImage(issuer.logoUrl, nil),
            title: .custom(issuer.name),
            isLoading: viewState.isLoading
          )
        }
      }

      WrapButtonView(
        style: .error,
        title: .deleteDocument,
        isLoading: viewState.isLoading,
        onAction: onShowDeleteModal()
      )
      .confirmationDialog(
        .custom(""),
        isPresented: isDeletionModalShowing,
        actions: {
          Button(.deleteDocument, role: .destructive) {
            onDeleteDocument()
          }
          Button(.cancelButton) {
            onShowDeleteModal()
          }
        }, message: {
          Text(.deleteDocumentConfirmDialog)
        }
      )
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
    isRevoked: true,
    documentCredentialsInfo: DocumentCredentialsInfoUi(
      availableCredentials: 5,
      totalCredentials: 10,
      title: .custom("instances remaining"),
      collapsedInfo: CollapsedInfo(
        moreInfoText: .custom("More Info")
      ),
      expandedInfo: ExpandedInfo(
        subtitle: .custom("For security reasons, this document can be shared a limited number of times before it needs to be re-issued by the issuing authority."),
        updateNowButtonText: .custom("Update now"),
        hideButtonText: .custom("Hide")
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
      issueNewDocument: {}
    )
  }
}
