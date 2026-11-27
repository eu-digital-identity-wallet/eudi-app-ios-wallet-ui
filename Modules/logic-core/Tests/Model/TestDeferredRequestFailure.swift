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
@testable import logic_core
@testable import logic_test

final class TestDeferredRequestFailure: EudiTest {

  func testInit_WhenTheIssuerRejectsTheTransactionOrTheCredential_ThenItIsAskedAgain() {
    let errors: [Error] = [
      CredentialIssuanceError.invalidTransactionId,
      CredentialIssuanceError.unsupportedCredentialType,
      CredentialIssuanceError.unsupportedCredentialFormat,
      CredentialIssuanceError.invalidProof(errorDescription: nil),
      CredentialIssuanceError.invalidEncryptionParameters,
      CredentialError.issuerDoesNotSupportDeferredIssuance
    ]
    for error in errors {
      XCTAssertEqual(DeferredRequestFailure(error), .transient, "\(error)")
    }
  }

  func testInit_WhenTheIssuerAnswersAnyHttpError_ThenItIsAskedAgain() {
    for statusCode in [400, 401, 403, 404, 408, 429, 500, 503] {
      let error = CredentialIssuanceError.requestFailed(code: statusCode, error: "error", errorDescription: nil)
      XCTAssertEqual(DeferredRequestFailure(error), .transient, "\(statusCode)")
    }
  }

  func testInit_WhenTheConnectionOrTheServerFails_ThenItIsAskedAgain() {
    let errors: [Error] = [
      URLError(.timedOut),
      URLError(.cannotConnectToHost),
      PostError.networkError(URLError(.networkConnectionLost)),
      PostError.invalidStatusCode(nil, 503, nil),
      PostError.requestError(404, URLError(.cannotParseResponse)),
      PostError.requestError(401, URLError(.userAuthenticationRequired))
    ]
    for error in errors {
      XCTAssertEqual(DeferredRequestFailure(error), .transient, "\(error)")
    }
  }

  func testInit_WhenTheIssuerRejectsTheAccessToken_ThenTheTransactionHasExpired() {
    let errors: [Error] = [
      CredentialIssuanceError.invalidToken,
      WalletError(description: "", code: .issuanceRequestFailed, innerError: CredentialIssuanceError.invalidToken)
    ]
    for error in errors {
      XCTAssertEqual(DeferredRequestFailure(error), .expired, "\(error)")
    }
  }

  func testInit_WhenWalletKitFailsForAnythingButTrust_ThenItIsAskedAgain() {
    let codes: [WalletError.Code] = [
      .internalError,
      .unsupportedCredentialConfiguration,
      .missingVciConfiguration,
      .issuanceRequestFailed,
      .storageError,
      .issuerMetadataResolutionFailed,
      .statusCheckFailed
    ]
    for code in codes {
      XCTAssertEqual(DeferredRequestFailure(WalletError(description: "", code: code)), .transient, "\(code)")
    }
  }

  func testInit_WhenWalletKitCannotVerifyTheIssuer_ThenTheIssuerIsUntrusted() {
    for code: WalletError.Code in [.trustError, .invalidWrprc] {
      XCTAssertEqual(DeferredRequestFailure(WalletError(description: "", code: code)), .untrusted, "\(code)")
    }
  }

  func testInit_WhenTheMdocIssuerChainIsNotTrusted_ThenTheIssuerIsUntrusted() {
    let errors: [Error] = [
      MsoValidationError.issuerTrustFailed("not trusted"),
      MsoValidationError.multipleErrors([.validityInfo("expired"), .issuerTrustFailed("not trusted")]),
      WalletError(description: "", code: .issuanceRequestFailed, innerError: MsoValidationError.issuerTrustFailed(""))
    ]
    for error in errors {
      XCTAssertEqual(DeferredRequestFailure(error), .untrusted, "\(error)")
    }
  }

  func testInit_WhenTheMdocFailsAnotherCheck_ThenItIsNotTakenForAnUntrustedIssuer() {
    XCTAssertEqual(DeferredRequestFailure(MsoValidationError.validityInfo("expired")), .transient)
  }

  func testInit_WhenTheIssuerMetadataOrRegistrationCannotBeVerified_ThenTheIssuerIsUntrusted() {
    let errors: [Error] = [
      CredentialIssuerMetadataError.invalidIssuerTrust,
      WalletError(description: "", code: .issuerMetadataResolutionFailed, innerError: CredentialIssuerMetadataError.invalidIssuerTrust),
      WRPRCError.missingIssuerInfo,
      RegistrationRefusedError()
    ]
    for error in errors {
      XCTAssertEqual(DeferredRequestFailure(error), .untrusted, "\(error)")
    }
  }

  func testInit_WhenWalletKitWrapsAnotherError_ThenTheWrappedErrorDecides() {
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

    XCTAssertEqual(DeferredRequestFailure(wrappedConnectionLoss), .transient)
    XCTAssertEqual(DeferredRequestFailure(wrappedTrustFailure), .untrusted)
  }

  func testInit_WhenANetworkErrorIsWrapped_ThenItIsAskedAgain() {
    let offline = URLError(.notConnectedToInternet)
    let errors: [Error] = [
      PostError.networkError(offline),
      FetchError.networkError(offline),
      WalletError(description: "", code: .issuanceRequestFailed, innerError: PostError.networkError(offline)),
      WalletError(description: "", code: .trustError, innerError: PostError.networkError(offline)),
      NSError(domain: "test", code: 1, userInfo: [NSUnderlyingErrorKey: offline])
    ]
    for error in errors {
      XCTAssertEqual(DeferredRequestFailure(error), .transient, "\(error)")
    }
  }

  func testInit_WhenTheWalletItselfFails_ThenItIsALocalFailure() {
    XCTAssertEqual(DeferredRequestFailure(WalletCoreError.missingMetadata), .local)
    XCTAssertEqual(DeferredRequestFailure(WalletCoreError.unableFetchDocument), .local)
    XCTAssertEqual(DeferredRequestFailure(DeferredEntryStorageError()), .local)
  }

  func testInit_WhenTheErrorIsUnknown_ThenItIsAskedAgain() {
    XCTAssertEqual(DeferredRequestFailure(WalletCoreError.unableFetchDocuments), .transient)
    XCTAssertEqual(DeferredRequestFailure(NSError(domain: "test", code: 1)), .transient)
  }
}
