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

public struct FloatingActionButtonView: View {

  private let title: LocalizableStringKey
  private let textColor: Color
  private let backgroundColor: Color
  private let icon: Image
  private let iconColor: Color
  private let isLoading: Bool
  private let action: () -> Void

  public init(
    title: LocalizableStringKey,
    textColor: Color = Theme.shared.color.onSurface,
    backgroundColor: Color = Theme.shared.color.primary,
    icon: Image,
    iconColor: Color = Theme.shared.color.onSurface,
    isLoading: Bool = false,
    action: @escaping () -> Void
  ) {
    self.title = title
    self.textColor = textColor
    self.backgroundColor = backgroundColor
    self.icon = icon
    self.iconColor = iconColor
    self.isLoading = isLoading
    self.action = action
  }

  public var body: some View {
    HStack {
      Button(action: action) {
        HStack(alignment: .center) {
          icon
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxHeight: 25)
            .foregroundStyle(iconColor)
          Text(title)
            .typography(Theme.shared.font.labelLarge)
            .lineLimit(1)
            .minimumScaleFactor(0.3)
            .foregroundStyle(textColor)

        }
        .padding(.horizontal, 20)
        .padding(.vertical, 15)
        .background(backgroundColor)

      }
      .clipShape(Capsule())
      .shimmer(isLoading: isLoading)
      .shadow(radius: 5, x: .zero, y: 5)
    }
    .disabled(isLoading)
  }
}

public struct FloatingActionButtonModifier: ViewModifier {

  private let title: LocalizableStringKey
  private let textColor: Color
  private let backgroundColor: Color
  private let icon: Image
  private let iconColor: Color
  private let isLoading: Bool
  private let action: () -> Void
  private let bottomPadding: CGFloat
  private let trailingPadding: CGFloat

  public init(
    title: LocalizableStringKey,
    textColor: Color = Theme.shared.color.onSurface,
    backgroundColor: Color = Theme.shared.color.secondary,
    icon: Image,
    iconColor: Color = Theme.shared.color.onSurface,
    bottomPadding: CGFloat = 20,
    trailingPadding: CGFloat = 15,
    isLoading: Bool = false,
    action: @escaping () -> Void
  ) {
    self.title = title
    self.textColor = textColor
    self.backgroundColor = backgroundColor
    self.icon = icon
    self.iconColor = iconColor
    self.bottomPadding = bottomPadding
    self.trailingPadding = trailingPadding
    self.action = action
    self.isLoading = isLoading
  }

  public func body(content: Content) -> some View {
    ZStack {
      content
      FloatingActionButtonView(
        title: title,
        textColor: textColor,
        backgroundColor: backgroundColor,
        icon: icon,
        iconColor: iconColor,
        isLoading: isLoading,
        action: action
      )
      .padding(.trailing, trailingPadding)
      .padding(.bottom, bottomPadding)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .edgesIgnoringSafeArea(.all)
  }
}

#Preview {
  Group {
    FloatingActionButtonView(
      title: LocalizableStringKey.addDocumentSubtitle,
      icon: Image(systemName: "calendar"),
      action: {}
    )
    .lightModePreview()

    FloatingActionButtonView(
      title: LocalizableStringKey.addDocumentSubtitle,
      icon: Image(systemName: "calendar"),
      action: {}
    )
    .darkModePreview()
  }
}
