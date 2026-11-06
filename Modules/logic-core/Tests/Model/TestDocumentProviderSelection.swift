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
import XCTest
import MdocDataModel18013
@testable import logic_core
@testable import logic_test

final class TestDocumentProviderSelection: EudiTest {

  func testInit_WhenTheSheetShowsDocuments_ThenSelectsOnlyThemAndTheirShownClaims() {
    let selection = DocumentProviderSelection(
      documents: [
        Self.document(id: "pid", claims: [("eu.europa.ec.eudi.pid.1", "family_name"), ("eu.europa.ec.eudi.pid.1", "birth_date")]),
        Self.document(id: "mdl", claims: [("org.iso.18013.5.1", "document_number")])
      ]
    )

    XCTAssertEqual(selection.documentIds, ["pid", "mdl"])
    XCTAssertEqual(
      selection.claimsByDocumentId,
      [
        "pid": ["eu.europa.ec.eudi.pid.1": ["family_name", "birth_date"]],
        "mdl": ["org.iso.18013.5.1": ["document_number"]]
      ]
    )
  }

  func testInit_WhenNothingIsShown_ThenSelectsNothing() {
    let selection = DocumentProviderSelection(documents: [])

    XCTAssertTrue(selection.documentIds.isEmpty)
    XCTAssertTrue(selection.claimsByDocumentId.isEmpty)
  }
}

private extension TestDocumentProviderSelection {

  static func document(id: String, claims: [(namespace: String, name: String)]) -> DocClaimsModel {
    DocClaimsModel(
      configuration: DocClaimsModelConfiguration(
        id: id,
        docType: "doc-type",
        displayName: nil,
        display: nil,
        credentialIssuerIdentifier: nil,
        configurationIdentifier: nil,
        validFrom: nil,
        validUntil: nil,
        statusList: nil,
        credentialsUsageCounts: nil,
        credentialPolicy: .rotateUse,
        secureAreaName: nil,
        modifiedAt: nil,
        docClaims: claims.map {
          DocClaim(name: $0.name, dataValue: .string("value"), stringValue: "value", namespace: $0.namespace)
        },
        docDataFormat: .cbor,
        hashingAlg: nil
      )
    )
  }
}
