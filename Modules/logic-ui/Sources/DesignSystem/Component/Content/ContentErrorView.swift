/*
 * Copyright (c) 2025 European Commission
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
import logic_resources

public struct ContentErrorView: View {

  private let config: Config

  public init(config: Config) {
    self.config = config
  }

  public var body: some View {

    ContentScreenView {

      ContentHeaderErrorView(dismissIcon: Theme.shared.image.xmark) {
        config.cancelAction()
      }

      ContentTitleView(
        title: config.title,
        accessibilityTitle: ContentErrorLocators.screenTitle,
        caption: config.description
      )

      Spacer()

      if let action = config.action {
        WrapButtonView(
          style: .primary,
          title: config.button,
          onAction: action()
        )
        .combineChilrenAccessibility(
          locator: ContentErrorLocators.primaryButton
        )
      }
    }
  }
}

public extension ContentErrorView {
  struct Config {

    let title: LocalizableStringKey
    let description: LocalizableStringKey
    let button: LocalizableStringKey
    let cancelAction: () -> Void
    let action: (() -> Void)?

    public init(
      title: LocalizableStringKey = .genericErrorTitle,
      description: LocalizableStringKey = .genericErrorDesc,
      button: LocalizableStringKey = .tryAgain,
      cancelAction: @escaping @autoclosure () -> Void,
      action: (() -> Void)? = nil
    ) {
      self.title = title
      self.description = description
      self.button = button
      self.action = action
      self.cancelAction = cancelAction
    }
  }
}

#Preview {
  Group {
    ContentErrorView(
      config: ContentErrorView.Config(
        cancelAction: {}()
      )
    )
    .lightModePreview()

    ContentErrorView(
      config: ContentErrorView.Config(
        cancelAction: {}()
      )
    )
    .darkModePreview()
  }
}
