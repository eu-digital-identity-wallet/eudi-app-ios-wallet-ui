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
import logic_resources

struct DocumentOfferView<Router: RouterHost>: View {

  @ObservedObject var viewModel: DocumentOfferViewModel<Router>

  init(with viewModel: DocumentOfferViewModel<Router>) {
    self.viewModel = viewModel
  }

  var body: some View {
    ContentScreenView(errorConfig: viewModel.viewState.error) {

      content(
        viewState: viewModel.viewState,
        imageSize: getScreenRect().width / 4,
        onIssueDocuments: viewModel.onIssueDocuments,
        onShowCancelModal: viewModel.onShowCancelModal
      )
    }
    .sheetDialog(isPresented: $viewModel.isCancelModalShowing) {
      SheetContentView {
        VStack(spacing: SPACING_MEDIUM) {

          ContentTitleView(
            title: .cancelIssueSheetTitle,
            caption: .cancelIssueSheetCaption
          )

          WrapButtonView(style: .primary, title: .cancelIssueSheetContinue, onAction: viewModel.onShowCancelModal())
          WrapButtonView(style: .secondary, title: .cancelButton, onAction: viewModel.onPop())
        }
      }
    }
    .task {
      await viewModel.initialize()
    }
    .onReceive(NotificationCenter.default.publisher(for: NSNotification.CredentialOffer)) { data in
      guard let payload = data.userInfo else {
        return
      }
      viewModel.handleNotification(with: payload)
    }
  }
}

@MainActor
@ViewBuilder
private func content(
  viewState: DocumentOfferViewState,
  imageSize: CGFloat,
  onIssueDocuments: @escaping () -> Void,
  onShowCancelModal: @escaping () -> Void
) -> some View {
  ContentTitleView(
    title: viewState.title,
    caption: .requestCredentialOfferCaption,
    topSpacing: .withoutToolbar,
    isLoading: viewState.isLoading
  )

  VSpacer.small()

  if viewState.documentOfferUiModel.uiOffers.isEmpty {
    noDocumentsFound(imageSize: imageSize)
  } else {
    ScrollView {
      VStack(spacing: SPACING_SMALL) {

        ForEach(viewState.documentOfferUiModel.uiOffers) { cell in
          DocumentOfferCellView(
            cellModel: cell,
            isLoading: viewState.isLoading
          )
        }
      }
      .padding(.top)
    }
    .bottomFade()
  }

  Spacer()

  VStack(spacing: SPACING_MEDIUM) {
    WrapButtonView(
      style: .primary,
      title: .issueButton,
      isLoading: viewState.isLoading,
      isEnabled: viewState.allowIssue && !viewState.isLoading,
      onAction: onIssueDocuments()
    )
    WrapButtonView(
      style: .secondary,
      title: .cancelButton,
      onAction: onShowCancelModal()
    )
  }
}

@MainActor
@ViewBuilder
private func noDocumentsFound(imageSize: CGFloat) -> some View {
  VStack(alignment: .center) {

    Spacer()

    VStack(alignment: .center, spacing: SPACING_MEDIUM) {

      Theme.shared.image.exclamationmarkCircle
        .renderingMode(.template)
        .resizable()
        .foregroundStyle(Theme.shared.color.textSecondaryDark)
        .frame(width: imageSize, height: imageSize)

      Text(.requestCredentialOfferNoDocument)
        .typography(Theme.shared.font.bodyMedium)
        .foregroundColor(Theme.shared.color.textSecondaryDark)
        .multilineTextAlignment(.center)
    }

    Spacer()
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
    initialized: true
  )

  ContentScreenView {
    content(
      viewState: viewState,
      imageSize: UIScreen.main.bounds.width / 4,
      onIssueDocuments: {},
      onShowCancelModal: {}
    )
  }
}

#Preview("No document") {
  let viewState = DocumentOfferViewState(
    isLoading: false,
    documentOfferUiModel: .init(
      issuerName: LocalizableString.shared.get(with: .unknownIssuer),
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
    initialized: true
  )

  ContentScreenView {
    content(
      viewState: viewState,
      imageSize: UIScreen.main.bounds.width / 4,
      onIssueDocuments: {},
      onShowCancelModal: {}
    )
  }
}
