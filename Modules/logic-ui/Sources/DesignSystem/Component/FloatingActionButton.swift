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

public struct FloatingActionButton: View {

  private let title: LocalizableString.Key
  private let textColor: Color
  private let backgroundColor: Color
  private let icon: Image
  private let iconColor: Color
  private let action: () -> Void
  private let bottomPadding: CGFloat
  private let trailingPadding: CGFloat

  public init(title: LocalizableString.Key,
              textColor: Color = Theme.shared.color.textPrimaryDark,
              backgroundColor: Color = Theme.shared.color.secondary,
              icon: Image,
              iconColor: Color = Theme.shared.color.textPrimaryDark,
              bottomPadding: CGFloat = 20,
              trailingPadding: CGFloat = 15,
              action: @escaping () -> Void) {
    self.title = title
    self.textColor = textColor
    self.backgroundColor = backgroundColor
    self.icon = icon
    self.iconColor = iconColor
    self.bottomPadding = bottomPadding
    self.trailingPadding = trailingPadding
    self.action = action
  }

  public var body: some View {
    // FAB
    VStack {
      Spacer()
      HStack {
        Spacer()
        Button(action: action) {
          HStack(alignment: .center) {
            icon
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(maxHeight: 30)
              .foregroundStyle(iconColor)
            Text(title)
              .typography(ThemeManager.shared.font.labelLarge)
              .foregroundStyle(textColor)

          }
          .padding(.horizontal, trailingPadding)
          .padding(.vertical, bottomPadding)
          .background(backgroundColor)

        }
        .clipShape(Capsule())
        .shadow(radius: 3, x: 1, y: 3)
      }
    }
  }
}

public struct FloatingActionButtonModifier: ViewModifier {

  private let title: LocalizableString.Key
  private let textColor: Color
  private let backgroundColor: Color
  private let icon: Image
  private let iconColor: Color
  private let action: () -> Void
  private let bottomPadding: CGFloat
  private let trailingPadding: CGFloat

  public init(title: LocalizableString.Key,
              textColor: Color = Theme.shared.color.textPrimaryDark,
              backgroundColor: Color = Theme.shared.color.secondary,
              icon: Image,
              iconColor: Color = Theme.shared.color.textPrimaryDark,
              bottomPadding: CGFloat = 20,
              trailingPadding: CGFloat = 15,
              action: @escaping () -> Void) {
    self.title = title
    self.textColor = textColor
    self.backgroundColor = backgroundColor
    self.icon = icon
    self.iconColor = iconColor
    self.bottomPadding = bottomPadding
    self.trailingPadding = trailingPadding
    self.action = action
  }

  public func body(content: Content) -> some View {
    ZStack {
      content
      FloatingActionButton(title: title, textColor: textColor, backgroundColor: backgroundColor, icon: icon, iconColor: iconColor, bottomPadding: bottomPadding, trailingPadding: trailingPadding, action: action)
        .padding(.trailing, trailingPadding)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .edgesIgnoringSafeArea(.all)
  }
}
