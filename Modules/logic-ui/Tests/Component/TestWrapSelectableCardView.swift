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
import os
import logic_resources
@testable import logic_ui
@testable import logic_test

final class TestWrapSelectableCardView: EudiTest {

  @MainActor
  func testSelectionContent_WhenOneCardIsChosenAmongOthers_ThenTheHeaderShowsARadioButton() {
    // Given
    let card = WrapSelectableCardView(
      title: .custom("Option 1 of 2"),
      isSelected: true,
      onSelected: {},
      content: { EmptyView() }
    )

    // When
    let content = card.selectionContent

    // Then
    XCTAssertEqual(content, .radioButton(isSelected: true))
  }

  @MainActor
  func testSelectionContent_WhenSeveralCardsCanBeChosen_ThenTheHeaderShowsACheckbox() {
    // Given
    let card = documentChoiceCard(isSelected: false, isEnabled: true)

    // When
    let content = card.selectionContent

    // Then
    XCTAssertEqual(content, .checkbox(isSelected: false, isEnabled: true))
  }

  @MainActor
  func testSelectionContent_WhenTheCardIsDisabled_ThenTheCheckboxIsDisabled() {
    // Given
    let card = documentChoiceCard(isSelected: true, isEnabled: false)

    // When
    let content = card.selectionContent

    // Then
    XCTAssertEqual(content, .checkbox(isSelected: true, isEnabled: false))
  }

  @MainActor
  func testSelectionContent_WhenTheCardIsDisabled_ThenItIsNotTheEnabledCheckbox() {
    // Given
    let card = documentChoiceCard(isSelected: true, isEnabled: false)

    // When
    let content = card.selectionContent

    // Then
    XCTAssertNotEqual(content, .checkbox(isSelected: true, isEnabled: true))
  }

  @MainActor
  func testHeader_WhenTheCardIsEnabledAndTapped_ThenItIsSelected() {
    // Given
    let taps = OSAllocatedUnfairLock(initialState: 0)
    let card = documentChoiceCard(isSelected: false, isEnabled: true, onSelected: { taps.withLock { $0 += 1 } })

    // When
    card.header.performSelection()

    // Then
    XCTAssertEqual(taps.withLock { $0 }, 1)
  }

  @MainActor
  func testHeader_WhenTheCardIsDisabledAndTapped_ThenNothingHappens() {
    // Given
    let taps = OSAllocatedUnfairLock(initialState: 0)
    let card = documentChoiceCard(isSelected: true, isEnabled: false, onSelected: { taps.withLock { $0 += 1 } })

    // When
    card.header.performSelection()

    // Then
    XCTAssertEqual(taps.withLock { $0 }, 0)
  }

  @MainActor
  func testHeader_WhenTheCardIsDisabled_ThenItIsNoButton() throws {
    // Given
    let card = documentChoiceCard(isSelected: true, isEnabled: false)

    // When
    let selection = try XCTUnwrap(card.header.selection)

    // Then
    XCTAssertEqual(selection, RowSelection(isSelected: true, canChange: false))
  }

  @MainActor
  func testBorderColor_WhenACheckboxCardIsNotSelected_ThenItIsTheSeparatorColour() {
    // Given
    let card = documentChoiceCard(isSelected: false, isEnabled: true)

    // When
    let color = card.borderColor

    // Then
    XCTAssertEqual(color, Theme.shared.color.separator)
  }

  @MainActor
  func testBorderColor_WhenARadioCardIsNotSelected_ThenThereIsNone() {
    // Given
    let card = WrapSelectableCardView(
      title: .custom("Option 2 of 2"),
      isSelected: false,
      onSelected: {},
      content: { EmptyView() }
    )

    // When
    let color = card.borderColor

    // Then
    XCTAssertEqual(color, .clear)
  }

  @MainActor
  func testBorderColor_WhenACheckboxCardIsSelected_ThenItIsTheAccentColour() {
    // Given
    let card = documentChoiceCard(isSelected: true, isEnabled: true)

    // When
    let color = card.borderColor

    // Then
    XCTAssertEqual(color, Theme.shared.color.accent)
  }

  @MainActor
  func testHeaderAccessibilityLabel_WhenTheCardNamesWhatItSelects_ThenTheNameFollowsTheTitle() {
    // Given
    let card = documentChoiceCard(isSelected: false, isEnabled: true)

    // When
    let label = card.headerAccessibilityLabel

    // Then
    XCTAssertEqual(label, "Share this document, PID (SD-JWT VC)")
  }

  @MainActor
  func testHeaderAccessibilityLabel_WhenTheCardNamesNothing_ThenItIsTheTitle() {
    // Given
    let card = WrapSelectableCardView(
      title: .custom("Option 1 of 2"),
      isSelected: false,
      onSelected: {},
      content: { EmptyView() }
    )

    // When
    let label = card.headerAccessibilityLabel

    // Then
    XCTAssertEqual(label, "Option 1 of 2")
  }
}

private extension TestWrapSelectableCardView {

  /// The card of a document the user chooses among several, named for VoiceOver.
  @MainActor
  func documentChoiceCard(
    isSelected: Bool,
    isEnabled: Bool,
    onSelected: @escaping () -> Void = {}
  ) -> WrapSelectableCardView<EmptyView> {
    WrapSelectableCardView(
      title: .custom("Share this document"),
      isSelected: isSelected,
      allowsMultipleSelection: true,
      isEnabled: isEnabled,
      accessibilityName: "PID (SD-JWT VC)",
      onSelected: onSelected,
      content: { EmptyView() }
    )
  }
}
