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
import MdocDataModel18013

/// The documents and claims the ID Provider extension's sheet showed for a Digital Credential API request. The
/// response is limited to them, so it cannot include an optional request the sheet left out or a document whose
/// revocation record was never checked.
public struct DocumentProviderSelection: Equatable, Sendable {

  public let documentIds: Set<String>
  /// The shown claims of each document, by namespace, as `DcApiHandler.buildAndEncryptResponse` takes them.
  public let claimsByDocumentId: [String: [String: [String]]]

  public init(documents: [DocClaimsModel]) {
    documentIds = Set(documents.map(\.id))
    claimsByDocumentId = Dictionary(
      documents.map { document in
        (
          document.id,
          Dictionary(grouping: document.docClaims.filter { $0.namespace != nil }, by: { $0.namespace ?? "" })
            .mapValues { claims in claims.map(\.name) }
        )
      },
      uniquingKeysWith: { first, _ in first }
    )
  }
}
