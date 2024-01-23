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