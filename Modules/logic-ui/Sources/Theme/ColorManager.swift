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

  var primary: Color { get }
  var onPrimary: Color { get }
  var primaryContainer: Color { get }
  var onPrimaryContainer: Color { get }
  var inversePrimary: Color { get }
  var secondary: Color { get }
  var onSecondary: Color { get }
  var secondaryContainer: Color { get }
  var onSecondaryContainer: Color { get }
  var tertiary: Color { get }
  var onTertiary: Color { get }
  var tertiaryContainer: Color { get }
  var onTertiaryContainer: Color { get }
  var background: Color { get }
  var onBackground: Color { get }
  var surface: Color { get }
  var onSurface: Color { get }
  var surfaceVariant: Color { get }
  var onSurfaceVariant: Color { get }
  var surfaceTint: Color { get }
  var inverseSurface: Color { get }
  var inverseOnSurface: Color { get }
  var error: Color { get }
  var onError: Color { get }
  var errorContainer: Color { get }
  var onErrorContainer: Color { get }
  var outline: Color { get }
  var outlineVariant: Color { get }
  var scrim: Color { get }
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

  var primary: Color {
    Color(ColorEnum.lightBlue.rawValue, bundle: bundle)
  }
  var onPrimary: Color {
    Color(PrimaryColors.white.rawValue, bundle: bundle)
  }
  var primaryContainer: Color {
    Color(ColorEnum.lightBlue.rawValue, bundle: bundle)
  }
  var onPrimaryContainer: Color {
    Color(PrimaryColors.black.rawValue, bundle: bundle)
  }
  var inversePrimary: Color {
    Color(ColorEnum.lightBlue.rawValue, bundle: bundle)
  }
  var secondary: Color {
    Color(ColorEnum.secondaryMain.rawValue, bundle: bundle)
  }
  var onSecondary: Color {
    Color(PrimaryColors.white.rawValue, bundle: bundle)
  }
  var secondaryContainer: Color {
    Color(ColorEnum.secondaryMain.rawValue, bundle: bundle)
  }
  var onSecondaryContainer: Color {
    Color(PrimaryColors.white.rawValue, bundle: bundle)
  }
  var tertiary: Color {
    Color(ColorEnum.tertiaryMain.rawValue, bundle: bundle)
  }
  var onTertiary: Color {
    Color(PrimaryColors.black.rawValue, bundle: bundle)
  }
  var tertiaryContainer: Color {
    Color(ColorEnum.tertiaryMain.rawValue, bundle: bundle)
  }
  var onTertiaryContainer: Color {
    Color(PrimaryColors.black.rawValue, bundle: bundle)
  }
  var background: Color {
    Color(ColorEnum.backgroundDefault.rawValue, bundle: bundle)
  }
  var onBackground: Color {
    Color(PrimaryColors.white.rawValue, bundle: bundle)
  }
  var surface: Color {
    Color(PrimaryColors.black.rawValue, bundle: bundle)
  }
  var onSurface: Color {
    Color(PrimaryColors.white.rawValue, bundle: bundle)
  }
  var surfaceVariant: Color {
    Color(PrimaryColors.black.rawValue, bundle: bundle)
  }
  var onSurfaceVariant: Color {
    Color(PrimaryColors.white.rawValue, bundle: bundle)
  }
  var surfaceTint: Color {
    Color(ColorEnum.lightBlue.rawValue, bundle: bundle)
  }
  var inverseSurface: Color {
    Color(ColorEnum.lightBlue.rawValue, bundle: bundle)
  }
  var inverseOnSurface: Color {
    Color(ColorEnum.lightBlue.rawValue, bundle: bundle)
  }
  var error: Color {
    Color(ColorEnum.onError.rawValue, bundle: bundle)
  }
  var onError: Color {
    Color(ColorEnum.textSecondaryDark.rawValue, bundle: bundle)
  }
  var errorContainer: Color {
    Color(ColorEnum.onError.rawValue, bundle: bundle)
  }
  var onErrorContainer: Color {
    Color(ColorEnum.onError.rawValue, bundle: bundle)
  }
  var outline: Color {
    Color(ColorEnum.dividerDark.rawValue, bundle: bundle)
  }
  var outlineVariant: Color {
    Color(ColorEnum.dividerDark.rawValue, bundle: bundle)
  }
  var scrim: Color {
    Color(PrimaryColors.blue.rawValue, bundle: bundle)
  }
}
