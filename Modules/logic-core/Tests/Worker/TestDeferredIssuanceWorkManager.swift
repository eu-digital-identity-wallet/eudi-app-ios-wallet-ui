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
import os
import UIKit
import WalletStorage
import logic_storage
import enum OpenID4VCI.CredentialIssuanceError
import enum OpenID4VCI.PostError
@testable import logic_business
@testable import logic_core
@testable import logic_test

final class TestDeferredIssuanceWorkManager: EudiTest {

  private let startDate = Date(timeIntervalSince1970: 100_000)

  private var walletKitController: MockWalletKitController!
  private var revocationWorkManager: MockRevocationWorkManager!
  private var storage: StubDeferredIssuanceStorageController!
  private var clock: TestClock!
  private var sessionStatus: WalletSessionStatusProviderImpl!
  private var workManager: DeferredIssuanceWorkManagerImpl!

  override func setUp() {
    super.setUp()
    walletKitController = MockWalletKitController()
    revocationWorkManager = MockRevocationWorkManager()
    storage = StubDeferredIssuanceStorageController()
    clock = TestClock(startDate)
    sessionStatus = WalletSessionStatusProviderImpl()
    sessionStatus.update(isUnlocked: true, isInForeground: true)
    workManager = makeManager()
    stub(walletKitController) { mock in
      when(mock.fetchDeferredDocuments()).thenReturn([])
      when(mock.fetchDocument(with: any())).thenReturn(nil)
      when(mock.fetchRevokedDocumentStatuses()).thenReturn([:])
      when(mock.fetchAllDocuments()).thenReturn([])
      when(mock.deleteDocument(with: any(), status: any())).thenDoNothing()
      when(mock.fetchFailedDeferredDocumentIds()).thenReturn([])
    }
    stub(revocationWorkManager) { mock in
      when(mock.checkAfterReIssue(of: any())).thenDoNothing()
    }
  }

  override func tearDown() {
    workManager = nil
    sessionStatus = nil
    clock = nil
    storage = nil
    revocationWorkManager = nil
    walletKitController = nil
    super.tearDown()
  }

  // MARK: - A check

  func testCheck_WhenAnEntryIsDue_ThenAsksItsIssuerOnce() async {
    await givenDeferred(["a"], entries: [entry("a", dueIn: -10)])
    stubRequest { document in deferredDocument(document.id) }

    await workManager.checkDeferredDocuments()

    verify(walletKitController, times(1)).requestDeferredIssuance(with: document("a"))
  }

  func testCheck_WhenAnEntryIsNotDueYet_ThenDoesNotAsk() async {
    await givenDeferred(["a"], entries: [entry("a", dueIn: 60)])

    await workManager.checkDeferredDocuments()

    verify(walletKitController, never()).requestDeferredIssuance(with: any())
  }

  func testCheck_WhenAnEntryFailed_ThenDoesNotAskAgain() async {
    await givenDeferred(["a"], entries: [entry("a", dueIn: -10, state: .failed)])

    await workManager.checkDeferredDocuments()

    verify(walletKitController, never()).requestDeferredIssuance(with: any())
  }

  func testCheck_WhenTheIssuerIsNotReady_ThenLeavesTheEntryToTheController() async {
    let due = entry("a", dueIn: -10, interval: 60)
    await givenDeferred(["a"], entries: [due])
    stubRequest { document in deferredDocument(document.id) }

    await workManager.checkDeferredDocuments()

    let stored = await storage.entries["a"]
    XCTAssertEqual(stored, due)
  }

  func testCheck_WhenTheRequestFails_ThenAsksAgainAfterTheFailureRetryDelayAndKeepsTheInterval() async {
    await givenDeferred(["a"], entries: [entry("a", dueIn: -10, interval: 42)])
    stubRequest { _ in throw URLError(.timedOut) }

    await workManager.checkDeferredDocuments()

    let stored = await storage.entries["a"]
    XCTAssertEqual(
      stored,
      DeferredIssuance(
        identifier: "a",
        nextAttemptAt: startDate.addingTimeInterval(30),
        interval: 42,
        state: .pending
      )
    )
  }

  func testCheck_WhenTheRequestFails_ThenAsksAgainAfterTheConfiguredFailureRetryDelay() async {
    workManager = makeManager(config: DeferredIssuanceConfig(initialPollingDelay: 5, failureRetryDelay: 45))
    await givenDeferred(["a"], entries: [entry("a", dueIn: -10)])
    stubRequest { _ in throw URLError(.timedOut) }

    await workManager.checkDeferredDocuments()

    let stored = await storage.entries["a"]
    XCTAssertEqual(stored?.nextAttemptAt, startDate.addingTimeInterval(45))
  }

  func testCheck_WhenTheIssuerRefuses_ThenKeepsAskingAfterTheFailureRetryDelay() async {
    await givenDeferred(["a"], entries: [entry("a", dueIn: -10)])
    stubRequest { _ in throw CredentialIssuanceError.invalidTransactionId }

    await workManager.checkDeferredDocuments()

    let stored = await storage.entries["a"]
    XCTAssertEqual(stored?.state, .pending)
    XCTAssertEqual(stored?.nextAttemptAt, startDate.addingTimeInterval(30))
  }

  func testCheck_WhenTheIssuerRejectsTheAccessToken_ThenMarksTheEntryFailedKeepsTheDocumentAndRefreshesTheList() async {
    await givenDeferred(["a"], entries: [entry("a", dueIn: -10)])
    stubRequest { _ in throw CredentialIssuanceError.invalidToken }
    let refreshed = expectation(forNotification: NSNotification.DocumentTabRefresh, object: nil)

    await workManager.checkDeferredDocuments()

    let stored = await storage.entries["a"]
    XCTAssertEqual(stored?.state, .failed)
    verify(walletKitController, never()).deleteDocument(with: any(), status: any())
    await fulfillment(of: [refreshed], timeout: 2)
  }

