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
import logic_core
import logic_resources
import struct OpenID4VP.ClaimPath
@testable import feature_common
@testable import logic_test

final class TestRelyingPartyRegistrationUiModel: EudiTest {

  func testToRegistrationData_WhenVerified_ThenShowsRegistrationAndNoWarning() {
    // Given
    let registration = relyingParty(status: .verified(details: details(), overaskedClaims: []))

    // When
    let data = registration.toRegistrationData(fallbackName: .unknownVerifier)

    // Then
    XCTAssertEqual(data.primary.isVerified, true)
    XCTAssertEqual(data.intendedUse, .custom("Onboarding"))
    XCTAssertNil(registration.toWarning(isRelyingPartyTrusted: true))
  }

  func testToWarning_WhenOverasked_ThenReturnsOveraskedWarning() {
    // Given
    let registration = relyingParty(
      status: .verified(
        details: details(),
        overaskedClaims: [
          OveraskedClaim(
            attestationType: "eu.europa.ec.eudi.pid.1",
            path: ClaimPath([.claim(name: "namespace"), .claim(name: "age")])
          )
        ]
      )
    )

    // When
    let warning = registration.toWarning(isRelyingPartyTrusted: true)

    // Then
    XCTAssertEqual(warning, .relyingPartyOverasked)
  }

  func testToWarning_WhenNotVerified_ThenReturnsNotVerifiedWarning() {
    // Given
    let registration = relyingParty(status: .notVerified(details: details()))

    // When
    let data = registration.toRegistrationData(fallbackName: .unknownVerifier)

    // Then
    XCTAssertEqual(data.primary.isVerified, false)
    XCTAssertEqual(registration.toWarning(isRelyingPartyTrusted: true), .relyingPartyNotVerified)
  }

  func testToWarning_WhenRelyingPartyIsNotTrusted_ThenReturnsTheAccessCertificateWarningForEveryRegistration() {
    // Given
    let overasked = OveraskedClaim(
      attestationType: "eu.europa.ec.eudi.pid.1",
      path: ClaimPath([.claim(name: "namespace"), .claim(name: "age")])
    )
    let statuses: [RegistrationStatus] = [
      .verified(details: details(), overaskedClaims: []),
      .verified(details: details(), overaskedClaims: [overasked]),
      .notVerified(details: details()),
      .notSupported
    ]

    // Then
    for status in statuses {
      XCTAssertEqual(
        relyingParty(status: status).toWarning(isRelyingPartyTrusted: false),
        .accessCertificateNotTrusted,
        "\(status)"
      )
    }
  }

  func testToWarning_WhenRelyingPartyIsTrusted_ThenFollowsTheRegistration() {
    // Then
    XCTAssertNil(relyingParty(status: .notSupported).toWarning(isRelyingPartyTrusted: true))
    XCTAssertNil(
      relyingParty(status: .verified(details: details(), overaskedClaims: [])).toWarning(isRelyingPartyTrusted: true)
    )
    XCTAssertEqual(
      relyingParty(status: .notVerified(details: details())).toWarning(isRelyingPartyTrusted: true),
      .relyingPartyNotVerified
    )
  }

  /// Given a transport without registration certificates, the requester is still identified and
  /// the badge falls back to access-certificate trust; only the certificate's sections are absent
  func testToRegistrationData_WhenNotSupported_ThenStillNamesTheRequester() {
    let registration = relyingParty(status: .notSupported)

    // When
    let data = registration.toRegistrationData(fallbackName: .unknownVerifier)

    // Then
    XCTAssertEqual(data.primary.name, .custom("NordicBank A/S"))
    XCTAssertEqual(data.primary.isVerified, registration.isVerified)
    XCTAssertNil(data.intendedUse)
    XCTAssertNil(data.privacyPolicyUrl)
    XCTAssertNil(registration.toWarning(isRelyingPartyTrusted: true))
  }

  /// Both layers must agree: a registration cannot vouch for a party the access certificate
  /// could not authenticate
  /// The certificate's own sections still render; only the badge is withheld.
  func testToRegistrationData_WhenRegistrationVerifiedButAccessCertificateIsNot_ThenNoBadge() {
    // Given
    let registration = RelyingPartyRegistration(
      name: "NordicBank A/S",
      uniqueId: "rp:nordicbank:prod",
      isVerified: false,
      logoUrl: nil,
      registration: .verified(details: details(), overaskedClaims: [])
    )

    // When
    let data = registration.toRegistrationData(fallbackName: .unknownVerifier)

    // Then
    XCTAssertFalse(registration.isFullyVerified)
    XCTAssertEqual(data.primary.isVerified, false)
    XCTAssertEqual(data.intendedUse, .custom("Onboarding"))
  }

