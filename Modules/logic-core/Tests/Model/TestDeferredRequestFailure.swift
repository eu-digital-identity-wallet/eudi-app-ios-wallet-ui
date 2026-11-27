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
import enum OpenID4VCI.CredentialIssuanceError
import enum OpenID4VCI.CredentialIssuerMetadataError
import enum OpenID4VCI.CredentialError
import enum OpenID4VCI.PostError
import enum OpenID4VCI.FetchError
import enum OpenID4VCI.WRPRCError
import enum OpenID4VP.ValidationError
import struct OpenID4VP.PolicyViolation
@testable import logic_core
@testable import logic_test

final class TestDeferredRequestFailure: EudiTest {

  func testInit_WhenTheIssuerNoLongerKnowsTheTransaction_ThenTheTransactionHasExpired() {
    // Given
    let errors: [Error] = [
      CredentialIssuanceError.invalidTransactionId,
      WalletError(description: "", code: .issuanceRequestFailed, innerError: CredentialIssuanceError.invalidTransactionId)
    ]

    // Then
    for error in errors {
      XCTAssertEqual(DeferredRequestFailure(error), .expired, "\(error)")
    }
  }

  func testInit_WhenTheIssuerRejectsTheCredentialRequest_ThenItIsAskedAgain() {
    // Given
    let errors: [Error] = [
      CredentialIssuanceError.unsupportedCredentialType,
      CredentialIssuanceError.unsupportedCredentialFormat,
      CredentialIssuanceError.invalidProof(errorDescription: nil),
      CredentialIssuanceError.invalidEncryptionParameters,
      CredentialError.issuerDoesNotSupportDeferredIssuance
    ]

    // Then
    for error in errors {
      XCTAssertEqual(DeferredRequestFailure(error), .transient, "\(error)")
    }
  }

  func testInit_WhenTheIssuerAnswersAnyHttpError_ThenItIsAskedAgain() {
    // Then
    for statusCode in [400, 401, 403, 404, 408, 429, 500, 503] {
      let error = CredentialIssuanceError.requestFailed(code: statusCode, error: "error", errorDescription: nil)
      XCTAssertEqual(DeferredRequestFailure(error), .transient, "\(statusCode)")
    }
  }

  func testInit_WhenTheConnectionOrTheServerFails_ThenItIsAskedAgain() {
    // Given
    let errors: [Error] = [
      URLError(.timedOut),
      URLError(.cannotConnectToHost),
      PostError.networkError(URLError(.networkConnectionLost)),
      PostError.invalidStatusCode(nil, 503, nil),
      PostError.requestError(404, URLError(.cannotParseResponse)),
      PostError.requestError(401, URLError(.userAuthenticationRequired))
    ]

    // Then
    for error in errors {
      XCTAssertEqual(DeferredRequestFailure(error), .transient, "\(error)")
    }
  }

  func testInit_WhenTheIssuerRejectsTheAccessToken_ThenTheTransactionHasExpired() {
    // Given
    let errors: [Error] = [
      CredentialIssuanceError.invalidToken,
      WalletError(description: "", code: .issuanceRequestFailed, innerError: CredentialIssuanceError.invalidToken)
    ]

    // Then
    for error in errors {
      XCTAssertEqual(DeferredRequestFailure(error), .expired, "\(error)")
    }
  }

  func testInit_WhenWalletKitFailsForAnythingButTrust_ThenItIsAskedAgain() {
    // Given
    let codes: [WalletError.Code] = [
      .internalError,
      .unsupportedCredentialConfiguration,
      .missingVciConfiguration,
      .issuanceRequestFailed,
      .storageError,
      .issuerMetadataResolutionFailed,
      .statusCheckFailed
    ]

    // Then
    for code in codes {
      XCTAssertEqual(DeferredRequestFailure(WalletError(description: "", code: code)), .transient, "\(code)")
    }
  }

  func testInit_WhenWalletKitCannotVerifyTheIssuer_ThenTheIssuerIsUntrusted() {
    // Then
    for code: WalletError.Code in [.trustError, .invalidWrprc] {
      XCTAssertEqual(DeferredRequestFailure(WalletError(description: "", code: code)), .untrusted, "\(code)")
    }
  }

