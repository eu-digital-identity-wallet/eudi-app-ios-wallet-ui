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

public struct DocumentOfferView<Router: RouterHost>: View {

  @ObservedObject var viewModel: DocumentOfferViewModel<Router>

  public init(
    with router: Router,
    and interactor: DocumentOfferInteractor,
    config: any UIConfigType
  ) {
    self.viewModel = .init(router: router, interactor: interactor, config: config)
  }

  public var body: some View {
    ContentScreenView(errorConfig: viewModel.viewState.error) {

      ContentTitleView(
        title: viewModel.viewState.title,
        caption: .requestCredentialOfferCaption,
        topSpacing: .withoutToolbar,
        isLoading: viewModel.viewState.isLoading
      )

      VSpacer.small()

      if viewModel.viewState.documentOfferUiModel.uiOffers.isEmpty {
        noDocumentsFound
      } else {
        ScrollView {
          VStack(spacing: SPACING_SMALL) {

            ForEach(viewModel.viewState.documentOfferUiModel.uiOffers) { cell in
              DocumentOfferCellView(
                cellModel: cell,
                isLoading: viewModel.viewState.isLoading
              )
            }
          }
          .padding(.top)
        }
        .bottomFade()
      }

      Spacer()

      footer
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
      await viewModel.processRequest()
    }
    .onReceive(NotificationCenter.default.publisher(for: NSNotification.CredentialOffer)) { data in
      guard let payload = data.userInfo else {
        return
      }
      viewModel.handleNotification(with: payload)
    }
  }

  var noDocumentsFound: some View {
    VStack(alignment: .center) {

      Spacer()

      VStack(alignment: .center, spacing: SPACING_MEDIUM) {

        let imageSize = getScreenRect().width / 4

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

  private var footer: some View {
    VStack(spacing: SPACING_MEDIUM) {
      WrapButtonView(
        style: .primary,
        title: .issueButton,
        isLoading: viewModel.viewState.isLoading,
        isEnabled: viewModel.viewState.allowIssue && !viewModel.viewState.isLoading,
        onAction: viewModel.onIssueDocuments()
      )
      WrapButtonView(
        style: .secondary,
        title: .cancelButton,
        onAction: viewModel.onShowCancelModal()
      )
    }
  }
}