  func testToRegistrationData_WhenNotEvaluated_ThenAccessCertificateDecidesAlone() {
    // Given
    let trusted = relyingParty(status: .notSupported)
    let untrusted = RelyingPartyRegistration(
      name: "NordicBank A/S",
      uniqueId: nil,
      isVerified: false,
      logoUrl: nil,
      registration: .notSupported
    )

    // Then
    XCTAssertTrue(trusted.isFullyVerified)
    XCTAssertFalse(untrusted.isFullyVerified)
  }

  /// The party whose registration failed is the one the user most needs identified
  func testToRegistrationData_WhenNotVerified_ThenStillNamesTheRequester() {
    // Given
    let registration = relyingParty(status: .notVerified(details: details()))

    // When
    let data = registration.toRegistrationData(fallbackName: .unknownVerifier)

    // Then
    XCTAssertEqual(data.primary.name, .custom("NordicBank A/S"))
    XCTAssertEqual(data.primary.isVerified, false)
  }

  func testToRegistrationData_WhenNotVerified_ThenStillDescribesTheRequester() {
    // Given
    let registration = relyingParty(status: .notVerified(details: details()))

    // When
    let data = registration.toRegistrationData(fallbackName: .unknownVerifier)

    // Then
    XCTAssertEqual(data.intendedUse, .custom("Onboarding"))
    XCTAssertEqual(data.privacyPolicyUrl, URL(string: "https://nordicbank.example/privacy"))
    XCTAssertFalse(registration.isFullyVerified)
  }

  func testToRegistrationData_WhenThePrivacyPolicyIsNotHttps_ThenItIsNotShown() {
    // Then
    for address in ["http://nordicbank.example/privacy", "javascript:alert(1)", "eudi-wallet://privacy"] {
      let registration = relyingParty(status: .notVerified(details: details(privacyPolicyUrl: URL(string: address))))

      let data = registration.toRegistrationData(fallbackName: .unknownVerifier)

      XCTAssertNil(data.privacyPolicyUrl, address)
    }
  }

  func testToRegistrationData_WhenTheIssuersPrivacyPolicyIsNotHttps_ThenItIsNotShown() {
    // Given
    let registration: IssuerRegistration? = .verified(details: details(privacyPolicyUrl: URL(string: "http://issuer.example/privacy")))

    // Then
    XCTAssertNil(registration.toRegistrationData(issuerName: "Issuer").privacyPolicyUrl)
    XCTAssertEqual(
      Optional(IssuerRegistration.verified(details: details())).toRegistrationData(issuerName: "Issuer").privacyPolicyUrl,
      URL(string: "https://nordicbank.example/privacy")
    )
  }

  func testToRegistrationData_WhenNotVerifiedAndUndecodable_ThenOnlyTheNameSurvives() {
    // Given
    let registration = relyingParty(status: .notVerified(details: nil))

    // When
    let data = registration.toRegistrationData(fallbackName: .unknownVerifier)

    // Then
    XCTAssertEqual(data.primary.name, .custom("NordicBank A/S"))
    XCTAssertNil(data.intendedUse)
    XCTAssertNil(data.privacyPolicyUrl)
  }

  /// Registrar-attested and proven bound to the signer, so it outranks the certificate subject
  func testResolveRequesterName_WhenVerified_ThenTheRegistrationNameWins() {
    // When
    let name = RegistrationStatus.verified(details: details(), overaskedClaims: [])
      .resolveRequesterName(registrationName: "NordicBank A/S", accessCertificateName: "nordicbank.example")

    // Then
    XCTAssertEqual(name, "NordicBank A/S")
  }

  /// An unverified registration proves nothing, and its name is the one an impersonator picks
  func testResolveRequesterName_WhenNotVerified_ThenTheAccessCertificateNameWins() {
    // When
    let name = RegistrationStatus.notVerified(details: nil)
      .resolveRequesterName(registrationName: "Definitely Your Bank", accessCertificateName: "nordicbank.example")

    // Then
    XCTAssertEqual(name, "nordicbank.example")
  }

