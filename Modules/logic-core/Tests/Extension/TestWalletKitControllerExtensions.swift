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
import Cuckoo
import logic_resources
@testable import logic_core
@testable import logic_test

final class TestWalletKitControllerExtensions: EudiTest {

  func testRefuseReIssueIfBlocked_WhenTheDocumentIsRevokedOrSuspended_ThenThrowsDocumentBlocked() async {
    for status in [DocumentRevocationStatus.revoked, .suspended, .unrecognised] {
      // Given
      let controller = MockWalletKitController()
      stub(controller) { mock in
        when(mock.fetchRevokedDocumentStatuses()).thenReturn(["pid": status])
      }

      // When
      do {
        try await controller.refuseReIssueIfBlocked("pid")

        // Then
        XCTFail("Expected a refusal for \(status)")
      } catch {
        XCTAssertEqual(error as? WalletCoreError, .documentBlocked)
      }
    }
  }

  func testRefuseReIssueIfBlocked_WhenOnlyAnotherDocumentIsBlocked_ThenDoesNotThrow() async throws {
    // Given
    let controller = MockWalletKitController()
    stub(controller) { mock in
      when(mock.fetchRevokedDocumentStatuses()).thenReturn(["other": .revoked])
    }


    // Then
    try await controller.refuseReIssueIfBlocked("pid")
  }

  func testRefuseReIssueIfBlocked_WhenTheRecordsCannotBeRead_ThenThrowsTheReadError() async {
    // Given
    let controller = MockWalletKitController()
    stub(controller) { mock in
      when(mock.fetchRevokedDocumentStatuses()).thenThrow(WalletCoreError.unableFetchDocuments)
    }

    // When
    do {
      try await controller.refuseReIssueIfBlocked("pid")

      // Then
      XCTFail("Expected the read error")
    } catch {
      XCTAssertEqual(error as? WalletCoreError, .unableFetchDocuments)
    }
  }

  func testParseDocClaim_WhenAnObjectSharesNoPart_ThenItsRowSaysNoDetailsShared() {
    // Given
    let claim = DocClaim(
      name: "place_of_birth",
      path: ["place_of_birth"],
      dataValue: .dictionary,
      stringValue: "{}",
      children: []
    )

    // When
    let rows = parseDocClaim(claim)

    // Then
    XCTAssertEqual(rows, [row(for: claim, value: LocalizableStringKey.requestDataNoDetailsShared.toString)])
    XCTAssertEqual(LocalizableStringKey.requestDataNoDetailsShared.toString, "No details shared")
  }

  func testParseDocClaim_WhenAnArraySharesNoElement_ThenItsRowSaysNoDetailsShared() {
    // Given
    let claim = DocClaim(
      name: "nationalities",
      path: ["nationalities"],
      dataValue: .array,
      stringValue: "",
      children: []
    )

    // When
    let rows = parseDocClaim(claim)

    // Then
    XCTAssertEqual(rows, [row(for: claim, value: LocalizableStringKey.requestDataNoDetailsShared.toString)])
  }

  func testParseDocClaim_WhenTheClaimIsAPlainValue_ThenItsRowShowsTheValue() {
    // Given
    let claim = DocClaim(
      name: "family_name",
      path: ["family_name"],
      dataValue: .string("Reset"),
      stringValue: "Reset"
    )

    // When
    let rows = parseDocClaim(claim)

    // Then
    XCTAssertEqual(rows, [row(for: claim, value: "Reset")])
  }

  func testParseDocClaim_WhenAWildcardArrayIsShownAsOneRow_ThenItsRowShowsTheElements() {
    // Given
    let claim = DocClaim(
      name: "nationalities",
      path: ["nationalities", ""],
      dataValue: .array,
      stringValue: "EU"
    )

    // When
    let rows = parseDocClaim(claim)

    // Then
    XCTAssertEqual(rows, [row(for: claim, value: "EU")])
  }
}

private extension TestWalletKitControllerExtensions {

  func parseDocClaim(_ claim: DocClaim) -> [DocumentElementClaim] {
    MockWalletKitController().parseDocClaim(
      docId: "pid",
      groupId: "group",
      docClaim: claim,
      type: .sdjwt,
      parser: { $0 }
    )
  }

  func row(for claim: DocClaim, value: String) -> DocumentElementClaim {
    .primitive(
      id: "group",
      title: claim.name,
      documentId: "pid",
      nameSpace: nil,
      path: claim.path,
      type: .sdjwt,
      value: .string(value),
      status: .available(isRequired: false)
    )
  }
}