  func testCheck_WhenTheTransactionHasExpired_ThenItIsNotAskedAgain() async {
    await givenDeferred(["a"], entries: [entry("a", dueIn: -10)])
    stubRequest { _ in throw CredentialIssuanceError.invalidToken }
    await workManager.checkDeferredDocuments()
    clock.advance(by: 3600)

    await workManager.checkDeferredDocuments()

    verify(walletKitController, times(1)).requestDeferredIssuance(with: any())
  }

  func testCheck_WhenAFailureMakesADocumentShowAsFailed_ThenRefreshesTheList() async {
    await givenDeferred(["a"], entries: [entry("a", dueIn: -10)])
    stubRequest { _ in throw URLError(.timedOut) }
    stub(walletKitController) { mock in
      when(mock.fetchFailedDeferredDocumentIds()).thenReturn([], ["a"])
    }
    let refreshed = expectation(forNotification: NSNotification.DocumentTabRefresh, object: nil)

    await workManager.checkDeferredDocuments()

    await fulfillment(of: [refreshed], timeout: 2)
  }

  func testCheck_WhenAStillPendingAnswerClearsTheFailure_ThenRefreshesTheList() async {
    await givenDeferred(["a"], entries: [entry("a", dueIn: -10)])
    stubRequest { document in deferredDocument(document.id) }
    stub(walletKitController) { mock in
      when(mock.fetchFailedDeferredDocumentIds()).thenReturn(["a"], [])
    }
    let refreshed = expectation(forNotification: NSNotification.DocumentTabRefresh, object: nil)

    await workManager.checkDeferredDocuments()

    await fulfillment(of: [refreshed], timeout: 2)
  }

  func testCheck_WhenADocumentAlreadyShowsAsFailedAndFailsAgain_ThenLeavesTheListAlone() async {
    await givenDeferred(["a"], entries: [entry("a", dueIn: -10)])
    stubRequest { _ in throw URLError(.timedOut) }
    stub(walletKitController) { mock in
      when(mock.fetchFailedDeferredDocumentIds()).thenReturn(["a"])
    }
    let refreshed = expectation(forNotification: NSNotification.DocumentTabRefresh, object: nil)
    refreshed.isInverted = true

    await workManager.checkDeferredDocuments()

    await fulfillment(of: [refreshed], timeout: 0.5)
  }

  func testCheck_WhenTheIssuerCannotBeVerified_ThenMarksTheEntryUntrustedAndRefreshesTheList() async {
    await givenDeferred(["a"], entries: [entry("a", dueIn: -10)])
    stubRequest { _ in throw WalletError(description: "not trusted", code: .trustError) }
    let refreshed = expectation(forNotification: NSNotification.DocumentTabRefresh, object: nil)

    await workManager.checkDeferredDocuments()

    let stored = await storage.entries["a"]
    XCTAssertEqual(stored?.state, .untrusted)
    await fulfillment(of: [refreshed], timeout: 2)
  }

  func testCheck_WhenTheIssuerCannotBeVerified_ThenDeletesTheDocument() async {
    await givenDeferred(["a"], entries: [entry("a", dueIn: -10)])
    stubRequest { _ in throw WalletError(description: "not trusted", code: .trustError) }

    await workManager.checkDeferredDocuments()

    verify(walletKitController, times(1)).deleteDocument(with: "a", status: equal(to: .deferred))
  }

  func testCheck_WhenTheIssuerRefuses_ThenKeepsTheDocument() async {
    await givenDeferred(["a"], entries: [entry("a", dueIn: -10)])
    stubRequest { _ in throw CredentialIssuanceError.invalidTransactionId }

    await workManager.checkDeferredDocuments()

    verify(walletKitController, never()).deleteDocument(with: any(), status: any())
  }

  func testCheck_WhenDeletingAnUntrustedDocumentFails_ThenKeepsItUntrustedAndDoesNotTryAgainThisRun() async {
    await givenDeferred(["a"], entries: [entry("a", dueIn: -10)])
    stubRequest { _ in throw WalletError(description: "not trusted", code: .trustError) }
    stub(walletKitController) { mock in
      when(mock.deleteDocument(with: any(), status: any())).thenThrow(RuntimeError.genericError)
    }

    await workManager.checkDeferredDocuments()
    await workManager.checkDeferredDocuments()

    let stored = await storage.entries["a"]
    XCTAssertEqual(stored?.state, .untrusted)
    verify(walletKitController, times(1)).deleteDocument(with: "a", status: equal(to: .deferred))
  }

  func testCheck_WhenTheAppOpensWithAnUntrustedDocumentLeft_ThenTriesToDeleteItOnceAndRefreshesTheList() async {
    await givenDeferred(["a"], entries: [entry("a", dueIn: -10, state: .untrusted)])
    let refreshed = expectation(forNotification: NSNotification.DocumentTabRefresh, object: nil)

    await workManager.checkDeferredDocuments()
    await workManager.checkDeferredDocuments()

    verify(walletKitController, never()).requestDeferredIssuance(with: any())
    verify(walletKitController, times(1)).deleteDocument(with: "a", status: equal(to: .deferred))
    await fulfillment(of: [refreshed], timeout: 2)
  }

