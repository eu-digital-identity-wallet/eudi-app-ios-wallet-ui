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
import logic_business
import logic_resources

public struct ContentError: View {

  private let config: Config

  public init(config: Config) {
    self.config = config
  }

  public var body: some View {

    ContentScreen {

      ContentHeader(dismissIcon: ThemeManager.shared.image.xmark) {
        config.cancelAction()
      }

      ContentTitle(title: config.title, caption: config.description)

      Spacer()

      if let action = config.action {
        WrapButtonView(
          title: config.button,
          onAction: action()
        )
      }
    }
  }
}

public extension ContentError {
  struct Config {

    let title: LocalizableString.Key
    let description: LocalizableString.Key
    let button: LocalizableString.Key
    let cancelAction: () -> Void
    let action: (() -> Void)?

    public init(
      title: LocalizableString.Key = .genericErrorTitle,
      description: LocalizableString.Key = .genericErrorDesc,
      button: LocalizableString.Key = .tryAgain,
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
