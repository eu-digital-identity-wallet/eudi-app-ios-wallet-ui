/*
 * Copyright (c) 2023 European Commission
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
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
        canFocus: $viewmodel.areBiometricsEnabled,
        shouldUseFullScreen: false,
        hasError: viewmodel.pinError != nil
      )

      VSpacer.mediumSmall()

      if let error = viewmodel.pinError {
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

    HeaderView(
      dismissIcon: ThemeManager.shared.image.xmark,
      onBack: { viewmodel.onPop() }
    )

    VSpacer.large()

    Group {
      HStack {
        Text(viewmodel.config.title)
          .typography(ThemeManager.shared.font.headlineSmall)
          .foregroundColor(ThemeManager.shared.color.secondaryMain)
        Spacer()
      }

      VSpacer.extraSmall()

      HStack {
        Text(
          viewmodel.areBiometricsEnabled
          ? viewmodel.config.caption
          : viewmodel.config.quickPinOnlyCaption
        )
        .typography(ThemeManager.shared.font.bodyMedium)
        .foregroundColor(ThemeManager.shared.color.textSecondaryDark)
        Spacer()
      }
    }

    VSpacer.medium()

    pinView

    Spacer()

    if viewmodel.areBiometricsEnabled, let image = viewmodel.getBiometryImage() {
      HStack {
        Spacer()
        image
          .onTapGesture {
            // viewmodel.setEvent(.loginWithBiometrics)
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
              // viewmodel.setEvent(.goToBiometricSettings)
            },
            secondaryButton: .cancel {
              // viewmodel.setEvent(.errorDialogCancelled)
            }
          )
        }
        .onChange(of: scenePhase) { _ in
          // viewmodel.setEvent(.setScenePhase(phase))
        }
    }
  }
}
