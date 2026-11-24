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
}
