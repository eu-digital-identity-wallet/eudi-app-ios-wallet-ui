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
import XCTest
import MdocDataModel18013
@testable import logic_core
@testable import logic_test

final class TestTrustMarkResourceExtensions: EudiTest {

  func testGetLocalizedText_WhenRequestedLanguageIsAvailableAfterAnother_ThenReturnIt() {
    let text = text(["en": "English", "fr": "Français"])
    XCTAssertEqual(text.getLocalizedText(userLanguageCode: "fr"), "Français")
  }

  func testGetLocalizedText_WhenMatchingTagHasMixedCaseAndUnderscore_ThenReturnIt() {
    let text = text(["en": "English", "EL_gr": "Ελληνικά"])
    XCTAssertEqual(text.getLocalizedText(userLanguageCode: "el"), "Ελληνικά")
  }

  func testGetLocalizedText_WhenRegionalTranslationMatchesUserLanguage_ThenReturnIt() {
    let text = text(["fr": "Français", "el-GR": "Ελληνικά"])
    XCTAssertEqual(text.getLocalizedText(userLanguageCode: "el"), "Ελληνικά")
  }

  func testGetLocalizedText_WhenMatchingTranslationIsBlank_ThenReturnNonBlankMatch() {
    let text = text(["el": "   ", "el-GR": "Ελληνικά", "en": "English"])
    XCTAssertEqual(text.getLocalizedText(userLanguageCode: "el"), "Ελληνικά")
  }

  func testGetLocalizedText_WhenRequestedLanguageIsAbsent_ThenReturnFirstNonBlankTranslation() {
    let text = text(["de": "", "fr": "Français", "it": "Italiano"])
    XCTAssertEqual(text.getLocalizedText(userLanguageCode: "el"), "Français")
  }

  func testGetLocalizedText_WhenTranslationsAreEmptyOrBlank_ThenReturnNil() {
    XCTAssertNil(text([:]).getLocalizedText(userLanguageCode: "en"))
    XCTAssertNil(text(["en": " ", "fr": "\n"]).getLocalizedText(userLanguageCode: "en"))
  }

  func testGetLocalizedText_WhenKeysIncludeRegionsScriptsAndVariants_ThenMatchOnLanguage() {
    let text = text(["zh-Hant-TW": "繁體中文", "sr-Latn-RS": "Srpski"])
    XCTAssertEqual(text.getLocalizedText(userLanguageCode: "sr"), "Srpski")
    XCTAssertEqual(text.getLocalizedText(userLanguageCode: "zh"), "繁體中文")
  }

  func testGetLocalizedText_WhenUserLanguageIsMissing_ThenReturnFirstNonBlankTranslation() {
    let text = text(["fr": "Français", "en": "English"])
    XCTAssertEqual(text.getLocalizedText(userLanguageCode: nil), "English")
  }
}

private extension TestTrustMarkResourceExtensions {
  func text(_ localisations: [String: String]) -> TrustMarkResource.Text {
    TrustMarkResource.Text(name: "Trust Mark user information", localisations: localisations)
  }
}
