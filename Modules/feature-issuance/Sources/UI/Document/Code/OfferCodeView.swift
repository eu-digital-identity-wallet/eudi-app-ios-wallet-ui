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

struct OfferCodeView<Router: RouterHost>: View {

  @ObservedObject var viewModel: OfferCodeViewModel<Router>

  init(with viewModel: OfferCodeViewModel<Router>) {
    self.viewModel = viewModel
  }

  var body: some View {
    ContentScreenView(errorConfig: viewModel.viewState.error) {

      ContentHeaderView(dismissIcon: Theme.shared.image.xmark) {
        viewModel.onPop()
      }

      ContentTitleView(
        title: viewModel.viewState.title,
        caption: viewModel.viewState.caption
      )

      VSpacer.large()

      HStack {
        Theme.shared.image.message
          .foregroundColor(Theme.shared.color.primary)
        Spacer()
      }

      if viewModel.viewState.isLoading {
        loader
      } else {
        pinView
      }
    }
    .task {
      await viewModel.checkPendingIssuance()
    }
  }

  @ViewBuilder
  private var loader: some View {
    Spacer()
    ContentLoaderView(showLoader: .constant(true))
    Spacer()
  }

  @ViewBuilder
  private var pinView: some View {

    VSpacer.large()

    PinTextFieldView(
      numericText: $viewModel.codeInput,
      maxDigits: viewModel.viewState.config.txCodeLength,
      isSecureEntry: true,
      canFocus: $viewModel.codeIsFocused,
      shouldUseFullScreen: false
    )
    .disabled(viewModel.viewState.isLoading)

    Spacer()
  }
}
