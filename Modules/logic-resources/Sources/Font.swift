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

public extension Font {
  static func custom(_ font: RobotoFont, relativeTo style: Font.TextStyle) -> Font {
    custom(font.rawValue, size: style.size, relativeTo: style)
  }

  fileprivate static func registerFont(bundle: Bundle, fontName: String, fontExtension: String) {
    guard let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension),
          let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
          let font = CGFont(fontDataProvider) else {
      fatalError("Couldn't create font from filename: \(fontName) with extension \(fontExtension)")
    }

    var error: Unmanaged<CFError>?

    CTFontManagerRegisterGraphicsFont(font, &error)
  }

  static func registerFonts() {
    RobotoFont.allCases.forEach {
      registerFont(bundle: .module, fontName: $0.rawValue, fontExtension: "ttf")
    }
  }
}

enum TypographyStyleEnum {
  case h1
  case h2
  case h3
  case h4
  case h5
  case h6
  case subtitle
  case body1
  case subtitle2
  case body2
  case button
  case caption
  case overline

  var textStyle: (Font, CGFloat) {
    (font, spacing)
  }

  var font: Font {
    switch self {
    case .h1:
      Font.custom(.light, relativeTo: .largeTitle)
    case .h2:
      Font.custom(.light, relativeTo: .title)
    case .h3:
      Font.custom(.regular, relativeTo: .title2)
    case .h4:
      Font.custom(.regular, relativeTo: .title3)
    case .h5:
      Font.custom(.medium, relativeTo: .headline)
    case .h6:
      Font.custom(.medium, relativeTo: .subheadline)
    case .subtitle:
      Font.custom(.medium, relativeTo: .caption)
    case .body1:
      Font.custom(.regular, relativeTo: .body)
    case .subtitle2:
      Font.custom(.medium, relativeTo: .caption2)
    case .body2:
      Font.custom(.regular, relativeTo: .caption2)
    case .button:
      Font.custom(.medium, relativeTo: .body)
    case .overline:
      Font.custom(.regular, relativeTo: .footnote)
    case .caption:
      Font.custom(.regular, relativeTo: .footnote)
    }
  }

  var spacing: CGFloat {
    switch self {
    case .h1:
      -1.5
    case .h2:
      -0.5
    case .h3:
      0
    case .h4:
      0.25
    case .h5:
      0
    case .h6:
      0.15
    case .subtitle:
      0.15
    case .body1:
      0.1
    case .subtitle2:
      0.5
    case .body2:
      0.25
    case .button:
      1.25
    case .overline:
      1.5
    case .caption:
      0.4
    }
  }
}

extension Font.TextStyle {

  var size: CGFloat {
    switch self {
    case .largeTitle: return 96
    case .title: return 60
    case .title2: return 48
    case .title3: return 30
    case .headline: return 24
    case .subheadline: return 20
    case .body: return 16
    case .callout: return 16
    case .caption: return  16
    case .caption2: return 14
    case .footnote: return 10
    @unknown default:
      return 16
    }
  }

}
