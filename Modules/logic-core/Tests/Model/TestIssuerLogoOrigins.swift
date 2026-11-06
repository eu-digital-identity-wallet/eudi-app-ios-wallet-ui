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

final class TestIssuerLogoOrigins: EudiTest {

  private let origins = IssuerLogoOrigins(
    logoOriginsByIssuer: [
      "https://issuer.example": ["https://eudiw.dev"],
      "https://other.example": ["https://other-logos.example"]
    ]
  )

  func testOriginsOfIssuer_WhenConfigured_ThenAreItsOwnAndItsLogoOrigins() {
    XCTAssertEqual(origins.origins(ofIssuer: "https://issuer.example"), ["https://issuer.example", "https://eudiw.dev"])
  }

  func testOriginsOfIssuer_WhenAnotherIssuerServesTheLogo_ThenItsOriginIsNotAllowed() {
    let logo = URL(string: "https://other-logos.example/logo.png")!
    XCTAssertNil(logo.allowedIssuerLogo(allowedOrigins: origins.origins(ofIssuer: "https://issuer.example")))
    XCTAssertEqual(logo.allowedIssuerLogo(allowedOrigins: origins.origins(ofIssuer: "https://other.example")), logo)
  }

  func testOriginsOfIssuer_WhenNotConfigured_ThenOnlyItsOwnOrigin() {
    XCTAssertEqual(origins.origins(ofIssuer: "https://unknown.example"), ["https://unknown.example"])
    XCTAssertEqual(origins.origins(ofIssuer: nil), [])
  }

  func testOriginsOfOffer_WhenTheIssuerIsConfigured_ThenAreThatIssuers() {
    let byReference = "openid-credential-offer://?credential_offer_uri=https%3A%2F%2Fother.example%2Foffer%2F1"
    XCTAssertEqual(origins.origins(ofOffer: byReference), ["https://other.example", "https://other-logos.example"])
  }

  func testOriginsOfOffer_WhenTheIssuerIsNotConfigured_ThenNone() {
    let byReference = "openid-credential-offer://?credential_offer_uri=https%3A%2F%2Funknown.example%2Foffer%2F1"
    XCTAssertEqual(origins.origins(ofOffer: byReference), [])
  }
}
