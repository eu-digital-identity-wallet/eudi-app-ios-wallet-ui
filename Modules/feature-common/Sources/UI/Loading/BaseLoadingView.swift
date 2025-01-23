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

public struct BaseLoadingView<Router: RouterHost>: View {

  @ObservedObject var viewModel: BaseLoadingViewModel<Router>

  public init(with router: Router, viewModel: BaseLoadingViewModel<Router>) {
    self.viewModel = viewModel
  }

  public var body: some View {
    ContentScreenView(
      errorConfig: viewModel.viewState.error,
      toolbarContent: viewModel.toolbarContent()
    ) {
      content(
        contentHeaderConfig: viewModel.viewState.contentHeaderConfig
      )
    }
    .task {
      await viewModel.doWork()
    }
  }
}

@MainActor
@ViewBuilder
private func content(
  contentHeaderConfig: ContentHeaderConfig
) -> some View {
  VStack(alignment: .center, spacing: SPACING_LARGE_MEDIUM) {
    ContentHeader(
      config: contentHeaderConfig
    )
    Spacer()

    ContentLoaderView(showLoader: .constant(true))

    Spacer()
  }
}

#Preview {
  ContentScreenView {
    content(
      contentHeaderConfig: .init(
        appIconAndTextData: AppIconAndTextData(
          appIcon: ThemeManager.shared.image.logoEuDigitalIndentityWallet,
          appText: ThemeManager.shared.image.euditext
        )
      )
    )
  }
}
