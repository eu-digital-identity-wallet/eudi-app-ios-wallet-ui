/*
 * Copyright (c) 2026 European Commission
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

  // MARK: - Lifecycle

  private let fontConfig: [String: String]

  /// Reads PostScript names from `WalletFontConfig.plist` in `bundle`.
  /// Falls back to system fonts when the plist is absent or a name is not
  /// registered — `Font.custom` handles this silently with no crash.
  init(bundle: Bundle = .assetsBundle) {
    if let url = bundle.url(forResource: "WalletFontConfig", withExtension: "plist"),
       let dict = NSDictionary(contentsOf: url) as? [String: String] {
      fontConfig = dict
    } else {
      fontConfig = [:]
    }
  }

  // MARK: - Font resolution

  /// Resolves a font by weight key and text style.
  /// Uses `Font.custom` when a PostScript name is configured; falls back to
  /// the system font for `textStyle` otherwise. `defaultSize` provides the
  /// base point size that `Font.custom(relativeTo:)` scales with Dynamic Type.
  private func font(_ key: String, _ textStyle: Font.TextStyle) -> Font {
    guard let name = fontConfig[key], !name.isEmpty else {
      return .system(textStyle)
    }
    return .custom(name, size: textStyle.defaultSize, relativeTo: textStyle)
  }

  private func style(_ key: String, _ textStyle: Font.TextStyle) -> TypographyStyle {
    TypographyStyle(font: font(key, textStyle), spacing: 0)
  }

  // MARK: - Type scale

  var displayLarge: TypographyStyle { style("bold", .largeTitle) }
  var displayMedium: TypographyStyle { style("bold", .title) }
  var displaySmall: TypographyStyle { style("bold", .title2) }

  var headlineLarge: TypographyStyle { style("medium", .title3) }
  var headlineMedium: TypographyStyle { style("medium", .headline) }
  var headlineSmall: TypographyStyle { style("medium", .subheadline) }

  var titleLarge: TypographyStyle { style("medium", .title) }
  var titleMedium: TypographyStyle { style("medium", .title2) }
  var titleSmall: TypographyStyle { style("medium", .title3) }

  var bodyLarge: TypographyStyle { style("regular", .body) }
  var bodyMedium: TypographyStyle { style("regular", .callout) }
  var bodySmall: TypographyStyle { style("regular", .footnote) }

  var labelLarge: TypographyStyle { style("medium", .headline) }
  var labelMedium: TypographyStyle { style("regular", .caption) }
  var labelSmall: TypographyStyle { style("regular", .caption2) }
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
