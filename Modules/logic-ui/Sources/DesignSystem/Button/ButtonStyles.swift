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
import Foundation
import SwiftUI
import logic_resources

public struct OutlinePressedButtonStyle: ButtonStyle {

  public let outlineColor: Color
  public let pressedBackgroundColor: Color
  public let defaultBackgroundColor: Color

  public init(
    outlineColor: Color = Theme.shared.color.palette.dividerDark,
    pressedBackgroundColor: Color = Theme.shared.color.palette.dividerDark,
    defaultBackgroundColor: Color = Theme.shared.color.palette.backgroundPaper
  ) {
    self.outlineColor = outlineColor
    self.pressedBackgroundColor = pressedBackgroundColor
    self.defaultBackgroundColor = defaultBackgroundColor
  }

  public func makeBody(configuration: Configuration) -> some View {
    let isPressed = configuration.isPressed

    return configuration.label
      .padding()
      .contentShape(Rectangle())
      .frame(maxWidth: .infinity, alignment: .center)
      .overlay(
        RoundedRectangle(cornerRadius: 8.0)
          .stroke(outlineColor, lineWidth: 2.0)
      )
      .foregroundColor(outlineColor)
      .background(
        RoundedRectangle(cornerRadius: 8)
          .fill(isPressed ? pressedBackgroundColor : defaultBackgroundColor)
        )
      .animation(.easeInOut, value: 0.33)
  }
}

public struct PrimaryButtonStyle: ButtonStyle {

  public let outlineColor: Color
  public let pressedBackgroundColor: Color
  public let defaultBackgroundColor: Color

  public init(
    outlineColor: Color = Theme.shared.color.palette.tertiaryMain,
    pressedBackgroundColor: Color = Theme.shared.color.palette.dividerDark,
    defaultBackgroundColor: Color = Theme.shared.color.palette.tertiaryMain
  ) {
    self.outlineColor = outlineColor
    self.pressedBackgroundColor = pressedBackgroundColor
    self.defaultBackgroundColor = defaultBackgroundColor
  }

  public func makeBody(configuration: Configuration) -> some View {
    let isPressed = configuration.isPressed

    return configuration.label
      .padding()
      .contentShape(Rectangle())
      .frame(maxWidth: .infinity, alignment: .center)
      .overlay(
        RoundedRectangle(cornerRadius: 8.0)
          .stroke(outlineColor, lineWidth: 2.0)
      )
      .foregroundColor(outlineColor)
      .background(
        RoundedRectangle(cornerRadius: 8)
          .fill(isPressed ? pressedBackgroundColor : defaultBackgroundColor)
        )
      .animation(.easeInOut, value: 0.33)
  }
}
