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
import logic_business
import logic_core

/// Why a factory reset stopped. Every step can run again, so the user can retry.
enum WalletResetError: Error {
  /// A background check was still running when `WalletKitConfig.workerStopTimeoutSeconds` ran out; nothing was
  /// deleted.
  case backgroundWorkStillRunning
  /// Documents were still stored after the deletion passes.
  case documentsRemain
  /// The keychain could not be cleared.
  case keychainNotCleared
}

/// The factory reset, as the Android wallet's `WalletCoreResetController`. It deletes every document and its keys,
/// the transaction history and the app's other records, the PIN, the biometric and other settings, and the cached
/// files, while the app keeps running, so that the wallet starts again at onboarding.
public protocol WalletResetController: Sendable {
  /// Runs the reset. The background checks are stopped first, and the reset fails without deleting anything when
  /// one is still running after `WalletKitConfig.workerStopTimeoutSeconds`. The documents are deleted through
  /// WalletKit, which also logs their deletion and updates the Digital Credential API registrations; the history is
  /// cleared after that, then the other records and the store itself, the keychain, the preferences except the
  /// language and the two counters, the cached and temporary files, the cookies and the URL cache; the session is
  /// locked last. Once started, the reset runs to the end even if its
  /// caller is cancelled, and `WalletResetStatusProvider.isResetting` is true meanwhile. A failed step throws and
  /// restarts the background checks; running the reset again is safe.
  func resetWallet() async throws
}

/// Runs the reset in a task of its own, kept in `runningReset`, so a second call joins the one under way.
final actor WalletResetControllerImpl: WalletResetController {

  private let walletKitController: WalletKitController
  private let walletWorkScheduler: WalletWorkScheduler
  private let keyChainController: KeyChainController
  private let prefsController: PrefsController
  private let sessionController: SessionController
  private let resetStatusProvider: WalletResetStatusProvider
  private let clearCachedData: @Sendable () -> Void
  private var runningReset: Task<Void, Error>?

  init(
    walletKitController: WalletKitController,
    walletWorkScheduler: WalletWorkScheduler,
    keyChainController: KeyChainController,
    prefsController: PrefsController,
    sessionController: SessionController,
    resetStatusProvider: WalletResetStatusProvider,
    clearCachedData: @escaping @Sendable () -> Void = WalletResetControllerImpl.removeCachedData
  ) {
    self.walletKitController = walletKitController
    self.walletWorkScheduler = walletWorkScheduler
    self.keyChainController = keyChainController
    self.prefsController = prefsController
    self.sessionController = sessionController
    self.resetStatusProvider = resetStatusProvider
    self.clearCachedData = clearCachedData
  }

  func resetWallet() async throws {
    if let runningReset {
      return try await runningReset.value
    }
    let reset = Task { try await self.performReset() }
    runningReset = reset
    defer { runningReset = nil }
    try await reset.value
  }

  /// The app's caches, WalletKit's log file and the image cache among them, its temporary files, the cookies and
  /// the URL cache. Best effort: a file that cannot be removed does not stop the reset (the Android wallet's reset
  /// fails instead).
  static func removeCachedData() {
    FileManager.default.removeContents(of: FileManager.default.cachesAndTemporaryDirectories)
    HTTPCookieStorage.shared.removeCookies(since: .distantPast)
    URLCache.shared.removeAllCachedResponses()
  }
}

private extension WalletResetControllerImpl {

  enum Constants {
    static let deletionPasses = 2
  }

  /// The flag is cleared before the checks restart after a failure, because `WalletWorkScheduler.schedule()` does
  /// nothing while a reset runs.
  func performReset() async throws {
    resetStatusProvider.setResetting(true)
    do {
      try await runSteps()
      resetStatusProvider.setResetting(false)
    } catch {
      resetStatusProvider.setResetting(false)
      await walletWorkScheduler.schedule()
      throw error
    }
  }

  /// The reset's steps in order; it throws before deleting anything when the background checks are still running.
  func runSteps() async throws {
    guard await walletWorkScheduler.stop() else { throw WalletResetError.backgroundWorkStillRunning }
    try await deleteDocuments()
    try await walletKitController.deleteAllRecords()
    guard keyChainController.clear() else { throw WalletResetError.keychainNotCleared }
    clearPreferences()
    clearCachedData()
    advanceResetGeneration()
    await sessionController.lock()
  }

  /// Deletes every document WalletKit stores, in up to `Constants.deletionPasses` passes, so that one stored by
  /// a check that was still finishing goes too. Whether any is left is read from the keychain itself.
  func deleteDocuments() async throws {
    for _ in 0..<Constants.deletionPasses {
      try await walletKitController.clearAllDocuments()
      if try await !walletKitController.hasStoredDocuments() { return }
    }
    throw WalletResetError.documentsRemain
  }

  /// Every preference goes, so that onboarding runs again, except the language and the two counters, which must
  /// never go back: a reader that cached the history at an old revision, or an extension that saw an old reset,
  /// would otherwise trust stale data.
  func clearPreferences() {
    let kept: Set<Prefs.Key> = [.language, .transactionLogRevision, .walletResetGeneration]
    for key in Prefs.Key.allCases where !kept.contains(key) {
      prefsController.remove(forKey: key)
    }
  }

  func advanceResetGeneration() {
    let generation = prefsController.getInt(forKey: .walletResetGeneration)
    prefsController.setValue(generation &+ 1, forKey: .walletResetGeneration)
  }
}
