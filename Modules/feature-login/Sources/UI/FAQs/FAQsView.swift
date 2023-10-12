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
import logic_resources

public struct FAQsView<Router: RouterHostType, Interactor: FAQsInteractorType>: View {

  @ObservedObject private var viewModel: FAQsViewModel<Router, Interactor>
  @State var userIsEditingAlias = false

  public init(with router: Router, and interactor: Interactor) {
    self.viewModel = .init(router: router, interactor: interactor)
  }

  public var body: some View {
    ContentScreen(canScroll: true) {

      ContentHeader {
        viewModel.goBack()
      }

      ScrollView(showsIndicators: false) {
        VStack(spacing: SPACING_LARGE_MEDIUM) {

          ContentTitle(title: .faqs)

          SearchBar(
            text: $viewModel.searchText,
            commited: $userIsEditingAlias,
            isLoading: viewModel.displayable.isLoading
          )

          ForEach(viewModel.displayable.filteredModels) { cell in
            ExpandableTextView(
              title: .custom(cell.value.title),
              content: .custom(cell.value.content),
              isloading: viewModel.displayable.isLoading
            ).transition(.opacity)
          }
        }
      }
      .disabled(viewModel.displayable.isLoading)
    }
    .task {
      await viewModel.fetchFAQs()
    }
    .background(Theme.shared.color.backgroundPaper)
  }
}
