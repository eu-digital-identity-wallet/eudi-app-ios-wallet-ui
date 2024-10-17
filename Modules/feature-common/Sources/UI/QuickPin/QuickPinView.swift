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

struct QuickPinView<Router: RouterHost>: View {

  @ObservedObject var viewModel: QuickPinViewModel<Router>

  init(with viewModel: QuickPinViewModel<Router>) {
    self.viewModel = viewModel
  }

  var body: some View {
    ContentScreenView {
      content(
        viewState: viewModel.viewState,
        uiPinInputField: $viewModel.uiPinInputField,
        onShowCancellationModal: { viewModel.onShowCancellationModal() },
        onButtonClick: { viewModel.onButtonClick() }
      )
    }
    .sheetDialog(isPresented: $viewModel.isCancelModalShowing) {
      SheetContentView {
        VStack(spacing: SPACING_MEDIUM) {

          ContentTitleView(
            title: .quickPinUpdateCancellationTitle,
            caption: .quickPinUpdateCancellationCaption
          )

          WrapButtonView(
            style: .primary,
            title: .quickPinUpdateCancellationContinue,
            onAction:
              viewModel.onShowCancellationModal()
          )
          WrapButtonView(
            style: .secondary,
            title: .cancelButton,
            onAction: viewModel.onPop()
          )
        }
      }
    }
  }
}

@MainActor
@ViewBuilder
private func content(
  viewState: QuickPinState,
  uiPinInputField: Binding<String>,
  onShowCancellationModal: @escaping () -> Void,
  onButtonClick: @escaping () -> Void
) -> some View {
  if viewState.isCancellable {
    ContentHeaderView(
      dismissIcon: Theme.shared.image.xmark,
      onBack: { onShowCancellationModal() }
    )
  }

  ContentTitleView(
    title: viewState.title,
    caption: viewState.caption,
    topSpacing: viewState.isCancellable ? .withToolbar : .withoutToolbar
  )

  VSpacer.large()

  pinView(
    uiPinInputField: uiPinInputField,
    quickPinSize: viewState.quickPinSize,
    pinError: viewState.pinError
  )

  Spacer()

  WrapButtonView(
    style: .primary,
    title: viewState.button,
    isLoading: false,
    isEnabled: viewState.isButtonActive,
    onAction: onButtonClick()
  )
}

@MainActor
@ViewBuilder
private func pinView(
  uiPinInputField: Binding<String>,
  quickPinSize: Int,
  pinError: LocalizableString.Key?
) -> some View {
  VStack(spacing: .zero) {

    PinTextFieldView(
      numericText: uiPinInputField,
      maxDigits: quickPinSize,
      isSecureEntry: true,
      canFocus: .constant(true),
      shouldUseFullScreen: false,
      hasError: pinError != nil
    )

    VSpacer.mediumSmall()

    if let error = pinError {
      HStack {
        Text(error)
          .typography(Theme.shared.font.bodyMedium)
          .foregroundColor(Theme.shared.color.error)
        Spacer()
      }
    }
  }
}

#Preview {
  let viewState = QuickPinState(
    config: QuickPinUiConfig(flow: .set),
    title: .quickPinSetTitle,
    caption: .quickPinSetCaptionOne,
    button: .quickPinNextButton,
    success: .success,
    successButton: .quickPinSetSuccessButton,
    successNavigationType: .push(screen: .featureDashboardModule(.dashboard)),
    isCancellable: false,
    pinError: nil,
    isButtonActive: true,
    step: .firstInput,
    quickPinSize: 6
  )

  ContentScreenView {
    content(
      viewState: viewState,
      uiPinInputField: .constant("PinInput Field"),
      onShowCancellationModal: {},
      onButtonClick: {}
    )
  }
}
