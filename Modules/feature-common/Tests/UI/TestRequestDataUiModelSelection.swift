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
import logic_resources
@testable import feature_common
@testable import logic_test

final class TestRequestDataUiModelSelection: EudiTest {

  func testFilterSelectedRows_whenARowIsOverasked_thenTheMarkDoesNotTravelOnwards() {
    // Given
    let models = [requestDataUiModel(rows: [row(title: "Age", isOverasked: true)])]

    // When
    let sections = models.filterSelectedRows()

    // Then
    XCTAssertEqual(sections.count, 1)
    XCTAssertNil(supportingText(of: sections.first?.listItems.first))
  }

  func testFilterSelectedRows_whenARowIsNotSelected_thenItIsDropped() {
    // Given
    let models = [
      requestDataUiModel(
        rows: [
          row(title: "Age", isOverasked: true, isSelected: false),
          row(title: "Family name")
        ]
      )
    ]

    // When
    let sections = models.filterSelectedRows()

    // Then
    XCTAssertEqual(sections.first?.listItems.count, 1)
    XCTAssertEqual(sections.first?.listItems.first?.overlineText, .custom("Family name"))
  }

  func testFilterSelectedRows_whenRowsAreNested_thenTheMarkIsDroppedFromTheChildren() {
    // Given
    let models = [
      requestDataUiModel(
        rows: [
          .nested(
            .init(
              collapsed: .init(groupId: "group", mainContent: .text(.custom("Address"))),
              expanded: [row(title: "Street", isOverasked: true)],
              isExpanded: false
            )
          )
        ]
      )
    ]

    // When
    let sections = models.filterSelectedRows()

    // Then
    guard case .nested(let group) = sections.first?.listItems.first else {
      return XCTFail("Expected the group to survive the selection")
    }
    XCTAssertNil(supportingText(of: group.expanded.first))
  }
}

private extension TestRequestDataUiModelSelection {

  func supportingText(of item: ExpandableListItem<DocumentElementClaim>?) -> LocalizableStringKey? {
    guard case .single(let data) = item else { return nil }
    return data.collapsed.supportingText
  }

  func requestDataUiModel(rows: [ExpandableListItem<DocumentElementClaim>]) -> RequestDataUiModel {
    .init(section: .init(id: "doc-id", title: "Document", listItems: rows))
  }

  func row(
    title: String,
    isOverasked: Bool = false,
    isSelected: Bool = true
  ) -> ExpandableListItem<DocumentElementClaim> {
    .single(
      .init(
        collapsed: .init(
          groupId: title,
          mainContent: .text(.custom("value")),
          overlineText: .custom(title),
          supportingText: isOverasked ? .notRegisteredData : nil,
          supportingTextColor: isOverasked ? Theme.shared.color.warning : Theme.shared.color.secondaryLabel,
          trailingContent: .checkbox(true, isSelected, { _ in })
        ),
        domainModel: nil
      )
    )
  }
}
