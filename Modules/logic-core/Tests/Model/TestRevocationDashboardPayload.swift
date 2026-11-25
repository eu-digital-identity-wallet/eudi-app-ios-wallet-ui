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

final class TestRevocationDashboardPayload: EudiTest {

  func testInitUserInfo_WhenBuiltFromItsOwnUserInfo_ThenRoundTrips() {
    // Given
    let payload = RevocationDashboardPayload(revoked: ["a": "PID"], suspended: ["b": "mDL"])

    // When
    let restored = RevocationDashboardPayload(userInfo: payload.userInfo)

    // Then
    XCTAssertEqual(restored, payload)
  }

  func testInitUserInfo_WhenBothGroupsAreEmpty_ThenIsNil() {
    // Given
    let payload = RevocationDashboardPayload(revoked: [:], suspended: [:])

    // When
    let restored = RevocationDashboardPayload(userInfo: payload.userInfo)

    // Then
    XCTAssertNil(restored)
  }

  func testInitUserInfo_WhenUserInfoHasTheOldFlatShape_ThenIsNil() {
    // When
    let flat = RevocationDashboardPayload(userInfo: ["PID": "a"])
    let none = RevocationDashboardPayload(userInfo: nil)

    // Then
    XCTAssertNil(flat)
    XCTAssertNil(none)
  }
}
