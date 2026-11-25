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
@testable import logic_core
@testable import logic_test

final class TestStringExtensions: EudiTest {

  func testDecodedBase64ByteCount_WhenTheContentIsBase64InEitherAlphabet_ThenIsItsDecodedSize() {
    // When
    let plain = "QUJD".decodedBase64ByteCount
    let padded = "QUI=".decodedBase64ByteCount
    let urlSafe = "Q-_x".decodedBase64ByteCount
    let withWhitespace = "QU JD\n".decodedBase64ByteCount
    let notBase64 = "not base64 !".decodedBase64ByteCount
    let misplacedPadding = "QUJ=D".decodedBase64ByteCount
    let mixedAlphabets = "Q+_x".decodedBase64ByteCount

    // Then
    XCTAssertEqual(plain, 3)
    XCTAssertEqual(padded, 2)
    XCTAssertEqual(urlSafe, 3)
    XCTAssertEqual(withWhitespace, 3)
    XCTAssertNil(notBase64)
    XCTAssertNil(misplacedPadding)
    XCTAssertNil(mixedAlphabets)
  }
}
