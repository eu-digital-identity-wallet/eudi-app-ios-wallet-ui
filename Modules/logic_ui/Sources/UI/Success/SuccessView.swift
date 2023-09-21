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
import UIPilot

public struct SuccessView<Router: RouterHostType>: View {

  @ObservedObject private var viewModel: SuccessViewModel<Router>

  public init(
    config: SuccessUiConfig,
    with router: Router
  ) {
    self.viewModel = .init(
      config: config,
      router: router
    )
  }

  public var body: some View {
    VStack(spacing: .zero) {

      HeaderView(
        showLogo: false,
        dismissIcon: "xmark",
        onBack: { viewModel.onBack() }
      )

      VSpacer.large()

      HStack {
        Text(viewModel.config.title)
          .bold()
          .font(.title)
          .foregroundColor(ThemeManager.textColor)
        Spacer()
      }

      VSpacer.medium()

      HStack {
        Text(viewModel.config.subTitle)
          .font(.headline)
          .foregroundColor(ThemeManager.textColor)
        Spacer()
      }

      if let caption = viewModel.config.caption {

        VSpacer.small()

        HStack {
          Text(caption)
            .font(.subheadline)
            .foregroundColor(ThemeManager.textColor)
          Spacer()
        }
      }

      Spacer()

      Image(systemName: viewModel.config.icon)
        .resizable()
        .scaledToFit()
        .frame(width: getScreenRect().width / 1.5)
        .foregroundColor(ThemeManager.accentColor)

      Spacer()
    }
    .uipNavigationBarHidden(true)
    .padding()
  }
}
