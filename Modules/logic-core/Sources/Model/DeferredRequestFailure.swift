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
import Foundation
import EudiWalletKit
import enum OpenID4VCI.CredentialIssuanceError

/// Thrown when the deferred entry of a document can't be read or written around its request: nothing is asked if it
/// happens before the request, and the document waits `failureRetryDelay` in memory either way
/// (`DeferredRequestFailure.local`).
struct DeferredEntryStorageError: Error, Equatable {}

/// Classifies a failed deferred request: only an issuer the wallet can't verify and an access token that can no
/// longer be used are permanent; any other failure, a refusal or a lost network alike, is asked again after
/// `failureRetryDelay` for as long as the document is deferred. `issuance_pending` never ends up here: OpenID4VCI maps
/// it to a pending response.
/// An issuer that can't be verified is recognised as the issuance flow recognises it (`isTrustBlocked`).
enum DeferredRequestFailure: Equatable {

  /// The credential arrived but its issuer, its metadata or its registration couldn't be verified. Stop asking; the
  /// document is deleted.
  case untrusted
  /// The issuer rejected the access token (`invalid_token`) and WalletKit had no refresh token to renew it first: the
  /// transaction has expired. Stop asking; the user can delete the document.
  case expired
  /// The wallet itself failed, not the request: the document's metadata is missing, its deferred entry can't be read or
  /// written, or an issued credential couldn't be read back. The entry is left as it was, the document isn't shown as
  /// failed, and it is asked again after `failureRetryDelay` in this run of the app.
  case local
  /// Asked again after `failureRetryDelay`, with no limit.
  case transient

  init(_ error: Error) {
    self = Self.classify(error)
  }
}

private extension DeferredRequestFailure {

  // A WalletError is left to classify(_: WalletError), so the error it wraps decides first.
  static func classify(_ error: Error) -> DeferredRequestFailure {
    if let error = error as? WalletError {
      return classify(error)
    }
    if error.isTrustBlocked || error.isIssuerMetadataTrustFailure {
      return .untrusted
    }
    switch error {
    case CredentialIssuanceError.invalidToken:
      return .expired
    case WalletCoreError.missingMetadata, WalletCoreError.unableFetchDocument, is DeferredEntryStorageError:
      return .local
    default:
      return .transient
    }
  }

  // WalletKit may wrap the underlying error; if so, classify that one instead, so a trust error caused by a lost
  // connection is asked again.
  static func classify(_ error: WalletError) -> DeferredRequestFailure {
    if let innerError = error.innerError {
      return classify(innerError)
    }
    switch error.code {
    case .trustError,
        .invalidWrprc:
      return .untrusted
    default:
      return .transient
    }
  }
}
