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

  @ObservedObject var viewModel: BiometryViewModel<Router>
  @Environment(\.scenePhase) var scenePhase

  init(with viewModel: BiometryViewModel<Router>) {
    self.viewModel = viewModel
  }

  private var pinView: some View {
    VStack(spacing: .zero) {

      PinTextFieldView(
        numericText: $viewModel.uiPinInputField,
        maxDigits: viewModel.viewState.quickPinSize,
        isSecureEntry: true,
        canFocus: .constant(!viewModel.viewState.areBiometricsEnabled),
        shouldUseFullScreen: false,
        hasError: viewModel.viewState.pinError != nil
      )

      VSpacer.mediumSmall()

      if let error = viewModel.viewState.pinError {
        HStack {
          Text(error)
            .typography(Theme.shared.font.bodyMedium)
            .foregroundColor(Theme.shared.color.error)
          Spacer()
        }
      }
    }
  }

  @ViewBuilder private var content: some View {

    if viewModel.viewState.isCancellable {
      ContentHeaderView(
        dismissIcon: Theme.shared.image.xmark,
        onBack: { viewModel.onPop() }
      )
    }

    ContentTitleView(
      title: viewModel.viewState.config.title,
      caption: viewModel.viewState.areBiometricsEnabled
      ? viewModel.viewState.config.caption
      : viewModel.viewState.config.quickPinOnlyCaption,
      titleColor: Theme.shared.color.textPrimaryDark,
      topSpacing: viewModel.viewState.isCancellable ? .withToolbar : .withoutToolbar
    )

    VSpacer.large()

    pinView

    Spacer()

    if viewModel.viewState.areBiometricsEnabled, let image = viewModel.viewState.biometryImage {
      HStack {
        Spacer()
        image
          .onTapGesture {
            viewModel.onBiometry()
          }
      }
      .padding(.horizontal)
    }
  }

  var body: some View {
    ContentScreenView {
      content
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
