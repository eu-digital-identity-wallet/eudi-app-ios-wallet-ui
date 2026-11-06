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
@testable import logic_resources
@testable import logic_test
@testable import feature_test
@testable import feature_dashboard

final class TestDocumentRevocationUi: EudiTest {

  func testTransformToDocumentTabUi_WhenSuspended_ThenShowsSuspended() {
    let model = Constants.createEuPidModel().transformToDocumentTabUi(
      categories: [:],
      revocationStatus: .suspended,
      issuerLogoOrigins: IssuerLogoOrigins(logoOriginsByIssuer: [:])
    )

    XCTAssertEqual(model.value.state, .suspended)
    XCTAssertEqual(model.listItem.supportingText, .suspended)
  }

  func testTransformToDocumentTabUi_WhenRevoked_ThenShowsRevoked() {
    let model = Constants.createEuPidModel().transformToDocumentTabUi(
      categories: [:],
      revocationStatus: .revoked,
      issuerLogoOrigins: IssuerLogoOrigins(logoOriginsByIssuer: [:])
    )

    XCTAssertEqual(model.value.state, .revoked)
    XCTAssertEqual(model.listItem.supportingText, .revoked)
  }

  func testTransformToDocumentTabUi_WhenUnrecognised_ThenShowsRevoked() {
    let model = Constants.createEuPidModel().transformToDocumentTabUi(
      categories: [:],
      revocationStatus: .unrecognised,
      issuerLogoOrigins: IssuerLogoOrigins(logoOriginsByIssuer: [:])
    )

    XCTAssertEqual(model.value.state, .revoked)
    XCTAssertEqual(model.listItem.supportingText, .revoked)
  }

  func testTransformToDocumentTabUi_WhenNoRecord_ThenShowsIssued() {
    let model = Constants.createEuPidModel().transformToDocumentTabUi(
      categories: [:],
      revocationStatus: nil,
      issuerLogoOrigins: IssuerLogoOrigins(logoOriginsByIssuer: [:])
    )

    XCTAssertEqual(model.value.state, .issued)
  }

  func testTransformToIssuerDetailsCardDataUi_WhenSuspended_ThenShowsSuspendedTexts() {
    let card = Constants.createEuPidModel().transformToIssuerDetailsCardDataUi(revocationStatus: .suspended, issuerLogoOrigins: Self.noOrigins)

    XCTAssertEqual(card.documentState, .suspended)
    XCTAssertEqual(card.dateText, .documentDetailsSuspendedDocument)
    XCTAssertEqual(card.expandedMessageText, .documentDetailsIssuerCardSuspendedMessageText)
    XCTAssertNil(card.expandedActionButtonText)
  }

  func testTransformToIssuerDetailsCardDataUi_WhenNoRecord_ThenIsNotRevokedOrSuspended() {
    let card = Constants.createEuPidModel().transformToIssuerDetailsCardDataUi(revocationStatus: nil, issuerLogoOrigins: Self.noOrigins)

    XCTAssertNotEqual(card.documentState, .revoked)
    XCTAssertNotEqual(card.documentState, .suspended)
  }

  func testTransformToIssuerDetailsCardDataUi_WhenRevoked_ThenShowsRevokedTexts() {
    let card = Constants.createEuPidModel().transformToIssuerDetailsCardDataUi(revocationStatus: .revoked, issuerLogoOrigins: Self.noOrigins)

    XCTAssertEqual(card.documentState, .revoked)
    XCTAssertEqual(card.dateText, .documentDetailsRevokedDocument)
    XCTAssertEqual(card.expandedMessageText, .documentDetailsIssuerCardRevokedMessageText)
  }

  func testTransformToIssuerDetailsCardDataUi_WhenUnrecognised_ThenShowsRevokedTexts() {
    let card = Constants.createEuPidModel().transformToIssuerDetailsCardDataUi(revocationStatus: .unrecognised, issuerLogoOrigins: Self.noOrigins)

    XCTAssertEqual(card.documentState, .revoked)
    XCTAssertEqual(card.dateText, .documentDetailsRevokedDocument)
    XCTAssertEqual(card.expandedMessageText, .documentDetailsIssuerCardRevokedMessageText)
  }

  func testTransformToIssuerDetailsCardDataUi_WhenTheStatusCouldNotBeRefreshed_ThenFlagsTheCard() {
    let failed = Constants.createEuPidModel().transformToIssuerDetailsCardDataUi(
      revocationStatus: nil,
      hasStatusRefreshFailed: true,
      issuerLogoOrigins: Self.noOrigins
    )
    let refreshed = Constants.createEuPidModel().transformToIssuerDetailsCardDataUi(revocationStatus: nil, issuerLogoOrigins: Self.noOrigins)

    XCTAssertTrue(failed.hasStatusRefreshFailed)
    XCTAssertFalse(refreshed.hasStatusRefreshFailed)
  }

  func testTransformToDocumentTabUi_WhenTheLogoIsOffTheIssuersOrigins_ThenTheListRowShowsThePlaceholder() {
    let model = Constants.createEuPidModel(
      issuerLogo: "https://tracker.example/p.png",
      credentialIssuerIdentifier: "https://issuer.example"
    ).transformToDocumentTabUi(categories: [:], revocationStatus: nil, issuerLogoOrigins: Self.noOrigins)

    XCTAssertNil(model.value.image?.url)
    XCTAssertNil(Self.listRowLogo(model))
  }

  func testTransformToDocumentTabUi_WhenTheLogoIsOnTheIssuersOrigin_ThenTheListRowShowsIt() {
    let logo = URL(string: "https://issuer.example/logo.png")!
    let model = Constants.createEuPidModel(
      issuerLogo: logo.absoluteString,
      credentialIssuerIdentifier: "https://issuer.example"
    ).transformToDocumentTabUi(categories: [:], revocationStatus: nil, issuerLogoOrigins: Self.noOrigins)

    XCTAssertEqual(Self.listRowLogo(model), logo)
  }

  func testTransformToIssuerDetailsCardDataUi_WhenTheLogoIsOffTheIssuersOrigins_ThenTheCardHasNoLogo() {
    let issuer = "https://issuer.example"
    let offOrigin = Constants.createEuPidModel(issuerLogo: "https://tracker.example/p.png", credentialIssuerIdentifier: issuer)
    let onOrigin = Constants.createEuPidModel(issuerLogo: "https://issuer.example/logo.png", credentialIssuerIdentifier: issuer)

    XCTAssertNil(offOrigin.transformToIssuerDetailsCardDataUi(revocationStatus: nil, issuerLogoOrigins: Self.noOrigins).issuerLogo)
    XCTAssertEqual(
      onOrigin.transformToIssuerDetailsCardDataUi(revocationStatus: nil, issuerLogoOrigins: Self.noOrigins).issuerLogo,
      URL(string: "https://issuer.example/logo.png")
    )
  }
}

private extension TestDocumentRevocationUi {

  static let noOrigins = IssuerLogoOrigins(logoOriginsByIssuer: [:])

  static func listRowLogo(_ model: DocumentTabUIModel) -> URL? {
    guard case .remoteImage(let url, _) = model.listItem.leadingContent else { return nil }
    return url
  }
}
