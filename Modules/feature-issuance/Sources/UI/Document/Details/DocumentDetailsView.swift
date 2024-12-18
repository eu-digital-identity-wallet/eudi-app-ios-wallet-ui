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
      errorConfig: viewModel.viewState.error
    ) {

      content(viewState: viewModel.viewState) {
        viewModel.onContinue()
      } pop: {
        viewModel.pop()
      }
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

@MainActor
@ViewBuilder
private func content(
  viewState: DocumentDetailsViewState,
  onContinue: @escaping () -> Void,
  pop: @escaping () -> Void
) -> some View {
  DocumentDetailsHeaderView(
    documentName: viewState.document.documentName,
    holdersName: viewState.document.holdersName,
    userIcon: viewState.document.holdersImage,
    hasDocumentExpired: viewState.document.hasExpired,
    isLoading: viewState.isLoading,
    actions: viewState.toolBarActions,
    onBack: viewState.isCancellable ? { pop() } : nil
  )

  details(viewState: viewState) {
    onContinue()
  }
}

@MainActor
@ViewBuilder
private func details(
  viewState: DocumentDetailsViewState,
  onContinue: @escaping () -> Void
) -> some View {
  ScrollView {
    VStack(spacing: .zero) {

      VSpacer.medium()

      ForEach(viewState.document.documentFields) { documentFieldContent in

        switch documentFieldContent.value {
        case .string(let value):
          KeyValueView(
            title: .custom(documentFieldContent.title),
            subTitle: .custom(value),
            isLoading: viewState.isLoading
          )
        case .image(let image):
          KeyValueView(
            title: .custom(documentFieldContent.title),
            image: image,
            isLoading: viewState.isLoading
          )
        }

        VSpacer.medium()
      }
    }
    .padding(.horizontal, Theme.shared.dimension.padding)
  }
  .if(viewState.hasContinueButton) {
    $0.bottomFade()
  }

  if viewState.hasContinueButton {
    WrapButtonView(
      style: .primary,
      title: .issuanceDetailsContinueButton,
      isLoading: viewState.isLoading,
      onAction: onContinue()
    )
    .padding([.horizontal, .bottom])
  }
}

#Preview {
  let viewState = DocumentDetailsViewState(
    document: DocumentDetailsUIModel.mock(),
    isLoading: false,
    error: nil,
    config: IssuanceDetailUiConfig(flow: .extraDocument("documentId")),
    toolBarActions: [
      .init(
        image: Theme.shared.image.trash,
        callback: {}()
      )
    ]
  )

  ContentScreenView(
    padding: .zero,
    canScroll: true
  ) {
    content(
      viewState: viewState,
      onContinue: {},
      pop: {}
    )
  }
}
