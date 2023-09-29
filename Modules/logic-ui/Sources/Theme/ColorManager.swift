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

public protocol ColorManagerProtocol {

  var black: Color { get }
  var white: Color { get }
  var blue: Color { get }
  var red: Color { get }
  var grey: Color { get }
  var darkGrey: Color { get }

  var backgroundDefault: Color { get }
  var dividerDark: Color { get }
  var lightBlue: Color { get }
  var lightGradientEnd: Color { get }
  var lightGradientStart: Color { get }
  var onError: Color { get }
  var secondaryMain: Color { get }
  var successText: Color { get }
  var tertiaryMain: Color { get }
  var textDisabledDark: Color { get }
  var textPrimaryDark: Color { get }
  var textSecondaryDark: Color { get }
}

class ColorManager: ColorManagerProtocol {

  enum ColorEnum: String {
    case backgroundDefault
    case dividerDark
    case lightBlue
    case lightGradientEnd
    case lightGradientStart
    case onError
    case secondaryMain
    case successText
    case tertiaryMain
    case textDisabledDark
    case textPrimaryDark
    case textSecondaryDark
  }

  enum PrimaryColors: String {
    case black
    case white
    case blue
    case red
    case grey
    case darkGrey
  }

  // MARK: - Properties

  var bundle: Bundle
  // MARK: - Lifecycle

  init(bundle: Bundle) {
    self.bundle = bundle
  }
  // MARK: - Primary Colors

  var black: Color {
    Color(PrimaryColors.black.rawValue, bundle: bundle)
  }
  var white: Color {
    Color(PrimaryColors.white.rawValue, bundle: bundle)
  }
  var blue: Color {
    Color(PrimaryColors.blue.rawValue, bundle: bundle)
  }
  var red: Color {
    Color(PrimaryColors.red.rawValue, bundle: bundle)
  }
  var grey: Color {
    Color(PrimaryColors.grey.rawValue, bundle: bundle)
  }
  var darkGrey: Color {
    Color(PrimaryColors.darkGrey.rawValue, bundle: bundle)
  }

  // MARK: - Colors

  var backgroundDefault: Color {
    Color(ColorEnum.backgroundDefault.rawValue, bundle: bundle)
  }

  var dividerDark: Color {
    Color(ColorEnum.dividerDark.rawValue, bundle: bundle)
  }

  var lightBlue: Color {
    Color(ColorEnum.lightBlue.rawValue, bundle: bundle)
  }

  var lightGradient: Gradient {
    Gradient(colors: [self.lightGradientEnd, self.lightGradientStart])
  }

  var lightGradientEnd: Color {
    Color(ColorEnum.lightGradientEnd.rawValue, bundle: bundle)
  }

  var lightGradientStart: Color {
    Color(ColorEnum.lightGradientStart.rawValue, bundle: bundle)
  }

  var onError: Color {
    Color(ColorEnum.onError.rawValue, bundle: bundle)
  }

  var secondaryMain: Color {
    Color(ColorEnum.secondaryMain.rawValue, bundle: bundle)
  }

  var successText: Color {
    Color(ColorEnum.successText.rawValue, bundle: bundle)
  }

  var tertiaryMain: Color {
    Color(ColorEnum.tertiaryMain.rawValue, bundle: bundle)
  }

  var textDisabledDark: Color {
    Color(ColorEnum.textDisabledDark.rawValue, bundle: bundle)
  }

  var textPrimaryDark: Color {
    Color(ColorEnum.textPrimaryDark.rawValue, bundle: bundle)
  }

  var textSecondaryDark: Color {
    Color(ColorEnum.textSecondaryDark.rawValue, bundle: bundle)
  }

}
