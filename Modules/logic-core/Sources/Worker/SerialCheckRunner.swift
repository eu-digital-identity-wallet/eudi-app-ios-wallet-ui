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

/// Runs a check so that two never overlap: a request that arrives while one runs makes it run once more when it
/// ends, instead of starting a second one beside it.
final actor SerialCheckRunner {

  private var isRunning = false
  private var runAgain = false
  private var idleWaiters: [CheckedContinuation<Void, Never>] = []

  /// Runs `check`, or, while one runs, makes it run once more when it ends; returns at once in that case.
  func run(_ check: @Sendable () async -> Void) async {
    guard !isRunning else {
      runAgain = true
      return
    }
    isRunning = true
    repeat {
      runAgain = false
      await check()
    } while runAgain
    isRunning = false
    idleWaiters.forEach { $0.resume() }
    idleWaiters.removeAll()
  }

  /// Returns once no check is running, at once when none is.
  func waitUntilIdle() async {
    guard isRunning else { return }
    await withCheckedContinuation { idleWaiters.append($0) }
  }
}
