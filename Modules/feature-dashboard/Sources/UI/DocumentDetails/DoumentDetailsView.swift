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

public struct DocumentDetailsView<Router: RouterHostType, Interactor: DocumentDetailsInteractorType>: View {

  @ObservedObject var viewModel: DocumentDetailsViewModel<Router, Interactor>

  public init(with router: Router, and interactor: Interactor) {
    self.viewModel = DocumentDetailsViewModel(router: router, interactor: interactor)
  }

  public var body: some View {
    ContentScreen(
      padding: 0,
      canScroll: true
    ) {
      VStack {
        // Close Button

        VSpacer.medium()
          .frame(maxWidth: .infinity)
          .background(Theme.shared.color.primary)

        VStack(alignment: .leading) {
          HStack {
            HSpacer.medium()
            Button(action: {
              viewModel.pop()
            }, label: {
              Theme.shared.image.xmark
            })
            .foregroundStyle(Theme.shared.color.white)
            Spacer()
          }

        }
        .background(Theme.shared.color.primary)
        .frame(maxWidth: .infinity)

        VSpacer.medium()
          .frame(maxWidth: .infinity)
          .background(Theme.shared.color.primary)

        DocumentDetailsHeaderView(
          documentName: viewModel.viewState.document.documentName,
          holdersName: viewModel.viewState.document.holdersName,
          userIcon: viewModel.viewState.document.holdersImage,
          isLoading: viewModel.viewState.isLoading
        )
      }

      DocumentFieldListView(
        documentFields: viewModel.viewState.document.documentFields,
        isLoading: viewModel.viewState.isLoading
      )
      Spacer()
    }
    .task {
      await self.viewModel.fetchDocumentDetails()
    }
  }

}
