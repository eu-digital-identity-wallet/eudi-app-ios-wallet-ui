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
import logic_resources

public struct ContentTitle: View {

  private let title: LocalizableString.Key
  private let caption: LocalizableString.Key?
  private let titleColor: Color
  private let captionColor: Color
  private let topSpacing: TopSpacing

  public init(
    title: LocalizableString.Key,
    caption: LocalizableString.Key? = nil,
    titleColor: Color = ThemeManager.shared.color.primary,
    captionColor: Color = ThemeManager.shared.color.textSecondaryDark,
    topSpacing: TopSpacing = .withToolbar
  ) {
    self.title = title
    self.caption = caption
    self.titleColor = titleColor
    self.captionColor = captionColor
    self.topSpacing = topSpacing
  }

  public var body: some View {
    VStack(spacing: .zero) {

      VSpacer.custom(size: topSpacing.rawValue)

      HStack {
        Text(self.title)
          .typography(ThemeManager.shared.font.headlineSmall)
          .foregroundColor(self.titleColor)
        Spacer()
      }

      VSpacer.extraSmall()

      if let caption = self.caption {
        HStack {
          Text(caption)
            .typography(ThemeManager.shared.font.bodyMedium)
            .foregroundColor(self.captionColor)
          Spacer()
        }
      }
    }
  }
}

public extension ContentTitle {
  enum TopSpacing: CGFloat {
    case withToolbar = 8
    case withoutToolbar = 16
  }
}
