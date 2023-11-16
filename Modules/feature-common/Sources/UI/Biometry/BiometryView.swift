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

  @ObservedObject var viewmodel: BiometryViewModel<Router, Interactor>
  @Environment(\.scenePhase) var scenePhase

  public init(with router: Router, interactor: Interactor, config: any UIConfigType) {
    self.viewmodel = .init(router: router, interactor: interactor, config: config)
  }

  private var pinView: some View {
    VStack(spacing: .zero) {

      PinTextField(
        numericText: $viewmodel.uiPinInputField,
        maxDigits: 4,
        isSecureEntry: true,
        canFocus: .constant(!viewmodel.viewState.areBiometricsEnabled),
        shouldUseFullScreen: false,
        hasError: viewmodel.viewState.pinError != nil
      )

      VSpacer.mediumSmall()

      if let error = viewmodel.viewState.pinError {
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

    ContentHeader(
      dismissIcon: ThemeManager.shared.image.xmark,
      onBack: { viewmodel.onPop() }
    )

    ContentTitle(
      title: viewmodel.viewState.config.title,
      caption: viewmodel.viewState.areBiometricsEnabled
      ? viewmodel.viewState.config.caption
      : viewmodel.viewState.config.quickPinOnlyCaption
    )

    VSpacer.medium()

    pinView

    Spacer()

    if viewmodel.viewState.areBiometricsEnabled, let image = viewmodel.viewState.biometryImage {
      HStack {
        Spacer()
        image
          .onTapGesture {
            viewmodel.onBiometry()
          }
      }
      .padding(.horizontal)
    }
  }

  public var body: some View {
    ContentScreen {
      content
        .alert(item: $viewmodel.biometryError) { error in
          Alert(
            title: Text(.genericErrorTitle),
            message: Text(error.errorDescription.orEmpty),
            primaryButton: .default(Text(.biometryOpenSettings)) {
              self.viewmodel.onSettings()
            },
            secondaryButton: .cancel {}
          )
        }
        .onChange(of: scenePhase) { phase in
          self.viewmodel.setPhase(with: phase)
        }
    }
    .onAppear {
      self.viewmodel.onAppearBiometry()
    }
  }
}
