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

/// Classifies a failed deferred request. Only a definite verdict is permanent: an issuer, registration or credential
/// the wallet can't trust, an access token the issuer rejects (`invalid_token`), or a transaction the issuer no longer
/// knows (`invalid_transaction_id`). They stop the requests, and the document stays, shown as failed, until the user
/// deletes it; the wallet never deletes it itself. Any other failure, a lost network alike, is asked again after
/// `failureRetryDelaySeconds` or the issuer's last interval, whichever is longer, for as long as the document is
/// deferred. `issuance_pending` never ends up here: OpenID4VCI maps it to a pending response.
/// Issuer metadata that can't be verified is asked again: an unreachable trust list, a wrong device clock or stale
/// signed metadata fail the same way as an untrusted issuer, before the issuer is asked.
enum DeferredRequestFailure: Equatable {

  /// The issuer, its registration or the credential that arrived couldn't be trusted. Stop asking; the document stays,
  /// shown as failed, for the user to delete.
  case untrusted
  /// The issuer rejected the access token (`invalid_token`) or no longer knows the transaction
  /// (`invalid_transaction_id`). Stop asking; the document stays, shown as failed, for the user to delete.
  case expired
  /// The wallet itself failed, not the request: the document's metadata is missing, its deferred entry can't be read or
  /// written, or an issued credential couldn't be read back. The entry is left as it was, the document isn't shown as
  /// failed, and it is asked again after `failureRetryDelaySeconds` in this run of the app.
  case local
  /// Asked again after `failureRetryDelaySeconds` or the issuer's last interval, whichever is longer, with no limit.
  case transient

  init(_ error: Error) {
    self = Self.classify(error)
  }
}

private extension DeferredRequestFailure {

  /// A `WalletError` is left to `classify(_: WalletError)`, so the error it wraps decides first.
  static func classify(_ error: Error) -> DeferredRequestFailure {
    if let error = error as? WalletError {
      return classify(error)
    }
    if error.isIssuerMetadataTrustFailure {
      return .transient
    }
    if error.isTrustBlocked || error.isRegistrationPolicyRejection {
      return .untrusted
    }
    switch error {
    case CredentialIssuanceError.invalidToken, CredentialIssuanceError.invalidTransactionId:
      return .expired
    case WalletCoreError.missingMetadata, WalletCoreError.unableFetchDocument, is DeferredEntryStorageError:
      return .local
    default:
      return .transient
    }
  }

  /// WalletKit may wrap the underlying error. A registration that fails the issuance policy is a verdict; any other
  /// wrapped error is classified itself, so a trust error caused by a lost connection is asked again.
  static func classify(_ error: WalletError) -> DeferredRequestFailure {
    if let innerError = error.innerError {
      return innerError.isRegistrationPolicyRejection ? .untrusted : classify(innerError)
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
