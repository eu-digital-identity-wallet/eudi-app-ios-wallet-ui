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

public struct AddDocumentView<Router: RouterHost>: View {

  @ObservedObject var viewModel: AddDocumentViewModel<Router>

  public init(
    with router: Router,
    and interactor: AddDocumentInteractor,
    config: any UIConfigType
  ) {
    self.viewModel = AddDocumentViewModel(router: router, interactor: interactor, config: config)
  }

  @ViewBuilder
  func content() -> some View {
    ScrollView {
      VStack(spacing: .zero) {

        ContentTitleView(
          title: .addDocumentTitle,
          caption: .addDocumentSubtitle,
          titleColor: Theme.shared.color.textPrimaryDark,
          topSpacing: viewModel.viewState.isFlowCancellable ? .withToolbar : .withoutToolbar
        )

        VSpacer.large()

        ForEach(viewModel.viewState.addDocumentCellModels) { cell in
          AddNewDocumentCellView(
            isEnabled: cell.isEnabled,
            icon: cell.image,
            title: cell.documentName,
            isLoading: cell.isLoading,
            action: {
              viewModel.onClick(for: cell.type)
            }
          )
          .padding(.bottom, Theme.shared.shape.small)
        }
      }
    }
  }

  public var body: some View {
    ContentScreenView(errorConfig: viewModel.viewState.error) {

      if viewModel.viewState.isFlowCancellable {
        ContentHeaderView(dismissIcon: Theme.shared.image.xmark) {
          viewModel.pop()
        }
      }

      content()
    }
    .onAppear {
      self.viewModel.fetchStoredDocuments()
    }
  }
}
