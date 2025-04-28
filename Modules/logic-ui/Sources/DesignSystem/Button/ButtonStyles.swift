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

public struct OutlinePressedButtonStyle: ButtonStyle {

  public let outlineColor: Color
  public let pressedBackgroundColor: Color
  public let defaultBackgroundColor: Color

  public init(
    outlineColor: Color = Theme.shared.color.onSurface,
    pressedBackgroundColor: Color = Theme.shared.color.onSurface,
    defaultBackgroundColor: Color = Theme.shared.color.surface
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
