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
import SwiftUI
@testable import logic_ui
@testable import logic_test

final class TestWrapSelectableCardView: EudiTest {

  @MainActor
  func testSelectionContent_WhenOneCardIsChosenAmongOthers_ThenTheHeaderShowsARadioButton() {
    // Given
    let card = WrapSelectableCardView(title: .custom("Option 1 of 2"), isSelected: true, onSelected: {}, content: { EmptyView() })

    // When
    let content = card.selectionContent

    // Then
    XCTAssertEqual(content, .radioButton(isSelected: true))
  }

  @MainActor
  func testSelectionContent_WhenSeveralCardsCanBeChosen_ThenTheHeaderShowsATickBox() {
    // Given
    let card = WrapSelectableCardView(
      title: .custom("Share this document"),
      isSelected: false,
      allowsMultipleSelection: true,
      onSelected: {},
      content: { EmptyView() }
    )

    // When
    let content = card.selectionContent

    // Then
    XCTAssertEqual(content, .checkbox(isSelected: false, isEnabled: true))
  }

  @MainActor
  func testSelectionContent_WhenTheCardIsDisabled_ThenTheTickBoxIsDisabled() {
    // Given
    let card = WrapSelectableCardView(
      title: .custom("Share this document"),
      isSelected: true,
      allowsMultipleSelection: true,
      isEnabled: false,
      onSelected: {},
      content: { EmptyView() }
    )

    // When
    let content = card.selectionContent

    // Then
    XCTAssertEqual(content, .checkbox(isSelected: true, isEnabled: false))
  }
}
