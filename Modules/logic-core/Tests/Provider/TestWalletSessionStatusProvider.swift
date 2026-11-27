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
    XCTAssertFalse(WalletSessionStatusProviderImpl().isActive)
  }

  func testIsActive_ThenNeedsTheWalletUnlockedAndInFront() {
    let provider = WalletSessionStatusProviderImpl()
    let cases: [(isUnlocked: Bool, isInForeground: Bool, isActive: Bool)] = [
      (true, true, true),
      (true, false, false),
      (false, true, false),
      (false, false, false)
    ]
    for item in cases {
      provider.update(isUnlocked: item.isUnlocked, isInForeground: item.isInForeground)
      XCTAssertEqual(provider.isActive, item.isActive, "\(item)")
    }
  }

  func testUpdate_WhenTheWalletTurnsActive_ThenAnnouncesIt() async {
    let provider = WalletSessionStatusProviderImpl()
    let announced = expectation(forNotification: .walletSessionBecameActive, object: nil)

    provider.update(isUnlocked: true, isInForeground: true)

    await fulfillment(of: [announced], timeout: 1)
  }

  func testUpdate_WhenTheWalletStaysActive_ThenAnnouncesNothingMore() async {
    let provider = WalletSessionStatusProviderImpl()
    provider.update(isUnlocked: true, isInForeground: true)
    let announced = expectation(forNotification: .walletSessionBecameActive, object: nil)
    announced.isInverted = true

    provider.update(isUnlocked: true, isInForeground: true)

    await fulfillment(of: [announced], timeout: 0.3)
  }

  func testUpdate_WhenTheWalletStaysInactive_ThenAnnouncesNothing() async {
    let provider = WalletSessionStatusProviderImpl()
    let announced = expectation(forNotification: .walletSessionBecameActive, object: nil)
    announced.isInverted = true

    provider.update(isUnlocked: true, isInForeground: false)
    provider.update(isUnlocked: false, isInForeground: true)

    await fulfillment(of: [announced], timeout: 0.3)
  }

  func testUpdate_WhenTheWalletIsActiveAgainAfterALock_ThenAnnouncesItAgain() async {
    let provider = WalletSessionStatusProviderImpl()
    provider.update(isUnlocked: true, isInForeground: true)
    provider.update(isUnlocked: false, isInForeground: true)
    let announced = expectation(forNotification: .walletSessionBecameActive, object: nil)

    provider.update(isUnlocked: true, isInForeground: true)

    await fulfillment(of: [announced], timeout: 1)
  }
}
