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
import logic_business

/// The screen that switches biometric unlock after the PIN or biometric check, then returns to the settings.
struct BiometrySelectionView<Router: RouterHost>: View {
  @State private var viewModel: BiometrySelectionViewModel<Router>

  init(with viewModel: BiometrySelectionViewModel<Router>) {
    self._viewModel = State(wrappedValue: viewModel)
  }

  var body: some View {
    ContentScreenView(
      navigationTitle: .loginWithBiometrics,
      isLoading: viewModel.viewState.isLoading
    ) {
      ContentLoaderView(showLoader: .constant(viewModel.viewState.isLoading))
    }
    .alert(item: $viewModel.biometryError) { error in
      Alert(
        title: Text(.genericErrorTitle),
        message: Text(error.errorDescription.orEmpty),
        primaryButton: .default(Text(.biometryOpenSettings)) {
          viewModel.onBiometrySettings()
        },
        secondaryButton: .cancel {
          viewModel.onCancel()
        }
      )
    }
    .task {
      await viewModel.switchBiometricUnlock()
    }
  }
}
