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
  static func custom(_ font: Roboto, relativeTo style: Font.TextStyle) -> Font {
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
    Roboto.allCases.forEach {
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

// 32pt
var Title: Font = .custom(.medium, relativeTo: .largeTitle)
// 24pt
var SubTitle: Font = .custom(.medium, relativeTo: .title)

var SubTitle2: Font = .custom(.medium, relativeTo: .title2)
// 20pt
var Text: Font = .custom(.medium, relativeTo: .headline)

var Text2: Font = .custom(.medium, relativeTo: .headline)
// 16pt
var Text3: Font = .custom(.regular, relativeTo: .callout)
// 12pt
var Text4: Font = .custom(.regular, relativeTo: .caption)

var Text5: Font  = .custom(.regular, relativeTo: .caption)
// 14 pt
var Body: Font = .custom(.regular, relativeTo: .body)

var Body2: Font = .custom(.regular, relativeTo: .body)
