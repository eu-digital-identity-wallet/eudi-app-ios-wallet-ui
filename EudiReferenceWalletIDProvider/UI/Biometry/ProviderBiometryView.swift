/*
 * Copyright (c) 2025 European Commission
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
import feature_common

struct ProviderBiometryView: View {

  @State private var viewModel: ProviderBiometryViewModel

  init(with viewModel: ProviderBiometryViewModel) {
    self._viewModel = State(wrappedValue: viewModel)
  }

  var body: some View {
    VStack {
      content(
        viewState: viewModel.viewState,
        uiPinInputField: $viewModel.uiPinInputField,
        onBiometry: viewModel.onBiometry
      )
    }
    .frame(maxWidth: .infinity)
    .padding()
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
    .task {
      await self.viewModel.onAppearBiometry()
    }
    .navigationBarBackButtonHidden(true)
  }
}

@MainActor
@ViewBuilder
private func content(
  viewState: ProviderBiometryState,
  uiPinInputField: Binding<String>,
  onBiometry: @escaping () -> Void
) -> some View {

  if viewState.config.displayLogo {
    ContentHeaderView(
      config: viewState.contentHeaderConfig
    )
  }

  ContentTitleView(
    caption: viewState.areBiometricsEnabled
    ? viewState.config.caption
    : viewState.config.quickPinOnlyCaption,
    titleColor: Theme.shared.color.onSurface,
    topSpacing: .withoutToolbar
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
