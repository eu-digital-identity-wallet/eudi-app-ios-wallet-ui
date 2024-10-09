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

  private let displayLargeFont: Font = TypographyStyleEnum.h1.font
  private let displayMediumFont: Font = TypographyStyleEnum.h2.font
  private let displaySmallFont: Font = TypographyStyleEnum.h3.font

  private let headlineLargeFont: Font = TypographyStyleEnum.h4.font.weight(.bold)
  private let headlineMediumFont: Font = TypographyStyleEnum.h4.font
  private let headlineSmallFont: Font = TypographyStyleEnum.h5.font

  private let titleLargeFont: Font = TypographyStyleEnum.h6.font
  private let titleMediumFont: Font = TypographyStyleEnum.subtitle.font
  private let titleSmallFont: Font = TypographyStyleEnum.subtitle2.font

  private let bodyLargeFont: Font = TypographyStyleEnum.body1.font
  private let bodyMediumFont: Font =  TypographyStyleEnum.body2.font
  private let bodySmallFont: Font =  Font.custom(.regular, relativeTo: .footnote)

  private let labelLargeFont: Font = TypographyStyleEnum.button.font
  private let labelMediumFont: Font = Font.custom(.regular, relativeTo: .body)
  private let labelSmallFont: Font  = TypographyStyleEnum.overline.font

  private let displayLargeSpacing: CGFloat = TypographyStyleEnum.h1.spacing
  private let displayMediumSpacing: CGFloat = TypographyStyleEnum.h2.spacing
  private let displaySmallSpacing: CGFloat = TypographyStyleEnum.h3.spacing

  private let headlineLargeSpacing: CGFloat = TypographyStyleEnum.h4.spacing
  private let headlineMediumSpacing: CGFloat = TypographyStyleEnum.h4.spacing
  private let headlineSmallSpacing: CGFloat = TypographyStyleEnum.h5.spacing

  private let titleLargeSpacing: CGFloat = TypographyStyleEnum.h6.spacing
  private let titleMediumSpacing: CGFloat = TypographyStyleEnum.subtitle.spacing
  private let titleSmallSpacing: CGFloat = TypographyStyleEnum.subtitle2.spacing

  private let bodyLargeSpacing: CGFloat = TypographyStyleEnum.body1.spacing
  private let bodyMediumSpacing: CGFloat =  TypographyStyleEnum.body2.spacing
  private let bodySmallSpacing: CGFloat =  TypographyStyleEnum.body1.spacing

  private let labelLargeSpacing: CGFloat = TypographyStyleEnum.button.spacing
  private let labelMediumSpacing: CGFloat = TypographyStyleEnum.button.spacing
  private let labelSmallSpacing: CGFloat = TypographyStyleEnum.overline.spacing

  init() {
    Font.registerFonts()
  }

}

/*
 --M2--         --M3--                  --DS--
 h1          displayLarge        H1
 h2          displayMedium       H2
 h3          displaySmall        H3
 N/A          headlineLarge       N/A
 h4          headlineMedium      H4
 h5          headlineSmall       H5
 h6          titleLarge          Roboto Medium 20dp
 subtitle1   titleMedium         Roboto Medium 16dp
 subtitle2   titleSmall          Roboto Medium 14dp
 body1      bodyLarge           Body 1
 body2      bodyMedium          Body 2
 caption      bodySmall           Roboto Regular 12dp
 button      labelLarge          BUTTON
 N/A          labelMedium         N/A
 overline    labelSmall          OVERLINE
 */
