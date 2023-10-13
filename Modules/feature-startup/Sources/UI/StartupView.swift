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

public struct StartupView<Router: RouterHostType, Interactor: StartupInteractorType>: View {

  @State var text: String
  @State var hasComited: Bool

  @ObservedObject private var viewModel: StartupViewModel<Router, Interactor>

  public init(with router: Router, and interactor: Interactor) {
    self.viewModel = .init(router: router, interactor: interactor)

    self.text = ""
    self.hasComited = false
  }

  public var body: some View {
    ContentScreen(canScroll: true) {
      ScrollView {
        VStack {

          Text("displayLarge")
            .typography(Theme.shared.font.displayLarge)
          Text("displayMedium")
            .typography(Theme.shared.font.displayMedium)
          Text("displaySmall")
            .typography(Theme.shared.font.displaySmall)

          Text("headlineLarge")
            .typography(ThemeManager.shared.font.headlineLarge)
          Text("headlineMedium")
            .typography(Theme.shared.font.headlineMedium)
          Text("headlineSmall")
            .typography(Theme.shared.font.headlineSmall)

          Text("titleLarge")
            .typography(Theme.shared.font.titleLarge)
          Text("titleMedium")
            .typography(Theme.shared.font.titleMedium)
          Text("titleSmall")
            .typography(Theme.shared.font.titleSmall)

          Text("bodyLarge")
            .typography(Theme.shared.font.bodyLarge)
          Text("bodyMedium")
            .typography(Theme.shared.font.bodyMedium)
          Text("bodySmall")
            .typography(Theme.shared.font.bodySmall)

          Text("labelLarge")
            .typography(Theme.shared.font.labelLarge)
          Text("labelMedium")
            .typography(Theme.shared.font.labelMedium)
          Text("labelSmall")
            .typography(Theme.shared.font.labelSmall)

          FloatingTextField(title: .custom("Hello"),
                            text: $text,
                            showError: false,
                            contentType: .name,
                            userHasCommitedChange: $hasComited)
          WrapButtonView(
            title: .custom("PRIMARY"),
            onAction: {}()
          )

          WrapButtonView(
            title: .custom("TEST FAQ SCREEN"),
            onAction: viewModel.onClickFAQ()
          )

          WrapButtonView(
            title: .custom("TEST SUCCESS SCREEN"),
            onAction: viewModel.onClickTestSuccess()
          )

          WrapButtonView(
            title: .custom("TEST BIOMETRICS SCREEN"),
            onAction: viewModel.onClickBiometry()
          )

          WrapButtonView(style: .secondary,
                         title: .custom("SECONDARY"),
                         onAction: {}())

          Theme.shared.image.faceId
          Theme.shared.image.id
          Theme.shared.image.nfc
          Theme.shared.image.qr
          Theme.shared.image.touchId
          Theme.shared.image.logo
        }
      }
    }
  }
}
