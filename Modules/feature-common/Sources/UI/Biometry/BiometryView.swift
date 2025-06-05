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

struct BiometryView<Router: RouterHost>: View {

  @StateObject private var viewModel: BiometryViewModel<Router>
  @Environment(\.scenePhase) var scenePhase

  init(with viewModel: BiometryViewModel<Router>) {
    self._viewModel = StateObject(wrappedValue: viewModel)
  }

  var body: some View {
    ContentScreenView(
      navigationTitle: viewModel.viewState.config.navigationTitle,
      toolbarContent: viewModel.toolbarContent()
    ) {
      content(
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
      .onChange(of: scenePhase) { phase in
        self.viewModel.setPhase(with: phase)
      }
    }
    .onAppear {
      self.viewModel.onAppearBiometry()
    }
  }
}

@MainActor
@ViewBuilder
private func content(
  viewState: BiometryState,
  uiPinInputField: Binding<String>,
  onBiometry: @escaping () -> Void
) -> some View {

  if viewState.config.displayLogo {
    ContentHeaderView(
      config: viewState.contentHeaderConfig
    )
  }

  ContentTitleView(
    title: viewState.config.title,
    titleWeight: .bold,
    caption: viewState.areBiometricsEnabled
    ? viewState.config.caption
    : viewState.config.quickPinOnlyCaption,
    titleColor: Theme.shared.color.onSurface,
    topSpacing: viewState.isCancellable ? .withToolbar : .withoutToolbar
  )

  VSpacer.large()

  pinView(
    uiPinInputField: uiPinInputField,
    quickPinSize: viewState.quickPinSize,
    areBiometricsEnabled: viewState.areBiometricsEnabled,
    pinError: viewState.pinError)

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
@ViewBuilder
private func pinView(
  uiPinInputField: Binding<String>,
  quickPinSize: Int,
  areBiometricsEnabled: Bool,
  pinError: String?
) -> some View {
  VStack(spacing: .zero) {

    PinTextFieldView(
      numericText: uiPinInputField,
      maxDigits: quickPinSize,
      isSecureEntry: true,
      canFocus: .constant(!areBiometricsEnabled),
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
    )
  )

  ContentScreenView {
    content(
      viewState: viewState,
      uiPinInputField: .constant("uiPinInputField"),
      onBiometry: {})
  }
}
