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
    let payload = RevocationDashboardPayload(revoked: ["a": "PID"], suspended: ["b": "mDL"])

    XCTAssertEqual(RevocationDashboardPayload(userInfo: payload.userInfo), payload)
  }

  func testInitUserInfo_WhenBothGroupsAreEmpty_ThenIsNil() {
    let payload = RevocationDashboardPayload(revoked: [:], suspended: [:])

    XCTAssertNil(RevocationDashboardPayload(userInfo: payload.userInfo))
  }

  func testInitUserInfo_WhenUserInfoHasTheOldFlatShape_ThenIsNil() {
    XCTAssertNil(RevocationDashboardPayload(userInfo: ["PID": "a"]))
    XCTAssertNil(RevocationDashboardPayload(userInfo: nil))
  }
}
