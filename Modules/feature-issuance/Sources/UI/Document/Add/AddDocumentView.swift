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
import logic_core

struct AddDocumentView<Router: RouterHost>: View {

  @ObservedObject var viewModel: AddDocumentViewModel<Router>

  var contentSize: CGFloat = 0.0

  init(with viewModel: AddDocumentViewModel<Router>) {
    self.viewModel = viewModel
    self.contentSize = getScreenRect().width / 2.0
  }

  var body: some View {
    ContentScreenView(
      padding: .zero,
      canScroll: true,
      errorConfig: viewModel.viewState.error,
      navigationTitle: .chooseFromList,
      isLoading: viewModel.viewState.isLoading,
      toolbarContent: viewModel.toolbarContent()
    ) {

      content(viewState: viewModel.viewState) { type in
        viewModel.onClick(for: type)
      }

      if viewModel.viewState.showFooterScanner {

        VSpacer.extraSmall()

        scanFooter(
          viewState: viewModel.viewState,
          contentSize: contentSize,
          action: viewModel.onScanClick()
        )
      }
    }
    .task {
      await self.viewModel.initialize()
    }
  }
}

@MainActor
@ViewBuilder
private func content(
  viewState: AddDocumentViewState,
  action: @escaping (String) -> Void
) -> some View {
  ScrollView {
    VStack(spacing: SPACING_LARGE_MEDIUM) {

      Text(.chooseFromListTitle)
        .typography(Theme.shared.font.bodyLarge)
        .foregroundStyle(Theme.shared.color.onSurface)

      VStack(spacing: SPACING_MEDIUM_SMALL) {
        ForEach(viewState.addDocumentCellModels) { cell in
          WrapCardView {
            WrapListItemView(
              listItem: cell.listItem,
              isLoading: cell.isLoading,
              action: { action(cell.configId) }
            )
          }
        }
      }
    }
    .padding(.horizontal, Theme.shared.dimension.padding)
    .padding(.bottom)
  }
}

@MainActor
@ViewBuilder
private func scanFooter(
  viewState: AddDocumentViewState,
  contentSize: CGFloat,
  action: @escaping @autoclosure () -> Void
) -> some View {
  VStack(spacing: SPACING_MEDIUM) {

    Spacer()

    HStack {

      Spacer()

      VStack(alignment: .center, spacing: SPACING_MEDIUM) {

        Text(.or)
          .typography(Theme.shared.font.bodyMedium)
          .foregroundColor(Theme.shared.color.onSurfaceVariant)

        Theme.shared.image.scanDocumentImage
      }

      Spacer()
    }

    WrapButtonView(
      style: .custom(
        textColor: Theme.shared.color.primary,
        backgroundColor: Theme.shared.color.surfaceContainerLowest,
        borderColor: Theme.shared.color.primary,
        useBorder: true
      ),
      title: .scanQrCode,
      isLoading: viewState.isLoading,
      onAction: action()
    )

    Spacer()

  }
  .frame(maxWidth: .infinity, maxHeight: contentSize)
  .padding([.horizontal, .bottom])
  .background(Theme.shared.color.surfaceContainer)
  .roundedCorner(SPACING_MEDIUM, corners: [.topLeft, .topRight])
}

#Preview {
  let viewState = AddDocumentViewState(
    addDocumentCellModels: AddDocumentUIModel.mocks,
    error: nil,
    config: IssuanceFlowUiConfig(flow: .noDocument),
    showFooterScanner: true
  )

  content(viewState: viewState) { _ in }
}

#Preview {
  let viewState = AddDocumentViewState(
    addDocumentCellModels: AddDocumentUIModel.mocks,
    error: nil,
    config: IssuanceFlowUiConfig(flow: .noDocument),
    showFooterScanner: true
  )
  scanFooter(
    viewState: viewState,
    contentSize: 500,
    action: {}()
  )
}
