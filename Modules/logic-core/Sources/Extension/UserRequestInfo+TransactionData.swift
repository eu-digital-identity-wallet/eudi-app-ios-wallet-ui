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
import MdocDataTransfer18013
import SwiftyJSON
import struct OpenID4VP.OpenId4VPSpec

extension Array where Element == UserRequestInfo {

  func toTransactionDataSets() -> [[String: [PresentationTransactionData]]] {
    self.map { request in
      (request.transactionDataRequested ?? [:]).mapValues { transactionsByType in
        transactionsByType
          .sorted { $0.key < $1.key }
          .map { type, json in
            PresentationTransactionData(
              type: type,
              content: json.toTransactionDataContent(type: type)
            )
          }
      }
    }
  }
}

private let transactionDataCommonKeys: Set<String> = [
  OpenId4VPSpec.TRANSACTION_DATA_TYPE,
  OpenId4VPSpec.TRANSACTION_DATA_CREDENTIAL_IDS,
  OpenId4VPSpec.TRANSACTION_DATA_HASH_ALGORITHMS
]

private let qesTrustFramework = "eIDAS"

private let hashAlgorithmNames: [String: String] = [
  "2.16.840.1.101.3.4.2.1": "SHA-256",
  "2.16.840.1.101.3.4.2.2": "SHA-384",
  "2.16.840.1.101.3.4.2.3": "SHA-512"
]

private enum QesApprovalKeys {
  static let credentialId = "credentialID"
  static let documentDigests = "documentDigests"
  static let label = "label"
  static let hash = "hash"
  static let hashType = "hashType"
  static let hashAlgorithmOID = "hashAlgorithmOID"
  static let numSignatures = "numSignatures"
}

private extension JSON {

  func toTransactionDataContent(type: String) -> PresentationTransactionData.Content {
    switch TransactionDataTypeIdentifier(rawValue: type) {
    case .qesApproval:
      .qesApproval(toQesApproval())
    case nil:
      .generic(toTransactionDataFields(excluding: transactionDataCommonKeys))
    }
  }

  func toQesApproval() -> QesApprovalTransactionData {
    QesApprovalTransactionData(
      trustFramework: qesTrustFramework,
      credentialIds: self[OpenId4VPSpec.TRANSACTION_DATA_CREDENTIAL_IDS].arrayValue.compactMap(\.string),
      signingCredentialId: self[QesApprovalKeys.credentialId].string,
      numberOfSignatures: self[QesApprovalKeys.numSignatures].int,
      documents: self[QesApprovalKeys.documentDigests].arrayValue.compactMap { digest in
        digest[QesApprovalKeys.hash].string.map {
          QesDocumentDigest(
            label: digest[QesApprovalKeys.label].string,
            hash: $0,
            hashType: digest[QesApprovalKeys.hashType].string
          )
        }
      },
      hashAlgorithm: self[QesApprovalKeys.hashAlgorithmOID].string.map {
        QesHashAlgorithm(oid: $0, name: hashAlgorithmNames[$0])
      }
    )
  }

  func toTransactionDataFields(excluding excludedKeys: Set<String> = []) -> [PresentationTransactionDataField] {
    switch self.type {
    case .dictionary:
      return self.dictionaryValue
        .filter { !excludedKeys.contains($0.key) }
        .sorted { $0.key < $1.key }
        .map { PresentationTransactionDataField(key: $0.key, value: $0.value.toTransactionDataValue()) }
    case .array:
      return self.arrayValue.enumerated().map {
        PresentationTransactionDataField(key: "\($0.offset + 1)", value: $0.element.toTransactionDataValue())
      }
    default:
      return []
    }
  }

  func toTransactionDataValue() -> PresentationTransactionDataField.Value {
    switch self.type {
    case .dictionary, .array:
      .group(toTransactionDataFields())
    case .null, .unknown:
      .text("")
    default:
      .text(self.stringValue)
    }
  }
}
