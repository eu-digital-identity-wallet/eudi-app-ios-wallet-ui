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
@testable import logic_ui
@testable import logic_test

final class TestRemoteImagePolicy: EudiTest {

  private let logo = URL(string: "https://issuer.example/logo.png")!

  func testLoadableUrl_WhenTheImageIsNotHttps_ThenIsNotLoaded() {
    for address in ["http://issuer.example/logo.png", "file:///etc/passwd", "data:image/png;base64,AA=="] {
      XCTAssertNil(RemoteImagePolicy.loadableUrl(URL(string: address)), address)
    }
    XCTAssertEqual(RemoteImagePolicy.loadableUrl(logo), logo)
  }

  func testFollowsRedirect_WhenItLeavesTheOriginOrHttps_ThenIsFalse() {
    for address in [
      "https://elsewhere.example/logo.png",
      "http://issuer.example/logo.png",
      "https://issuer.example:8443/logo.png"
    ] {
      XCTAssertFalse(RemoteImagePolicy.followsRedirect(from: logo, to: URL(string: address)), address)
    }
    XCTAssertFalse(RemoteImagePolicy.followsRedirect(from: nil, to: logo))
  }

  func testFollowsRedirect_WhenItStaysOnTheOrigin_ThenIsTrue() {
    XCTAssertTrue(RemoteImagePolicy.followsRedirect(from: logo, to: URL(string: "https://ISSUER.example:443/other.png")))
  }

  func testIsWithinLimit_WhenTheReceivedOrDeclaredSizeExceedsTheLimit_ThenIsFalse() {
    let limit = RemoteImagePolicy.maxImageByteCount
    XCTAssertFalse(RemoteImagePolicy.isWithinLimit(receivedByteCount: limit + 1, expectedByteCount: 0))
    XCTAssertFalse(RemoteImagePolicy.isWithinLimit(receivedByteCount: 0, expectedByteCount: limit + 1))
    XCTAssertTrue(RemoteImagePolicy.isWithinLimit(receivedByteCount: limit, expectedByteCount: limit))
    XCTAssertTrue(RemoteImagePolicy.isWithinLimit(receivedByteCount: 1, expectedByteCount: 0))
  }
}
