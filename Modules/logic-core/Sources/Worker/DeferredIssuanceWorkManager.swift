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
import WalletStorage
import logic_business
import logic_storage

protocol DeferredIssuanceWorkManager: Sendable {
  /// Starts the loop. Entries that fell due while the app was closed are requested right away.
  func start() async
  /// Returns after any running check has finished, so nothing is written afterwards.
  func stop() async
  /// Re-reads the entries and reschedules. No-op while stopped.
  func wake() async
}

/// Requests deferred credentials as their entries fall due, one check at a time, and only while the wallet is
/// unlocked and in front (`WalletSessionStatusProvider`); a request under way when it locks finishes.
/// Sleeps until the next due entry, at most `maximumWait` at a time; goes idle when nothing is pending, or the wallet
/// is locked or in the background, until `wake()`. Also woken by `wakingNotifications` while running.
final actor DeferredIssuanceWorkManagerImpl: DeferredIssuanceWorkManager {

  /// `Task.sleep` doesn't advance while the device sleeps, so the wallet turning active again, which includes its
  /// return to the front, re-checks.
  static let wakingNotifications: [Notification.Name] = [
    .deferredIssuanceEntered,
    .walletSessionBecameActive
  ]

  /// The shortest wait before the next check: an overdue document is asked at once, and a clock that hasn't moved
  /// can't make a tight loop.
  static let minimumWait: TimeInterval = 0.001

  /// A longer wait is split into pieces: the issuer's interval has no upper limit and `Task.sleep` traps
  /// past UInt64 nanoseconds. Each wake-up only reads the entries; nothing is requested before it's due.
  static let maximumWait: TimeInterval = 60 * 60

  private let walletKitController: WalletKitController
  private let storageController: any DeferredIssuanceStorageController
  private let revocationWorkManager: RevocationWorkManager
  private let schedule: DeferredIssuanceSchedule
  private let sessionStatusProvider: WalletSessionStatusProvider
  private let checkRunner: SerialCheckRunner
  private let now: @Sendable () -> Date
  private let sleep: @Sendable (TimeInterval) async throws -> Void

  private var isRunning = false
  /// nil while idle.
  private var loopTask: Task<Void, Never>?
  /// Bumped per loop, so a stale loop finishing after stop()/start() doesn't clear the new one.
  private var loopGeneration = 0
  /// Cancelled by wake() to run the next check immediately.
  private var waitTask: Task<Void, Error>?
  /// Set when wake() arrives mid-check, so the loop re-reads the entries instead of sleeping.
  private var isWakeRequested = false
  /// Registered in start(), removed in stop().
  private var wakingObservers: [any NSObjectProtocol] = []
  /// When a document may be asked again after the wallet itself failed (a write, its metadata). Kept in memory only:
  /// a new launch asks when the entry says.
  private var localRetryAt: [String: Date] = [:]
  /// Set when the last check couldn't read or sync the entries, so the next one waits `failureWait` instead of
  /// retrying at once.
  private var didLastCheckFailLocally = false

  /// `now` and `sleep` are injectable so tests can control time.
  init(
    walletKitController: WalletKitController,
    storageController: any DeferredIssuanceStorageController,
    revocationWorkManager: RevocationWorkManager,
    schedule: DeferredIssuanceSchedule,
    sessionStatusProvider: WalletSessionStatusProvider,
    checkRunner: SerialCheckRunner = SerialCheckRunner(),
    now: @escaping @Sendable () -> Date = { Date() },
    sleep: @escaping @Sendable (TimeInterval) async throws -> Void = { try await Task.sleep(seconds: $0) }
  ) {
    self.walletKitController = walletKitController
    self.storageController = storageController
    self.revocationWorkManager = revocationWorkManager
    self.schedule = schedule
    self.sessionStatusProvider = sessionStatusProvider
    self.checkRunner = checkRunner
    self.now = now
    self.sleep = sleep
  }

  func start() async {
    guard !isRunning else { return }
    isRunning = true
    localRetryAt = [:]
    wakingObservers = Self.wakingNotifications.map { name in
      NotificationCenter.default.addObserver(forName: name, object: nil, queue: nil) { [weak self] _ in
        Task { await self?.wake() }
      }
    }
    startLoopIfIdle()
  }

  func stop() async {
    isRunning = false
    wakingObservers.forEach { NotificationCenter.default.removeObserver($0) }
    wakingObservers = []
    loopTask?.cancel()
    loopTask = nil
    waitTask?.cancel()
    waitTask = nil
    await checkRunner.waitUntilIdle()
  }

  /// True when no loop is running (nothing pending, or stopped). Used by tests.
  var isIdle: Bool {
    loopTask == nil
  }

  func wake() async {
    guard isRunning else { return }
    guard loopTask != nil else {
      startLoopIfIdle()
      return
    }
    if let waitTask {
      waitTask.cancel()
    } else {
      isWakeRequested = true
    }
  }

  /// Syncs the entries with WalletKit's deferred documents, then requests the due ones, oldest first.
  /// Documents deferred before entries existed get one based on their last modification date.
  /// If the check is cancelled, or the document is deleted meanwhile, no failure is recorded for the request and its
  /// entry isn't written back. A request that an issuance or a deletion under way holds back is asked again after
  /// `failureWait` in this run of the app.
  /// The documents list is refreshed when a document is issued, deleted, or starts or stops showing as failed.
  /// A request that ends with a verdict (untrusted, expired) stops asking for that document; the document stays,
  /// listed as failed, until the user deletes it.
  /// Does nothing while the wallet is locked or in the background, and stops before the next request if it locks.
  func checkDeferredDocuments() async {

    guard sessionStatusProvider.isActive else { return }
    didLastCheckFailLocally = false
    guard let entries = try? await storageController.retrieveAllEntries() else {
      didLastCheckFailLocally = true
      return
    }
    let documents = await walletKitController.fetchDeferredDocuments()
    guard let current = try? await reconcile(entries, with: documents) else {
      didLastCheckFailLocally = true
      return
    }

    let date = now()
    let due = current
      .filter { $0.state == .pending && dueAt($0) <= date }
      .sorted { dueAt($0) < dueAt($1) }

    var didIssue = false
    var didChangeState = false
    let failedBefore = due.isEmpty ? [] : await walletKitController.fetchFailedDeferredDocumentIds()

    for entry in due {

      guard !Task.isCancelled, sessionStatusProvider.isActive else { break }
      guard let document = documents.first(where: { $0.id == entry.identifier }) else { continue }
      localRetryAt[entry.identifier] = nil

      do {
        let result = try await walletKitController.requestDeferredIssuance(with: document)
        if !(result is DeferrredDocument) {
          didIssue = true
        }
      } catch is DeferredDocumentDeletedError, is DeferredRequestHeldError {
        postponeInMemory(of: entry.identifier)
        continue
      } catch {
        guard !Task.isCancelled else { break }
        guard await isStillDeferred(entry.identifier) else { continue }
        let failure = DeferredRequestFailure(error)
        let next = schedule.after(failure, of: entry, at: now())
        do {
          try await storageController.update(next)
        } catch {
          postponeInMemory(of: entry.identifier)
        }
        if failure == .local {
          postponeInMemory(of: entry.identifier)
        }
        if next.state != .pending {
          didChangeState = true
        }
      }
    }

    if !due.isEmpty, await walletKitController.fetchFailedDeferredDocumentIds() != failedBefore {
      didChangeState = true
    }

    if didIssue {
      await checkRevocationAfterDeferredReIssue()
    }

    if didIssue || didChangeState {
      await notifyDocumentTabListener()
    }
  }

  /// Never less than `minimumWait` and never more than `maximumWait`. nil when no deferred document is pending, or
  /// the wallet is locked or in the background. After the last check couldn't read or sync the entries, or this read
  /// fails, waits `failureWait`. A document the wallet itself failed on, or whose request was held back, waits its
  /// `localRetryAt` too. An entry kept without its document (see `reconcile`) is never due, so it is left out.
  func delayUntilNextCheck() async -> TimeInterval? {
    guard sessionStatusProvider.isActive else { return nil }
    guard !didLastCheckFailLocally else { return min(schedule.failureWait, Self.maximumWait) }
    let entries: [DeferredIssuance]
    do {
      entries = try await storageController.retrieveAllEntries()
    } catch {
      return min(schedule.failureWait, Self.maximumWait)
    }
    let deferredIds = Set(await walletKitController.fetchDeferredDocuments().map(\.id))
    guard
      let next = entries
        .filter({ $0.state == .pending && deferredIds.contains($0.identifier) })
        .map(dueAt)
        .min()
    else {
      return nil
    }
    let delay = max(next.timeIntervalSince(now()), Self.minimumWait)
    return min(delay, Self.maximumWait)
  }
}

