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

struct BiometryView<Router: RouterHost>: View {

  @State private var viewModel: BiometryViewModel<Router>
  @Environment(\.scenePhase) var scenePhase

  init(with viewModel: BiometryViewModel<Router>) {
    self._viewModel = State(wrappedValue: viewModel)
  }

  var body: some View {
    let config = viewModel.viewState.config
    let isEmbeddedPresentation = !config.displayNavigationBar

    ContentScreenView(
      padding: isEmbeddedPresentation ? .zero : Theme.shared.dimension.padding,
      navigationTitle: config.displayNavigationBar
        ? config.navigationTitle
        : nil,
      toolbarContent: config.displayNavigationBar
        ? viewModel.toolbarContent()
        : nil
    ) {
      BiometryViewContainer(
        viewState: viewModel.viewState,
        uiPinInputField: $viewModel.uiPinInputField,
        onBiometry: viewModel.onBiometry
      )
      .alert(item: $viewModel.biometryError) { error in
        Alert(
          title: Text(.genericErrorTitle),
          message: Text(error.errorDescription.orEmpty),
          primaryButton: .default(Text(.biometryOpenSettings)) {
            self.viewModel.onSettings()
          },
          secondaryButton: .cancel {}
        )
      }
      .onChange(of: scenePhase) {
        self.viewModel.setPhase(with: scenePhase)
      }
    }
    .if(isEmbeddedPresentation) {
      $0
        .frame(maxWidth: .infinity)
        .padding()
        .toolbar(.hidden, for: .navigationBar)
    }
    .task {
      await self.viewModel.initialize()
    }
  }
}

private struct BiometryViewContainer: View {

  let viewState: BiometryState
  @Binding var uiPinInputField: String
  let onBiometry: () -> Void

  var body: some View {
    content()
  }

  @MainActor
  @ViewBuilder
  private func content() -> some View {
    if viewState.config.displayLogo {
      ContentHeaderView(
        config: viewState.contentHeaderConfig
      )
    }

    ContentTitleView(
      title: viewState.config.title,
      accessibilityTitle: BiometryLocators.biometryScreenTitle,
      titleWeight: .bold,
      caption: biometryTitleCaption(),
      accessibilityCaption: BiometryLocators.biometryScreenPinText,
      titleColor: Theme.shared.color.primaryLabel,
      topSpacing: viewState.config.displayNavigationBar && viewState.isCancellable
        ? .withToolbar
        : .withoutToolbar
    )

    VSpacer.small()

    pinView()

    Spacer()

    if viewState.areBiometricsEnabled, let image = viewState.biometryImage {
      HStack {
        Spacer()
        image
          .onTapGesture {
            onBiometry()
          }
      }
      .padding(.horizontal)
    }
  }

  @MainActor
  private func biometryTitleCaption() -> LocalizableStringKey? {
    guard
      viewState.config.pinTextFieldTitle == nil,
      !viewState.config.isPreAuthorization
    else {
      return nil
    }
    return viewState.areBiometricsEnabled
      ? viewState.config.caption
      : viewState.config.quickPinOnlyCaption
  }

  @MainActor
  private func biometryPinTitle() -> LocalizableStringKey? {
    if let pinTextFieldTitle = viewState.config.pinTextFieldTitle {
      return pinTextFieldTitle
    }
    return viewState.areBiometricsEnabled
      ? viewState.config.caption
      : viewState.config.quickPinOnlyCaption
  }

  @MainActor
  @ViewBuilder
  private func pinView() -> some View {
    let hasError = viewState.pinError != nil || viewState.isLockedOut

    VStack(spacing: .zero) {

      PinTextFieldView(
        pinTitle: biometryPinTitle(),
        numericText: $uiPinInputField,
        maxDigits: viewState.quickPinSize,
        isSecureEntry: true,
        canFocus: .constant(!viewState.areBiometricsEnabled && !viewState.isLockedOut),
        shouldUseFullScreen: true,
        hasError: hasError,
        isDisabled: viewState.isLockedOut
      )

      VSpacer.mediumSmall()

      if let lockoutMessage = viewState.lockoutMessage {
        HStack {
          Text(lockoutMessage)
            .typography(Theme.shared.font.bodySmall)
            .foregroundColor(Theme.shared.color.red)
            .multilineTextAlignment(.leading)
          Spacer()
        }
      } else if let error = viewState.pinError {
        HStack {
          Text(error)
            .typography(Theme.shared.font.bodySmall)
            .foregroundColor(Theme.shared.color.red)
          Spacer()
        }
      }
    }
  }
}

#Preview {
  let viewState = BiometryState(
    config: UIConfig.Biometry(
      navigationTitle: .custom("Navigation Title"),
      title: .quickPinSetTitle,
      caption: .loginCaptionQuickPinOnly,
      quickPinOnlyCaption: .requestDataShareQuickPinCaption,
      navigationSuccessType: .pop,
      navigationBackType: nil,
      isPreAuthorization: true,
      shouldInitializeBiometricOnCreate: true
    ),
    areBiometricsEnabled: true,
    pinError: nil,
    throttlePinInput: true,
    scenePhase: .active,
    pendingNavigation: nil,
    autoBiometryInitiated: true,
    biometryImage: Theme.shared.image.faceId,
    isCancellable: true,
    quickPinSize: 6,
    contentHeaderConfig: .init(
      appIconAndTextData: AppIconAndTextData(
        appIcon: ThemeManager.shared.image.logoEuDigitalIndentityWallet,
        appText: ThemeManager.shared.image.euditext
      )
    ),
    isLockedOut: false,
    lockoutMessage: nil
  )

  ContentScreenView {
    BiometryViewContainer(
      viewState: viewState,
      uiPinInputField: .constant("uiPinInputField"),
      onBiometry: {}
    )
  }
}
