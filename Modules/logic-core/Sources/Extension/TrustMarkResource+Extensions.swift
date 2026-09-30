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
import MdocDataModel18013

extension TrustMarkResource.Text {

  func getLocalizedText(userLanguageCode: String?) -> String? {
    let translations = localisations
      .filter { !$0.value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
      .sorted { $0.key < $1.key }

    let userLanguage = userLanguageCode.flatMap { Self.languageCode(of: $0) }

    let match = translations.first { translation in
      guard let userLanguage else { return false }
      return Self.languageCode(of: translation.key) == userLanguage
    }

    return (match ?? translations.first)?.value
  }

  private static func languageCode(of tag: String) -> String? {
    let identifier = tag.replacingOccurrences(of: "_", with: "-")
    guard let code = Locale(identifier: identifier).language.languageCode?.identifier, !code.isEmpty else {
      return nil
    }
    return code.lowercased()
  }
}
