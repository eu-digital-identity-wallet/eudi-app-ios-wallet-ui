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
      allowBackGesture: false,
      errorConfig: viewModel.viewState.error,
      navigationTitle: LocalizableString.shared.get(with: .details),
      toolbarContent: ToolBarContent(
        trailingActions: [
          Action(image: viewModel.viewState.isBookmarked ? Theme.shared.image.bookmarkIconFill : Theme.shared.image.bookmarkIcon) {
            viewModel.saveBookmark(viewModel.viewState.document.id)
            viewModel.alertType = .bookmark
            viewModel.showAlert = true
          },
          Action(
            image: viewModel.isVisible ? Theme.shared.image.eyeSlash : Theme.shared.image.eye
          ) {
            viewModel.isVisible.toggle()
          }
        ],
        leadingActions: [
          Action(image: Theme.shared.image.chevronLeft) {
            viewModel.pop()
          }
        ]
      )
    ) {

      content(
        viewState: viewModel.viewState,
        isVisible: viewModel.isVisible
      ) {
        viewModel.alertType = .issuer
        viewModel.showAlert = true
      } onContinue: {
        viewModel.onContinue()
      } onShowDeleteModal: {
        viewModel.onShowDeleteModal()
      }
    }
    .confirmationDialog(
      title: "",
      message: LocalizableString.shared.get(with: .deleteDocumentConfirmDialog),
      destructiveText: LocalizableString.shared.get(with: .deleteButton),
      baseText: LocalizableString.shared.get(with: .cancelButton),
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
      title: alertTitle(),
      message: alertMessage(),
      buttonText: LocalizableString.shared.get(with: .close),
      onDismiss: {
        viewModel.showAlert = false
      }
    )
    .task {
      await self.viewModel.fetchDocumentDetails()
      await viewModel.bookmarked()
    }
  }

  private func alertTitle() -> String {
    if viewModel.alertType == .issuer {
      return LocalizableString.shared.get(with: .trustedRelyingParty)
    } else {
      if viewModel.viewState.isBookmarked {
        return LocalizableString.shared.get(with: .savedToFavorites)
      } else {
        return LocalizableString.shared.get(with: .removedFromFavorites)
      }
    }
  }

  private func alertMessage() -> String {
    if viewModel.alertType == .issuer {
      return LocalizableString.shared.get(with: .trustedRelyingPartyDescription)
    } else {
      if viewModel.viewState.isBookmarked {
        return LocalizableString.shared.get(with: .savedToFavoritesMessage)
      } else {
        return LocalizableString.shared.get(with: .removedFromFavoritesMessages)
      }
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
            ForEach(viewState.document.documentFields) { documentFieldContent in
              switch documentFieldContent.value {
              case .string(let value):
                WrapListItemView(
                  listItem: .init(
                    mainText: value,
                    overlineText: documentFieldContent.title,
                    isBlur: isVisible
                  ),
                  minHeight: false
                )
              case .image(let image):
                WrapListItemView(
                  listItem: .init(
                    mainText: documentFieldContent.title,
                    leadingIcon: (nil, image),
                    isBlur: isVisible
                  ),
                  minHeight: false
                )
              }
              if documentFieldContent != viewState.document.documentFields.last {
                Divider()
                  .padding(.horizontal, SPACING_MEDIUM)
                  .background(Theme.shared.color.onSurfaceVariant.opacity(0.2))
              }
            }
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
            title: issuer.name
          ) {
            showAlert()
          }
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
