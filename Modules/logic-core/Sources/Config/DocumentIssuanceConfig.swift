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
import EudiWalletKit
import Foundation

struct DocumentIssuanceConfig {
  let defaultRule: DocumentIssuanceRule
  let documentSpecificRules: [DocumentTypeIdentifier: DocumentIssuanceRule]
  let reIssuanceRule: ReIssuanceRule

  func rule(for documentIdentifier: DocumentTypeIdentifier?) -> DocumentIssuanceRule {
    guard let documentIdentifier, let rule = documentSpecificRules[documentIdentifier] else {
      return defaultRule
    }
    return rule
  }
}

/// ARF Annex II (ETSI TS 119 472-3) credential reuse methods.
/// Each method maps to a WalletKit `CredentialPolicy` used when building `CredentialOptions`.
enum CredentialReuseMethod {
  /// Once-Only: the credential is deleted after a single use. Maps to `.oneTimeUse`.
  case onceOnly
  /// Limited-Time: the credential is reused within a time window. Maps to `.rotateUse` with a batch size of 1.
  case limitedTime
  /// Rotating-Batch: credentials rotate across a batch. Maps to `.rotateUse`.
  case rotatingBatch

  var credentialPolicy: CredentialPolicy {
    switch self {
    case .onceOnly:
      return .oneTimeUse
    case .limitedTime, .rotatingBatch:
      return .rotateUse
    }
  }
}

struct DocumentIssuanceRule {
  let reuseMethod: CredentialReuseMethod
  let numberOfCredentials: Int

  /// Builds the WalletKit `CredentialOptions` for this rule. Used as a fallback when a
  /// document has no persisted credential options (`getDocumentCredentialOptions`).
  var credentialOptions: CredentialOptions {
    CredentialOptions(
      credentialPolicy: reuseMethod.credentialPolicy,
      batchSize: reuseMethod == .limitedTime ? 1 : numberOfCredentials
    )
  }
}

struct ReIssuanceRule {
  let minNumberOfCredentials: Int
  let minExpirationHours: Int
  let backgroundIntervalSeconds: TimeInterval
}
