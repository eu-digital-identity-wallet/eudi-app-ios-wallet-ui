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
@testable import logic_business
@testable import logic_test

final class TestPrefsControllerWalletReset: EudiTest {

  func testTakeNewWalletReset_WhenAResetHappenedSinceTheLastLook_ThenReportsItOnce() {
    // Given
    let defaults = UserDefaults(suiteName: UUID().uuidString)!
    let prefsController = MockPrefsController()
    stub(prefsController) { mock in
      when(mock.getInt(forKey: any())).thenReturn(3)
    }

    // When
    let first = prefsController.recordWalletResetSeen(in: defaults)
    let second = prefsController.recordWalletResetSeen(in: defaults)

    // Then
    XCTAssertTrue(first)
    XCTAssertFalse(second)
  }

  func testTakeNewWalletReset_WhenNoResetEverHappened_ThenReportsNothing() {
    // Given
    let defaults = UserDefaults(suiteName: UUID().uuidString)!
    let prefsController = MockPrefsController()
    stub(prefsController) { mock in
      when(mock.getInt(forKey: any())).thenReturn(0)
    }

    // When
    let reported = prefsController.recordWalletResetSeen(in: defaults)

    // Then
    XCTAssertFalse(reported)
  }
}
