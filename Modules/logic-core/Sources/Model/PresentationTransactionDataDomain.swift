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

public enum PresentationTransactionDataDomain: Sendable, Equatable {
  case qesApproval(QesApprovalTransactionDomain)
  case qes(QesTransactionDomain)
  case unavailable
}

public struct QesApprovalTransactionDomain: Sendable, Equatable {
  public let credentialIds: [String]
  public let credentialId: String?
  public let signatureQualifier: String?
  public let numSignatures: Int
  public let hashAlgorithmOid: String
  public let documentDigests: [QesDocumentDigestDomain]
  public let locations: [String]
  /// `transaction_data_hashes_alg`.
  public let transactionDataHashAlgorithms: [String]

  public init(
    credentialIds: [String],
    credentialId: String?,
    signatureQualifier: String?,
    numSignatures: Int,
    hashAlgorithmOid: String,
    documentDigests: [QesDocumentDigestDomain],
    locations: [String] = [],
    transactionDataHashAlgorithms: [String] = []
  ) {
    self.credentialIds = credentialIds
    self.credentialId = credentialId
    self.signatureQualifier = signatureQualifier
    self.numSignatures = numSignatures
    self.hashAlgorithmOid = hashAlgorithmOid
    self.documentDigests = documentDigests
    self.locations = locations
    self.transactionDataHashAlgorithms = transactionDataHashAlgorithms
  }
}

public struct QesTransactionDomain: Sendable, Equatable {
  public let credentialIds: [String]
  public let signatureRequests: [QesSignatureRequestDomain]
  /// `transaction_data_hashes_alg`.
  public let transactionDataHashAlgorithms: [String]

  public init(
    credentialIds: [String],
    signatureRequests: [QesSignatureRequestDomain],
    transactionDataHashAlgorithms: [String] = []
  ) {
    self.credentialIds = credentialIds
    self.signatureRequests = signatureRequests
    self.transactionDataHashAlgorithms = transactionDataHashAlgorithms
  }
}

public struct QesDocumentDigestDomain: Sendable, Equatable {
  public let label: String?
  public let hash: String
  public let hashType: String
  public let signedProperties: [SigningAttributeDomain]?
  public let href: String?
  public let checksum: DocumentChecksumDomain?
  public let oneTimePassword: String?
  public let circumstantialData: String?
  /// How the document is fetched (`access.type`).
  public let accessMode: String?

  public init(
    label: String?,
    hash: String,
    hashType: String,
    signedProperties: [SigningAttributeDomain]?,
    href: String?,
    checksum: DocumentChecksumDomain?,
    oneTimePassword: String?,
    circumstantialData: String? = nil,
    accessMode: String? = nil
  ) {
    self.label = label
    self.hash = hash
    self.hashType = hashType
    self.signedProperties = signedProperties
    self.href = href
    self.checksum = checksum
    self.oneTimePassword = oneTimePassword
    self.circumstantialData = circumstantialData
    self.accessMode = accessMode
  }
}

public struct QesSignatureRequestDomain: Sendable, Equatable {
  public let label: String?
  public let signatureQualifier: String
  public let responseUri: String?
  public let signatureFormat: String?
  public let conformanceLevel: String?
  public let signedProperties: [SigningAttributeDomain]?
  public let href: String?
  public let checksum: DocumentChecksumDomain?
  public let oneTimePassword: String?
  public let signedEnvelopeProperty: String?
  public let referenceUri: String?
  public let circumstantialData: String?
  /// The signature algorithm's OID (`signAlgo`).
  public let signatureAlgorithm: String?
  public let signatureAlgorithmParameters: String?
  /// How the document is fetched (`access.type`).
  public let accessMode: String?
  /// A document the request carries itself; its content is not kept.
  public let inlineDocument: QesInlineDocumentDomain?

  public init(
    label: String?,
    signatureQualifier: String,
    responseUri: String?,
    signatureFormat: String?,
    conformanceLevel: String?,
    signedProperties: [SigningAttributeDomain]?,
    href: String?,
    checksum: DocumentChecksumDomain?,
    oneTimePassword: String?,
    signedEnvelopeProperty: String? = nil,
    referenceUri: String? = nil,
    circumstantialData: String? = nil,
    signatureAlgorithm: String? = nil,
    signatureAlgorithmParameters: String? = nil,
    accessMode: String? = nil,
    inlineDocument: QesInlineDocumentDomain? = nil
  ) {
    self.label = label
    self.signatureQualifier = signatureQualifier
    self.responseUri = responseUri
    self.signatureFormat = signatureFormat
    self.conformanceLevel = conformanceLevel
    self.signedProperties = signedProperties
    self.href = href
    self.checksum = checksum
    self.oneTimePassword = oneTimePassword
    self.signedEnvelopeProperty = signedEnvelopeProperty
    self.referenceUri = referenceUri
    self.circumstantialData = circumstantialData
    self.signatureAlgorithm = signatureAlgorithm
    self.signatureAlgorithmParameters = signatureAlgorithmParameters
    self.accessMode = accessMode
    self.inlineDocument = inlineDocument
  }
}

/// A document carried in the request itself: its type and its size once decoded, not its content.
public struct QesInlineDocumentDomain: Sendable, Equatable {
  public let documentType: String?
  /// Nil when the content is not Base64.
  public let sizeInBytes: Int?

  public init(documentType: String?, sizeInBytes: Int?) {
    self.documentType = documentType
    self.sizeInBytes = sizeInBytes
  }
}

public struct DocumentChecksumDomain: Sendable, Equatable {
  public let value: String
  public let algorithmOid: String

  public init(value: String, algorithmOid: String) {
    self.value = value
    self.algorithmOid = algorithmOid
  }
}

public struct SigningAttributeDomain: Sendable, Equatable {
  public let name: String
  public let value: String?

  public init(name: String, value: String?) {
    self.name = name
    self.value = value
  }
}
