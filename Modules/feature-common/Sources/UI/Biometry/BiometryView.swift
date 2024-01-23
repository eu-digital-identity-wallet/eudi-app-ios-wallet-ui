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

public struct BiometryView<Router: RouterHostType, Interactor: BiometryInteractorType>: View {

  @ObservedObject var viewModel: BiometryViewModel<Router, Interactor>
  @Environment(\.scenePhase) var scenePhase

  public init(with router: Router, interactor: Interactor, config: any UIConfigType) {
    self.viewModel = .init(router: router, interactor: interactor, config: config)
  }

  private var pinView: some View {
    VStack(spacing: .zero) {

      PinTextField(
        numericText: $viewModel.uiPinInputField,
        maxDigits: 4,
        isSecureEntry: true,
        canFocus: .constant(!viewModel.viewState.areBiometricsEnabled),
        shouldUseFullScreen: false,
        hasError: viewModel.viewState.pinError != nil
      )

      VSpacer.mediumSmall()

      if let error = viewModel.viewState.pinError {
        HStack {
          Text(error)
            .typography(ThemeManager.shared.font.bodyMedium)
            .foregroundColor(ThemeManager.shared.color.error)
          Spacer()
        }
      }
    }
  }

  @ViewBuilder private var content: some View {

    if viewModel.viewState.isCancellable {
      ContentHeader(
        dismissIcon: ThemeManager.shared.image.xmark,
        onBack: { viewModel.onPop() }
      )
    }

    ContentTitle(
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

  public var body: some View {
    ContentScreen {
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