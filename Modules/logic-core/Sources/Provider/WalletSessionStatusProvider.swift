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
import Foundation
import os

/// Whether the wallet is unlocked and its scene in front: deferred credentials are requested only then. The session
/// lock keeps it up to date, after it has applied the lock timeouts, so a wallet that returns to the front already
/// timed out is never seen as active.
public protocol WalletSessionStatusProvider: Sendable {
  var isActive: Bool { get }
  func update(isUnlocked: Bool, isInForeground: Bool)
}

/// Keeps the flag behind a lock, so the session lock and the workers read and write it from any thread. Starts
/// inactive: the wallet starts locked.
final class WalletSessionStatusProviderImpl: WalletSessionStatusProvider {

  private let state = OSAllocatedUnfairLock(initialState: false)

  var isActive: Bool { state.withLock { $0 } }

  /// Posts `walletSessionBecameActive` when the wallet turns active.
  func update(isUnlocked: Bool, isInForeground: Bool) {
    let isActive = isUnlocked && isInForeground
    let becameActive = state.withLock { wasActive in
      defer { wasActive = isActive }
      return isActive && !wasActive
    }
    if becameActive {
      NotificationCenter.default.post(name: .walletSessionBecameActive, object: nil)
    }
  }
}
