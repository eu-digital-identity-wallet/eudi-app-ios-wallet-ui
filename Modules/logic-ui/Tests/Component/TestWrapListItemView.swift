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

/// Checks what a list row that shows a choice gives VoiceOver: a trailing checkbox (a claim on the request screen), a
/// leading radio button (an option) or a leading tick box (a document chosen among several). The rendered accessibility tree cannot be read in this project's unit tests; how
/// VoiceOver speaks it is checked on an iPhone.
final class TestWrapListItemView: EudiTest {

  @MainActor
  func testSelection_WhenAClaimRowIsCheckedAndCanChange_ThenItIsASelectedButton() throws {
    // Given
    let row = claimRow(isEnabled: true, isChecked: true)

    // When
    let selection = try XCTUnwrap(row.selection)

    // Then
    XCTAssertEqual(selection, RowSelection(isSelected: true, canChange: true))
    XCTAssertEqual(selection.traits, [.isButton, .isSelected])
  }

  @MainActor
  func testSelection_WhenAClaimRowIsUncheckedAndCanChange_ThenItIsAButtonThatIsNotSelected() throws {
    // Given
    let row = claimRow(isEnabled: true, isChecked: false)

    // When
    let selection = try XCTUnwrap(row.selection)

    // Then
    XCTAssertEqual(selection, RowSelection(isSelected: false, canChange: true))
    XCTAssertEqual(selection.traits, [.isButton])
  }

  @MainActor
  func testSelection_WhenARequiredClaimRowCannotChange_ThenItIsSelectedButNoButton() throws {
    // Given
    let row = claimRow(isEnabled: false, isChecked: true)

    // When
    let selection = try XCTUnwrap(row.selection)

    // Then
    XCTAssertEqual(selection, RowSelection(isSelected: true, canChange: false))
    XCTAssertEqual(selection.traits, [.isSelected])
  }

  @MainActor
  func testSelection_WhenAClaimRowHasNoAction_ThenItIsNoButton() throws {
    // Given
    let row = claimRow(isEnabled: true, isChecked: false, action: nil)

    // When
    let selection = try XCTUnwrap(row.selection)

    // Then
    XCTAssertEqual(selection, RowSelection(isSelected: false, canChange: false))
    XCTAssertEqual(selection.traits, [])
  }

  @MainActor
  func testSelection_WhenAnOptionIsSelected_ThenItsRowIsASelectedButton() throws {
    // Given
    let row = optionRow(isSelected: true)

    // When
    let selection = try XCTUnwrap(row.selection)

    // Then
    XCTAssertEqual(selection, RowSelection(isSelected: true, canChange: true))
    XCTAssertEqual(selection.traits, [.isButton, .isSelected])
  }

  @MainActor
  func testSelection_WhenAnOptionIsNotSelected_ThenItsRowIsAButtonThatIsNotSelected() throws {
    // Given
    let row = optionRow(isSelected: false)

    // When
    let selection = try XCTUnwrap(row.selection)

    // Then
    XCTAssertEqual(selection, RowSelection(isSelected: false, canChange: true))
    XCTAssertEqual(selection.traits, [.isButton])
  }

  @MainActor
  func testSelection_WhenAnOptionHasNoAction_ThenItIsNoButton() throws {
    // Given
    let row = optionRow(isSelected: true, action: nil)

    // When
    let selection = try XCTUnwrap(row.selection)

    // Then
    XCTAssertEqual(selection, RowSelection(isSelected: true, canChange: false))
    XCTAssertEqual(selection.traits, [.isSelected])
  }

  @MainActor
  func testSelection_WhenADocumentsTickBoxIsTicked_ThenItsRowIsASelectedButton() throws {
    // Given
    let row = tickBoxRow(isSelected: true, isEnabled: true)

    // When
    let selection = try XCTUnwrap(row.selection)

    // Then
    XCTAssertEqual(selection, RowSelection(isSelected: true, canChange: true))
    XCTAssertEqual(selection.traits, [.isButton, .isSelected])
  }

  @MainActor
  func testSelection_WhenADocumentsTickBoxIsNotTicked_ThenItsRowIsAButtonThatIsNotSelected() throws {
    // Given
    let row = tickBoxRow(isSelected: false, isEnabled: true)

    // When
    let selection = try XCTUnwrap(row.selection)

    // Then
    XCTAssertEqual(selection, RowSelection(isSelected: false, canChange: true))
    XCTAssertEqual(selection.traits, [.isButton])
  }