  func testCheck_WhenTheWalletIsLocked_ThenDoesNotDeleteAnUntrustedDocument() async {
    await givenDeferred(["a"], entries: [entry("a", dueIn: -10, state: .untrusted)])
    sessionStatus.update(isUnlocked: false, isInForeground: true)

    await workManager.checkDeferredDocuments()

    verify(walletKitController, never()).deleteDocument(with: any(), status: any())
  }

  func testCheck_WhenAnEntryIsUntrusted_ThenItIsNotAskedAgain() async {
    await givenDeferred(["a"], entries: [entry("a", dueIn: -10)])
    stubRequest { _ in throw WalletError(description: "not trusted", code: .trustError) }
    await workManager.checkDeferredDocuments()
    clock.advance(by: 3600)

    await workManager.checkDeferredDocuments()

    verify(walletKitController, times(1)).requestDeferredIssuance(with: any())
  }

  func testCheck_WhenTheRequestKeepsFailing_ThenKeepsAskingEveryFailureRetryDelay() async {
    await givenDeferred(["a"], entries: [entry("a", dueIn: -10, interval: 10)])
    stubRequest { _ in throw URLError(.timedOut) }

    for _ in 0..<10 {
      await workManager.checkDeferredDocuments()
      clock.advance(by: 30)
    }

    let stored = await storage.entries["a"]
    XCTAssertEqual(stored?.state, .pending)
    verify(walletKitController, times(10)).requestDeferredIssuance(with: any())
  }

  func testCheck_WhenTheDeviceIsOffline_ThenKeepsAskingAfterTheFailureRetryDelay() async {
    await givenDeferred(["a"], entries: [entry("a", dueIn: -10, interval: 10)])
    stubRequest { _ in throw PostError.networkError(URLError(.notConnectedToInternet)) }

    await workManager.checkDeferredDocuments()

    let stored = await storage.entries["a"]
    XCTAssertEqual(stored?.state, .pending)
    XCTAssertEqual(stored?.nextAttemptAt, startDate.addingTimeInterval(30))
  }

  func testCheck_WhenTheDocumentIsDeletedWhileItIsRequested_ThenRecordsNoFailureAndLeavesTheListAlone() async {
    let due = entry("a", dueIn: -10)
    await givenDeferred(["a"], entries: [due])
    stubRequest { _ in throw DeferredDocumentDeletedError() }
    let refreshed = expectation(forNotification: NSNotification.DocumentTabRefresh, object: nil)
    refreshed.isInverted = true

    await workManager.checkDeferredDocuments()

    let stored = await storage.entries["a"]
    XCTAssertEqual(stored, due)
    await fulfillment(of: [refreshed], timeout: 0.5)
  }

  func testCheck_WhenTheCredentialIsIssued_ThenRefreshesTheList() async {
    await givenDeferred(["a"], entries: [entry("a", dueIn: -10)])
    stubRequest { _ in StubDocument.make(id: "issued-a", displayName: "PID") }
    let refreshed = expectation(forNotification: NSNotification.DocumentTabRefresh, object: nil)

    await workManager.checkDeferredDocuments()

    await fulfillment(of: [refreshed], timeout: 2)
  }

  func testCheck_WhenNothingIsSettled_ThenLeavesTheListAlone() async {
    await givenDeferred(["a"], entries: [entry("a", dueIn: -10)])
    stubRequest { document in deferredDocument(document.id) }
    let refreshed = expectation(forNotification: NSNotification.DocumentTabRefresh, object: nil)
    refreshed.isInverted = true

    await workManager.checkDeferredDocuments()

    await fulfillment(of: [refreshed], timeout: 0.5)
  }

  func testCheck_WhenSeveralAreDue_ThenAsksTheLongestDueFirst() async {
    await givenDeferred(
      ["a", "b", "c"],
      entries: [entry("a", dueIn: -10), entry("b", dueIn: -300), entry("c", dueIn: -60)]
    )
    let asked = OSAllocatedUnfairLock<[String]>(initialState: [])
    stubRequest { document in
      asked.withLock { $0.append(document.id) }
      return deferredDocument(document.id)
    }

    await workManager.checkDeferredDocuments()

    XCTAssertEqual(asked.withLock { $0 }, ["b", "c", "a"])
  }

  func testCheck_WhenADeferredDocumentHasNoEntry_ThenGivesItOneFromWhenItWasDeferred() async {
    stub(walletKitController) { mock in
      when(mock.fetchDeferredDocuments()).thenReturn([
        storedDocument("old", modifiedAt: startDate.addingTimeInterval(-3_600)),
        storedDocument("new", modifiedAt: startDate)
      ])
    }
    stubRequest { document in deferredDocument(document.id) }

    await workManager.checkDeferredDocuments()

    let entries = await storage.entries
    XCTAssertEqual(entries["old"]?.nextAttemptAt, startDate.addingTimeInterval(-3_595))
    XCTAssertEqual(entries["new"]?.nextAttemptAt, startDate.addingTimeInterval(5))
    verify(walletKitController, times(1)).requestDeferredIssuance(with: document("old"))
    verify(walletKitController, never()).requestDeferredIssuance(with: document("new"))
  }

  func testCheck_WhenAnEntrysDocumentIsIssued_ThenRemovesTheEntry() async {
    await givenDeferred(["a"], entries: [entry("a", dueIn: 60), entry("issued", dueIn: -10)])
    stub(walletKitController) { mock in
      when(mock.fetchDocument(with: "issued")).thenReturn(StubDocument.make(id: "issued"))
    }

    await workManager.checkDeferredDocuments()

    let entries = await storage.entries
    XCTAssertEqual(Set(entries.keys), ["a"])
    verify(walletKitController, never()).requestDeferredIssuance(with: any())
  }

