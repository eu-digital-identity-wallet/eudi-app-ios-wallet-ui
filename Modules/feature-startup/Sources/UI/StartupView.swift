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

  @ObservedObject private var viewModel: StartupViewModel<Router, Interactor>

  public init(with router: Router, and interactor: Interactor) {
    self.viewModel = .init(router: router, interactor: interactor)
  }

  public var body: some View {
    ContentScreen(
      padding: 0,
      canScroll: false,
      allowBackGesture: false,
      background: Theme.shared.color.primary
    ) {
      ZStack {
        SplashBackground(
          isAnimating: viewModel.viewState.isAnimating
        )
        .onAppear {
          withAnimation(Animation.easeInOut(duration: viewModel.viewState.config.splashDuration)) {
            viewModel.startAnimatingSplash()
          }
        }

        // TODO: Remove when done

//        VStack {
//          WrapButtonView(
//            title: .custom("PRIMARY"),
//            onAction: {}()
//          )
//
//          WrapButtonView(
//            title: .custom("TEST FAQ SCREEN"),
//            onAction: viewModel.onClickFAQ()
//          )
//
//          WrapButtonView(
//            title: .custom("TEST SUCCESS SCREEN"),
//            onAction: viewModel.onClickTestSuccess()
//          )
//
//          WrapButtonView(
//            title: .custom("TEST BIOMETRICS SCREEN"),
//            onAction: viewModel.onClickBiometry()
//          )
//        }

      }
    }
    .task {
      await viewModel.setup()
    }
  }
}
