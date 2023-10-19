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

public struct DashboardView<Router: RouterHostType, Interactor: DashboardInteractorType>: View {

  @ObservedObject private var viewModel: DashboardViewModel<Router, Interactor>

  public init(with router: Router, and interactor: Interactor) {
    self.viewModel = .init(router: router, interactor: interactor)
  }

  @ViewBuilder
  func content() -> some View {
    ZStack {
      DocumentList(
        items: viewModel.viewState.documents,
        isLoading: viewModel.viewState.documentsLoading
      ) { item in
        print(item)
      }
      FloatingActionButtonBar(
        isAddEnabled: viewModel.isLoading,
        addAction: {},
        shareAction: {}
      )
    }
    .background(ThemeManager.shared.color.backgroundPaper)
  }

  public var body: some View {
    ContentScreen(
      padding: .zero,
      spacing: .zero,
      background: ThemeManager.shared.color.primary
    ) {
      ContentJumboHeaderView(
        title: viewModel.bearerName,
        image: Theme.shared.image.user,
        isLoading: viewModel.viewState.bearerLoading
      )
      content()
    }
    .task {
      await viewModel.fetch()
    }
  }
}