  func testCheck_WhenAnEntrysDocumentIsMissing_ThenKeepsTheEntryAndAsksNothing() async {
    let kept = entry("missing", dueIn: -10, interval: 600)
    await givenDeferred(["a"], entries: [entry("a", dueIn: 60), kept])

    await workManager.checkDeferredDocuments()

    let entries = await storage.entries
    XCTAssertEqual(Set(entries.keys), ["a", "missing"])
    XCTAssertEqual(entries["missing"], kept)
    verify(walletKitController, never()).requestDeferredIssuance(with: any())
  }

  func testCheck_WhenNoDocumentHasLoaded_ThenKeepsEveryEntry() async {
    let pending = entry("a", dueIn: -10, interval: 600)
    let failed = entry("b", dueIn: -10, state: .failed)
    await givenDeferred([], entries: [pending, failed])

    await workManager.checkDeferredDocuments()

    let entries = await storage.entries
    XCTAssertEqual(entries["a"], pending)
    XCTAssertEqual(entries["b"], failed)
    verify(walletKitController, never()).requestDeferredIssuance(with: any())
  }

  func testCheck_WhenAMissingDocumentHasLoadedAgain_ThenAsksWithItsKeptEntry() async {
    let kept = entry("a", dueIn: -10, interval: 600)
    await givenDeferred([], entries: [kept])
    await workManager.checkDeferredDocuments()
    let loaded = [storedDocument("a", modifiedAt: startDate)]
    stub(walletKitController) { mock in
      when(mock.fetchDeferredDocuments()).thenReturn(loaded)
    }
    stubRequest { _ in throw URLError(.timedOut) }

    await workManager.checkDeferredDocuments()

    let stored = await storage.entries["a"]
    XCTAssertEqual(stored?.nextAttemptAt, startDate.addingTimeInterval(30))
    XCTAssertEqual(stored?.interval, 600)
  }

  func testCheck_WhenTheEntriesCannotBeRead_ThenAsksNothing() async {
    await givenDeferred(["a"], entries: [entry("a", dueIn: -10)])
    await storage.setFailsReads(true)

    await workManager.checkDeferredDocuments()

    verify(walletKitController, never()).requestDeferredIssuance(with: any())
  }

  func testCheck_WhenTheReIssuedOriginalWasRevoked_ThenRunsTheRevocationCheckOnceIssued() async {
    await givenDeferred(["a"], entries: [entry("a", dueIn: -10)])
    stub(walletKitController) { mock in
      when(mock.fetchRevokedDocumentStatuses()).thenReturn(["original": .revoked])
      when(mock.fetchAllDocuments()).thenReturn([StubDocument.make(id: "a")])
    }
    stubRequest { _ in StubDocument.make(id: "a") }

    await workManager.checkDeferredDocuments()

    verify(revocationWorkManager).checkAfterReIssue(of: equal(to: "original"))
  }

  func testCheck_WhenTheReIssuedOriginalWasRevokedButTheIssuerIsNotReady_ThenRunsNoRevocationCheck() async {
    await givenDeferred(["a"], entries: [entry("a", dueIn: -10)])
    stub(walletKitController) { mock in
      when(mock.fetchRevokedDocumentStatuses()).thenReturn(["original": .revoked])
      when(mock.fetchAllDocuments()).thenReturn([deferredDocument("a")])
    }
    stubRequest { document in deferredDocument(document.id) }

    await workManager.checkDeferredDocuments()

    verify(revocationWorkManager, never()).checkAfterReIssue(of: any())
  }

  func testCheck_WhenEveryRevokedDocumentIsStillThere_ThenRunsNoRevocationCheck() async {
    await givenDeferred(["a"], entries: [entry("a", dueIn: -10)])
    stub(walletKitController) { mock in
      when(mock.fetchRevokedDocumentStatuses()).thenReturn(["kept": .revoked])
      when(mock.fetchAllDocuments()).thenReturn([StubDocument.make(id: "a"), StubDocument.make(id: "kept")])
    }
    stubRequest { _ in StubDocument.make(id: "a") }

    await workManager.checkDeferredDocuments()

    verify(revocationWorkManager, never()).checkAfterReIssue(of: any())
  }

  func testCheck_WhenTheRevocationRecordsCannotBeRead_ThenStillRefreshesTheList() async {
    await givenDeferred(["a"], entries: [entry("a", dueIn: -10)])
    stub(walletKitController) { mock in
      when(mock.fetchRevokedDocumentStatuses()).thenThrow(RuntimeError.genericError)
    }
    stubRequest { _ in StubDocument.make(id: "a", displayName: "PID") }
    let refreshed = expectation(forNotification: NSNotification.DocumentTabRefresh, object: nil)

    await workManager.checkDeferredDocuments()

    await fulfillment(of: [refreshed], timeout: 2)
    verify(revocationWorkManager, never()).checkAfterReIssue(of: any())
  }

  func testCheck_WhenTheCheckIsCancelled_ThenRecordsNoFailure() async {
    let due = entry("a", dueIn: -10)
    await givenDeferred(["a", "b"], entries: [due, entry("b", dueIn: -5)])
    stubRequest { _ in
      withUnsafeCurrentTask { $0?.cancel() }
      throw CancellationError()
    }
    let manager = workManager!

    await Task { await manager.checkDeferredDocuments() }.value

    let entries = await storage.entries
    XCTAssertEqual(entries["a"], due)
    verify(walletKitController, times(1)).requestDeferredIssuance(with: any())
  }

  // MARK: - The wait

  func testDelayUntilNextCheck_ThenWaitsForTheEarliestPendingEntry() async {
    await givenDeferred(["a", "b", "c"], entries: [
      entry("a", dueIn: 100),
      entry("b", dueIn: 40),
      entry("c", dueIn: 1, state: .failed)
    ])

    let delay = await workManager.delayUntilNextCheck()

    XCTAssertEqual(delay, 40)
  }

