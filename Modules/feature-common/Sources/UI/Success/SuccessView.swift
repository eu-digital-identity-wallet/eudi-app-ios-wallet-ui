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

public struct SuccessView<Router: RouterHostType>: View {

  @ObservedObject var viewmodel: SuccessViewModel<Router>

  public init(with router: Router, and config: any UIConfigType) {
    self.viewmodel = .init(config: config, router: router)
  }

  public var body: some View {
    ContentScreen {
      ContentTitle(
        title: viewmodel.viewState.config.title,
        caption: viewmodel.viewState.config.subtitle,
        titleColor: ThemeManager.shared.color.success,
        topSpacing: .withoutToolbar
      )
      mainView()
    }
  }

  private func getCenteredIcon() -> Image {
    return switch viewmodel.viewState.config.visualKind {
    case .defaultIcon:
      ThemeManager.shared.image.checkmarkCircle
    case .customIcon(let image):
      image
    }
  }

  private func mainView() -> some View {
    VStack {

      Spacer()

      ZStack(alignment: .center) {
        getCenteredIcon()
          .resizable()
          .scaledToFit()
          .foregroundColor(ThemeManager.shared.color.success)
          .frame(height: getScreenRect().width / 2.5)
      }
      Spacer()

      VStack {
        ForEach(viewmodel.viewState.config.buttons, id: \.id) { button in
          WrapButtonView(
            style: button.style == .primary ? .primary : .secondary,
            title: button.title,
            onAction: viewmodel.onButtonClicked(with: button)
          )
        }
      }
    }
  }
}
