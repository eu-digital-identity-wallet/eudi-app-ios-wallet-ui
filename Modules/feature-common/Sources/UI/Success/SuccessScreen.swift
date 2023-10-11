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
      topView()
      mainView()
    }
  }

  private func topView() -> some View {
    VStack(alignment: .leading, spacing: 0) {

      VSpacer.custom(size: getScreenRect().height * 0.06)

      HStack {
        Text(viewmodel.config.title)
          .typography(ThemeManager.shared.font.headlineSmall)
          .foregroundColor(ThemeManager.shared.color.successText)
        Spacer()
      }

      VSpacer.small()

      HStack {
        Text(viewmodel.config.subtitle)
          .typography(ThemeManager.shared.font.bodyMedium)
          .foregroundColor(ThemeManager.shared.color.textSecondaryDark)
        Spacer()
      }
    }
  }

  private func getCenteredIcon() -> Image {
    return switch viewmodel.config.visualKind {
    case .defaultIcon:
      Image(systemName: "checkmark.circle")
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
          .foregroundColor(ThemeManager.shared.color.successText)
          .frame(height: getScreenRect().width / 2)
      }
      Spacer()

      VStack {
        ForEach(viewmodel.config.buttons, id: \.id) { button in
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

#Preview {
  SuccessView(
    with: PreviewRouter(),
    and: UIConfig.Success(
      title: "title",
      subtitle: "SubTitle",
      buttons: [
        .init(
          title: "Button title",
          screen: .startup,
          style: .primary,
          navigationType: .pop
        )
      ],
      visualKind: .defaultIcon
    )
  )
}
