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

public struct MaterialColor: Sendable {
  enum MaterialColors: String {
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

  var bundle: Bundle

  // MARK: - Primary

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
}
