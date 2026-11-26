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
import logic_core
import logic_ui
@testable import feature_common
@testable import logic_test

final class TestRequestDataUiModelCredentialChoice: EudiTest {

  func testSharedDocuments_WhenADocumentIsNotChosen_ThenItIsLeftOut() {
    // Given
    let models = [
      document("pid-1", queryIds: ["pid"], isChosen: false),
      document("pid-2", queryIds: ["pid"], isChosen: true),
      document("mdl", queryIds: ["mdl"], isChosen: nil)
    ]

    // When
    let shared = models.sharedDocuments()

    // Then
    XCTAssertEqual(shared.map(\.section.id), ["pid-2", "mdl"])
    XCTAssertEqual(models.chosenDocumentIds(), ["pid-2"])
  }

  func testKeepsEveryChosenQuery_WhenNoDocumentOfTheQueryIsChosen_ThenIsFalse() {
    // Given
    let models = [
      document("pid-1", queryIds: ["pid"], isChosen: false),
      document("pid-2", queryIds: ["pid"], isChosen: false),
      document("mdl", queryIds: ["mdl"], isChosen: nil)
    ]

    // Then
    XCTAssertFalse(models.keepsEveryChosenQuery())
  }

  func testKeepsEveryChosenQuery_WhenOneDocumentOfTheQueryIsChosen_ThenIsTrue() {
    // Given
    let models = [
      document("pid-1", queryIds: ["pid"], isChosen: false),
      document("pid-2", queryIds: ["pid"], isChosen: true)
    ]

    // Then
    XCTAssertTrue(models.keepsEveryChosenQuery())
  }

  func testKeepsEveryChosenQuery_WhenTheQueryHasADocumentSharedWithTheOption_ThenIsTrue() {
    // Given
    let models = [
      document("pid-1", queryIds: ["pid"], isChosen: nil),
      document("pid-2", queryIds: ["pid"], isChosen: false),
      document("pid-3", queryIds: ["pid"], isChosen: false)
    ]

    // Then
    XCTAssertTrue(models.keepsEveryChosenQuery())
  }

  func testKeepsEveryChosenQuery_WhenNoDocumentCanBeChosen_ThenIsTrue() {
    // Given
    let models = [document("mdl", queryIds: [], isChosen: nil)]

    // Then
    XCTAssertTrue(models.keepsEveryChosenQuery())
  }

  func testTogglingChoice_WhenTheDocumentCanBeChosen_ThenOnlyItsChoiceIsReversed() {
    // Given
    let models = [
      document("pid-1", queryIds: ["pid"], isChosen: false),
      document("pid-2", queryIds: ["pid"], isChosen: false)
    ]

    // When
    let toggled = models.togglingChoice(of: "pid-2")

    // Then
    XCTAssertEqual(toggled.map(\.isChosen), [false, true])
    XCTAssertEqual(toggled.togglingChoice(of: "pid-2").map(\.isChosen), [false, false])
  }

  func testTogglingChoice_WhenTheDocumentCannotBeChosen_ThenNothingChanges() {
    // Given
    let models = [document("mdl", queryIds: ["mdl"], isChosen: nil)]

    // When
    let toggled = models.togglingChoice(of: "mdl")

    // Then
    XCTAssertEqual(toggled, models)
    XCTAssertNil(toggled.first?.isChosen)
  }
}

private extension TestRequestDataUiModelCredentialChoice {
  func document(_ id: String, queryIds: [String], isChosen: Bool?) -> RequestDataUiModel {
    RequestDataUiModel(
      section: .init(id: id, title: "PID", listItems: []),
      queryIds: queryIds,
      isChosen: isChosen
    )
  }
}
