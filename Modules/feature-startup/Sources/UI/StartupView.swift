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
    ScrollView {
      WrapperView {

        Text("displayLarge")
          .applyFont(Theme.shared.font.displayLarge)
        Text("displayMedium")
          .applyFont(Theme.shared.font.displayMedium)
        Text("displaySmall")
          .applyFont(Theme.shared.font.displaySmall)

        Text("headlineLarge")
          .applyFont(ThemeManager.shared.font.headlineLarge)
        Text("headlineMedium")
          .applyFont(Theme.shared.font.headlineMedium)
        Text("headlineSmall")
          .applyFont(Theme.shared.font.headlineSmall)

        Text("titleLarge")
          .applyFont(Theme.shared.font.titleLarge)
        Text("titleMedium")
          .applyFont(Theme.shared.font.titleMedium)
        Text("titleSmall")
          .applyFont(Theme.shared.font.titleSmall)

        Text("bodyLarge")
          .applyFont(Theme.shared.font.bodyLarge)
        Text("bodyMedium")
          .applyFont(Theme.shared.font.bodyMedium)
        Text("bodySmall")
          .applyFont(Theme.shared.font.bodySmall)

        Text("labelLarge")
          .applyFont(Theme.shared.font.labelLarge)
        Text("labelMedium")
          .applyFont(Theme.shared.font.labelMedium)
        Text("labelSmall")
          .applyFont(Theme.shared.font.labelSmall)

        FloatingTextField(title: .init("Hello"),
                          text: $text,
                          showError: false,
                          contentType: .name,
                          userHasCommitedChange: $hasComited)
        WrapButtonView(
          title: .init(stringLiteral: "Hello World!"),
          onAction: {}()
        )

        WrapButtonView(
          title: .init("Secondary"),
          textColor: ThemeManager.shared.color.palette.textPrimaryDark,
          backgroundColor: ThemeManager.shared.color.palette.backgroundPaper,
          borderWidth: 1,
          borderColor: ThemeManager.shared.color.palette.dividerDark,
          onAction: {}())

        WrapIconView(
          backgroundColor: Theme.shared.color.palette.tertiaryMain,
          systemIcon: "left"

        )
      }
    }

  }
}

#Preview {
  StartupView(with: MockRouter(), and: StartupInteractor())
}

class MockRouter: RouterHostType {
  func push(with route: logic_ui.AppRoute) {
  }

  func popTo(with route: logic_ui.AppRoute, inclusive: Bool, animated: Bool) {

  }

  func pop() {

  }

  func composeApplication() -> AnyView {
    StartupView(with: self, and: StartupInteractor()).eraseToAnyView()
  }

  func getCurrentScreen() -> logic_ui.AppRoute? {
    nil
  }

}
