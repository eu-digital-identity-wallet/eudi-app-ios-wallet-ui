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

public protocol ColorManagerProtocol: Sendable {

  var black: Color { get }
  var white: Color { get }
  var blue: Color { get }
  var red: Color { get }
  var grey: Color { get }
  var darkGrey: Color { get }

  var backgroundDefault: Color { get }
  var backgroundPaper: Color { get }
  var chipBackground: Color { get }
  var infoBackground: Color { get }
  var dividerDark: Color { get }
  var error: Color { get }
  var warning: Color { get }
  var info: Color { get }
  var primary: Color { get }
  var success: Color { get }
  var secondary: Color { get }
  var textDisabledDark: Color { get }
  var textDisabledLight: Color { get }
  var textPrimaryDark: Color { get }
  var textSecondaryDark: Color { get }
  var textSecondaryLight: Color { get }

  var material: MaterialColor { get }
}

final class ColorManager: ColorManagerProtocol {

  // MARK: - Properties

  enum PaletteColorEnum: String, CaseIterable {
    case backgroundDefault
    case backgroundPaper
    case chipBackground
    case infoBackground

    case dividerDark
    case lightGradientEnd
    case lightGradientStart

    case errorMain
    case warningMain
    case infoMain
    case primaryDark
    case primaryLight
    case primaryMain
    case successText
    case secondaryMain

    case textDisabledDark
    case textDisabledLight
    case textPrimaryDark
    case textSecondaryDark
    case textSecondaryLight
  }

  enum BaseColors: String, CaseIterable {
    case black
    case white
    case blue
    case red
    case grey
    case darkGrey
  }

  public var black: Color {
    Color(BaseColors.black.rawValue, bundle: bundle)
  }
  public var white: Color {
    Color(BaseColors.white.rawValue, bundle: bundle)
  }
  public var blue: Color {
    Color(BaseColors.blue.rawValue, bundle: bundle)
  }
  public var red: Color {
    Color(BaseColors.red.rawValue, bundle: bundle)
  }
  public var grey: Color {
    Color(BaseColors.grey.rawValue, bundle: bundle)
  }
  public var darkGrey: Color {
    Color(BaseColors.darkGrey.rawValue, bundle: bundle)
  }
  public var backgroundDefault: Color {
    Color(PaletteColorEnum.backgroundDefault.rawValue, bundle: bundle)
  }
  public var backgroundPaper: Color {
    Color(PaletteColorEnum.backgroundPaper.rawValue, bundle: bundle)
  }
  public var chipBackground: Color {
    Color(PaletteColorEnum.chipBackground.rawValue, bundle: bundle)
  }
  var infoBackground: Color {
    Color(PaletteColorEnum.infoBackground.rawValue, bundle: bundle)
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
    Color(PaletteColorEnum.errorMain.rawValue, bundle: bundle)
  }
  public var primaryDark: Color {
    Color(PaletteColorEnum.primaryDark.rawValue, bundle: bundle)
  }
  public var primaryLight: Color {
    Color(PaletteColorEnum.primaryLight.rawValue, bundle: bundle)
  }
  public var primary: Color {
    Color(PaletteColorEnum.primaryMain.rawValue, bundle: bundle)
  }
  public var success: Color {
    Color(PaletteColorEnum.successText.rawValue, bundle: bundle)
  }
  public var secondary: Color {
    Color(PaletteColorEnum.secondaryMain.rawValue, bundle: bundle)
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
  var warning: Color {
    Color(PaletteColorEnum.warningMain.rawValue, bundle: bundle)
  }
  var info: Color {
    Color(PaletteColorEnum.infoMain.rawValue, bundle: bundle)
  }

  let bundle: Bundle

  let material: MaterialColor

  // MARK: - Lifecycle

  init(bundle: Bundle) {
    material = MaterialColor(bundle: bundle)
    self.bundle = bundle
  }
}

struct ColorDescr: Identifiable {
  var id = UUID()
  var color: Color
  var description: String
}

struct ColorsPreview: View {
  func colors() -> [ColorDescr] {
    return ColorManager.PaletteColorEnum.allCases.map { colorEnum in
      ColorDescr(
        color: Color(colorEnum.rawValue, bundle: .assetsBundle),
        description: colorEnum.rawValue
      )
    }
  }
  func baseColors() -> [ColorDescr] {
    return ColorManager.BaseColors.allCases.map { colorEnum in
      ColorDescr(
        color: Color(colorEnum.rawValue, bundle: .assetsBundle),
        description: colorEnum.rawValue
      )
    }
  }

  var body: some View {
    ScrollView {
      VStack {
        Text("Palette colors")
          .font(.title)
        ForEach(colors()) { touple in
          ZStack {
            touple.color
            Text(touple.description).foregroundColor(Color.black)
          }
        }
        Text("Base colors")
          .font(.title)
        ForEach(baseColors()) { touple in
          ZStack {
            touple.color
            Text(touple.description).foregroundColor(Color.black)
          }
        }
      }
    }
  }
}

#Preview {
  ColorsPreview()
}
