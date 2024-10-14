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
import feature_common

struct OfferCodeView<Router: RouterHost>: View {

  @ObservedObject var viewModel: OfferCodeViewModel<Router>

  init(with viewModel: OfferCodeViewModel<Router>) {
    self.viewModel = viewModel
  }

  var body: some View {
    ContentScreenView(errorConfig: viewModel.viewState.error) {
      content(
        viewState: viewModel.viewState,
        codeInput: $viewModel.codeInput,
        codeIsFocused: $viewModel.codeIsFocused,
        onPop: viewModel.onPop
      )
    }
    .task {
      await viewModel.checkPendingIssuance()
    }
  }
}

@MainActor
@ViewBuilder
fileprivate func loader() -> some View {
  Spacer()
  ContentLoaderView(showLoader: .constant(true))
  Spacer()
}

@MainActor
@ViewBuilder
fileprivate func pinView(
  isLoading: Bool,
  txCodeLength: Int,
  codeInput: Binding<String>,
  codeIsFocused: Binding<Bool>
) -> some View {

  VSpacer.large()

  PinTextFieldView(
    numericText: codeInput,
    maxDigits: txCodeLength,
    isSecureEntry: true,
    canFocus: codeIsFocused,
    shouldUseFullScreen: false
  )
  .disabled(isLoading)

  Spacer()
}

@MainActor
@ViewBuilder
fileprivate func content(
  viewState: OfferCodeViewState,
  codeInput: Binding<String>,
  codeIsFocused: Binding<Bool>,
  onPop: @escaping () -> Void
) -> some View {
  ContentHeaderView(dismissIcon: Theme.shared.image.xmark) {
    onPop()
  }

  ContentTitleView(
    title: viewState.title,
    caption: viewState.caption
  )

  VSpacer.large()

  HStack {
    Theme.shared.image.message
      .foregroundColor(Theme.shared.color.primary)
    Spacer()
  }

  if viewState.isLoading {
    loader()
  } else {
    pinView(
      isLoading: viewState.isLoading,
      txCodeLength: viewState.config.txCodeLength,
      codeInput: codeInput,
      codeIsFocused: codeIsFocused
    )
  }
}

#Preview {
  let state = OfferCodeViewState(
    isLoading: false,
    error: nil,
    config: IssuanceCodeUiConfig(
      offerUri: "",
      issuerName: "Issuer Name",
      txCodeLength: 6,
      docOffers: [],
      successNavigation: .popTo(.featureLoginModule(.welcome)),
      navigationCancelType: .pop
    ),
    title: LocalizableString.Key.addDocumentTitle,
    caption: LocalizableString.Key.addDocumentSubtitle
  )

  ContentScreenView {
    content(
      viewState: state,
      codeInput: .constant("inout"),
      codeIsFocused: .constant(false),
      onPop: {}
    )
  }
}
