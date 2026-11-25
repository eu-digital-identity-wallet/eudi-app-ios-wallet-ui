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
import EudiWalletKit
import MdocSecurity18013
import enum OpenID4VCI.CredentialIssuerMetadataError
@testable import logic_core
@testable import logic_test
@testable import feature_test

final class TestErrorIssuerTrust: EudiTest {

  // MARK: - WalletError

  func testIsTrustBlocked_WhenWalletErrorTrustError_ThenReturnsTrue() {
    // Given
    let error: Error = WalletError(description: "trust", code: .trustError)

    // When
    let result = error.isTrustBlocked

    // Then
    XCTAssertTrue(result)
  }

  func testIsTrustBlocked_WhenWalletErrorOtherCode_ThenReturnsFalse() {
    // Given
    let error: Error = WalletError(description: "boom", code: .internalError)

    // When
    let result = error.isTrustBlocked

    // Then
    XCTAssertFalse(result)
  }

  /// `.notSecuredRequest` is a distinct code from `.trustError`; only `.trustError`
  /// maps to an untrusted issuer.
  func testIsTrustBlocked_WhenWalletErrorNotSecuredRequest_ThenReturnsFalse() {
    // Given
    let error: Error = WalletError(description: "not secured", code: .notSecuredRequest)

    // When
    let result = error.isTrustBlocked

    // Then
    XCTAssertFalse(result)
  }

  // MARK: - Credential issuer metadata

  func testIsTrustBlocked_WhenOfferResolutionFailedWithUntrustedMetadata_ThenReturnsTrue() {
    // Given
    let error: Error = WalletError(
      description: "Unable to resolve credential offer: Credential issuer metadata is not issued by a trusted issuer",
      code: .offerResolutionFailed,
      innerError: CredentialIssuerMetadataError.invalidIssuerTrust
    )

    // When
    let result = error.isTrustBlocked

    // Then
    XCTAssertTrue(result)
  }

  func testIsTrustBlocked_WhenOfferResolutionFailedWithUnsignedMetadata_ThenReturnsTrue() {
    // Given
    let error: Error = WalletError(
      description: "Unable to resolve credential offer",
      code: .offerResolutionFailed,
      innerError: CredentialIssuerMetadataError.missingRightContentTypeHeader
    )

    // When
    let result = error.isTrustBlocked

    // Then
    XCTAssertTrue(result)
  }

  func testIsTrustBlocked_WhenOfferResolutionFailedBecauseTheIssuerIsUnreachable_ThenReturnsFalse() {
    // Given
    let error: Error = WalletError(
      description: "Unable to resolve credential offer",
      code: .offerResolutionFailed,
      innerError: CredentialIssuerMetadataError.unableToFetchCredentialIssuerMetadata(
        cause: URLError(.notConnectedToInternet)
      )
    )

    // When
    let result = error.isTrustBlocked

    // Then
    XCTAssertFalse(result)
  }

  func testIsTrustBlocked_WhenOfferResolutionFailedWithMalformedMetadata_ThenReturnsFalse() {
    // Given
    let error: Error = WalletError(
      description: "Unable to resolve credential offer",
      code: .offerResolutionFailed,
      innerError: CredentialIssuerMetadataError.nonParseableCredentialIssuerMetadata(
        cause: URLError(.cannotParseResponse)
      )
    )

    // When
    let result = error.isTrustBlocked

    // Then
    XCTAssertFalse(result)
  }

  func testIsTrustBlocked_WhenOfferResolutionFailedWithoutAnInnerError_ThenReturnsFalse() {
    // Given
    let error: Error = WalletError(description: "Unable to resolve credential offer", code: .offerResolutionFailed)

    // When
    let result = error.isTrustBlocked

    // Then
    XCTAssertFalse(result)
  }

  // MARK: - MsoValidationError

  func testIsTrustBlocked_WhenMsoIssuerTrustFailed_ThenReturnsTrue() {
    // Given
    let error: Error = MsoValidationError.issuerTrustFailed("untrusted issuer")

    // When
    let result = error.isTrustBlocked

    // Then
    XCTAssertTrue(result)
  }

  func testIsTrustBlocked_WhenMsoOtherCase_ThenReturnsFalse() {
    // Given
    let error: Error = MsoValidationError.signatureVerificationFailed("bad signature")

    // When
    let result = error.isTrustBlocked

    // Then
    XCTAssertFalse(result)
  }

  func testIsTrustBlocked_WhenMsoMultipleErrorsContainsTrustFailure_ThenReturnsTrue() {
    // Given
    let error: Error = MsoValidationError.multipleErrors([
      .signatureVerificationFailed("bad signature"),
      .issuerTrustFailed("untrusted issuer")
    ])

    // When
    let result = error.isTrustBlocked

    // Then
    XCTAssertTrue(result)
  }

  func testIsTrustBlocked_WhenMsoMultipleErrorsNoTrustFailure_ThenReturnsFalse() {
    // Given
    let error: Error = MsoValidationError.multipleErrors([
      .signatureVerificationFailed("bad signature"),
      .validityInfo("expired")
    ])

    // When
    let result = error.isTrustBlocked

    // Then
    XCTAssertFalse(result)
  }

  func testIsTrustBlocked_WhenMsoMultipleErrorsEmpty_ThenReturnsFalse() {
    // Given
    let error: Error = MsoValidationError.multipleErrors([])

    // When
    let result = error.isTrustBlocked

    // Then
    XCTAssertFalse(result)
  }

  /// Exercises the recursive walk through nested `.multipleErrors`.
  func testIsTrustBlocked_WhenMsoNestedMultipleErrorsContainsTrustFailure_ThenReturnsTrue() {
    // Given
    let error: Error = MsoValidationError.multipleErrors([
      .multipleErrors([
        .validityInfo("expired"),
        .issuerTrustFailed("untrusted issuer")
      ])
    ])

    // When
    let result = error.isTrustBlocked

    // Then
    XCTAssertTrue(result)
  }

  // MARK: - Unrelated errors

  func testIsTrustBlocked_WhenGenericError_ThenReturnsFalse() {
    // Given
    let error: Error = NSError(domain: "com.eudi.test", code: 1)

    // When
    let result = error.isTrustBlocked

    // Then
    XCTAssertFalse(result)
  }
}
