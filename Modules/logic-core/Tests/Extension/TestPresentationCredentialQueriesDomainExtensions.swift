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

final class TestPresentationCredentialQueriesDomainExtensions: EudiTest {

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

  func testHasSingleQueryWithManyDocuments_WhenTwoDocumentsAnswerASingleQuery_ThenIsTrue() {
    // Given
    let queries = PresentationCredentialQueriesDomain(
      queryIdsByDocumentId: ["pid-1": ["pid"], "pid-2": ["pid"]],
      multipleQueryIds: []
    )

    // When
    let result = queries.hasSingleQueryWithManyDocuments(among: ["pid-1", "pid-2"])

    // Then
    XCTAssertTrue(result)
  }

  func testHasSingleQueryWithManyDocuments_WhenOneDocumentAnswersASingleQuery_ThenIsFalse() {
    // Given
    let queries = PresentationCredentialQueriesDomain(
      queryIdsByDocumentId: ["pid-1": ["pid"], "pid-2": ["pid"]],
      multipleQueryIds: []
    )

    // When
    let result = queries.hasSingleQueryWithManyDocuments(among: ["pid-1"])

    // Then
    XCTAssertFalse(result)
  }

  func testHasSingleQueryWithManyDocuments_WhenTwoDocumentsAnswerAMultipleQuery_ThenIsFalse() {
    // Given
    let queries = PresentationCredentialQueriesDomain(
      queryIdsByDocumentId: ["pid-1": ["pid"], "pid-2": ["pid"]],
      multipleQueryIds: ["pid"]
    )

    // When
    let result = queries.hasSingleQueryWithManyDocuments(among: ["pid-1", "pid-2"])

    // Then
    XCTAssertFalse(result)
  }

  func testKeepsEveryQuery_WhenEachQueryKeepsADocument_ThenIsTrue() {
    // Given
    let queries = PresentationCredentialQueriesDomain(
      queryIdsByDocumentId: ["pid-1": ["pid"], "pid-2": ["pid"], "mdl": ["mdl"]],
      multipleQueryIds: ["pid"]
    )

    // When
    let result = queries.keepsEveryQuery(of: ["pid-1", "pid-2", "mdl"], sharing: ["pid-2", "mdl"])

    // Then
    XCTAssertTrue(result)
  }

  func testKeepsEveryQuery_WhenAQueryLosesAllItsDocuments_ThenIsFalse() {
    // Given
    let queries = PresentationCredentialQueriesDomain(
      queryIdsByDocumentId: ["pid-1": ["pid"], "pid-2": ["pid"], "mdl": ["mdl"]],
      multipleQueryIds: ["pid"]
    )

    // When
    let result = queries.keepsEveryQuery(of: ["pid-1", "pid-2", "mdl"], sharing: ["mdl"])

    // Then
    XCTAssertFalse(result)
  }

  func testCanLeaveOut_WhenABlockedMatchLeavesAnotherForItsMultipleQuery_ThenIsTrue() {
    // Given
    let queries = PresentationCredentialQueriesDomain(
      queryIdsByDocumentId: ["pid-1": ["pid"], "pid-2": ["pid"], "mdl": ["mdl"]],
      multipleQueryIds: ["pid"]
    )

    // When
    let result = queries.canLeaveOut(["pid-1"], among: ["pid-1", "pid-2", "mdl"], transactionDocumentIds: [])

    // Then
    XCTAssertTrue(result)
  }

  func testCanLeaveOut_WhenEveryMatchOfTheQueryIsBlocked_ThenIsFalse() {
    // Given
    let queries = PresentationCredentialQueriesDomain(
      queryIdsByDocumentId: ["pid-1": ["pid"], "pid-2": ["pid"]],
      multipleQueryIds: ["pid"]
    )

    // When
    let result = queries.canLeaveOut(["pid-1", "pid-2"], among: ["pid-1", "pid-2"], transactionDocumentIds: [])

    // Then
    XCTAssertFalse(result)
  }

  func testCanLeaveOut_WhenTheBlockedDocumentAnswersASingleQuery_ThenIsFalse() {
    // Given
    let queries = PresentationCredentialQueriesDomain(
      queryIdsByDocumentId: ["pid-1": ["pid", "single"], "pid-2": ["pid", "single"]],
      multipleQueryIds: ["pid"]
    )

    // When
    let result = queries.canLeaveOut(["pid-1"], among: ["pid-1", "pid-2"], transactionDocumentIds: [])

    // Then
    XCTAssertFalse(result)
  }

  func testCanLeaveOut_WhenTheBlockedMatchCarriesTransactionData_ThenIsFalse() {
    // Given
    let queries = PresentationCredentialQueriesDomain(
      queryIdsByDocumentId: ["pid-1": ["pid"], "pid-2": ["pid"]],
      multipleQueryIds: ["pid"]
    )

    // When
    let result = queries.canLeaveOut(["pid-1"], among: ["pid-1", "pid-2"], transactionDocumentIds: ["pid-1"])

    // Then
    XCTAssertFalse(result)
  }

  func testCanLeaveOut_WhenTheRequestHasNoQueries_ThenIsFalse() {
    // Given
    let queries = PresentationCredentialQueriesDomain()

    // When
    let result = queries.canLeaveOut(["mdl-1"], among: ["mdl-1", "mdl-2"], transactionDocumentIds: [])

    // Then
    XCTAssertFalse(result)
  }
}
