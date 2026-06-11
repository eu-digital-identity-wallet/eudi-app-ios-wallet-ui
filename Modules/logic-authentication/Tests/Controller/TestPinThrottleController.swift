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

@testable import logic_test
@testable import logic_authentication

final class TestPinThrottleController: EudiTest {

  private var controller: PinThrottleController!
  private var provider: MockPinThrottleProvider!

  override func setUp() {
    super.setUp()
    self.provider = MockPinThrottleProvider()
    self.controller = PinThrottleControllerImpl(provider: provider)
  }

  override func tearDown() {
    self.controller = nil
    self.provider = nil
    super.tearDown()
  }

  func testGetState_WhenProviderReturnsIdle_ThenReturnsIdle() {
    // Given
    stub(provider) { mock in
      when(mock.getState()).thenReturn(.idle)
    }

    // When
    let state = controller.getState()

    // Then
    XCTAssertEqual(state, .idle)
    verify(provider).getState()
  }

  func testGetState_WhenProviderReturnsActiveLockout_ThenReturnsActiveLockout() {
    // Given
    let expected: PinLockoutState = .active(remaining: 30, total: 90)
    stub(provider) { mock in
      when(mock.getState()).thenReturn(expected)
    }

    // When
    let state = controller.getState()

    // Then
    XCTAssertEqual(state, expected)
    verify(provider).getState()
  }

  func testRecordFailure_WhenProviderReturnsIdle_ThenForwardsIdle() {
    // Given
    stub(provider) { mock in
      when(mock.recordFailure()).thenReturn(.idle)
    }

    // When
    let state = controller.recordFailure()

    // Then
    XCTAssertEqual(state, .idle)
    verify(provider).recordFailure()
  }

  func testRecordFailure_WhenProviderReturnsActiveLockout_ThenForwardsLockout() {
    // Given
    let expected: PinLockoutState = .active(remaining: 60, total: 300)
    stub(provider) { mock in
      when(mock.recordFailure()).thenReturn(expected)
    }

    // When
    let state = controller.recordFailure()

    // Then
    XCTAssertEqual(state, expected)
    verify(provider).recordFailure()
  }

  func testRecordSuccess_WhenCalled_ThenDelegatesToProvider() {
    // Given
    stub(provider) { mock in
      when(mock.recordSuccess()).thenDoNothing()
    }

    // When
    controller.recordSuccess()

    // Then
    verify(provider).recordSuccess()
  }
}
