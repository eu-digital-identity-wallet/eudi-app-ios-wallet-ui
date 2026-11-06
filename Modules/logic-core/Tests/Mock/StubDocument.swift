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
import MdocDataModel18013
@testable import logic_core

/// An issued document for the worker tests, with a status list unless told otherwise.
struct StubDocument: DocClaimsDecodable {
  var id: String
  var createdAt: Date
  var modifiedAt: Date?
  var displayName: String?
  var display: [MdocDataModel18013.DisplayMetadata]?
  var issuerDisplay: [MdocDataModel18013.DisplayMetadata]?
  var credentialIssuerIdentifier: String?
  var configurationIdentifier: String?
  var docType: String
  var docClaims: [MdocDataModel18013.DocClaim]
  var docDataFormat: MdocDataModel18013.DocDataFormat
  var validFrom: Date?
  var validUntil: Date?
  var statusList: MdocDataModel18013.StatusList?
  var secureAreaName: String?
  var credentialsUsageCounts: MdocDataModel18013.CredentialsUsageCounts?
  var credentialPolicy: MdocDataModel18013.CredentialPolicy
  var ageOverXX: [Int: Bool]

  /// A PID named "Document `id`" whose status list URI ends with `id`.
  static func make(id: String, hasStatusList: Bool = true, displayName: String? = nil) -> any DocClaimsDecodable {
    StubDocument(
      id: id,
      createdAt: Date(),
      displayName: displayName ?? "Document \(id)",
      docType: "eu.europa.ec.eudi.pid.1",
      docClaims: [],
      docDataFormat: .cbor,
      statusList: hasStatusList ? MdocDataModel18013.StatusList(idx: 0, uri: "https://status.example/\(id)") : nil,
      credentialPolicy: .rotateUse,
      ageOverXX: [:]
    )
  }
}