private extension DeferredIssuanceWorkManagerImpl {

  func dueAt(_ entry: DeferredIssuance) -> Date {
    max(entry.nextAttemptAt, localRetryAt[entry.identifier] ?? .distantPast)
  }

  /// Waits `failureWait` in this run of the app before the document is asked again: after a failure of the wallet
  /// itself, or a request that an issuance or a deletion held back.
  func postponeInMemory(of id: String) {
    localRetryAt[id] = now().addingTimeInterval(schedule.failureWait)
  }

  /// False once the user has deleted the document or it was issued, so a failed request doesn't write its entry back.
  func isStillDeferred(_ id: String) async -> Bool {
    await walletKitController.fetchDeferredDocuments().contains { $0.id == id }
  }

  func startLoopIfIdle() {
    guard loopTask == nil else { return }
    loopGeneration += 1
    let generation = loopGeneration
    loopTask = Task(priority: .utility) { [weak self] in
      await self?.runLoop(generation: generation)
    }
  }

  /// Checks again after `stop()` has come during the read of the next delay, since a wait started then would outlive
  /// it. After `stop()` and `start()`, `waitTask` may already be the next loop's wait, so only its own is cleared.
  func runLoop(generation: Int) async {
    while isRunning, !Task.isCancelled {
      isWakeRequested = false
      await runCheck()
      guard isRunning, !Task.isCancelled else { break }
      let delay = await delayUntilNextCheck()
      guard isRunning, !Task.isCancelled else { break }
      if isWakeRequested { continue }
      guard let delay else { break }
      let wait = Task { [sleep] in try await sleep(delay) }
      waitTask = wait
      _ = try? await wait.value
      if waitTask == wait {
        waitTask = nil
      }
    }
    if generation == loopGeneration {
      loopTask = nil
    }
  }

