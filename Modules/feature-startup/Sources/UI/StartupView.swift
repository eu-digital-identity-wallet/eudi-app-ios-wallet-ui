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

public struct StartupView<Router: RouterHost>: View {

  @ObservedObject private var viewModel: StartupViewModel<Router>

  public init(with router: Router, and interactor: StartupInteractor) {
    self.viewModel = .init(router: router, interactor: interactor)
  }

  public var body: some View {
    ContentScreenView(
      padding: .zero,
      canScroll: false,
      allowBackGesture: false,
      background: Theme.shared.color.primary
    ) {
      ZStack {
        SplashBackgroundView(
          isAnimating: viewModel.viewState.isAnimating
        )
        .onAppear {
          withAnimation(Animation.easeInOut(duration: viewModel.viewState.splashDuration)) {
            viewModel.startAnimatingSplash()
          }
        }
      }
    }
    .task {
      await viewModel.initialize()
    }
  }
}
