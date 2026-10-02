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

public enum TransactionLogDomain: Sendable, Equatable {
  case presentation(Presentation)
  case credentialIssuance(CredentialIssuance)
  case credentialReissuance(CredentialReissuance)
  case credentialDeletion(CredentialDeletion)
  case signingSealing(SigningSealing)
  case dataDeletionRequest(DataDeletionRequest)
  case dpaReport(DpaReport)

  public var id: String {
    switch self {
    case .presentation(let value): value.id
    case .credentialIssuance(let value): value.id
    case .credentialReissuance(let value): value.id
    case .credentialDeletion(let value): value.id
    case .signingSealing(let value): value.id
    case .dataDeletionRequest(let value): value.id
    case .dpaReport(let value): value.id
    }
  }

  public var time: Date {
    switch self {
    case .presentation(let value): value.time
    case .credentialIssuance(let value): value.time
    case .credentialReissuance(let value): value.time
    case .credentialDeletion(let value): value.time
    case .signingSealing(let value): value.time
    case .dataDeletionRequest(let value): value.time
    case .dpaReport(let value): value.time
    }
  }

  public var result: TransactionResultDomain {
    switch self {
    case .presentation(let value): value.result
    case .credentialIssuance(let value): value.result
    case .credentialReissuance(let value): value.result
    case .credentialDeletion(let value): value.result
    case .signingSealing(let value): value.result
    case .dataDeletionRequest(let value): value.result
    case .dpaReport(let value): value.result
    }
  }

  public var parentPresentationId: String? {
    switch self {
    case .dataDeletionRequest(let value): value.parentPresentationId
    case .dpaReport(let value): value.parentPresentationId
    default: nil
    }
  }

  public struct Presentation: Sendable, Equatable {
    public let id: String
    public let time: Date
    public let result: TransactionResultDomain
    public let party: InteractingPartyDomain
    public let intermediary: InteractingPartyDomain?
    public let registration: PresentationRegistrationDomain?
    public let claimsRequested: [CredentialClaimsDomain]
    public let claimsPresented: [CredentialClaimsDomain]

    public init(
      id: String,
      time: Date,
      result: TransactionResultDomain,
      party: InteractingPartyDomain,
      intermediary: InteractingPartyDomain?,
      registration: PresentationRegistrationDomain?,
      claimsRequested: [CredentialClaimsDomain],
      claimsPresented: [CredentialClaimsDomain]
    ) {
      self.id = id
      self.time = time
      self.result = result
      self.party = party
      self.intermediary = intermediary
      self.registration = registration
      self.claimsRequested = claimsRequested
      self.claimsPresented = claimsPresented
    }
  }

  public struct CredentialIssuance: Sendable, Equatable {
    public let id: String
    public let time: Date
    public let result: TransactionResultDomain
    public let details: IssuanceDetailsDomain

    public init(id: String, time: Date, result: TransactionResultDomain, details: IssuanceDetailsDomain) {
      self.id = id
      self.time = time
      self.result = result
      self.details = details
    }
  }

  public struct CredentialReissuance: Sendable, Equatable {
    public let id: String
    public let time: Date
    public let result: TransactionResultDomain
    public let details: IssuanceDetailsDomain

    public init(id: String, time: Date, result: TransactionResultDomain, details: IssuanceDetailsDomain) {
      self.id = id
      self.time = time
      self.result = result
      self.details = details
    }
  }

  public struct CredentialDeletion: Sendable, Equatable {
    public let id: String
    public let time: Date
    public let result: TransactionResultDomain
    public let credential: CredentialRefDomain
    public let issuer: InteractingPartyDomain

    public init(
      id: String,
      time: Date,
      result: TransactionResultDomain,
      credential: CredentialRefDomain,
      issuer: InteractingPartyDomain
    ) {
      self.id = id
      self.time = time
      self.result = result
      self.credential = credential
      self.issuer = issuer
    }
  }

  public struct SigningSealing: Sendable, Equatable {
    public let id: String
    public let time: Date
    public let result: TransactionResultDomain
    public let service: InteractingPartyDomain
    public let signingTransactionIdentifier: String?
    public let certificateSerialNumber: String?
    public let fileName: String?
    public let fileSizeBytes: Int?
    public let dtbsr: String?

    public init(
      id: String,
      time: Date,
      result: TransactionResultDomain,
      service: InteractingPartyDomain,
      signingTransactionIdentifier: String?,
      certificateSerialNumber: String?,
      fileName: String?,
      fileSizeBytes: Int?,
      dtbsr: String?
    ) {
      self.id = id
      self.time = time
      self.result = result
      self.service = service
      self.signingTransactionIdentifier = signingTransactionIdentifier
      self.certificateSerialNumber = certificateSerialNumber
      self.fileName = fileName
      self.fileSizeBytes = fileSizeBytes
      self.dtbsr = dtbsr
    }
  }

