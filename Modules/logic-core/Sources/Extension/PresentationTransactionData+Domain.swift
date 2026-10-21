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
import MdocDataModel18013
import struct OpenID4VP.SupportedTransactionDataType

extension DisclosedDocumentSet {
  func transactionDataDomains() -> [String: [PresentationTransactionDataDomain]] {
    transactionData.mapValues { transactions in
      transactions.map { $0.payload.toPresentationTransactionDataDomain() }
    }
  }
}

extension TransactionalData {
  func toPresentationTransactionDataDomains(
    supportedTypes: [SupportedTransactionDataType]
  ) -> [PresentationTransactionDataDomain] {
    payloads(supportedTypes: supportedTypes).map { $0.toPresentationTransactionDataDomain() }
  }
}

extension PresentationTransactionData.Payload {
  func toPresentationTransactionDataDomain() -> PresentationTransactionDataDomain {
    switch self {
    case .qesApprovalRequest(let approval):
      .qesApproval(approval.toQesApprovalTransactionDomain())
    case .qesRequest(let request):
      .qes(request.toQesTransactionDomain())
    case .raw:
      .unavailable
    }
  }
}

private extension QesApprovalRequest {
  func toQesApprovalTransactionDomain() -> QesApprovalTransactionDomain {
    QesApprovalTransactionDomain(
      credentialIds: credentialIds,
      credentialId: credentialID,
      signatureQualifier: signatureQualifier,
      numSignatures: numSignatures,
      hashAlgorithmOid: hashAlgorithmOID,
      documentDigests: documentDigests.map { $0.toQesDocumentDigestDomain() }
    )
  }
}

private extension QesRequest {
  func toQesTransactionDomain() -> QesTransactionDomain {
    QesTransactionDomain(
      credentialIds: credentialIds,
      signatureRequests: signatureRequests.map { $0.toQesSignatureRequestDomain() }
    )
  }
}

private extension QesDocumentDigest {
  func toQesDocumentDigestDomain() -> QesDocumentDigestDomain {
    QesDocumentDigestDomain(
      label: label,
      hash: hash,
      hashType: hashType,
      signedProperties: signedProperties?.map { $0.toSigningAttributeDomain() },
      href: href,
      checksum: checksum?.toDocumentChecksumDomain(),
      oneTimePassword: access?.oneTimePassword
    )
  }
}

private extension QesSignatureRequest {
  func toQesSignatureRequestDomain() -> QesSignatureRequestDomain {
    QesSignatureRequestDomain(
      label: label,
      signatureQualifier: signatureQualifier,
      responseUri: responseURI,
      signatureFormat: signatureFormat,
      conformanceLevel: conformanceLevel,
      signedProperties: signedProperties?.map { $0.toSigningAttributeDomain() },
      href: href,
      checksum: checksum?.toDocumentChecksumDomain(),
      oneTimePassword: access?.oneTimePassword
    )
  }
}

private extension QesChecksum {
  func toDocumentChecksumDomain() -> DocumentChecksumDomain {
    DocumentChecksumDomain(value: value, algorithmOid: algorithmOID)
  }
}

private extension QesAttribute {
  func toSigningAttributeDomain() -> SigningAttributeDomain {
    SigningAttributeDomain(name: name, value: value)
  }
}
