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
@testable import logic_core
@testable import logic_test

final class TestPresentationCredentialQueriesDomain: EudiTest {

  func testChoosableDocumentIds_WhenAMultipleQueryHasTwoDocuments_ThenBothCanBeChosen() {
    // Given
    let queries = PresentationCredentialQueriesDomain(
      queryIdsByDocumentId: ["pid-1": ["pid"], "pid-2": ["pid"]],
      multipleQueryIds: ["pid"]
    )

    // When
    let choosable = queries.choosableDocumentIds(among: ["pid-1", "pid-2"])

    // Then
    XCTAssertEqual(choosable, ["pid-1", "pid-2"])
  }

  func testChoosableDocumentIds_WhenAMultipleQueryHasOneDocument_ThenNoneCanBeChosen() {
    // Given
    let queries = PresentationCredentialQueriesDomain(
      queryIdsByDocumentId: ["pid-1": ["pid"]],
      multipleQueryIds: ["pid"]
    )

    // When
    let choosable = queries.choosableDocumentIds(among: ["pid-1"])

    // Then
    XCTAssertEqual(choosable, [])
  }

  func testChoosableDocumentIds_WhenTheQueryAcceptsOneDocument_ThenNoneCanBeChosen() {
    // Given
    let queries = PresentationCredentialQueriesDomain(
      queryIdsByDocumentId: ["pid-1": ["pid"], "pid-2": ["pid"]],
      multipleQueryIds: []
    )

    // When
    let choosable = queries.choosableDocumentIds(among: ["pid-1", "pid-2"])

    // Then
    XCTAssertEqual(choosable, [])
  }

  func testChoosableDocumentIds_WhenADocumentAlsoAnswersASingleQuery_ThenOnlyTheOtherCanBeChosen() {
    // Given
    let queries = PresentationCredentialQueriesDomain(
      queryIdsByDocumentId: ["pid-1": ["pid", "single"], "pid-2": ["pid"]],
      multipleQueryIds: ["pid"]
    )

    // When
    let choosable = queries.choosableDocumentIds(among: ["pid-1", "pid-2"])

    // Then
    XCTAssertEqual(choosable, ["pid-2"])
  }

  func testChoosableDocumentIds_WhenADocumentCarriesTransactionData_ThenOnlyTheOthersCanBeChosen() {
    // Given
    let queries = PresentationCredentialQueriesDomain(
      queryIdsByDocumentId: ["pid-1": ["pid"], "pid-2": ["pid"], "pid-3": ["pid"]],
      multipleQueryIds: ["pid"]
    )

    // When
    let choosable = queries.choosableDocumentIds(among: ["pid-1", "pid-2", "pid-3"], excluding: ["pid-1"])

    // Then
    XCTAssertEqual(choosable, ["pid-2", "pid-3"])
  }

  func testChoosableDocumentIds_WhenTheRequestHasNoQueries_ThenNoneCanBeChosen() {
    // Given
    let queries = PresentationCredentialQueriesDomain()

    // When
    let choosable = queries.choosableDocumentIds(among: ["mdl-1", "mdl-2"])

    // Then
    XCTAssertEqual(choosable, [])
  }

  func testGivesASingleQueryManyDocuments_WhenTwoDocumentsAnswerASingleQuery_ThenIsTrue() {
    // Given
    let queries = PresentationCredentialQueriesDomain(
      queryIdsByDocumentId: ["pid-1": ["pid"], "pid-2": ["pid"]],
      multipleQueryIds: []
    )

    // Then
    XCTAssertTrue(queries.givesASingleQueryManyDocuments(["pid-1", "pid-2"]))
    XCTAssertFalse(queries.givesASingleQueryManyDocuments(["pid-1"]))
  }

  func testGivesASingleQueryManyDocuments_WhenTwoDocumentsAnswerAMultipleQuery_ThenIsFalse() {
    // Given
    let queries = PresentationCredentialQueriesDomain(
      queryIdsByDocumentId: ["pid-1": ["pid"], "pid-2": ["pid"]],
      multipleQueryIds: ["pid"]
    )

    // Then
    XCTAssertFalse(queries.givesASingleQueryManyDocuments(["pid-1", "pid-2"]))
  }

  func testKeepsEveryQuery_WhenEachQueryKeepsADocument_ThenIsTrue() {
    // Given
    let queries = PresentationCredentialQueriesDomain(
      queryIdsByDocumentId: ["pid-1": ["pid"], "pid-2": ["pid"], "mdl": ["mdl"]],
      multipleQueryIds: ["pid"]
    )

    // Then
    XCTAssertTrue(queries.keepsEveryQuery(of: ["pid-1", "pid-2", "mdl"], sharing: ["pid-2", "mdl"]))
  }

  func testKeepsEveryQuery_WhenAQueryLosesAllItsDocuments_ThenIsFalse() {
    // Given
    let queries = PresentationCredentialQueriesDomain(
      queryIdsByDocumentId: ["pid-1": ["pid"], "pid-2": ["pid"], "mdl": ["mdl"]],
      multipleQueryIds: ["pid"]
    )

    // Then
    XCTAssertFalse(queries.keepsEveryQuery(of: ["pid-1", "pid-2", "mdl"], sharing: ["mdl"]))
  }
}
