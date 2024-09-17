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

public struct ContentTitleView: View {

  public typealias TapListener = (() -> Void)?

  public enum TitleDecoration {
    case plain(LocalizableString.Key)
    case icon(decorated: String, icon: Image, text: String?)
  }

  private let titleDecoration: TitleDecoration
  private let decorationColor: Color
  private let caption: LocalizableString.Key?
  private let titleColor: Color
  private let captionColor: Color
  private let topSpacing: TopSpacing
  private let isLoading: Bool
  private let onTap: TapListener

  public init(
    title: LocalizableString.Key,
    caption: LocalizableString.Key? = nil,
    decorationColor: Color = Theme.shared.color.primary,
    titleColor: Color = Theme.shared.color.textPrimaryDark,
    captionColor: Color = Theme.shared.color.textSecondaryDark,
    topSpacing: TopSpacing = .withToolbar,
    isLoading: Bool = false,
    onTap: TapListener = nil
  ) {
    self.titleDecoration = .plain(title)
    self.caption = caption
    self.decorationColor = decorationColor
    self.titleColor = titleColor
    self.captionColor = captionColor
    self.topSpacing = topSpacing
    self.isLoading = isLoading
    self.onTap = onTap
  }

  public init(
    titleDecoration: TitleDecoration,
    caption: LocalizableString.Key? = nil,
    decorationColor: Color = Theme.shared.color.primary,
    titleColor: Color = Theme.shared.color.textPrimaryDark,
    captionColor: Color = Theme.shared.color.textSecondaryDark,
    topSpacing: TopSpacing = .withToolbar,
    isLoading: Bool = false,
    onTap: TapListener = nil
  ) {
    self.titleDecoration = titleDecoration
    self.decorationColor = decorationColor
    self.caption = caption
    self.titleColor = titleColor
    self.captionColor = captionColor
    self.topSpacing = topSpacing
    self.isLoading = isLoading
    self.onTap = onTap
  }

  var title: some View {
    HStack {
      switch titleDecoration {
      case .plain(let key):
        Text(key)
          .typography(Theme.shared.font.headlineSmall)
          .foregroundColor(self.titleColor)
      case .icon(let decorated, let icon, let text):
        Text(decorated)
          .typography(style: Theme.shared.font.headlineSmall)
          .foregroundColor(self.titleColor)
        +
        Text("\(icon)")
          .typography(style: Theme.shared.font.headlineSmall)
          .foregroundColor(self.decorationColor)
        +
        Text(text ?? "")
          .typography(style: Theme.shared.font.headlineSmall)
          .foregroundColor(self.titleColor)

      }
      Spacer()
    }
  }

  public var body: some View {
    VStack(spacing: .zero) {

      VSpacer.custom(size: topSpacing.rawValue)

      title.onTapGesture(
        perform: {
          onTap?()
        }
      )

      VSpacer.extraSmall()

      if let caption = self.caption {
        HStack {
          Text(caption)
            .typography(Theme.shared.font.bodyMedium)
            .foregroundColor(self.captionColor)
          Spacer()
        }
      }
    }
    .shimmer(isLoading: self.isLoading)
  }
}

public extension ContentTitleView {
  enum TopSpacing: CGFloat {
    case withToolbar = 8
    case withoutToolbar = 16
  }
}

#Preview {
  Group {
    ContentTitleView(
      title: LocalizableString.Key.tryAgain,
      caption: LocalizableString.Key.tryAgain
    )
    .lightModePreview()

    ContentTitleView(
      title: LocalizableString.Key.tryAgain,
      caption: LocalizableString.Key.tryAgain
    )
    .darkModePreview()
  }
}
