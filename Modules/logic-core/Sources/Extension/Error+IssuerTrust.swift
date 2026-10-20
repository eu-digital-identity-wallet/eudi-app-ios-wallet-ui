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
import MdocSecurity18013
import enum OpenID4VP.ValidationError
import enum OpenID4VCI.WRPRCError
import enum OpenID4VCI.CredentialIssuerMetadataError

public extension Error {

  var isTrustBlocked: Bool {

    if self is WRPRCError { return true }

    if self is RegistrationRefusedError { return true }

    if let walletError = self as? WalletError {

      if walletError.code == .trustError || walletError.code == .invalidWrprc { return true }

      if let innerError = walletError.innerError,
         innerError.isRegistrationPolicyRejection || innerError.isIssuerMetadataTrustFailure {
        return true
      }
    }

    if let msoError = self as? MsoValidationError, msoError.containsIssuerTrustFailure {
      return true
    }

    return false
  }
}

private extension Error {
  var isRegistrationPolicyRejection: Bool {
    guard let validationError = self as? ValidationError else { return false }
    if case .authorizationPolicyNotMet = validationError { return true }
    return false
  }

  var isIssuerMetadataTrustFailure: Bool {
    guard let metadataError = self as? CredentialIssuerMetadataError else { return false }
    switch metadataError {
    case .invalidIssuerTrust,
         .missingSignedMetadata,
         .missingContentType,
         .missingRightContentTypeHeader,
         .invalidSignedMetadata,
         .invalidJOSEHeader,
         .invalidJWTClaims,
         .nonParseableSignedMetadata,
         .issuerMismatch:
      return true
    default:
      return false
    }
  }
}

private extension MsoValidationError {
  var containsIssuerTrustFailure: Bool {
    switch self {
    case .issuerTrustFailed:
      return true
    case .multipleErrors(let errors):
      return errors.contains { $0.containsIssuerTrustFailure }
    default:
      return false
    }
  }
}