  func testDelayUntilNextCheck_WhenAnEntryIsOverdue_ThenChecksAgainAtOnce() async {
    await givenDeferred(["a"], entries: [entry("a", dueIn: -100)])

    let delay = await workManager.delayUntilNextCheck()

    XCTAssertEqual(delay, DeferredIssuanceWorkManagerImpl.minimumWait)
  }

  func testDelayUntilNextCheck_WhenTheNextEntryIsDueInMoreThanAnHour_ThenWaitsAnHour() async {
    await givenDeferred(["a"], entries: [entry("a", dueIn: 3 * 24 * 3_600)])

    let delay = await workManager.delayUntilNextCheck()

    XCTAssertEqual(delay, 3_600)
  }

  func testDelayUntilNextCheck_WhenAnOverdueEntryHasNoDocument_ThenWaitsOnlyForTheDeferredOnes() async {
    await givenDeferred(["a"], entries: [entry("a", dueIn: 100), entry("missing", dueIn: -100)])

    let delay = await workManager.delayUntilNextCheck()

    XCTAssertEqual(delay, 100)
  }

  func testDelayUntilNextCheck_WhenNoEntryHasADocument_ThenThereIsNoNextCheck() async {
    await givenDeferred([], entries: [entry("a", dueIn: -100)])

    let delay = await workManager.delayUntilNextCheck()

    XCTAssertNil(delay)
  }

  func testDelayUntilNextCheck_WhenNoEntryIsPending_ThenThereIsNoNextCheck() async {
    await givenDeferred(["a"], entries: [entry("a", dueIn: 10, state: .failed)])

    let delay = await workManager.delayUntilNextCheck()

    XCTAssertNil(delay)
  }

  func testDelayUntilNextCheck_WhenTheEntriesCannotBeRead_ThenReadsAgainAfterTheFailureRetryDelay() async {
    await storage.setFailsReads(true)

    let delay = await workManager.delayUntilNextCheck()

    XCTAssertEqual(delay, 30)
  }

  func testDelayUntilNextCheck_WhenTheEntriesCannotBeRead_ThenReadsAgainAfterTheConfiguredFailureRetryDelay() async {
    workManager = makeManager(config: DeferredIssuanceConfig(initialPollingDelay: 5, failureRetryDelay: 45))
    await storage.setFailsReads(true)

    let delay = await workManager.delayUntilNextCheck()

    XCTAssertEqual(delay, 45)
  }

  func testDelayUntilNextCheck_WhenTheLastCheckCouldNotSyncTheEntries_ThenWaitsTheFailureRetryDelay() async {
    await givenDeferred(["a"], entries: [])
    await storage.setFailsWrites(true)
    await workManager.checkDeferredDocuments()
    await storage.setFailsWrites(false)

    let delay = await workManager.delayUntilNextCheck()

    XCTAssertEqual(delay, 30)
    verify(walletKitController, never()).requestDeferredIssuance(with: any())
  }

  func testCheck_WhenTheWalletItselfFails_ThenLeavesTheEntryAndDoesNotShowItFailed() async {
    let due = entry("a", dueIn: -10, interval: 60)
    await givenDeferred(["a"], entries: [due])
    stubRequest { _ in throw WalletCoreError.missingMetadata }
    let refreshed = expectation(forNotification: NSNotification.DocumentTabRefresh, object: nil)
    refreshed.isInverted = true

    await workManager.checkDeferredDocuments()

    let stored = await storage.entries["a"]
    XCTAssertEqual(stored, due)
    await fulfillment(of: [refreshed], timeout: 0.5)
  }

  func testCheck_WhenTheWalletItselfFails_ThenAsksAgainOnlyAfterTheFailureRetryDelayInThisRun() async {
    await givenDeferred(["a"], entries: [entry("a", dueIn: -10)])
    stubRequest { _ in throw WalletCoreError.missingMetadata }
    await workManager.checkDeferredDocuments()

    clock.advance(by: 29)
    await workManager.checkDeferredDocuments()
    let delay = await workManager.delayUntilNextCheck()
    clock.advance(by: 1)
    await workManager.checkDeferredDocuments()

    XCTAssertEqual(delay, 1)
    verify(walletKitController, times(2)).requestDeferredIssuance(with: any())
  }

  func testCheck_WhenTheAppOpensAfterTheWalletItselfFailed_ThenAsksWhenTheEntrySays() async {
    await givenDeferred(["a"], entries: [entry("a", dueIn: -10)])
    stubRequest { _ in throw WalletCoreError.missingMetadata }
    await workManager.checkDeferredDocuments()
    workManager = makeManager()

    await workManager.checkDeferredDocuments()

    verify(walletKitController, times(2)).requestDeferredIssuance(with: any())
  }

  func testCheck_WhenTheFailureCannotBeStored_ThenAsksAgainOnlyAfterTheFailureRetryDelayInThisRun() async {
    await givenDeferred(["a"], entries: [entry("a", dueIn: -10)])
    stubRequest { _ in
      throw URLError(.timedOut)
    }
    await storage.setFailsWrites(true)
    await workManager.checkDeferredDocuments()

    clock.advance(by: 10)
    await workManager.checkDeferredDocuments()
    let delay = await workManager.delayUntilNextCheck()

    XCTAssertEqual(delay, 20)
    verify(walletKitController, times(1)).requestDeferredIssuance(with: any())
  }


