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

/// Whether a factory reset is running, as the Android wallet's `WalletResetStatus`. The app reads it to drop links
/// that arrive meanwhile, so that none opens after onboarding.
public protocol WalletResetStatusProvider: Sendable {
  var isResetting: Bool { get }
  func setResetting(_ isResetting: Bool)
}

/// Keeps the flag behind a lock, so the app and the reset read and write it from any thread.
final class WalletResetStatusProviderImpl: WalletResetStatusProvider {

  private let state = OSAllocatedUnfairLock(initialState: false)

  var isResetting: Bool { state.withLock { $0 } }

  func setResetting(_ isResetting: Bool) {
    state.withLock { $0 = isResetting }
  }
}
