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
import logic_business
import feature_common

public struct DashboardView<Router: RouterHostType, Interactor: DashboardInteractorType>: View {

  @ObservedObject private var viewModel: DashboardViewModel<Router, Interactor>

  public init(with router: Router, and interactor: Interactor) {
    self.viewModel = .init(router: router, interactor: interactor)
  }

  @ViewBuilder
  func content() -> some View {
    VStack(spacing: .zero) {
      DocumentListView(
        items: viewModel.viewState.documents,
        isLoading: viewModel.viewState.isLoading
      ) { _ in

      }
      FloatingActionButtonBar(
        isLoading: viewModel.viewState.isLoading,
        edgeInsets: .init(top: SPACING_SMALL, leading: .zero, bottom: .zero, trailing: .zero),
        addAction: {},
        shareAction: {}
      )
    }
    .background(ThemeManager.shared.color.backgroundPaper)
  }

  public var body: some View {
    ContentScreen(
      padding: .zero,
      canScroll: false,
      background: ThemeManager.shared.color.primary
    ) {
      BearerHeaderView(
        item: viewModel.viewState.bearer,
        isLoading: viewModel.viewState.isLoading
      )
      content()
    }
    .task {
      await viewModel.fetch()
    }
  }
}
