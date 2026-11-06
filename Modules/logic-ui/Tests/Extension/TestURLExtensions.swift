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

final class TestURLExtensions: EudiTest {

  func testIsHttpsWebLink_WhenTheLinkIsHttpsWithAHost_ThenIsTrue() throws {
    XCTAssertTrue(try XCTUnwrap(URL(string: "https://verifier.example/done?state=1")).isHttpsWebLink)
    XCTAssertTrue(try XCTUnwrap(URL(string: "HTTPS://verifier.example")).isHttpsWebLink)
  }

  func testIsHttpsWebLink_WhenTheLinkIsAWalletOrAnotherScheme_ThenIsFalse() throws {
    let links = [
      "openid-credential-offer://?credential_offer_uri=https://issuer.example",
      "eudi-openid4vp://?request_uri=https://verifier.example",
      "haip-vp://?request_uri=https://verifier.example",
      "rqes://callback?code=abc",
      "http://verifier.example",
      "mailto:someone@example.com",
      "https:///no-host"
    ]

    for link in links {
      XCTAssertFalse(try XCTUnwrap(URL(string: link)).isHttpsWebLink, link)
    }
  }

  @MainActor
  func testOpenInBrowser_WhenTheLinkIsHttpsWithAHost_ThenOpensIt() throws {
    let url = try XCTUnwrap(URL(string: "https://verifier.example/done"))
    var opened: [URL] = []

    url.openInBrowser { opened.append($0) }

    XCTAssertEqual(opened, [url])
  }

  @MainActor
  func testOpenInBrowser_WhenTheLinkIsAWalletLink_ThenOpensNothing() throws {
    let url = try XCTUnwrap(URL(string: "openid-credential-offer://?credential_offer_uri=https://issuer.example"))
    var opened: [URL] = []

    url.openInBrowser { opened.append($0) }

    XCTAssertTrue(opened.isEmpty)
  }
}
