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

public struct StartupView<Router: RouterHostType, Interactor: StartupInteractorType>: View {

  @ObservedObject private var viewModel: StartupViewModel<Router, Interactor>

  public init(with router: Router, and interactor: Interactor) {
    self.viewModel = .init(router: router, interactor: interactor)

  }

  public var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      Spacer()
      Text("Hello, world!")
        .font(Theme.shared.font.headline)

    }
    .padding()
    .environment(\.font, .callout)
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
