/*
 * Copyright (c) 2026 European Commission
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

  @State private var viewModel: QuickPinViewModel<Router>

  init(with viewModel: QuickPinViewModel<Router>) {
    self._viewModel = State(wrappedValue: viewModel)
  }

  var body: some View {
    ContentScreenView(
      navigationTitle: viewModel.viewState.navigationTitle,
      toolbarContent: viewModel.toolbarContent()
    ) {
      content(
        viewState: viewModel.viewState,
        contentCaption: viewModel.contentCaption,
        uiPinInputField: $viewModel.uiPinInputField,
        onShowCancellationModal: { viewModel.onShowCancellationModal() }
      )
    }
    .dialogCompat(
      .quickPinUpdateCancellationTitle,
      isPresented: $viewModel.isCancelModalShowing,
      actions: {
        Button(.cancelButton, role: .destructive) {
          viewModel.onPop()
        }
        Button(.quickPinUpdateCancellationContinue, role: .cancel) {
          viewModel.onShowCancellationModal()
        }
      },
      message: {
        Text(.quickPinUpdateCancellationCaption)
      }
    )
    .task {
      await viewModel.initialize()
    }
  }
}

@MainActor
@ViewBuilder
private func content(
  viewState: QuickPinState,
  contentCaption: LocalizableStringKey?,
  uiPinInputField: Binding<String>,
  onShowCancellationModal: @escaping () -> Void
) -> some View {

  ContentHeaderView(
    config: ContentHeaderConfig(
      appIconAndTextData: AppIconAndTextData(
        appIcon: ThemeManager.shared.image.logoEuDigitalIndentityWallet,
        appText: ThemeManager.shared.image.euditext
      )
    )
  )

  ContentTitleView(
    title: viewState.title,
    accessibilityTitle: QuickPinLocators.quickPinTitle,
    titleWeight: .bold,
    caption: contentCaption,
    captionWeight: .semibold
  )

  VSpacer.large()

  pinView(
    uiPinInputField: uiPinInputField,
    quickPinSize: viewState.quickPinSize,
    pinTextfieldTitle: viewState.pinTextFieldTitle,
    pinError: viewState.pinError,
    isLockedOut: viewState.isLockedOut,
    lockoutMessage: viewState.lockoutMessage
  )

  Spacer()
}

@MainActor
@ViewBuilder
private func pinView(
  uiPinInputField: Binding<String>,
  quickPinSize: Int,
  pinTextfieldTitle: LocalizableStringKey,
  pinError: LocalizableStringKey?,
  isLockedOut: Bool,
  lockoutMessage: LocalizableStringKey?
) -> some View {
  let hasError = pinError != nil || isLockedOut

  VStack(spacing: .zero) {

    PinTextFieldView(
      pinTitle: pinTextfieldTitle,
      numericText: uiPinInputField,
      maxDigits: quickPinSize,
      isSecureEntry: true,
      canFocus: .constant(!isLockedOut),
      shouldUseFullScreen: true,
      hasError: hasError,
      isDisabled: isLockedOut
    )

    VSpacer.mediumSmall()

    if let lockoutMessage {
      HStack {
        Text(lockoutMessage)
          .typography(Theme.shared.font.bodySmall)
          .foregroundColor(Theme.shared.color.error)
          .multilineTextAlignment(.leading)
        Spacer()
      }
    } else if let error = pinError {
      HStack {
        Text(error)
          .typography(Theme.shared.font.bodySmall)
          .foregroundColor(Theme.shared.color.error)
        Spacer()
      }
    }
  }
}

#Preview {
  let viewState = QuickPinState(
    config: QuickPinUiConfig(flow: .setWithActivation),
    navigationTitle: .quickPinEnterPin,
    title: .quickPinSetTitle,
    caption: .quickPinSetCaptionOne,
    pinTextFieldTitle: .quickPinEnterPin,
    buttonImage: Theme.shared.image.chevronRight,
    successTitle: .quickPinSetTitle,
    successCaption: .quickPinSetSuccess,
    successButton: .quickPinSetSuccessButton,
    successNavigationType: .push(screen: .featureDashboardModule(.dashboard)),
    isCancellable: false,
    pinError: nil,
    step: .firstInput,
    quickPinSize: 6,
    isLockedOut: false,
    lockoutMessage: nil
  )

  ContentScreenView {
    content(
      viewState: viewState,
      contentCaption: viewState.caption,
      uiPinInputField: .constant("PinInput Field"),
      onShowCancellationModal: {}
    )
  }
}