  func testCheck_WhenTheWalletIsLocked_ThenAsksNothing() async {
    sessionStatus.update(isUnlocked: false, isInForeground: true)
    let due = entry("a", dueIn: -10)
    await givenDeferred(["a"], entries: [due])
    stubRequest { _ in
      XCTFail("Asked while locked")
      throw URLError(.timedOut)
    }

    await workManager.checkDeferredDocuments()

    let stored = await storage.entries["a"]
    XCTAssertEqual(stored, due)
  }

  func testCheck_WhenTheAppIsInTheBackground_ThenAsksNothing() async {
    sessionStatus.update(isUnlocked: true, isInForeground: false)
    await givenDeferred(["a"], entries: [entry("a", dueIn: -10)])
    stubRequest { _ in
      XCTFail("Asked in the background")
      throw URLError(.timedOut)
    }

    await workManager.checkDeferredDocuments()
  }

  func testCheck_WhenTheWalletLocksDuringARequest_ThenFinishesItButAsksForNoOtherDocument() async {
    await givenDeferred(["a", "b"], entries: [entry("a", dueIn: -20), entry("b", dueIn: -10)])
    let sessionStatus = sessionStatus!
    let asked = OSAllocatedUnfairLock<[String]>(initialState: [])
    stubRequest { document in
      asked.withLock { $0.append(document.id) }
      sessionStatus.update(isUnlocked: false, isInForeground: true)
      throw URLError(.timedOut)
    }

    await workManager.checkDeferredDocuments()

    XCTAssertEqual(asked.withLock { $0 }, ["a"])
    let first = await storage.entries["a"]
    XCTAssertEqual(first?.nextAttemptAt, startDate.addingTimeInterval(30))
  }

  func testDelayUntilNextCheck_WhenTheWalletIsLocked_ThenThereIsNoNextCheck() async {
    sessionStatus.update(isUnlocked: false, isInForeground: true)
    await givenDeferred(["a"], entries: [entry("a", dueIn: 60)])

    let delay = await workManager.delayUntilNextCheck()

    XCTAssertNil(delay)
  }

  // MARK: - Starting, waking and stopping

  func testStart_WhenAnEntryIsOverdue_ThenAsksAtOnce() async {
    await givenDeferred(["a"], entries: [entry("a", dueIn: -3_600)])
    let asked = expectation(description: "asked")
    stubRequest { _ in
      asked.fulfill()
      throw URLError(.timedOut)
    }

    await workManager.start()

    await fulfillment(of: [asked], timeout: 2)
    await workManager.stop()
  }

  func testStart_WhenTheIssuerAsksForMoreThanAnHour_ThenAsksOnlyOnceItIsDue() async {
    await givenDeferred(["a"], entries: [entry("a", dueIn: 5_400)])
    let delays = OSAllocatedUnfairLock<[TimeInterval]>(initialState: [])
    let blocked = expectation(description: "blocked")
    workManager = makeManager(passingWaits: 2, recordingIn: delays, blocked: blocked)
    let clock = clock!
    let askedAt = OSAllocatedUnfairLock<Date?>(initialState: nil)
    stubRequest { _ in
      askedAt.withLock { $0 = clock.now }
      throw URLError(.timedOut)
    }

    await workManager.start()
    await fulfillment(of: [blocked], timeout: 2)
    await workManager.stop()

    XCTAssertEqual(delays.withLock { $0 }, [3_600, 1_800, 30])
    XCTAssertEqual(askedAt.withLock { $0 }, startDate.addingTimeInterval(5_400))
    verify(walletKitController, times(1)).requestDeferredIssuance(with: any())
  }

  func testStart_WhenTheIssuerSentAHugeInterval_ThenWaitsAnHourAtATimeWithoutAsking() async {
    let farOff = DeferredIssuanceSchedule(config: .stub).pending(identifier: "a", interval: 1e12, at: startDate)
    await givenDeferred(["a"], entries: [farOff])
    let delays = OSAllocatedUnfairLock<[TimeInterval]>(initialState: [])
    let blocked = expectation(description: "blocked")
    workManager = makeManager(passingWaits: 2, recordingIn: delays, blocked: blocked)
    stubRequest { document in deferredDocument(document.id) }

    await workManager.start()
    await fulfillment(of: [blocked], timeout: 2)
    await workManager.stop()

    XCTAssertEqual(delays.withLock { $0 }, [3_600, 3_600, 3_600])
    verify(walletKitController, never()).requestDeferredIssuance(with: any())
    let entries = await storage.entries
    XCTAssertEqual(entries["a"], farOff)
  }

  func testWake_WhenIdle_ThenChecksTheEntryAddedMeanwhile() async {
    await workManager.start()
    await waitUntilIdle()
    await givenDeferred(["a"], entries: [entry("a", dueIn: -1)])
    let asked = expectation(description: "asked")
    stubRequest { _ in
      asked.fulfill()
      throw URLError(.timedOut)
    }

    await workManager.wake()

    await fulfillment(of: [asked], timeout: 2)
    await workManager.stop()
  }

  func testWake_WhenWaitingForALaterEntry_ThenChecksAgainAtOnce() async {
    await givenDeferred(["a"], entries: [entry("a", dueIn: 3_600)])
    let waiting = expectation(description: "waiting")
    waiting.assertForOverFulfill = false
    workManager = makeManager(sleep: { _ in
      waiting.fulfill()
      try await Task.sleep(nanoseconds: 60_000_000_000)
    })
    let asked = expectation(description: "asked")
    stubRequest { _ in
      asked.fulfill()
      throw URLError(.timedOut)
    }
    await workManager.start()
    await fulfillment(of: [waiting], timeout: 2)

    clock.advance(by: 3_600)
    await workManager.wake()

    await fulfillment(of: [asked], timeout: 2)
    await workManager.stop()
  }