  @MainActor
  func testSelection_WhenADocumentsTickBoxIsDisabled_ThenItIsNoButton() throws {
    // Given
    let row = tickBoxRow(isSelected: true, isEnabled: false)

    // When
    let selection = try XCTUnwrap(row.selection)

    // Then
    XCTAssertEqual(selection, RowSelection(isSelected: true, canChange: false))
    XCTAssertEqual(selection.traits, [.isSelected])
  }

  @MainActor
  func testSelection_WhenARowShowsNoChoice_ThenItIsNil() {
    // Given
    let row = WrapListItemView(
      listItem: ListItemData(
        mainContent: .text(.custom("Family name")),
        supportingText: .custom("Doe"),
        trailingContent: .icon(Theme.shared.image.chevronRight, Theme.shared.color.accent)
      )
    )

    // When
    let selection = row.selection

    // Then
    XCTAssertNil(selection)
  }

  @MainActor
  func testPerformSelection_WhenTheWholeClaimRowIsTappable_ThenRunsTheRowAction() {
    // Given
    var taps = 0
    let toggles = OSAllocatedUnfairLock<[Bool]>(initialState: [])
    let row = claimRow(isEnabled: true, isChecked: false, toggles: toggles) { taps += 1 }

    // When
    row.performSelection()

    // Then
    XCTAssertEqual(taps, 1)
    XCTAssertEqual(toggles.withLock { $0 }, [])
  }

  @MainActor
  func testPerformSelection_WhenOnlyACheckedCheckboxIsTappable_ThenUnchecksIt() {
    // Given
    var taps = 0
    let toggles = OSAllocatedUnfairLock<[Bool]>(initialState: [])
    let row = claimRow(isEnabled: true, isChecked: true, clickableArea: .trailingContent, toggles: toggles) {
      taps += 1
    }

    // When
    row.performSelection()

    // Then
    XCTAssertEqual(toggles.withLock { $0 }, [false])
    XCTAssertEqual(taps, 0)
  }

  @MainActor
  func testPerformSelection_WhenOnlyAnUncheckedCheckboxIsTappable_ThenChecksIt() {
    // Given
    let toggles = OSAllocatedUnfairLock<[Bool]>(initialState: [])
    let row = claimRow(isEnabled: true, isChecked: false, clickableArea: .trailingContent, toggles: toggles)

    // When
    row.performSelection()

    // Then
    XCTAssertEqual(toggles.withLock { $0 }, [true])
  }

  @MainActor
  func testCheckboxData_WhenTheCheckboxChanges_ThenRunsTheRowAction() {
    // Given
    var taps = 0
    let row = claimRow(isEnabled: true, isChecked: false) { taps += 1 }
    let data = row.checkboxData(isEnabled: true, isChecked: false)

    // When
    data.onCheckedChange?(true)

    // Then
    XCTAssertEqual(taps, 1)
    XCTAssertTrue(data.enabled)
    XCTAssertFalse(data.isChecked)
  }
}

private extension TestWrapListItemView {

  /// A claim row built as the request screen builds it: the claim's name above its value, and a checkbox at its end
  /// whose toggles are recorded in `toggles`.
  @MainActor
  func claimRow(
    isEnabled: Bool,
    isChecked: Bool,
    clickableArea: WrapListItemView.ClickableArea = .entireRow,
    toggles: OSAllocatedUnfairLock<[Bool]> = OSAllocatedUnfairLock(initialState: []),
    action: (() -> Void)? = {}
  ) -> WrapListItemView {
    WrapListItemView(
      listItem: ListItemData(
        mainContent: .text(.custom("Doe")),
        overlineText: .custom("Family name"),
        trailingContent: .checkbox(isEnabled, isChecked) { value in
          toggles.withLock { $0.append(value) }
        }
      ),
      clickableArea: clickableArea,
      action: action
    )
  }

  /// The row at the top of an option card: its title and a radio button at its start.
  @MainActor
  func optionRow(isSelected: Bool, action: (() -> Void)? = {}) -> WrapListItemView {
    WrapListItemView(
      listItem: ListItemData(
        mainContent: .text(.custom("Option 1 of 2")),
        leadingContent: .radioButton(isSelected: isSelected)
      ),
      minHeight: false,
      action: action
    )
  }

  /// The row at the top of a document's card when the user chooses among several: its title and a tick box at its
  /// start.
  @MainActor
  func tickBoxRow(isSelected: Bool, isEnabled: Bool) -> WrapListItemView {
    WrapListItemView(
      listItem: ListItemData(
        mainContent: .text(.custom("Share this document")),
        leadingContent: .checkbox(isSelected: isSelected, isEnabled: isEnabled)
      ),
      minHeight: false,
      action: {}
    )
  }
}
