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
import OpenID4VCI
@testable import logic_core
@testable import logic_test

final class TestOfferIssuer: EudiTest {

  private let configured = ["https://issuer.example", "https://backend.example:8443"]

  func testOf_WhenTheOfferByValueNamesAConfiguredIssuer_ThenReturnsIt() {
    let issuer = OfferIssuer.of(offerUri: byValue(issuer: "https://issuer.example"), configuredIssuers: configured)

    XCTAssertEqual(issuer, .configured("https://issuer.example"))
  }

  func testOf_WhenTheOfferByValueNamesAnotherIssuer_ThenIsNotConfigured() {
    XCTAssertEqual(
      OfferIssuer.of(offerUri: byValue(issuer: "https://attacker.example"), configuredIssuers: configured),
      .notConfigured
    )
    XCTAssertEqual(
      OfferIssuer.of(offerUri: byValue(issuer: "https://issuer.example/"), configuredIssuers: configured),
      .notConfigured
    )
  }

  func testOf_WhenTheOfferByReferenceIsOnAConfiguredIssuersOrigin_ThenReturnsThatIssuer() {
    XCTAssertEqual(
      OfferIssuer.of(offerUri: byReference("https://ISSUER.example/offers/1"), configuredIssuers: configured),
      .configured("https://issuer.example")
    )
    XCTAssertEqual(
      OfferIssuer.of(offerUri: byReference("https://backend.example:8443/offer"), configuredIssuers: configured),
      .configured("https://backend.example:8443")
    )
  }

  func testOf_WhenTheOfferByReferenceIsElsewhereOrNotHttps_ThenIsNotConfigured() {
    for address in [
      "https://attacker.example/offer",
      "http://issuer.example/offer",
      "https://backend.example/offer",
      "https://issuer.example:8443/offer"
    ] {
      XCTAssertEqual(
        OfferIssuer.of(offerUri: byReference(address), configuredIssuers: configured),
        .notConfigured,
        address
      )
    }
  }

  func testOf_WhenTheLinkCarriesNoOfferOrMoreThanOne_ThenIsUnreadable() {
    let both = byValue(issuer: "https://issuer.example") + "&credential_offer_uri=https://issuer.example/o"
    for link in ["openid-credential-offer://?foo=bar", both, byReference("https://issuer.example/a") + "&CREDENTIAL_OFFER_URI=x"] {
      XCTAssertEqual(OfferIssuer.of(offerUri: link, configuredIssuers: configured), .unreadable, link)
    }
    XCTAssertEqual(
      OfferIssuer.of(offerUri: "openid-credential-offer://?credential_offer=not-json", configuredIssuers: configured),
      .unreadable
    )
  }

  func testOf_WhenTheOfferParameterIsNotSpelledAsTheLibraryReadsIt_ThenIsUnreadable() {
    let reference = encoded("https://issuer.example/offer")
    let value = encoded(offer(issuer: "https://issuer.example"))
    for link in [
      "https://attacker.example/offer?Credential_Offer_Uri=\(reference)",
      "https://attacker.example/offer?CREDENTIAL_OFFER_URI=\(reference)",
      "https://attacker.example/offer?Credential_Offer=\(value)",
      "openid-credential-offer://?Credential_Offer_Uri=\(reference)"
    ] {
      XCTAssertEqual(OfferIssuer.of(offerUri: link, configuredIssuers: configured), .unreadable, link)
    }
  }

  func testOf_WhenOnlyTheLinkItselfCouldBeFetched_ThenIsUnreadable() {
    for link in [
      "https://issuer.example/offer",
      "https://attacker.example/offer",
      "https://attacker.example/offer?credential_offer_uri=",
      "https://attacker.example/offer?credential_offer="
    ] {
      XCTAssertEqual(OfferIssuer.of(offerUri: link, configuredIssuers: configured), .unreadable, link)
    }
  }

  func testOf_WhenTheOfferUriIsGivenTwice_ThenIsUnreadable() {
    let link = byReference("https://issuer.example/a") + "&credential_offer_uri=" + encoded("https://attacker.example/b")

    XCTAssertEqual(OfferIssuer.of(offerUri: link, configuredIssuers: configured), .unreadable)
  }

  func testRequireConfigured_WhenTheIssuerIsNotConfigured_ThenThrowsIssuerNotConfigured() {
    XCTAssertThrowsError(
      try OfferIssuer.requireConfigured(offerUri: byValue(issuer: "https://attacker.example"), configuredIssuers: configured)
    ) { error in
      XCTAssertEqual(error.localizedDescription, WalletCoreError.issuerNotConfigured.localizedDescription)
    }
  }

  func testRequireConfigured_WhenTheIssuerIsConfigured_ThenPasses() {
    XCTAssertNoThrow(
      try OfferIssuer.requireConfigured(offerUri: byValue(issuer: "https://issuer.example"), configuredIssuers: configured)
    )
  }

  func testByValueLink_WhenAFetchedOfferIsPassedOn_ThenTheLibraryReadsExactlyThatOffer() throws {
    let fetched = "{\"credential_issuer\":\"https://issuer.example\",\"credential_configuration_ids\":[\"a&b=c+d#e%20é\"]}"

    let link = try XCTUnwrap(
      OfferIssuer.byValueLink(offerUri: byReference("https://issuer.example/offers/1") + "#fragment", offer: fetched)
    )

    XCTAssertTrue(link.hasPrefix("openid-credential-offer://?credential_offer="))
    XCTAssertFalse(link.contains("#"))
    guard case .passByValue(let offer) = try CredentialOfferRequest(urlString: link) else {
      return XCTFail("Expected the offer by value")
    }
    XCTAssertEqual(offer, fetched)
  }

  func testByValueLink_WhenTheFetchedOfferNamesAConfiguredIssuer_ThenTheLinkComesFromIt() throws {
    let link = try XCTUnwrap(
      OfferIssuer.byValueLink(offerUri: byReference("https://issuer.example/offers/1"), offer: offer(issuer: "https://issuer.example"))
    )

    XCTAssertEqual(OfferIssuer.of(offerUri: link, configuredIssuers: configured), .configured("https://issuer.example"))
  }

  func testByValueLink_WhenTheFetchedOfferNamesAnotherIssuer_ThenTheLinkIsNotConfigured() throws {
    let link = try XCTUnwrap(
      OfferIssuer.byValueLink(offerUri: byReference("https://issuer.example/offers/1"), offer: offer(issuer: "https://attacker.example"))
    )

    XCTAssertEqual(OfferIssuer.of(offerUri: link, configuredIssuers: configured), .notConfigured)
  }
}

private extension TestOfferIssuer {

  func offer(issuer: String) -> String {
    "{\"credential_issuer\":\"\(issuer)\",\"credential_configuration_ids\":[\"pid\"]}"
  }

  func encoded(_ value: String) -> String {
    value.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? ""
  }

  func byValue(issuer: String) -> String {
    "openid-credential-offer://?credential_offer=" + encoded(offer(issuer: issuer))
  }

  func byReference(_ address: String) -> String {
    "openid-credential-offer://?credential_offer_uri=" + encoded(address)
  }
}
