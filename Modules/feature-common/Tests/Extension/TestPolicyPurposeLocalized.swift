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
import EudiWalletKit
@testable import logic_business
@testable import logic_core
@testable import logic_test

final class TestPolicyPurposeLocalized: EudiTest {

  private var deviceLanguage: String {
    Locale.current.systemLanguageCode ?? "en"
  }

  func testLocalizedValue_whenEmpty_thenReturnsNil() {
    XCTAssertNil([PolicyPurpose]().localizedValue)
  }

  func testLocalizedValue_whenDeviceLanguageIsCarried_thenPrefersIt() {
    let purposes = [
      PolicyPurpose(lang: "zz", value: "Wrong language"),
      PolicyPurpose(lang: deviceLanguage, value: "Name verification")
    ]

    XCTAssertEqual(purposes.localizedValue, "Name verification")
  }

  func testLocalizedValue_whenNoEntryMatches_thenFallsBackToTheFirst() {
    let purposes = [
      PolicyPurpose(lang: "zz", value: "First written"),
      PolicyPurpose(lang: "yy", value: "Second written")
    ]

    XCTAssertEqual(purposes.localizedValue, "First written")
  }

  func testLocalizedValue_whenTagCarriesRegionOrCasing_thenStillMatches() {
    let purposes = [
      PolicyPurpose(lang: "zz", value: "Wrong language"),
      PolicyPurpose(lang: "\(deviceLanguage.uppercased())-GB", value: "Name verification")
    ]

    XCTAssertEqual(purposes.localizedValue, "Name verification")
  }
}
