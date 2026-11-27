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

final class TestWalletSessionStatusProvider: EudiTest {

  func testIsActive_WhenNothingWasReported_ThenIsInactiveAsTheWalletStartsLocked() {
    // Then
    XCTAssertFalse(WalletSessionStatusProviderImpl().isActive)
  }

  func testIsActive_WhenEachStateIsReported_ThenIsTrueOnlyWhenUnlockedAndInFront() {
    // Given
    struct Report {
      let isUnlocked: Bool
      let isInForeground: Bool
      let isActive: Bool
    }
    let provider = WalletSessionStatusProviderImpl()
    let cases = [
      Report(isUnlocked: true, isInForeground: true, isActive: true),
      Report(isUnlocked: true, isInForeground: false, isActive: false),
      Report(isUnlocked: false, isInForeground: true, isActive: false),
      Report(isUnlocked: false, isInForeground: false, isActive: false)
    ]

    // Then
    for item in cases {
      provider.update(isUnlocked: item.isUnlocked, isInForeground: item.isInForeground)
      XCTAssertEqual(provider.isActive, item.isActive, "\(item)")
    }
  }

  func testUpdate_WhenTheWalletTurnsActive_ThenAnnouncesIt() async {
    // Given
    let provider = WalletSessionStatusProviderImpl()
    let announced = expectation(forNotification: .walletSessionBecameActive, object: nil)

    // When
    provider.update(isUnlocked: true, isInForeground: true)

    // Then
    await fulfillment(of: [announced], timeout: 1)
  }

  func testUpdate_WhenTheWalletStaysActive_ThenAnnouncesNothingMore() async {
    // Given
    let provider = WalletSessionStatusProviderImpl()
    provider.update(isUnlocked: true, isInForeground: true)
    let announced = expectation(forNotification: .walletSessionBecameActive, object: nil)
    announced.isInverted = true

    // When
    provider.update(isUnlocked: true, isInForeground: true)

    // Then
    await fulfillment(of: [announced], timeout: 0.3)
  }

  func testUpdate_WhenTheWalletStaysInactive_ThenAnnouncesNothing() async {
    // Given
    let provider = WalletSessionStatusProviderImpl()
    let announced = expectation(forNotification: .walletSessionBecameActive, object: nil)
    announced.isInverted = true

    // When
    provider.update(isUnlocked: true, isInForeground: false)
    provider.update(isUnlocked: false, isInForeground: true)

    // Then
    await fulfillment(of: [announced], timeout: 0.3)
  }

  func testUpdate_WhenTheWalletIsActiveAgainAfterALock_ThenAnnouncesItAgain() async {
    // Given
    let provider = WalletSessionStatusProviderImpl()
    provider.update(isUnlocked: true, isInForeground: true)
    provider.update(isUnlocked: false, isInForeground: true)
    let announced = expectation(forNotification: .walletSessionBecameActive, object: nil)

    // When
    provider.update(isUnlocked: true, isInForeground: true)

    // Then
    await fulfillment(of: [announced], timeout: 1)
  }
}
