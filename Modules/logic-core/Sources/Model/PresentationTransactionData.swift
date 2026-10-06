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

enum TransactionDataTypeIdentifier: String {
  case qesApproval = "https://cloudsignatureconsortium.org/2025/qes-approval"
  case qes = "https://cloudsignatureconsortium.org/2025/qes"
}

public struct PresentationTransactionData: Sendable, Equatable {

  public enum Content: Sendable, Equatable {
    case qesApproval(QesApprovalTransactionData)
    case qes(QesTransactionData)
    case generic([PresentationTransactionDataField])
  }

  public let type: String
  public let content: Content

  public init(type: String, content: Content) {
    self.type = type
    self.content = content
  }
}

public struct QesApprovalTransactionData: Sendable, Equatable {
  public let trustFramework: String
  public let credentialIds: [String]
  public let signingCredentialId: String?
  public let numberOfSignatures: Int?
  public let documents: [QesDocumentDigest]
  public let hashAlgorithm: QesHashAlgorithm?

  public init(
    trustFramework: String,
    credentialIds: [String],
    signingCredentialId: String?,
    numberOfSignatures: Int?,
    documents: [QesDocumentDigest],
    hashAlgorithm: QesHashAlgorithm?
  ) {
    self.trustFramework = trustFramework
    self.credentialIds = credentialIds
    self.signingCredentialId = signingCredentialId
    self.numberOfSignatures = numberOfSignatures
    self.documents = documents
    self.hashAlgorithm = hashAlgorithm
  }
}

public struct QesTransactionData: Sendable, Equatable {
  public let trustFramework: String
  public let credentialIds: [String]
  public let signatureRequests: [QesSignatureRequest]

  public init(
    trustFramework: String,
    credentialIds: [String],
    signatureRequests: [QesSignatureRequest]
  ) {
    self.trustFramework = trustFramework
    self.credentialIds = credentialIds
    self.signatureRequests = signatureRequests
  }
}

public struct QesSignatureRequest: Sendable, Equatable {
  public let label: String?
  public let signatureQualifier: String?
  public let signatureFormat: String?
  public let conformanceLevel: String?
  public let signedAttributes: [QesSignedAttribute]
  public let href: String?
  public let checksum: QesDocumentChecksum?
  public let oneTimePassword: String?
  public let responseUri: String?

  public init(
    label: String?,
    signatureQualifier: String?,
    signatureFormat: String?,
    conformanceLevel: String?,
    signedAttributes: [QesSignedAttribute],
    href: String?,
    checksum: QesDocumentChecksum?,
    oneTimePassword: String?,
    responseUri: String?
  ) {
    self.label = label
    self.signatureQualifier = signatureQualifier
    self.signatureFormat = signatureFormat
    self.conformanceLevel = conformanceLevel
    self.signedAttributes = signedAttributes
    self.href = href
    self.checksum = checksum
    self.oneTimePassword = oneTimePassword
    self.responseUri = responseUri
  }
}

public struct QesSignedAttribute: Sendable, Equatable {
  public let name: String
  public let value: String?

  public init(name: String, value: String?) {
    self.name = name
    self.value = value
  }
}

public struct QesDocumentChecksum: Sendable, Equatable {
  public let value: String
  public let algorithm: QesHashAlgorithm

  public init(value: String, algorithm: QesHashAlgorithm) {
    self.value = value
    self.algorithm = algorithm
  }
}

public struct QesHashAlgorithm: Sendable, Equatable {
  public let oid: String
  public let name: String?

  public init(oid: String, name: String?) {
    self.oid = oid
    self.name = name
  }
}

public struct QesDocumentDigest: Sendable, Equatable {
  public let label: String?
  public let hash: String
  public let hashType: String?

  public init(label: String?, hash: String, hashType: String?) {
    self.label = label
    self.hash = hash
    self.hashType = hashType
  }
}

public struct PresentationTransactionDataField: Sendable, Equatable {

  public enum Value: Sendable, Equatable {
    case text(String)
    case group([PresentationTransactionDataField])
  }

  public let key: String
  public let value: Value

  public init(key: String, value: Value) {
    self.key = key
    self.value = value
  }
}