  func testInit_WhenTheMdocIssuerChainIsNotTrusted_ThenTheIssuerIsUntrusted() {
    // Given
    let errors: [Error] = [
      MsoValidationError.issuerTrustFailed("not trusted"),
      MsoValidationError.multipleErrors([.validityInfo("expired"), .issuerTrustFailed("not trusted")]),
      WalletError(description: "", code: .issuanceRequestFailed, innerError: MsoValidationError.issuerTrustFailed(""))
    ]

    // Then
    for error in errors {
      XCTAssertEqual(DeferredRequestFailure(error), .untrusted, "\(error)")
    }
  }

  func testInit_WhenTheMdocFailsAnotherCheck_ThenItIsNotTakenForAnUntrustedIssuer() {
    // Then
    XCTAssertEqual(DeferredRequestFailure(MsoValidationError.validityInfo("expired")), .transient)
  }

  /// An unreachable trust list, a wrong device clock or stale signed metadata fail the same way, before the issuer is
  /// asked, so they mustn't stop the requests.
  func testInit_WhenTheIssuerMetadataCannotBeVerified_ThenItIsAskedAgain() {
    // Given
    let errors: [Error] = [
      CredentialIssuerMetadataError.invalidIssuerTrust,
      CredentialIssuerMetadataError.invalidSignedMetadata("chain could not be checked"),
      WalletError(description: "", code: .issuerMetadataResolutionFailed, innerError: CredentialIssuerMetadataError.invalidIssuerTrust),
      WalletError(description: "", code: .trustError, innerError: CredentialIssuerMetadataError.invalidSignedMetadata("chain could not be checked"))
    ]

    // Then
    for error in errors {
      XCTAssertEqual(DeferredRequestFailure(error), .transient, "\(error)")
    }
  }

  func testInit_WhenTheIssuerRegistrationCannotBeVerified_ThenTheIssuerIsUntrusted() {
    // Given
    let policyRejection = ValidationError.authorizationPolicyNotMet(PolicyViolation("not registered for it"))
    let errors: [Error] = [
      WRPRCError.missingIssuerInfo,
      RegistrationRefusedError(),
      policyRejection,
      WalletError(description: "", code: .trustError, innerError: policyRejection)
    ]

    // Then
    for error in errors {
      XCTAssertEqual(DeferredRequestFailure(error), .untrusted, "\(error)")
    }
  }

  func testInit_WhenWalletKitWrapsAnotherError_ThenTheWrappedErrorDecides() {
    // Given
    let wrappedConnectionLoss = WalletError(
      description: "",
      code: .trustError,
      innerError: URLError(.networkConnectionLost)
    )
    let wrappedTrustFailure = WalletError(
      description: "",
      code: .storageError,
      innerError: MsoValidationError.issuerTrustFailed("")
    )

    // Then
    XCTAssertEqual(DeferredRequestFailure(wrappedConnectionLoss), .transient)
    XCTAssertEqual(DeferredRequestFailure(wrappedTrustFailure), .untrusted)
  }

  func testInit_WhenANetworkErrorIsWrapped_ThenItIsAskedAgain() {
    // Given
    let offline = URLError(.notConnectedToInternet)
    let errors: [Error] = [
      PostError.networkError(offline),
      FetchError.networkError(offline),
      WalletError(description: "", code: .issuanceRequestFailed, innerError: PostError.networkError(offline)),
      WalletError(description: "", code: .trustError, innerError: PostError.networkError(offline)),
      NSError(domain: "test", code: 1, userInfo: [NSUnderlyingErrorKey: offline])
    ]

    // Then
    for error in errors {
      XCTAssertEqual(DeferredRequestFailure(error), .transient, "\(error)")
    }
  }

  func testInit_WhenTheWalletItselfFails_ThenItIsALocalFailure() {
    // Then
    XCTAssertEqual(DeferredRequestFailure(WalletCoreError.missingMetadata), .local)
    XCTAssertEqual(DeferredRequestFailure(WalletCoreError.unableFetchDocument), .local)
    XCTAssertEqual(DeferredRequestFailure(DeferredEntryStorageError()), .local)
  }

  func testInit_WhenTheErrorIsUnknown_ThenItIsAskedAgain() {
    // Then
    XCTAssertEqual(DeferredRequestFailure(WalletCoreError.unableFetchDocuments), .transient)
    XCTAssertEqual(DeferredRequestFailure(NSError(domain: "test", code: 1)), .transient)
  }
}
