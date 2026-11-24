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
    // Given
    let text = text(["en": "English", "fr": "Français"])

    // When
    let result = text.getLocalizedText(userLanguageCode: "fr")

    // Then
    XCTAssertEqual(result, "Français")
  }

  func testGetLocalizedText_WhenMatchingTagHasMixedCaseAndUnderscore_ThenReturnIt() {
    // Given
    let text = text(["en": "English", "EL_gr": "Ελληνικά"])

    // When
    let result = text.getLocalizedText(userLanguageCode: "el")

    // Then
    XCTAssertEqual(result, "Ελληνικά")
  }

  func testGetLocalizedText_WhenRegionalTranslationMatchesUserLanguage_ThenReturnIt() {
    // Given
    let text = text(["fr": "Français", "el-GR": "Ελληνικά"])

    // When
    let result = text.getLocalizedText(userLanguageCode: "el")

    // Then
    XCTAssertEqual(result, "Ελληνικά")
  }

  func testGetLocalizedText_WhenMatchingTranslationIsBlank_ThenReturnNonBlankMatch() {
    // Given
    let text = text(["el": "   ", "el-GR": "Ελληνικά", "en": "English"])

    // When
    let result = text.getLocalizedText(userLanguageCode: "el")

    // Then
    XCTAssertEqual(result, "Ελληνικά")
  }

  func testGetLocalizedText_WhenRequestedLanguageIsAbsent_ThenReturnFirstNonBlankTranslation() {
    // Given
    let text = text(["de": "", "fr": "Français", "it": "Italiano"])

    // When
    let result = text.getLocalizedText(userLanguageCode: "el")

    // Then
    XCTAssertEqual(result, "Français")
  }

  func testGetLocalizedText_WhenTranslationsAreEmptyOrBlank_ThenReturnNil() {
    // Then
    XCTAssertNil(text([:]).getLocalizedText(userLanguageCode: "en"))
    XCTAssertNil(text(["en": " ", "fr": "\n"]).getLocalizedText(userLanguageCode: "en"))
  }

  func testGetLocalizedText_WhenKeysIncludeRegionsScriptsAndVariants_ThenMatchOnLanguage() {
    // Given
    let text = text(["zh-Hant-TW": "繁體中文", "sr-Latn-RS": "Srpski"])

    // Then
    XCTAssertEqual(text.getLocalizedText(userLanguageCode: "sr"), "Srpski")
    XCTAssertEqual(text.getLocalizedText(userLanguageCode: "zh"), "繁體中文")
  }

  func testGetLocalizedText_WhenUserLanguageIsMissing_ThenReturnFirstNonBlankTranslation() {
    // Given
    let text = text(["fr": "Français", "en": "English"])

    // When
    let result = text.getLocalizedText(userLanguageCode: nil)

    // Then
    XCTAssertEqual(result, "English")
  }
}

private extension TestTrustMarkResourceExtensions {
  func text(_ localisations: [String: String]) -> TrustMarkResource.Text {
    TrustMarkResource.Text(name: "Trust Mark user information", localisations: localisations)
  }
}