  public struct DataDeletionRequest: Sendable, Equatable {
    public let id: String
    public let time: Date
    public let result: TransactionResultDomain
    public let parentPresentationId: String
    public let party: InteractingPartyDomain
    public let claims: [CredentialClaimsDomain]
    public let channel: TransactionActionChannel?

    public init(
      id: String,
      time: Date,
      result: TransactionResultDomain,
      parentPresentationId: String,
      party: InteractingPartyDomain,
      claims: [CredentialClaimsDomain],
      channel: TransactionActionChannel? = nil
    ) {
      self.id = id
      self.time = time
      self.result = result
      self.parentPresentationId = parentPresentationId
      self.party = party
      self.claims = claims
      self.channel = channel
    }
  }

  public struct DpaReport: Sendable, Equatable {
    public let id: String
    public let time: Date
    public let result: TransactionResultDomain
    public let parentPresentationId: String
    public let dpaName: String?
    public let dpaCountry: String?
    public let channel: TransactionActionChannel?

    public init(
      id: String,
      time: Date,
      result: TransactionResultDomain,
      parentPresentationId: String,
      dpaName: String?,
      dpaCountry: String?,
      channel: TransactionActionChannel? = nil
    ) {
      self.id = id
      self.time = time
      self.result = result
      self.parentPresentationId = parentPresentationId
      self.dpaName = dpaName
      self.dpaCountry = dpaCountry
      self.channel = channel
    }
  }
}

public enum TransactionResultDomain: Sendable, Equatable {
  case completed
  case notCompleted(reason: String?)

  public var isCompleted: Bool {
    if case .completed = self { return true }
    return false
  }
}

public struct InteractingPartyDomain: Sendable, Equatable {
  public let name: String?
  public let identifier: QualifiedIdentifierDomain?
  public let contacts: [String]
  public let type: String?

  public init(
    name: String?,
    identifier: QualifiedIdentifierDomain?,
    contacts: [String],
    type: String? = nil
  ) {
    self.name = name
    self.identifier = identifier
    self.contacts = contacts
    self.type = type
  }
}

public struct QualifiedIdentifierDomain: Sendable, Equatable {
  public let schemeUri: String
  public let value: String

  public init(schemeUri: String, value: String) {
    self.schemeUri = schemeUri
    self.value = value
  }
}

public struct PresentationRegistrationDomain: Sendable, Equatable {
  public let registrarUrl: String?
  public let purpose: String?
  public let privacyPolicyUrls: [String]
  public let dpa: DpaContactDomain?

  public init(registrarUrl: String?, purpose: String?, privacyPolicyUrls: [String], dpa: DpaContactDomain?) {
    self.registrarUrl = registrarUrl
    self.purpose = purpose
    self.privacyPolicyUrls = privacyPolicyUrls
    self.dpa = dpa
  }
}

public struct DpaContactDomain: Sendable, Equatable {
  public let name: String?
  public let country: String?
  public let contacts: [String]

  public init(name: String?, country: String?, contacts: [String]) {
    self.name = name
    self.country = country
    self.contacts = contacts
  }
}

public struct IssuanceDetailsDomain: Sendable, Equatable {
  public let issuer: InteractingPartyDomain
  public let requestedCount: Int
  public let issuedCount: Int
  public let credentials: [CredentialRefDomain]
  public let isUserTriggered: Bool?

  public init(
    issuer: InteractingPartyDomain,
    requestedCount: Int,
    issuedCount: Int,
    credentials: [CredentialRefDomain],
    isUserTriggered: Bool?
  ) {
    self.issuer = issuer
    self.requestedCount = requestedCount
    self.issuedCount = issuedCount
    self.credentials = credentials
    self.isUserTriggered = isUserTriggered
  }
}

public struct CredentialClaimsDomain: Sendable, Equatable {
  public let credential: CredentialRefDomain
  public let claims: [ClaimRefDomain]

  public init(credential: CredentialRefDomain, claims: [ClaimRefDomain]) {
    self.credential = credential
    self.claims = claims
  }
}

public struct CredentialRefDomain: Sendable, Equatable {
  public let identifier: DocumentTypeIdentifier

  public init(identifier: DocumentTypeIdentifier) {
    self.identifier = identifier
  }
}

public struct ClaimRefDomain: Sendable, Equatable {
  public let segments: [ClaimPathSegment]

  public init(segments: [ClaimPathSegment]) {
    self.segments = segments
  }
}

public enum ClaimPathSegment: Sendable, Equatable {
  case key(name: String)
  case index(Int)
  case allElements
}
