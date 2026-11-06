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
@testable import logic_authentication
@testable import logic_test

final class TestAuthenticationConfig: EudiTest {

  private let config = AuthenticationConfigImpl()

  func testIsWeakPin_WhenOneDigitIsRepeated_ThenIsWeak() {
    XCTAssertTrue(config.isWeakPin("000000"))
    XCTAssertTrue(config.isWeakPin("777777"))
  }

  func testIsWeakPin_WhenTheDigitsRunUpOrDown_ThenIsWeak() {
    XCTAssertTrue(config.isWeakPin("123456"))
    XCTAssertTrue(config.isWeakPin("456789"))
    XCTAssertTrue(config.isWeakPin("987654"))
  }

  func testIsWeakPin_WhenThePinIsCommon_ThenIsWeak() {
    XCTAssertTrue(config.isWeakPin("123123"))
    XCTAssertTrue(config.isWeakPin("000123"))
  }

  func testIsWeakPin_WhenThePinHasNoPattern_ThenIsNotWeak() {
    XCTAssertFalse(config.isWeakPin("135792"))
    XCTAssertFalse(config.isWeakPin("246813"))
    XCTAssertFalse(config.isWeakPin("901234"))
  }

  func testDefaults_WhenNotChanged_ThenRequireNoPasscodeAndListAndroidsTenCommonPins() {
    XCTAssertFalse(config.requireDeviceSecure)
    XCTAssertEqual(config.commonPins.count, 10)
  }
}
