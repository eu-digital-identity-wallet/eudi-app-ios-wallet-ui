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
import WalletStorage
import struct OpenID4VP.ClaimPath

public struct RelyingPartyRegistration: Sendable, Equatable {

  public let name: String?
  public let uniqueId: String?
  public let isVerified: Bool
  public let logoUrl: URL?
  public let registration: RegistrationStatus

  public init(
    name: String?,
    uniqueId: String?,
    isVerified: Bool,
    logoUrl: URL?,
    registration: RegistrationStatus
  ) {
    self.name = name
    self.uniqueId = uniqueId
    self.isVerified = isVerified
    self.logoUrl = logoUrl
    self.registration = registration
  }

  public var isFullyVerified: Bool {
    if case .notVerified = registration { return false }
    return isVerified
  }
}

public enum RegistrationStatus: Sendable, Equatable {

  case verified(details: RegistrationDetails, overaskedClaims: [OveraskedClaim])
  case notVerified(details: RegistrationDetails?)
  case notSupported

  public var details: RegistrationDetails? {
    switch self {
    case .verified(let details, _): details
    case .notVerified(let details): details
    case .notSupported: nil
    }
  }

  public var overaskedClaims: [OveraskedClaim] {
    guard case .verified(_, let overaskedClaims) = self else { return [] }
    return overaskedClaims
  }

  public func resolveRequesterName(
    registrationName: String?,
    accessCertificateName: String?
  ) -> String? {
    switch self {
    case .verified: registrationName ?? accessCertificateName
    case .notVerified: accessCertificateName ?? registrationName
    case .notSupported: accessCertificateName
    }
  }
}

public struct RegistrationDetails: Sendable, Equatable {

  public let tradeName: String
  public let uniqueId: String
  public let logoUrl: URL?
  public let intendedUse: String?
  public let privacyPolicyUrl: URL?
  public let serviceDescription: String?

  public init(
    tradeName: String,
    uniqueId: String,
    logoUrl: URL?,
    intendedUse: String?,
    privacyPolicyUrl: URL?,
    serviceDescription: String?
  ) {
    self.tradeName = tradeName
    self.uniqueId = uniqueId
    self.logoUrl = logoUrl
    self.intendedUse = intendedUse
    self.privacyPolicyUrl = privacyPolicyUrl
    self.serviceDescription = serviceDescription
  }
}

public struct OveraskedClaim: Sendable, Equatable, Hashable {

  public let attestationType: String
  public let path: ClaimPath?

  public init(attestationType: String, path: ClaimPath?) {
    self.attestationType = attestationType
    self.path = path
  }

  public func appliesTo(attestationType: String) -> Bool {
    self.attestationType == attestationType
  }
}

public enum IssuerRegistration: Sendable, Equatable {

  case verified(details: RegistrationDetails)
  case blocked(reason: BlockedReason)

  public enum BlockedReason: Sendable, Equatable {
    case notRegisteredAsProvider
    case attestationNotRegistered
  }

  public var details: RegistrationDetails? {
    guard case .verified(let details) = self else { return nil }
    return details
  }
}

public extension Optional where Wrapped == IssuerRegistration {

  var vouchesForIssuer: Bool {
    switch self {
    case .none: return true
    case .some(let registration): return registration.details != nil
    }
  }
}

public struct IssuanceResult: Sendable {

  public let documents: [WalletStorage.Document]
  public let issuerRegistration: IssuerRegistration?

  public init(
    documents: [WalletStorage.Document],
    issuerRegistration: IssuerRegistration?
  ) {
    self.documents = documents
    self.issuerRegistration = issuerRegistration
  }
}
