/*
 * Copyright (c) 2025 European Commission
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

  var primary: Color { get }
  var onPrimary: Color { get }
  var primaryContainer: Color { get }
  var onPrimaryContainer: Color { get }
  var onPrimaryFixed: Color { get }
  var onPrimaryFixedVariant: Color { get }
  var primaryFixedDim: Color { get }
  var secondary: Color { get }
  var onSecondary: Color { get }
  var secondaryContainer: Color { get }
  var onSecondaryContainer: Color { get }
  var onSecondaryFixed: Color { get }
  var onSecondaryFixedVariant: Color { get }
  var secondaryFixed: Color { get }
  var secondaryFixedDim: Color { get }
  var tertiary: Color { get }
  var onTertiary: Color { get }
  var tertiaryContainer: Color { get }
  var onTertiaryContainer: Color { get }
  var error: Color { get }
  var errorContainer: Color { get }
  var onError: Color { get }
  var onErrorContainer: Color { get }
  var background: Color { get }
  var onBackground: Color { get }
  var surface: Color { get }
  var onSurface: Color { get }
  var surfaceVariant: Color { get }
  var onSurfaceVariant: Color { get }
  var surfaceTint: Color { get }
  var surfaceDim: Color { get }
  var surfaceBright: Color { get }
  var surfaceContainerLowest: Color { get }
  var surfaceContainerLow: Color { get }
  var surfaceContainer: Color { get }
  var surfaceContainerHigh: Color { get }
  var surfaceContainerHighest: Color { get }
  var outline: Color { get }
  var outlineVariant: Color { get }
  var inverseOnSurface: Color { get }
  var inverseSurface: Color { get }
  var inversePrimary: Color { get }
  var scrim: Color { get }
  var shadow: Color { get }

  var pending: Color { get }
  var success: Color { get }
  var warning: Color { get }
}

final class ColorManager: ColorManagerProtocol {
  // MARK: - Properties

  enum MaterialColors: String, CaseIterable {
    case primary
    case onPrimary
    case primaryContainer
    case onPrimaryContainer
    case onPrimaryFixed
    case onPrimaryFixedVariant
    case primaryFixedDim
    case secondary
    case onSecondary
    case secondaryContainer
    case onSecondaryContainer
    case onSecondaryFixed
    case onSecondaryFixedVariant
    case secondaryFixed
    case secondaryFixedDim
    case tertiary
    case onTertiary
    case tertiaryContainer
    case onTertiaryContainer
    case error
    case errorContainer
    case onError
    case onErrorContainer
    case background
    case onBackground
    case surface
    case onSurface
    case surfaceVariant
    case onSurfaceVariant
    case surfaceTint
    case surfaceDim
    case surfaceBright
    case surfaceContainerLowest
    case surfaceContainerLow
    case surfaceContainer
    case surfaceContainerHigh
    case surfaceContainerHighest
    case outline
    case outlineVariant
    case inverseOnSurface
    case inverseSurface
    case inversePrimary
    case scrim
    case shadow
  }

  enum BaseColors: String, CaseIterable {
    case black
    case white
    case blue
    case red
    case grey
    case darkGrey
    case success
    case pending
    case warning
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
  public var success: Color {
    Color(BaseColors.success.rawValue, bundle: bundle)
  }
  public var pending: Color {
    Color(BaseColors.pending.rawValue, bundle: bundle)
  }
  public var warning: Color {
    Color(BaseColors.warning.rawValue, bundle: bundle)
  }
  public var primary: Color {
    Color(MaterialColors.primary.rawValue, bundle: bundle)
  }
  public var onPrimary: Color {
    Color(MaterialColors.onPrimary.rawValue, bundle: bundle)
  }
  public var primaryContainer: Color {
    Color(MaterialColors.primaryContainer.rawValue, bundle: bundle)
  }
  public var onPrimaryContainer: Color {
    Color(MaterialColors.onPrimaryContainer.rawValue, bundle: bundle)
  }
  public var onPrimaryFixed: Color {
    Color(MaterialColors.onPrimaryFixed.rawValue, bundle: bundle)
  }
  public var onPrimaryFixedVariant: Color {
    Color(MaterialColors.onPrimaryFixedVariant.rawValue, bundle: bundle)
  }
  public var primaryFixedDim: Color {
    Color(MaterialColors.primaryFixedDim.rawValue, bundle: bundle)
  }
  public var secondaryFixedDim: Color {
    Color(MaterialColors.secondaryFixedDim.rawValue, bundle: bundle)
  }

  // MARK: - Secondary

  public var secondary: Color {
    Color(MaterialColors.secondary.rawValue, bundle: bundle)
  }

  public var onSecondary: Color {
    Color(MaterialColors.onSecondary.rawValue, bundle: bundle)
  }
  public var secondaryContainer: Color {
    Color(MaterialColors.secondaryContainer.rawValue, bundle: bundle)
  }
  public var onSecondaryContainer: Color {
    Color(MaterialColors.onSecondaryContainer.rawValue, bundle: bundle)
  }
  public var onSecondaryFixed: Color {
    Color(MaterialColors.onSecondaryFixed.rawValue, bundle: bundle)
  }
  public var onSecondaryFixedVariant: Color {
    Color(MaterialColors.onSecondaryFixedVariant.rawValue, bundle: bundle)
  }
  public var secondaryFixed: Color {
    Color(MaterialColors.secondaryFixed.rawValue, bundle: bundle)
  }

  // MARK: - Tertiary

  public var tertiary: Color {
    Color(MaterialColors.tertiary.rawValue, bundle: bundle)
  }
  public var onTertiary: Color {
    Color(MaterialColors.onTertiary.rawValue, bundle: bundle)
  }
  public var tertiaryContainer: Color {
    Color(MaterialColors.tertiaryContainer.rawValue, bundle: bundle)
  }
  public var onTertiaryContainer: Color {
    Color(MaterialColors.onTertiaryContainer.rawValue, bundle: bundle)
  }

  // MARK: - Error

  public var error: Color {
    Color(MaterialColors.error.rawValue, bundle: bundle)
  }
  public var errorContainer: Color {
    Color(MaterialColors.errorContainer.rawValue, bundle: bundle)
  }
  public var onError: Color {
    Color(MaterialColors.onError.rawValue, bundle: bundle)
  }
  public var onErrorContainer: Color {
    Color(MaterialColors.onErrorContainer.rawValue, bundle: bundle)
  }

  // MARK: - Background

  public var background: Color {
    Color(MaterialColors.background.rawValue, bundle: bundle)
  }
  public var onBackground: Color {
    Color(MaterialColors.onBackground.rawValue, bundle: bundle)
  }

  // MARK: - Surface

  public var surface: Color {
    Color(MaterialColors.surface.rawValue, bundle: bundle)
  }
  public var onSurface: Color {
    Color(MaterialColors.onSurface.rawValue, bundle: bundle)
  }
  public var surfaceVariant: Color {
    Color(MaterialColors.surfaceVariant.rawValue, bundle: bundle)
  }
  public var onSurfaceVariant: Color {
    Color(MaterialColors.onSurfaceVariant.rawValue, bundle: bundle)
  }
  public var surfaceTint: Color {
    Color(MaterialColors.surfaceTint.rawValue, bundle: bundle)
  }
  public var surfaceDim: Color {
    Color(MaterialColors.surfaceDim.rawValue, bundle: bundle)
  }
  public var surfaceBright: Color {
    Color(MaterialColors.surfaceBright.rawValue, bundle: bundle)
  }
  public var surfaceContainerLowest: Color {
    Color(MaterialColors.surfaceContainerLowest.rawValue, bundle: bundle)
  }
  public var surfaceContainerLow: Color {
    Color(MaterialColors.surfaceContainerLow.rawValue, bundle: bundle)
  }
  public var surfaceContainerHigh: Color {
    Color(MaterialColors.surfaceContainerHigh.rawValue, bundle: bundle)
  }
  public var surfaceContainerHighest: Color {
    Color(MaterialColors.surfaceContainerHighest.rawValue, bundle: bundle)
  }
  public var surfaceContainer: Color {
    Color(MaterialColors.surfaceContainer.rawValue, bundle: bundle)
  }

  // MARK: - Outline

  public var outline: Color {
    Color(MaterialColors.outline.rawValue, bundle: bundle)
  }

  public var outlineVariant: Color {
    Color(MaterialColors.outlineVariant.rawValue, bundle: bundle)
  }
  // MARK: - Inverse

  public var inverseOnSurface: Color {
    Color(MaterialColors.inverseOnSurface.rawValue, bundle: bundle)
  }
  public var inverseSurface: Color {
    Color(MaterialColors.inverseSurface.rawValue, bundle: bundle)
  }
  public var inversePrimary: Color {
    Color(MaterialColors.inversePrimary.rawValue, bundle: bundle)
  }

  // MARK: - Scrim

  public var scrim: Color {
    Color(MaterialColors.scrim.rawValue, bundle: bundle)
  }
  public var shadow: Color {
    Color(MaterialColors.shadow.rawValue, bundle: bundle)
  }

  let bundle: Bundle

  // MARK: - Lifecycle

  init(bundle: Bundle) {
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
    return ColorManager.MaterialColors.allCases.map { colorEnum in
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
        Text("Material colors")
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
