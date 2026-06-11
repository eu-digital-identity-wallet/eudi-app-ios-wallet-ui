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
import Foundation
import CoreText

public extension Bundle {
  static var assetsBundle: Bundle {
    Bundle.module
  }

  /// Registers every .ttf and .otf font file found in the module bundle with
  /// Core Text so they can be used via `Font.custom` or `UIFont(name:size:)`.
  ///
  /// Call once at app startup. Core Text deduplicates registrations, so
  /// calling this multiple times is safe.
  ///
  /// Member states only need to drop new font files into
  /// `Sources/Resources/` — they will be picked up automatically here,
  /// with no changes to Info.plist or Swift code required.
  static func registerModuleFonts() {
    ["ttf", "otf"].forEach { ext in
      assetsBundle
        .urls(forResourcesWithExtension: ext, subdirectory: nil)?
        .forEach { url in
          CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
        }
    }
  }
}
