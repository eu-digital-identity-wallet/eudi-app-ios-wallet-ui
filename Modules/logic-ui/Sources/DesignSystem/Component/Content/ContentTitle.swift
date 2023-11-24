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

  public typealias TapListener = (() -> Void)?

  public enum TitleDecoration {
    case plain(LocalizableString.Key)
    case icon(decorated: Text, icon: Image, text: Text?)
  }

  private let titleDecoration: TitleDecoration
  private let decorationColor: Color
  private let caption: LocalizableString.Key?
  private let titleColor: Color
  private let captionColor: Color
  private let topSpacing: TopSpacing
  private let onTap: TapListener

  public init(
    title: LocalizableString.Key,
    caption: LocalizableString.Key? = nil,
    decorationColor: Color = ThemeManager.shared.color.primary,
    titleColor: Color = ThemeManager.shared.color.primary,
    captionColor: Color = ThemeManager.shared.color.textSecondaryDark,
    topSpacing: TopSpacing = .withToolbar,
    onTap: TapListener = nil
  ) {
    self.titleDecoration = .plain(title)
    self.caption = caption
    self.decorationColor = decorationColor
    self.titleColor = titleColor
    self.captionColor = captionColor
    self.topSpacing = topSpacing
    self.onTap = onTap
  }

  public init(
    titleDecoration: TitleDecoration,
    caption: LocalizableString.Key? = nil,
    decorationColor: Color = ThemeManager.shared.color.primary,
    titleColor: Color = ThemeManager.shared.color.primary,
    captionColor: Color = ThemeManager.shared.color.textSecondaryDark,
    topSpacing: TopSpacing = .withToolbar,
    onTap: TapListener = nil
  ) {
    self.titleDecoration = titleDecoration
    self.decorationColor = decorationColor
    self.caption = caption
    self.titleColor = titleColor
    self.captionColor = captionColor
    self.topSpacing = topSpacing
    self.onTap = onTap
  }

  var title: some View {
    HStack {
      switch titleDecoration {
      case .plain(let key):
        Text(key)
          .typography(ThemeManager.shared.font.headlineSmall)
          .foregroundColor(self.titleColor)
      case .icon(let decorated, let icon, let text):
        Text("\(decorated)")
          .typography(style: ThemeManager.shared.font.headlineSmall)
          .foregroundColor(self.titleColor)
        +
        Text("\(icon)")
          .typography(style: ThemeManager.shared.font.headlineSmall)
          .foregroundColor(self.decorationColor)
        +
        Text("\(text ?? Text(""))")
          .typography(style: ThemeManager.shared.font.headlineSmall)
          .foregroundColor(self.titleColor)

      }

      Spacer()
    }
  }

  public var body: some View {
    VStack(spacing: .zero) {

      VSpacer.custom(size: topSpacing.rawValue)

      title
        .onTapGesture(perform: {
          onTap?()
        })

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
