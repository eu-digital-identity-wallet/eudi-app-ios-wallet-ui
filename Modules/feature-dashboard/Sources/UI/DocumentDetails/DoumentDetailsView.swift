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
    ContentScreen {
      VStack(alignment: .leading) {

        Text(LocalizableString.Key.addDocumentTitle)
          .typography(Theme.shared.font.headlineSmall)
          .foregroundStyle(Theme.shared.color.primary)

        VSpacer.medium()

        Text(LocalizableString.Key.addDocumentSubtitle)
          .typography(Theme.shared.font.bodyLarge)
          .foregroundStyle(Theme.shared.color.textSecondaryDark)

        VSpacer.extraLarge()

        ScrollView {
          VStack {
            ForEach(viewModel.viewState.addDocumentCellModels) { cell in
              AddNewDocumentCell(
                isEnabled: true,
                icon: cell.value.image,
                title: cell.value.documentName
              ) {
                print("cell")
              }
              .padding(.bottom, Theme.shared.shape.small)
            }
          }
        }
      }
    }
  }

}
