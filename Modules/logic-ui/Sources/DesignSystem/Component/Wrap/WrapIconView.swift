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

public struct WrapIconView: View {

  private let title: LocalizableStringKey?
  private let textColor: Color
  private let backgroundColor: Color
  private let systemIcon: String
  private let gravity: Gravity
  private let cornerRadius: CGFloat
  private let isEnabled: Bool

  public init(
    title: LocalizableStringKey? = nil,
    textColor: Color = .white,
    backgroundColor: Color = Theme.shared.color.background,
    systemIcon: String,
    gravity: Gravity = .center,
    isEnabled: Bool = true,
    cornerRadius: CGFloat = Theme.shared.shape.large
  ) {
    self.title = title
    self.textColor = textColor
    self.backgroundColor = backgroundColor
    self.systemIcon = systemIcon
    self.gravity = gravity
    self.isEnabled = isEnabled
    self.cornerRadius = cornerRadius
  }

  public var body: some View {
    HStack {
      if gravity == .center || gravity == .end {
        Spacer()
      }

      Image(systemName: systemIcon)
        .resizable()
        .scaledToFit()
        .frame(width: 25)
        .foregroundColor(textColor)

      HSpacer.small()

      if let title {
        Text(title)
          .foregroundColor(textColor)
      }

      if gravity == .center || gravity == .start {
        Spacer()
      }
    }
    .padding()
    .background(backgroundColor)
    .cornerRadius(cornerRadius)
  }
}

public extension WrapIconView {
  enum Gravity {
    case center, start, end
  }
}

#Preview {
  Group {
    WrapIconView(
      title: LocalizableStringKey.addDoc,
      textColor: Theme.shared.color.onSurface,
      systemIcon: "calendar"
    )
    .lightModePreview()

    WrapIconView(
      title: LocalizableStringKey.addDoc,
      textColor: Theme.shared.color.onSurface,
      systemIcon: "calendar"
    )
    .darkModePreview()
  }
}
