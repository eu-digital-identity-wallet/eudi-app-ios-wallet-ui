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

public struct BaseLoadingView<Router: RouterHostType>: View {

  @ObservedObject var viewModel: BaseLoadingViewModel<Router>

  public init(with router: Router, viewModel: BaseLoadingViewModel<Router>) {
    self.viewModel = viewModel
  }

  public var body: some View {
    ContentScreen(errorConfig: viewModel.viewState.error) {

      ContentHeader(
        dismissIcon: ThemeManager.shared.image.xmark,
        onBack: { viewModel.onNavigate(type: .pop) }
      )

      ContentTitle(
        title: viewModel.getTitle(),
        caption: viewModel.getCaption()
      )

      Spacer()

      ContentLoader(showLoader: .constant(true))

      Spacer()
    }
    .task {
      await viewModel.doWork()
    }
  }
}
