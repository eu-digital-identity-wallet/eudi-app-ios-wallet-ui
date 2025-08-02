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

public struct TypographyStyle: Sendable {
  public let font: Font
  public let spacing: CGFloat
}

public protocol TypographyManagerProtocol: Sendable {

  var displayLarge: TypographyStyle { get }
  var displayMedium: TypographyStyle { get }
  var displaySmall: TypographyStyle { get }

  var headlineLarge: TypographyStyle { get }
  var headlineMedium: TypographyStyle { get }
  var headlineSmall: TypographyStyle { get }

  var titleLarge: TypographyStyle { get }
  var titleMedium: TypographyStyle { get }
  var titleSmall: TypographyStyle { get }

  var bodyLarge: TypographyStyle { get }
  var bodyMedium: TypographyStyle { get }
  var bodySmall: TypographyStyle { get }

  var labelLarge: TypographyStyle { get }
  var labelMedium: TypographyStyle { get }
  var labelSmall: TypographyStyle { get }

}

final class TypographyManager: TypographyManagerProtocol {

  var displayLarge: TypographyStyle {
    TypographyStyle(font: displayLargeFont, spacing: displayLargeSpacing)
  }
  var displayMedium: TypographyStyle {
    TypographyStyle(font: displayMediumFont, spacing: displayMediumSpacing)
  }
  var displaySmall: TypographyStyle {
    TypographyStyle(font: displaySmallFont, spacing: displaySmallSpacing)
  }

  var headlineLarge: TypographyStyle {
    TypographyStyle(font: headlineLargeFont, spacing: headlineLargeSpacing)
  }
  var headlineMedium: TypographyStyle {
    TypographyStyle(font: headlineMediumFont, spacing: headlineMediumSpacing)
  }
  var headlineSmall: TypographyStyle {
    TypographyStyle(font: headlineSmallFont, spacing: headlineSmallSpacing)
  }

  var titleLarge: TypographyStyle {
    TypographyStyle(font: titleLargeFont, spacing: titleLargeSpacing)
  }
  var titleMedium: TypographyStyle {
    TypographyStyle(font: titleMediumFont, spacing: titleMediumSpacing)
  }
  var titleSmall: TypographyStyle {
    TypographyStyle(font: titleSmallFont, spacing: titleSmallSpacing)
  }

  var bodyLarge: TypographyStyle {
    TypographyStyle(font: bodyLargeFont, spacing: bodyLargeSpacing)
  }
  var bodyMedium: TypographyStyle {
    TypographyStyle(font: bodyMediumFont, spacing: bodyMediumSpacing)
  }
  var bodySmall: TypographyStyle {
    TypographyStyle(font: bodySmallFont, spacing: bodySmallSpacing)
  }

  var labelLarge: TypographyStyle {
    TypographyStyle(font: labelLargeFont, spacing: labelLargeSpacing)
  }
  var labelMedium: TypographyStyle {
    TypographyStyle(font: labelMediumFont, spacing: labelMediumSpacing)
  }
  var labelSmall: TypographyStyle {
    TypographyStyle(font: labelSmallFont, spacing: labelSmallSpacing)
  }

  private let displayLargeFont = Font.largeTitle
  private let displayMediumFont = Font.title
  private let displaySmallFont = Font.title2

  private let headlineLargeFont = Font.title3
  private let headlineMediumFont = Font.headline
  private let headlineSmallFont = Font.subheadline

  private let titleLargeFont = Font.title
  private let titleMediumFont = Font.title2
  private let titleSmallFont = Font.title3

  private let bodyLargeFont = Font.body
  private let bodyMediumFont = Font.callout
  private let bodySmallFont = Font.footnote

  private let labelLargeFont = Font.headline
  private let labelMediumFont = Font.caption
  private let labelSmallFont = Font.caption2

  private let displayLargeSpacing: CGFloat = 0
  private let displayMediumSpacing: CGFloat = 0
  private let displaySmallSpacing: CGFloat = 0

  private let headlineLargeSpacing: CGFloat = 0
  private let headlineMediumSpacing: CGFloat = 0
  private let headlineSmallSpacing: CGFloat = 0

  private let titleLargeSpacing: CGFloat = 0
  private let titleMediumSpacing: CGFloat = 0
  private let titleSmallSpacing: CGFloat = 0

  private let bodyLargeSpacing: CGFloat = 0
  private let bodyMediumSpacing: CGFloat =  0
  private let bodySmallSpacing: CGFloat =  0

  private let labelLargeSpacing: CGFloat = 0
  private let labelMediumSpacing: CGFloat = 0
  private let labelSmallSpacing: CGFloat = 0
}

extension Font.TextStyle {
  var defaultSize: CGFloat {
    switch self {
      case .largeTitle: return 34
      case .title: return 28
      case .title2: return 22
      case .title3: return 20
      case .headline: return 17
      case .subheadline: return 15
      case .body: return 17
      case .callout: return 16
      case .caption: return 12
      case .caption2: return 11
      case .footnote: return 13
      @unknown default:
        return 17
    }
  }
}
