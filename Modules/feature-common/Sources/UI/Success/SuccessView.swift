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

public struct SuccessView<Router: RouterHost>: View {

  @ObservedObject var viewmodel: SuccessViewModel<Router>

  public init(
    with router: Router,
    and config: any UIConfigType,
    also deepLinkController: DeepLinkController
  ) {
    self.viewmodel = .init(config: config, router: router, deepLinkController: deepLinkController)
  }

  public var body: some View {
    ContentScreenView {
      ContentTitleView(
        title: viewmodel.viewState.config.title.value,
        caption: viewmodel.viewState.config.subtitle,
        titleColor: viewmodel.viewState.config.title.color,
        topSpacing: .withoutToolbar
      )
      mainView()
    }
  }

  private func getCenteredIcon() -> some View {

    let imageData: (image: Image, color: Color) = switch viewmodel.viewState.config.visualKind {
    case .defaultIcon:
      (Theme.shared.image.checkmarkCircleFill, Theme.shared.color.success)
    case .customIcon(let image, let color):
      (image, color)
    }

    return imageData.image
      .resizable()
      .scaledToFit()
      .foregroundColor(imageData.color)
      .frame(height: getScreenRect().width / 2.5)
  }

  private func mainView() -> some View {
    VStack {

      Spacer()

      ZStack(alignment: .center) {
        getCenteredIcon()
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
