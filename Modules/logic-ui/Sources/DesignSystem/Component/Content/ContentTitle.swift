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