  /// Goes through `checkRunner` so `stop()` can wait for it.
  func runCheck() async {
    await checkRunner.run { [weak self] in
      guard let self, await self.isRunning else { return }
      await self.checkDeferredDocuments()
    }
  }

  /// Adds entries for deferred documents that have none, and removes the entries of documents that are issued now.
  /// A document that is simply missing keeps its entry: the documents may not have loaded, and
  /// removing the entries then would lose the issuer's intervals and the failed states. Deleting a document
  /// removes its entry. Returns the entries of the deferred documents.
  func reconcile(
    _ entries: [DeferredIssuance],
    with documents: [WalletStorage.Document]
  ) async throws -> [DeferredIssuance] {
    let deferredIds = Set(documents.map(\.id))
    let enteredIds = Set(entries.map(\.identifier))

    let missing = documents
      .filter { !enteredIds.contains($0.id) }
      .map {
        schedule.pending(
          identifier: $0.id,
          interval: $0.deferredIssuanceInterval,
          at: $0.modifiedAt ?? $0.createdAt
        )
      }

    if !missing.isEmpty {
      try await storageController.store(missing)
    }
    for entry in entries where !deferredIds.contains(entry.identifier) {
      if await walletKitController.fetchDocument(with: entry.identifier) != nil {
        try await storageController.delete(entry.identifier)
      }
    }
    return entries.filter { deferredIds.contains($0.identifier) } + missing
  }

  /// When a re-issue comes back deferred, WalletKit deletes the original right away but the wallet keeps its
  /// revocation record. Once the credential arrives, such a leftover record means the new copy's status should
  /// be read now instead of on the next revocation check.
  func checkRevocationAfterDeferredReIssue() async {
    guard let revocationStatuses = try? await walletKitController.fetchRevokedDocumentStatuses() else { return }
    let remainingIds = Set(await walletKitController.fetchAllDocuments().map(\.id))
    guard let goneId = revocationStatuses.keys.first(where: { !remainingIds.contains($0) }) else { return }
    await revocationWorkManager.checkAfterReIssue(of: goneId)
  }

  @MainActor
  func notifyDocumentTabListener() async {
    NotificationCenter.default.post(
      name: NSNotification.DocumentTabRefresh,
      object: nil,
      userInfo: [:]
    )
  }
}
