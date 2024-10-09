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

  @ViewBuilder
  func content() -> some View {
    ScrollView {
      VStack(spacing: .zero) {

        VSpacer.medium()

        ForEach(viewModel.viewState.document.documentFields) { documentFieldContent in

          switch documentFieldContent.value {
          case .string(let value):
            KeyValueView(
              title: .custom(documentFieldContent.title),
              subTitle: .custom(value),
              isLoading: viewModel.viewState.isLoading
            )
          case .image(let data):
            KeyValueView(
              title: .custom(documentFieldContent.title),
              image: Image(data: data),
              isLoading: viewModel.viewState.isLoading
            )
          }

          VSpacer.medium()
        }
      }
      .padding(.horizontal, Theme.shared.dimension.padding)
    }
    .if(viewModel.viewState.hasContinueButton) {
      $0.bottomFade()
    }

    if viewModel.viewState.hasContinueButton {
      WrapButtonView(
        style: .primary,
        title: .issuanceDetailsContinueButton,
        isLoading: viewModel.viewState.isLoading,
        onAction: viewModel.onContinue()
      )
      .padding([.horizontal, .bottom])
    }
  }

  var body: some View {
    ContentScreenView(
      padding: .zero,
      canScroll: !viewModel.viewState.hasContinueButton,
      errorConfig: viewModel.viewState.error
    ) {

      DocumentDetailsHeaderView(
        documentName: viewModel.viewState.document.documentName,
        holdersName: viewModel.viewState.document.holdersName,
        userIcon: viewModel.viewState.document.holdersImage,
        hasDocumentExpired: viewModel.viewState.document.hasExpired,
        isLoading: viewModel.viewState.isLoading,
        actions: viewModel.viewState.toolBarActions,
        onBack: viewModel.viewState.isCancellable ? { viewModel.pop() } : nil
      )

      content()
    }
    .sheetDialog(isPresented: $viewModel.isDeletionModalShowing) {
      SheetContentView {
        VStack(spacing: SPACING_MEDIUM) {

          ContentTitleView(
            title: .issuanceDetailsDeletionTitle([viewModel.viewState.document.documentName]),
            caption: .issuanceDetailsDeletionCaption([viewModel.viewState.document.documentName])
          )

          WrapButtonView(
            style: .primary,
            title: .yes,
            onAction: viewModel.onDeleteDocument()
          )
          WrapButtonView(
            style: .secondary,
            title: .no,
            onAction: viewModel.onShowDeleteModal()
          )
        }
      }
    }
    .task {
      await self.viewModel.fetchDocumentDetails()
    }
  }
}
