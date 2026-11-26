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
import EudiWalletKit
import OpenID4VP
@testable import logic_core
@testable import logic_test

final class TestDisclosedDocumentSetCredentialQueries: EudiTest {

  func testQueryIdsByDocumentId_WhenADocumentAnswersMergedAlternatives_ThenCarriesEveryQueryId() throws {
    // Given
    let selections: CredentialSelectionSet = [
      try selection(documentId: "pid-1", queryIds: ["pid_sd", "pid_any"]),
      try selection(documentId: "pid-2", queryIds: ["pid_sd"])
    ]

    // When
    let queryIds = selections.queryIdsByDocumentId()

    // Then
    XCTAssertEqual(queryIds, ["pid-1": ["pid_sd", "pid_any"], "pid-2": ["pid_sd"]])
  }

  func testCredentialQueriesDomain_WhenTheOptionHasNoQueries_ThenIsEmpty() {
    // Given
    let documentSet = DisclosedDocumentSet(docElements: [], warnings: nil)

    // When
    let queries = documentSet.credentialQueriesDomain()

    // Then
    XCTAssertEqual(queries, PresentationCredentialQueriesDomain())
  }
}

private extension TestDisclosedDocumentSetCredentialQueries {
  func selection(documentId: String, queryIds: [String]) throws -> CredentialSelection {
    let ids = try queryIds.map { try QueryId(value: $0) }
    return CredentialSelection(
      credentialId: documentId,
      docType: "urn:eudi:pid:1",
      queryId: ids[0],
      optionId: "option-1",
      claimQueries: [],
      queryIds: ids
    )
  }
}
