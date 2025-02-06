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
import logic_ui
import feature_common
import logic_resources

struct DocumentDetailsView<Router: RouterHost>: View {

  @ObservedObject var viewModel: DocumentDetailsViewModel<Router>

  init(with viewModel: DocumentDetailsViewModel<Router>) {
    self.viewModel = viewModel
  }

  var body: some View {
    ContentScreenView(
      padding: .zero,
      canScroll: !viewModel.viewState.hasContinueButton,
      errorConfig: viewModel.viewState.error,
      navigationTitle: .details,
      toolbarContent: viewModel.toolbarContent()
    ) {

      content(
        viewState: viewModel.viewState,
        isVisible: viewModel.isVisible
      ) {
        viewModel.showAlert = true
      } onContinue: {
        viewModel.onContinue()
      } onShowDeleteModal: {
        viewModel.onShowDeleteModal()
      }
    }
    .confirmationDialog(
      title: .custom(""),
      message: .deleteDocumentConfirmDialog,
      destructiveText: .deleteDocument,
      baseText: .cancelButton,
      isPresented: $viewModel.isDeletionModalShowing,
      destructiveAction: {
        viewModel.onDeleteDocument()
      },
      baseAction: {
        viewModel.onShowDeleteModal()
      }
    )
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
      await viewModel.bookmarked()
    }
  }
}

@MainActor
@ViewBuilder
private func content(
  viewState: DocumentDetailsViewState,
  isVisible: Bool,
  showAlert: @escaping () -> Void,
  onContinue: @escaping () -> Void,
  onShowDeleteModal: @escaping () -> Void
) -> some View {
  ScrollView {
    VStack(alignment: .leading, spacing: SPACING_MEDIUM) {
      Text(viewState.document.documentName)
        .font(.largeTitle)
        .bold()
        .frame(maxWidth: .infinity, alignment: .leading)

      VStack(spacing: .zero) {
        WrapCardView {
          VStack(spacing: .zero) {
            WrapListItemsView(
              listItems: viewState.document.documentFields
            )
          }
        }
      }
      .shimmer(isLoading: viewState.isLoading)

      if let issuer = viewState.document.issuer {
        VStack(spacing: SPACING_SMALL) {
          Text(.genericIssuer)
            .typography(Theme.shared.font.bodySmall)
            .fontWeight(.semibold)
            .foregroundStyle(Theme.shared.color.onSurfaceVariant)
            .frame(maxWidth: .infinity, alignment: .leading)

          CardViewWithLogo(
            icon: .remoteImage(issuer.logoUrl, Theme.shared.image.logo),
            title: .custom(issuer.name)
          )
        }
        .shimmer(isLoading: viewState.isLoading)
      }

      if viewState.hasDeleteAction {
        WrapButtonView(
          style: .error,
          title: .deleteDocument,
          isLoading: viewState.isLoading,
          onAction: onShowDeleteModal()
        )
      }

      if viewState.hasContinueButton {
        WrapButtonView(
          style: .primary,
          title: .issuanceDetailsContinueButton,
          isLoading: viewState.isLoading,
          onAction: onContinue()
        )
      }
    }
    .padding(Theme.shared.dimension.padding)
    .padding(.bottom)
  }
}

#Preview {
  let viewState = DocumentDetailsViewState(
    document: DocumentDetailsUIModel.mock(),
    isLoading: false,
    error: nil,
    config: IssuanceDetailUiConfig(
      flow: .extraDocument("documentId")
    ),
    hasDeleteAction: true,
    documentFieldsCount: DocumentDetailsUIModel.mock().documentFields.count,
    isBookmarked: true
  )

  ContentScreenView(
    padding: .zero,
    canScroll: true
  ) {
    content(
      viewState: viewState,
      isVisible: true,
      showAlert: {},
      onContinue: {},
      onShowDeleteModal: {}
    )
  }
}