  func testResolveRequesterName_WhenNamesAreMissing_ThenFallsBackToTheOtherLayer() {
    // Then
    XCTAssertEqual(
      RegistrationStatus.verified(details: details(), overaskedClaims: [])
        .resolveRequesterName(registrationName: nil, accessCertificateName: "nordicbank.example"),
      "nordicbank.example"
    )
    XCTAssertEqual(
      RegistrationStatus.notVerified(details: nil)
        .resolveRequesterName(registrationName: "Definitely Your Bank", accessCertificateName: nil),
      "Definitely Your Bank"
    )
    XCTAssertNil(
      RegistrationStatus.notSupported
        .resolveRequesterName(registrationName: "Definitely Your Bank", accessCertificateName: nil)
    )
  }

  /// Nothing was checked, so an unchecked certificate's name must not be shown at all
  func testResolveRequesterName_WhenNotEvaluated_ThenTheRegistrationIsIgnored() {
    // When
    let name = RegistrationStatus.notSupported
      .resolveRequesterName(registrationName: "Definitely Your Bank", accessCertificateName: "nordicbank.example")

    // Then
    XCTAssertEqual(name, "nordicbank.example")
  }

  func testIssuerToRegistrationData_WhenCertificateHasNoLogo_ThenFallsBackToIssuerMetadata() {
    // Given
    let metadataLogo = URL(string: "https://issuer.example/logo.png")
    let registration: IssuerRegistration? = .verified(details: details())

    // When
    let data = registration.toRegistrationData(issuerName: "Aegean S.A.", issuerLogo: metadataLogo)

    // Then
    XCTAssertEqual(data.primary.logoUrl, metadataLogo)
  }

  func testIssuerToRegistrationData_WhenCertificateCarriesALogo_ThenItWinsOverMetadata() {
    // Given
    let certificateLogo = URL(string: "https://registry.example/certified-logo.png")
    let registration: IssuerRegistration? = .verified(details: details(logoUrl: certificateLogo))

    // When
    let data = registration.toRegistrationData(
      issuerName: "Aegean S.A.",
      issuerLogo: URL(string: "https://issuer.example/logo.png")
    )

    // Then
    XCTAssertEqual(data.primary.logoUrl, certificateLogo)
  }

  /// The offer names the issuer, so a refused registration does not erase who made the offer
  func testIssuerToRegistrationData_WhenBlocked_ThenStillNamesTheIssuer() {
    // Given
    let registration: IssuerRegistration? = .blocked(reason: .attestationNotRegistered)

    // When
    let data = registration.toRegistrationData(issuerName: "Aegean S.A.")

    // Then
    XCTAssertEqual(data.primary.name, .custom("Aegean S.A."))
    XCTAssertEqual(data.primary.isVerified, false)
    XCTAssertNil(data.primary.identifier)
    XCTAssertNil(data.intendedUse)
  }

  /// Validation switched off: nothing was checked, but the offer still says who is offering
  func testIssuerToRegistrationData_WhenNotEvaluated_ThenStillNamesTheIssuer() {
    // Given
    let registration: IssuerRegistration? = nil
    let metadataLogo = URL(string: "https://issuer.example/logo.png")

    // When
    let data = registration.toRegistrationData(issuerName: "Aegean S.A.", issuerLogo: metadataLogo)

    // Then
    XCTAssertEqual(data.primary.name, .custom("Aegean S.A."))
    XCTAssertEqual(data.primary.logoUrl, metadataLogo)
    XCTAssertEqual(data.primary.isVerified, false)
    XCTAssertNil(data.privacyPolicyUrl)
  }
}

private extension TestRelyingPartyRegistrationUiModel {

  func relyingParty(status: RegistrationStatus) -> RelyingPartyRegistration {
    RelyingPartyRegistration(
      name: "NordicBank A/S",
      uniqueId: "rp:nordicbank:prod",
      isVerified: true,
      logoUrl: nil,
      registration: status
    )
  }

  func details(
    logoUrl: URL? = nil,
    privacyPolicyUrl: URL? = URL(string: "https://nordicbank.example/privacy")
  ) -> RegistrationDetails {
    RegistrationDetails(
      tradeName: "NordicBank A/S",
      uniqueId: "rp:nordicbank:prod",
      logoUrl: logoUrl,
      intendedUse: "Onboarding",
      privacyPolicyUrl: privacyPolicyUrl,
      serviceDescription: "Current account onboarding"
    )
  }
}