  func testStart_WhenADocumentIsEnteredLater_ThenChecksIt() async {
    await workManager.start()
    await waitUntilIdle()
    await givenDeferred(["a"], entries: [entry("a", dueIn: -1)])
    let asked = expectation(description: "asked")
    stubRequest { _ in
      asked.fulfill()
      throw URLError(.timedOut)
    }

    NotificationCenter.default.post(name: .deferredIssuanceEntered, object: nil)

    await fulfillment(of: [asked], timeout: 2)
    await workManager.stop()
  }

  func testStop_ThenAnEnteredDocumentAsksNothing() async {
    await workManager.start()
    await workManager.stop()
    await givenDeferred(["a"], entries: [entry("a", dueIn: -1)])
    let asked = expectation(description: "asked")
    asked.isInverted = true
    stubRequest { _ in
      asked.fulfill()
      throw URLError(.timedOut)
    }

    NotificationCenter.default.post(name: .deferredIssuanceEntered, object: nil)

    await fulfillment(of: [asked], timeout: 0.5)
  }

  func testStart_WhenTheWalletIsActiveAgainAfterAnEntryFellDue_ThenChecksAtOnce() async {
    await givenDeferred(["a"], entries: [entry("a", dueIn: 3_600)])
    let waiting = expectation(description: "waiting")
    waiting.assertForOverFulfill = false
    workManager = makeManager(sleep: { _ in
      waiting.fulfill()
      try await Task.sleep(nanoseconds: 60_000_000_000)
    })
    let asked = expectation(description: "asked")
    stubRequest { _ in
      asked.fulfill()
      throw URLError(.timedOut)
    }
    await workManager.start()
    await fulfillment(of: [waiting], timeout: 2)

    sessionStatus.update(isUnlocked: true, isInForeground: false)
    clock.advance(by: 3_600)
    sessionStatus.update(isUnlocked: true, isInForeground: true)

    await fulfillment(of: [asked], timeout: 2)
    await workManager.stop()
  }

  func testStop_ThenTheWalletTurningActiveAsksNothing() async {
    await workManager.start()
    await workManager.stop()
    await givenDeferred(["a"], entries: [entry("a", dueIn: -1)])
    let asked = expectation(description: "asked")
    asked.isInverted = true
    stubRequest { _ in
      asked.fulfill()
      throw URLError(.timedOut)
    }

    sessionStatus.update(isUnlocked: false, isInForeground: true)
    sessionStatus.update(isUnlocked: true, isInForeground: true)

    await fulfillment(of: [asked], timeout: 0.5)
  }

  func testStart_WhenTheWalletIsUnlockedLater_ThenChecksAtOnce() async {
    sessionStatus.update(isUnlocked: false, isInForeground: true)
    await givenDeferred(["a"], entries: [entry("a", dueIn: -1)])
    let asked = expectation(description: "asked")
    stubRequest { _ in
      asked.fulfill()
      throw URLError(.timedOut)
    }
    await workManager.start()
    await waitUntilIdle()

    sessionStatus.update(isUnlocked: true, isInForeground: true)

    await fulfillment(of: [asked], timeout: 2)
    await workManager.stop()
  }

  func testStop_ThenWakeAsksNothing() async {
    await workManager.start()
    await workManager.stop()
    await givenDeferred(["a"], entries: [entry("a", dueIn: -1)])
    let asked = expectation(description: "asked")
    asked.isInverted = true
    stubRequest { _ in
      asked.fulfill()
      throw URLError(.timedOut)
    }

    await workManager.wake()

    await fulfillment(of: [asked], timeout: 0.5)
  }

  func testStop_WhenACheckIsUnderWay_ThenReturnsOnceItHasFinished() async {
    let runner = SerialCheckRunner()
    let manager = makeManager(checkRunner: runner)
    let gate = AsyncGate()
    let started = expectation(description: "started")
    let underWay = Task {
      await runner.run {
        started.fulfill()
        await gate.wait()
      }
    }
    await fulfillment(of: [started], timeout: 5)
    let stoppedEarly = expectation(description: "stopped while it ran")
    stoppedEarly.isInverted = true

    let stopping = Task {
      await manager.stop()
      stoppedEarly.fulfill()
    }

    await fulfillment(of: [stoppedEarly], timeout: 0.5)
    await gate.open()
    await stopping.value
    await underWay.value
  }

  func testStop_WhenTheLoopIsReadingTheEntries_ThenStartsNoWait() async {
    await givenDeferred(["a"], entries: [entry("a", dueIn: 3_600)])
    let gate = AsyncGate()
    let reading = expectation(description: "reading the entries for the wait")
    // The check reads the entries first; the second read is the one for the wait.
    await storage.hold(read: 2, until: gate) { reading.fulfill() }
    let waited = expectation(description: "waited")
    waited.isInverted = true
    workManager = makeManager(sleep: { _ in
      waited.fulfill()
      try await Task.sleep(nanoseconds: 60_000_000_000)
    })
    await workManager.start()
    await fulfillment(of: [reading], timeout: 2)

    await workManager.stop()
    await gate.open()

    await fulfillment(of: [waited], timeout: 0.5)
  }

