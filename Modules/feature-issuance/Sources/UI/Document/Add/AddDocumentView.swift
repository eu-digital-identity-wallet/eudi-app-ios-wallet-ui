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
      navigationTitle: LocalizableString.shared.get(with: .chooseFromList),
      isLoading: viewModel.viewState.isLoading,
      toolbarContent: viewModel.toolbarContent()
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
        .typography(Theme.shared.font.bodyLarge)
        .foregroundStyle(Theme.shared.color.onSurface)

      VStack(spacing: SPACING_MEDIUM_SMALL) {
        ForEach(viewState.addDocumentCellModels) { cell in
          WrapCardView {
            WrapListItemView(
              listItem: cell.listItem,
              action: { action(cell.configId) }
            )
          }
        }
      }
      .shimmer(isLoading: viewState.isLoading)
    }
    .padding(.horizontal, Theme.shared.dimension.padding)
    .padding(.bottom)
  }
}

#Preview {
  let viewState = AddDocumentViewState(
    addDocumentCellModels: AddDocumentUIModel.mocks,
    error: nil,
    config: IssuanceFlowUiConfig(flow: .noDocument)
  )

  content(viewState: viewState) { _ in }
}
