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
      allowBackGesture: true,
      errorConfig: viewModel.viewState.error,
      navigationTitle: LocalizableString.shared.get(with: .chooseFromList),
      isLoading: viewModel.viewState.isLoading,
      toolbarContent: ToolBarContent(
        trailingActions: [
          Action(title: LocalizableString.shared.get(with: .cancelButton).lowercased()) {
            viewModel.pop()
          }
        ]
      )
    ) {

      content(viewState: viewModel.viewState) { type in
        viewModel.onClick(for: type)
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
        .typography(Theme.shared.font.bodyMedium)
        .foregroundStyle(Theme.shared.color.onSurface)

      VStack(spacing: SPACING_MEDIUM_SMALL) {
        ForEach(viewState.addDocumentCellModels) { cell in
          WrapCardView {
            WrapListItemView(
              listItem: ListItemData(
                mainText: LocalizableString.shared.get(with: cell.documentName),
                trailingContent: .icon(Theme.shared.image.plus)
              ),
              action: { action(cell.configId) }
            )
          }
        }
      }
    }
    .padding(.horizontal, Theme.shared.dimension.padding)
  }
}

@MainActor
@ViewBuilder
private func scanFooter(
  viewState: AddDocumentViewState,
  contentSize: CGFloat,
  action: @escaping () -> Void
) -> some View {
  VStack(spacing: SPACING_MEDIUM) {

    Spacer()

    Text(.or)
      .typography(Theme.shared.font.bodyMedium)
      .foregroundColor(Theme.shared.color.onSurface )
      .shimmer(isLoading: viewState.isLoading)

    Button(
      action: { action() },
      label: {
        HStack {
          Spacer()

          VStack(alignment: .center) {

            Theme.shared.image.qrScan
              .resizable()
              .renderingMode(.template)
              .scaledToFit()
              .foregroundStyle(Theme.shared.color.primary)
              .frame(height: contentSize / 6)

            Text(.issuanceScanQr)
              .typography(Theme.shared.font.titleSmall)
              .foregroundColor(Theme.shared.color.onSurface)
          }
          .padding(.vertical)

          Spacer()
        }
      }
    )
    .background(Theme.shared.color.surface)
    .roundedCorner(SPACING_MEDIUM_SMALL, corners: .allCorners)
    .padding(.horizontal)
    .disabled(viewState.isLoading)
    .shimmer(isLoading: viewState.isLoading)

    Spacer()
  }
  .frame(maxWidth: .infinity, maxHeight: contentSize)
  .background(Theme.shared.color.surface)
  .roundedCorner(SPACING_MEDIUM, corners: [.topLeft, .topRight])
}

#Preview {
  let viewState = AddDocumentViewState(
    addDocumentCellModels: AddDocumentUIModel.mocks,
    error: nil,
    config: IssuanceFlowUiConfig(flow: .noDocument)
  )

  ContentScreenView(
    padding: .zero,
    canScroll: true
  ) {
    ContentHeaderView(dismissIcon: Theme.shared.image.xmark) {}
      .padding([.top, .horizontal], Theme.shared.dimension.padding)

    content(viewState: viewState) { _ in }

    scanFooter(viewState: viewState, contentSize: 300) {}
  }
}
