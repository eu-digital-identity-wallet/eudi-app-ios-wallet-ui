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

public struct PaletteColor {
  enum PaletteColorEnum: String {
    case backgroundDefault
    case backgroundPaper
    case dividerDark
    case lightGradientEnd
    case lightGradientStart
    case error
    case primaryDark
    case primaryLight
    case secondaryMain
    case successText
    case tertiaryMain
    case textDisabledDark
    case textDisabledLight
    case textPrimaryDark
    case textSecondaryDark
    case textSecondaryLight
  }

  var bundle: Bundle

  public var backgroundDefault: Color {
    Color(PaletteColorEnum.backgroundDefault.rawValue, bundle: bundle)
  }
  public var backgroundPaper: Color {
    Color(PaletteColorEnum.backgroundPaper.rawValue, bundle: bundle)
  }
  public var dividerDark: Color {
    Color(PaletteColorEnum.dividerDark.rawValue, bundle: bundle)
  }
  public var lightGradientEnd: Color {
    Color(PaletteColorEnum.lightGradientEnd.rawValue, bundle: bundle)
  }
  public var lightGradientStart: Color {
    Color(PaletteColorEnum.lightGradientStart.rawValue, bundle: bundle)
  }
  public var error: Color {
    Color(PaletteColorEnum.error.rawValue, bundle: bundle)
  }
  public var primaryDark: Color {
    Color(PaletteColorEnum.primaryDark.rawValue, bundle: bundle)
  }
  public var primaryLight: Color {
    Color(PaletteColorEnum.primaryLight.rawValue, bundle: bundle)
  }
  public var secondaryMain: Color {
    Color(PaletteColorEnum.secondaryMain.rawValue, bundle: bundle)
  }
  public var successText: Color {
    Color(PaletteColorEnum.successText.rawValue, bundle: bundle)
  }
  public var tertiaryMain: Color {
    Color(PaletteColorEnum.tertiaryMain.rawValue, bundle: bundle)
  }
  public var textDisabledDark: Color {
    Color(PaletteColorEnum.textDisabledDark.rawValue, bundle: bundle)
  }
  public var textDisabledLight: Color {
    Color(PaletteColorEnum.textDisabledLight.rawValue, bundle: bundle)
  }
  public var textPrimaryDark: Color {
    Color(PaletteColorEnum.textPrimaryDark.rawValue, bundle: bundle)
  }
  public var textSecondaryDark: Color {
    Color(PaletteColorEnum.textSecondaryDark.rawValue, bundle: bundle)
  }
  public var textSecondaryLight: Color {
    Color(PaletteColorEnum.textSecondaryLight.rawValue, bundle: bundle)
  }
}
