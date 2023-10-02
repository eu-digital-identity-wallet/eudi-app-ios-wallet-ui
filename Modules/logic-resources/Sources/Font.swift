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

extension Font.TextStyle {
  var size: CGFloat {
    switch self {
    case .largeTitle: return 32
    case .title: return 24
    case .title2: return 24
    case .headline: return 20
    case .body: return 14
    case .callout: return 16
    case .caption: return 12
    default:
      return 14
    }
  }
}
