/*
 * Copyright (c) 2023 European Commission
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import SwiftUI
import logic_ui
import feature_common
import logic_resources

public struct AddDocumentView<Router: RouterHostType, Interactor: AddDocumentInteractorType>: View {

  @ObservedObject var viewModel: AddDocumentViewModel<Router, Interactor>

  public init(with router: Router, and interactor: Interactor) {
    self.viewModel = AddDocumentViewModel(router: router, interactor: interactor)
  }

  @ViewBuilder
  func content() -> some View {
    ScrollView {
      VStack(spacing: .zero) {

        ContentTitle(
          title: .addDocumentTitle,
          caption: .addDocumentSubtitle
        )

        VSpacer.large()

        ForEach(viewModel.viewState.addDocumentCellModels) { cell in
          AddNewDocumentCell(
            isEnabled: cell.isEnabled,
            icon: cell.image,
            title: cell.documentName,
            isLoading: cell.isLoading,
            action: {
              viewModel.routeToIssuance(for: cell.type)
            }
          )
          .padding(.bottom, Theme.shared.shape.small)
        }
      }
    }
  }

  public var body: some View {
    ContentScreen(errorConfig: viewModel.viewState.error) {

      ContentHeader(dismissIcon: Theme.shared.image.xmark) {
        viewModel.pop()
      }

      content()
    }
    .onAppear {
      self.viewModel.fetchStoredDocuments()
    }
  }
}
