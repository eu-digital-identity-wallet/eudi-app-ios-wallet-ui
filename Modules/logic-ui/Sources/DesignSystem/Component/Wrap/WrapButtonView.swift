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

public struct WrapButtonView: View {

  private let title: LocalizableString.Key
  private let onAction: () -> Void
  private let textColor: Color
  private let backgroundColor: Color
  private let iconColor: Color
  private let icon: Image?
  private let gravity: Gravity
  private let cornerRadius: CGFloat
  private let isEnabled: Bool
  private let borderWidth: CGFloat
  private let borderColor: Color
  private let isLoading: Bool

  public init(
    title: LocalizableString.Key,
    textColor: Color = Theme.shared.color.textPrimaryDark,
    backgroundColor: Color = Theme.shared.color.primary,
    iconColor: Color = Theme.shared.color.primary,
    icon: Image? = nil,
    gravity: Gravity = .center,
    isLoading: Bool = false,
    isEnabled: Bool = true,
    cornerRadius: CGFloat = Theme.shared.shape.small,
    borderWidth: CGFloat = 0,
    borderColor: Color = .clear,
    onAction: @autoclosure @escaping () -> Void
  ) {
    self.title = title
    self.textColor = textColor
    self.backgroundColor = backgroundColor
    self.iconColor = iconColor
    self.icon = icon
    self.gravity = gravity
    self.isLoading = isLoading
    self.isEnabled = isEnabled
    self.cornerRadius = cornerRadius
    self.borderWidth = borderWidth
    self.borderColor = borderColor
    self.onAction = onAction
  }

  public init(
    style: ButtonViewStyle,
    title: LocalizableString.Key,
    iconColor: Color = Theme.shared.color.primary,
    icon: Image? = nil,
    gravity: Gravity = .center,
    isLoading: Bool = false,
    isEnabled: Bool = true,
    cornerRadius: CGFloat = Theme.shared.shape.small,
    onAction: @autoclosure @escaping () -> Void
  ) {
    self.title = title
    self.textColor = style.textColor
    self.backgroundColor = style.backgroundColor
    self.iconColor = style.textColor
    self.icon = icon
    self.gravity = gravity
    self.isLoading = isLoading
    self.isEnabled = isEnabled
    self.cornerRadius = cornerRadius
    self.borderWidth = style.borderWidth
    self.borderColor = style.borderColor
    self.onAction = onAction
  }

  public var body: some View {
    Button(
      action: { onAction() },
      label: {
        HStack {

          if gravity == .center || gravity == .end {
            Spacer()
          }

          if let icon {

            icon
              .resizable()
              .scaledToFit()
              .frame(width: 25)
              .foregroundColor(iconColor)

            HSpacer.medium()
          }

          Text(title)
            .typography(Theme.shared.font.labelLarge)
            .foregroundColor(textColor)
            .buttonStyle(OutlinePressedButtonStyle())

          if gravity == .center || gravity == .start {
            Spacer()
          }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(backgroundColor)
        .cornerRadius(cornerRadius)
        .overlay(
          RoundedRectangle(cornerRadius: cornerRadius)
            .stroke(borderColor, lineWidth: borderWidth)
        )
      }
    )
    .if(!isEnabled && !isLoading) {
      $0.opacity(0.5)
    }
    .disabled(isLoading || !isEnabled)
    .shimmer(isLoading: isLoading)
  }
}

public extension WrapButtonView {
  enum Gravity {
    case center, start, end
  }
}
