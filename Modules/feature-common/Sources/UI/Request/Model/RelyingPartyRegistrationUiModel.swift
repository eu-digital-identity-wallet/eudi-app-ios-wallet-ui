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
import logic_core
import logic_ui
import logic_resources

public enum RegistrationWarning: Sendable, Equatable {

  case relyingPartyNotVerified
  case relyingPartyOverasked

  public var message: LocalizableStringKey {
    return switch self {
    case .relyingPartyNotVerified: .relyingPartyNotVerifiedWarning
    case .relyingPartyOverasked: .relyingPartyOveraskedWarning
    }
  }

  public var acknowledgement: LocalizableStringKey {
    return .understandRisksAgree
  }
}

public extension RelyingPartyRegistration {

  func toRegistrationData(fallbackName: LocalizableStringKey) -> RelyingPartyRegistrationData {
    let details = registration.details

    return RelyingPartyRegistrationData(
      primary: RegisteredParty(
        name: name.map { LocalizableStringKey.custom($0) } ?? fallbackName,
        identifier: uniqueId.map { LocalizableStringKey.relyingPartyId([$0]) },
        isVerified: isFullyVerified,
        logoUrl: logoUrl
      ),
      privacyPolicyUrl: details?.privacyPolicyUrl,
      intendedUse: details?.intendedUse.map { LocalizableStringKey.custom($0) }
    )
  }

  func toWarning() -> RegistrationWarning? {
    return switch registration {
    case .verified(_, let overaskedClaims):
      overaskedClaims.isEmpty ? nil : .relyingPartyOverasked
    case .notVerified:
      .relyingPartyNotVerified
    case .notSupported:
      nil
    }
  }
}

public extension Optional where Wrapped == IssuerRegistration {

  func toRegistrationData(issuerName: String, issuerLogo: URL? = nil) -> RelyingPartyRegistrationData {
    let details = self?.details
    return RelyingPartyRegistrationData(
      primary: RegisteredParty(
        name: .custom(issuerName),
        identifier: details.map { LocalizableStringKey.relyingPartyId([$0.uniqueId]) },
        isVerified: details != nil,
        logoUrl: details?.logoUrl ?? issuerLogo
      ),
      privacyPolicyUrl: details?.privacyPolicyUrl,
      intendedUse: details?.intendedUse.map { LocalizableStringKey.custom($0) }
    )
  }
}
