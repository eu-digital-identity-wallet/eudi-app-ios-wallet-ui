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

public struct WrapIconView: View {

  private let title: LocalizedStringKey?
  private let textColor: Color
  private let backgroundColor: Color
  private let systemIcon: String
  private let gravity: Gravity
  private let cornerRadius: CGFloat
  private let isEnabled: Bool

  public init(
    title: LocalizedStringKey? = nil,
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