  func testStart_WhenTheStoppedLoopWakesLate_ThenTheNewLoopCanStillBeWoken() async {
    await givenDeferred(["a"], entries: [entry("a", dueIn: 3_600)])
    let gate = AsyncGate()
    let firstWaiting = expectation(description: "the first loop waits")
    let firstWaitEnded = expectation(description: "the first loop's wait ended")
    let secondWaiting = expectation(description: "the second loop waits")
    secondWaiting.assertForOverFulfill = false
    let waits = OSAllocatedUnfairLock(initialState: 0)
    // The first loop's wait outlasts stop(), so that loop gets back to the manager only after start().
    workManager = makeManager(sleep: { _ in
      let number = waits.withLock { count in
        count += 1
        return count
      }
      guard number > 1 else {
        firstWaiting.fulfill()
        await gate.wait()
        firstWaitEnded.fulfill()
        return
      }
      secondWaiting.fulfill()
      try await Task.sleep(nanoseconds: 60_000_000_000)
    })
    let asked = expectation(description: "asked")
    stubRequest { _ in
      asked.fulfill()
      throw URLError(.timedOut)
    }
    await workManager.start()
    await fulfillment(of: [firstWaiting], timeout: 2)
    await workManager.stop()
    await workManager.start()
    await fulfillment(of: [secondWaiting], timeout: 2)
    await gate.open()
    await fulfillment(of: [firstWaitEnded], timeout: 2)
    // Nothing tells when the first loop is back on the manager. If it's later than this, the test passes
    // without having checked anything, but it never fails wrongly.
    try? await Task.sleep(nanoseconds: 200_000_000)

    clock.advance(by: 3_600)
    await workManager.wake()

    await fulfillment(of: [asked], timeout: 2)
    await workManager.stop()
  }
}

private extension TestDeferredIssuanceWorkManager {

  func makeManager(
    config: DeferredIssuanceConfig = .stub,
    checkRunner: SerialCheckRunner = SerialCheckRunner(),
    sleep: @escaping @Sendable (TimeInterval) async throws -> Void = { _ in
      try await Task.sleep(nanoseconds: 60_000_000_000)
    }
  ) -> DeferredIssuanceWorkManagerImpl {
    let clock = clock!
    return DeferredIssuanceWorkManagerImpl(
      walletKitController: walletKitController,
      storageController: storage,
      revocationWorkManager: revocationWorkManager,
      schedule: DeferredIssuanceSchedule(config: config),
      sessionStatusProvider: sessionStatus,
      checkRunner: checkRunner,
      now: { clock.now },
      sleep: sleep
    )
  }

  /// Records every wait. The first `passingWaits` move the clock on by their delay and return at once;
  /// the next one fulfils `blocked` and blocks until the manager stops.
  func makeManager(
    passingWaits: Int,
    recordingIn delays: OSAllocatedUnfairLock<[TimeInterval]>,
    blocked: XCTestExpectation
  ) -> DeferredIssuanceWorkManagerImpl {
    let clock = clock!
    blocked.assertForOverFulfill = false
    return makeManager(sleep: { delay in
      let count = delays.withLock { recorded in
        recorded.append(delay)
        return recorded.count
      }
      guard count > passingWaits else {
        clock.advance(by: delay)
        return
      }
      blocked.fulfill()
      try await Task.sleep(nanoseconds: 60_000_000_000)
    })
  }

  /// Polls until the manager's loop has ended.
  func waitUntilIdle() async {
    for _ in 0..<500 {
      if await workManager.isIdle { return }
      try? await Task.sleep(nanoseconds: 10_000_000)
    }
    XCTFail("The manager did not go idle")
  }

  /// Deferred documents for `ids` (named "Document <id>") and the given stored entries.
  func givenDeferred(_ ids: [String], entries: [DeferredIssuance]) async {
    let documents = ids.map { storedDocument($0, modifiedAt: startDate) }
    stub(walletKitController) { mock in
      when(mock.fetchDeferredDocuments()).thenReturn(documents)
    }
    await storage.setEntries(entries)
  }

  func stubRequest(_ answer: @escaping (WalletStorage.Document) throws -> any DocClaimsDecodable) {
    stub(walletKitController) { mock in
      when(mock.requestDeferredIssuance(with: any())).then(answer)
    }
  }

  func entry(
    _ id: String,
    dueIn seconds: TimeInterval,
    interval: TimeInterval? = nil,
    state: DeferredIssuance.State = .pending
  ) -> DeferredIssuance {
    DeferredIssuance(
      identifier: id,
      nextAttemptAt: startDate.addingTimeInterval(seconds),
      interval: interval,
      state: state
    )
  }

  func storedDocument(_ id: String, modifiedAt: Date) -> WalletStorage.Document {
    WalletStorage.Document(
      id: id,
      docType: "eu.europa.ec.eudi.pid.1",
      docDataFormat: .cbor,
      data: Data(),
      docKeyInfo: nil,
      createdAt: modifiedAt,
      modifiedAt: modifiedAt,
      metadata: nil,
      displayName: "Document \(id)",
      status: .deferred
    )
  }

  func document(_ id: String) -> ParameterMatcher<WalletStorage.Document> {
    ParameterMatcher { $0.id == id }
  }
}

/// What WalletKit returns while the credential isn't ready.
private func deferredDocument(_ id: String) -> any DocClaimsDecodable {
  WalletStorage.Document(
    id: id,
    docType: "eu.europa.ec.eudi.pid.1",
    docDataFormat: .cbor,
    data: Data(),
    docKeyInfo: nil,
    createdAt: nil,
    metadata: nil,
    displayName: "Document \(id)",
    status: .deferred
  ).transformToDeferredDecodable()
}

/// Clock that tests can advance.
private final class TestClock: Sendable {

  private let date: OSAllocatedUnfairLock<Date>

  init(_ date: Date) {
    self.date = OSAllocatedUnfairLock(initialState: date)
  }

  var now: Date {
    date.withLock { $0 }
  }

  func advance(by seconds: TimeInterval) {
    date.withLock { $0 = $0.addingTimeInterval(seconds) }
  }
}
