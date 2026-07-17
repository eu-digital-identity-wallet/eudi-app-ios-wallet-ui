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
@testable import logic_core
@testable import logic_test
@testable import feature_test

final class TestErrorIssuerTrust: EudiTest {

  // MARK: - WalletError

  func testIsIssuerNotTrusted_whenWalletErrorTrustError_thenReturnsTrue() {
    let error: Error = WalletError(description: "trust", code: .trustError)
    XCTAssertTrue(error.isIssuerNotTrusted)
  }

  func testIsIssuerNotTrusted_whenWalletErrorOtherCode_thenReturnsFalse() {
    let error: Error = WalletError(description: "boom", code: .internalError)
    XCTAssertFalse(error.isIssuerNotTrusted)
  }

  func testIsIssuerNotTrusted_whenWalletErrorNotSecuredRequest_thenReturnsFalse() {
    // `.notSecuredRequest` is a distinct code from `.trustError`; only `.trustError`
    // maps to an untrusted issuer.
    let error: Error = WalletError(description: "not secured", code: .notSecuredRequest)
    XCTAssertFalse(error.isIssuerNotTrusted)
  }

  // MARK: - MsoValidationError

  func testIsIssuerNotTrusted_whenMsoIssuerTrustFailed_thenReturnsTrue() {
    let error: Error = MsoValidationError.issuerTrustFailed("untrusted issuer")
    XCTAssertTrue(error.isIssuerNotTrusted)
  }

  func testIsIssuerNotTrusted_whenMsoOtherCase_thenReturnsFalse() {
    let error: Error = MsoValidationError.signatureVerificationFailed("bad signature")
    XCTAssertFalse(error.isIssuerNotTrusted)
  }

  func testIsIssuerNotTrusted_whenMsoMultipleErrorsContainsTrustFailure_thenReturnsTrue() {
    let error: Error = MsoValidationError.multipleErrors([
      .signatureVerificationFailed("bad signature"),
      .issuerTrustFailed("untrusted issuer")
    ])
    XCTAssertTrue(error.isIssuerNotTrusted)
  }

  func testIsIssuerNotTrusted_whenMsoMultipleErrorsNoTrustFailure_thenReturnsFalse() {
    let error: Error = MsoValidationError.multipleErrors([
      .signatureVerificationFailed("bad signature"),
      .validityInfo("expired")
    ])
    XCTAssertFalse(error.isIssuerNotTrusted)
  }

  func testIsIssuerNotTrusted_whenMsoMultipleErrorsEmpty_thenReturnsFalse() {
    let error: Error = MsoValidationError.multipleErrors([])
    XCTAssertFalse(error.isIssuerNotTrusted)
  }

  func testIsIssuerNotTrusted_whenMsoNestedMultipleErrorsContainsTrustFailure_thenReturnsTrue() {
    // Exercises the recursive walk through nested `.multipleErrors`.
    let error: Error = MsoValidationError.multipleErrors([
      .multipleErrors([
        .validityInfo("expired"),
        .issuerTrustFailed("untrusted issuer")
      ])
    ])
    XCTAssertTrue(error.isIssuerNotTrusted)
  }

  // MARK: - Unrelated errors

  func testIsIssuerNotTrusted_whenGenericError_thenReturnsFalse() {
    let error: Error = NSError(domain: "com.eudi.test", code: 1)
    XCTAssertFalse(error.isIssuerNotTrusted)
  }
}
