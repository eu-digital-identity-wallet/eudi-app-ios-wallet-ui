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
import MdocDataModel18013
@testable import logic_business
@testable import logic_core
@testable import logic_test

final class TestRevocationWorkManager: EudiTest {

  var walletKitController: MockWalletKitController!
  var walletKitConfig: MockWalletKitConfig!
  var workManager: RevocationWorkManagerImpl!

  override func setUp() {
    walletKitController = MockWalletKitController()
    walletKitConfig = MockWalletKitConfig()
    workManager = RevocationWorkManagerImpl(
      configLogic: walletKitConfig,
      walletKitController: walletKitController
    )
    stub(walletKitController) { mock in
      when(mock.storeRevokedDocuments(with: any())).thenDoNothing()
      when(mock.removeRevokedDocument(with: any())).thenDoNothing()
      when(mock.storeStatusRefreshFailures(ids: any())).thenDoNothing()
      when(mock.removeStatusRefreshFailures(ids: any())).thenDoNothing()
    }
  }

  override func tearDown() {
    walletKitController = nil
    walletKitConfig = nil
    workManager = nil
  }

  func testCheckRevocation_WhenInvalid_ThenStoresRevoked() async throws {
    // Given
    stubSweep(stored: [:], statuses: ["a": .invalid])

    // When
    try await workManager.checkRevocation()

    // Then
    verify(walletKitController).storeRevokedDocuments(with: equal(to: ["a": .revoked]))
    verify(walletKitController, never()).removeRevokedDocument(with: any())
  }

  func testCheckRevocation_WhenDocumentsHaveDifferentTypes_ThenChecksEachStatusAgainstItsDocumentsType() async throws {
    // Given
    let asked = OSAllocatedUnfairLock<[String: String]>(initialState: [:])
    stub(walletKitController) { mock in
      when(mock.fetchIssuedDocuments()).thenReturn([
        StubDocument.make(id: "mdoc", docType: "eu.europa.ec.eudi.pid.1"),
        StubDocument.make(id: "sdjwt", docType: "urn:eudi:pid:1")
      ])
      when(mock.fetchRevokedDocumentStatuses()).thenReturn([:])
      when(mock.fetchStatusRefreshFailures()).thenReturn([])
      when(mock.getDocumentStatus(for: any(), docType: any())).then { statusList, docType in
        asked.withLock { $0[String(statusList.uri.split(separator: "/").last ?? "")] = docType }
        return .valid
      }
    }

    // When
    try await workManager.checkRevocation()

    let askedTypes = asked.withLock { $0 }

    // Then
    XCTAssertEqual(askedTypes, ["mdoc": "eu.europa.ec.eudi.pid.1", "sdjwt": "urn:eudi:pid:1"])
  }

  func testCheckRevocation_WhenRevokedDocumentIsReportedValid_ThenStaysRevoked() async throws {
    // Given
    stubSweep(stored: ["a": .revoked], statuses: ["a": .valid])

    // When
    try await workManager.checkRevocation()

    // Then
    verify(walletKitController, never()).removeRevokedDocument(with: any())
    verify(walletKitController, never()).storeRevokedDocuments(with: any())
  }

  func testCheckRevocation_WhenRevokedDocumentIsReportedSuspended_ThenStaysRevoked() async throws {
    // Given
    stubSweep(stored: ["a": .revoked], statuses: ["a": .suspended])

    // When
    try await workManager.checkRevocation()

    // Then
    verify(walletKitController, never()).storeRevokedDocuments(with: any())
    verify(walletKitController, never()).removeRevokedDocument(with: any())
  }

  func testCheckRevocation_WhenSuspended_ThenStoresSuspended() async throws {
    // Given
    stubSweep(stored: [:], statuses: ["a": .suspended])

    // When
    try await workManager.checkRevocation()

    // Then
    verify(walletKitController).storeRevokedDocuments(with: equal(to: ["a": .suspended]))
  }

  func testCheckRevocation_WhenSuspendedDocumentIsReportedValid_ThenClearsTheRecord() async throws {
    // Given
    stubSweep(stored: ["a": .suspended], statuses: ["a": .valid])

    // When
    try await workManager.checkRevocation()

    // Then
    verify(walletKitController).removeRevokedDocument(with: equal(to: "a"))
    verify(walletKitController, never()).storeRevokedDocuments(with: any())
  }

  func testCheckRevocation_WhenSuspendedDocumentIsReportedInvalid_ThenBecomesRevoked() async throws {
    // Given
    stubSweep(stored: ["a": .suspended], statuses: ["a": .invalid])

    // When
    try await workManager.checkRevocation()

    // Then
    verify(walletKitController).storeRevokedDocuments(with: equal(to: ["a": .revoked]))
    verify(walletKitController, never()).removeRevokedDocument(with: any())
  }

  func testCheckRevocation_WhenTwoDocumentsWithTheSameNameAreRevoked_ThenTheNoticeListsBoth() async throws {
    // Given
    stubSweep(stored: [:], statuses: ["a": .invalid, "b": .invalid])
    stub(walletKitController) { mock in
      when(mock.fetchIssuedDocuments()).thenReturn([
        StubDocument.make(id: "a", displayName: "PID"),
        StubDocument.make(id: "b", displayName: "PID")
      ])
    }
    let notified = expectation(forNotification: NSNotification.RevocationDashboard, object: nil) { notification in
      RevocationDashboardPayload(userInfo: notification.userInfo)
        == RevocationDashboardPayload(revoked: ["a": "PID", "b": "PID"], suspended: [:])
    }

    // When
    try await workManager.checkRevocation()

    // Then
    await fulfillment(of: [notified], timeout: 2)
  }

  func testCheckRevocation_WhenAStatusCannotBeInterpreted_ThenBlocksTheDocumentAsUnrecognised() async throws {
    // Given
    stubSweep(stored: [:], statuses: ["a": .applicationSpecific(3), "c": .reserved(3)])
    let notified = expectation(forNotification: NSNotification.RevocationDashboard, object: nil) { notification in
      RevocationDashboardPayload(userInfo: notification.userInfo)
        == RevocationDashboardPayload(revoked: ["a": "Document a", "c": "Document c"], suspended: [:])
    }

    // When
    try await workManager.checkRevocation()

    // Then
    verify(walletKitController).storeRevokedDocuments(with: equal(to: ["a": .unrecognised, "c": .unrecognised]))
    await fulfillment(of: [notified], timeout: 2)
  }

  func testCheckRevocation_WhenASuspendedDocumentGetsAStatusThatCannotBeInterpreted_ThenBecomesUnrecognised() async throws {
    // Given
    stubSweep(stored: ["a": .suspended], statuses: ["a": .applicationSpecific(3)])

    // When
    try await workManager.checkRevocation()

    // Then
    verify(walletKitController).storeRevokedDocuments(with: equal(to: ["a": .unrecognised]))
    verify(walletKitController, never()).removeRevokedDocument(with: any())
  }

  func testCheckRevocation_WhenAnUnrecognisedDocumentIsReportedValid_ThenClearsTheRecord() async throws {
    // Given
    stubSweep(stored: ["a": .unrecognised], statuses: ["a": .valid])

    // When
    try await workManager.checkRevocation()

    // Then
    verify(walletKitController).removeRevokedDocument(with: equal(to: "a"))
    verify(walletKitController, never()).storeRevokedDocuments(with: any())
  }

  func testCheckRevocation_WhenABlockedDocumentChangesStatus_ThenOnlyItsDetailsRefresh() async throws {
    // Given
    stubSweep(stored: ["a": .suspended], statuses: ["a": .invalid])
    let detailsRefreshed = expectation(forNotification: NSNotification.DocumentDetailsRefresh, object: nil) { notification in
      notification.userInfo?["ids"] as? [String] == ["a"]
    }
    let dashboardNotified = expectation(forNotification: NSNotification.RevocationDashboard, object: nil)
    dashboardNotified.isInverted = true

    // When
    try await workManager.checkRevocation()

    // Then
    await fulfillment(of: [detailsRefreshed, dashboardNotified], timeout: 2)
  }

  func testCheckRevocation_WhenOneStatusFetchFails_ThenTheOthersAreStillStored() async throws {
    // Given
    stubSweep(stored: ["b": .suspended], statuses: ["a": .invalid, "c": .suspended], failing: ["b"])

    // When
    try await workManager.checkRevocation()

    // Then
    verify(walletKitController).storeRevokedDocuments(with: equal(to: ["a": .revoked, "c": .suspended]))
    verify(walletKitController, never()).removeRevokedDocument(with: any())
    verify(walletKitController).storeStatusRefreshFailures(ids: equal(to: ["b"]))
  }

  func testCheckRevocation_WhenAFetchFails_ThenTheFailureIsRecordedAndTheDetailsRefresh() async throws {
    // Given
    stubSweep(stored: [:], statuses: [:], failing: ["a"])
    let detailsRefreshed = expectation(forNotification: NSNotification.DocumentDetailsRefresh, object: nil) { notification in
      notification.userInfo?["ids"] as? [String] == ["a"]
    }
    let dashboardNotified = expectation(forNotification: NSNotification.RevocationDashboard, object: nil)
    dashboardNotified.isInverted = true

    // When
    try await workManager.checkRevocation()

    // Then
    verify(walletKitController).storeStatusRefreshFailures(ids: equal(to: ["a"]))
    verify(walletKitController, never()).storeRevokedDocuments(with: any())
    await fulfillment(of: [detailsRefreshed, dashboardNotified], timeout: 2)
  }

  func testCheckRevocation_WhenAFetchFailsAgain_ThenNothingChanges() async throws {
    // Given
    stubSweep(stored: [:], statuses: [:], failing: ["a"], previousFailures: ["a"])
    let detailsRefreshed = expectation(forNotification: NSNotification.DocumentDetailsRefresh, object: nil)
    detailsRefreshed.isInverted = true

    // When
    try await workManager.checkRevocation()

    // Then
    verify(walletKitController, never()).storeStatusRefreshFailures(ids: any())
    verify(walletKitController, never()).removeStatusRefreshFailures(ids: any())
    await fulfillment(of: [detailsRefreshed], timeout: 0.5)
  }

  func testCheckRevocation_WhenTheSweepIsCancelled_ThenNoFailureIsRecordedAndNothingRefreshes() async {
    // Given
    stub(walletKitController) { mock in
      when(mock.fetchIssuedDocuments()).thenReturn(["a", "b"].map { StubDocument.make(id: $0) })
      when(mock.fetchRevokedDocumentStatuses()).thenReturn([:])
      when(mock.fetchStatusRefreshFailures()).thenReturn([])
      when(mock.getDocumentStatus(for: any(), docType: any())).then { _, _ in
        withUnsafeCurrentTask { $0?.cancel() }
        throw CancellationError()
      }
    }
    let detailsRefreshed = expectation(forNotification: NSNotification.DocumentDetailsRefresh, object: nil)
    detailsRefreshed.isInverted = true
    let manager = workManager!

    // When
    _ = await Task { try await manager.checkRevocation() }.result

    // Then
    verify(walletKitController, never()).storeStatusRefreshFailures(ids: any())
    verify(walletKitController, never()).storeRevokedDocuments(with: any())
    await fulfillment(of: [detailsRefreshed], timeout: 0.5)
  }

  func testCheckRevocation_WhenTheSweepIsCancelledAfterARevocationWasRead_ThenTheRevocationIsStoredAndAnnounced() async {
    // Given
    stub(walletKitController) { mock in
      when(mock.fetchIssuedDocuments()).thenReturn(["a", "b"].map { StubDocument.make(id: $0) })
      when(mock.fetchRevokedDocumentStatuses()).thenReturn([:])
      when(mock.fetchStatusRefreshFailures()).thenReturn([])
      when(mock.getDocumentStatus(for: any(), docType: any())).then { statusList, _ in
        guard statusList.uri.hasSuffix("/a") else {
          withUnsafeCurrentTask { $0?.cancel() }
          throw CancellationError()
        }
        return .invalid
      }
    }
    let announced = expectation(forNotification: NSNotification.RevocationDashboard, object: nil)
    let manager = workManager!

    // When
    _ = await Task { try await manager.checkRevocation() }.result

    // Then
    verify(walletKitController).storeRevokedDocuments(with: equal(to: ["a": .revoked]))
    verify(walletKitController, never()).storeStatusRefreshFailures(ids: any())
    await fulfillment(of: [announced], timeout: 1)
  }

  func testCheckRevocation_WhenAFailedDocumentIsRefreshed_ThenItsFailureIsRemovedAndTheDetailsRefresh() async throws {
    // Given
    stubSweep(stored: [:], statuses: ["a": .valid], previousFailures: ["a"])
    let detailsRefreshed = expectation(forNotification: NSNotification.DocumentDetailsRefresh, object: nil) { notification in
      notification.userInfo?["ids"] as? [String] == ["a"]
    }
    let listRefreshed = expectation(forNotification: NSNotification.DocumentTabRefresh, object: nil)

    // When
    try await workManager.checkRevocation()

    // Then
    verify(walletKitController).removeStatusRefreshFailures(ids: equal(to: ["a"]))
    verify(walletKitController, never()).storeStatusRefreshFailures(ids: any())
    await fulfillment(of: [detailsRefreshed, listRefreshed], timeout: 2)
  }

  func testCheckRevocation_WhenTheFailureRecordsCannotBeRead_ThenChangesNothing() async {
    // Given
    stubSweep(stored: [:], statuses: ["a": .invalid])
    stub(walletKitController) { mock in
      when(mock.fetchStatusRefreshFailures()).thenThrow(RuntimeError.genericError)
    }

    // When
    do {
      try await workManager.checkRevocation()

      // Then
      XCTFail("Expected the sweep to stop")
    } catch {
      verify(walletKitController, never()).storeRevokedDocuments(with: any())
      verify(walletKitController, never()).storeStatusRefreshFailures(ids: any())
    }
  }

  func testCheckRevocation_WhenStoredRecordsCannotBeRead_ThenChangesNothing() async {
    // Given
    stub(walletKitController) { mock in
      when(mock.fetchIssuedDocuments()).thenReturn([StubDocument.make(id: "a")])
      when(mock.fetchRevokedDocumentStatuses()).thenThrow(RuntimeError.genericError)
      when(mock.getDocumentStatus(for: any(), docType: any())).thenReturn(.suspended)
    }

    // When
    do {
      try await workManager.checkRevocation()

      // Then
      XCTFail("Expected the sweep to stop")
    } catch {
      verify(walletKitController, never()).storeRevokedDocuments(with: any())
      verify(walletKitController, never()).removeRevokedDocument(with: any())
    }
  }

  func testCheckRevocation_WhenDocumentsAreRevokedAndSuspended_ThenTheDashboardGetsBothGroups() async throws {
    // Given
    stubSweep(stored: [:], statuses: ["a": .invalid, "c": .suspended])
    let notified = expectation(forNotification: NSNotification.RevocationDashboard, object: nil) { notification in
      RevocationDashboardPayload(userInfo: notification.userInfo)
        == RevocationDashboardPayload(revoked: ["a": "Document a"], suspended: ["c": "Document c"])
    }

    // When
    try await workManager.checkRevocation()

    // Then
    await fulfillment(of: [notified], timeout: 2)
  }

  func testFirstCheckDelay_WhenNoCheckHasRun_ThenIsTheInitialDelay() async {
    // When
    let delay = await workManager.firstCheckDelay()

    // Then
    XCTAssertEqual(delay, 30)
  }

  func testFirstCheckDelay_WhenACheckHasRun_ThenIsTheInterval() async throws {
    // Given
    stub(walletKitConfig) { mock in
      when(mock.revocationIntervalSeconds.get).thenReturn(300)
    }
    stubSweep(stored: [:], statuses: [:])

    // When
    try await workManager.checkRevocation()
    let delay = await workManager.firstCheckDelay()

    // Then
    XCTAssertEqual(delay, 300)
  }

  func testCheckRevocation_WhenClearingASuspensionFails_ThenTheRevocationIsStillStored() async {
    // Given
    stubSweep(stored: ["b": .suspended], statuses: ["a": .invalid, "b": .valid])
    stub(walletKitController) { mock in
      when(mock.removeRevokedDocument(with: equal(to: "b"))).thenThrow(RuntimeError.genericError)
    }

    // When
    try? await workManager.checkRevocation()

    // Then
    verify(walletKitController).storeRevokedDocuments(with: equal(to: ["a": .revoked]))
  }

  func testCheckRevocation_WhenDocumentHasNoStatusList_ThenItsRecordIsLeft() async throws {
    // Given
    stub(walletKitController) { mock in
      when(mock.fetchIssuedDocuments()).thenReturn([StubDocument.make(id: "a", hasStatusList: false)])
      when(mock.fetchRevokedDocumentStatuses()).thenReturn(["a": .suspended])
      when(mock.fetchStatusRefreshFailures()).thenReturn([])
    }

    // When
    try await workManager.checkRevocation()

    // Then
    verify(walletKitController, never()).getDocumentStatus(for: any(), docType: any())
    verify(walletKitController, never()).removeRevokedDocument(with: any())
    verify(walletKitController, never()).storeRevokedDocuments(with: any())
  }

  func testCheckRevocation_WhenRevokedDocumentGetsAReservedStatus_ThenStaysRevoked() async throws {
    // Given
    stubSweep(stored: ["a": .revoked], statuses: ["a": .reserved(3)])

    // When
    try await workManager.checkRevocation()

    // Then
    verify(walletKitController, never()).removeRevokedDocument(with: any())
    verify(walletKitController, never()).storeRevokedDocuments(with: any())
  }

  func testCheckRevocation_WhenValidWithoutARecord_ThenChangesNothing() async throws {
    // Given
    stubSweep(stored: [:], statuses: ["a": .valid])
    let notified = expectation(forNotification: NSNotification.DocumentTabRefresh, object: nil)
    notified.isInverted = true

    // When
    try await workManager.checkRevocation()

    // Then
    await fulfillment(of: [notified], timeout: 0.5)
    verify(walletKitController, never()).removeRevokedDocument(with: any())
    verify(walletKitController, never()).storeRevokedDocuments(with: any())
  }

  func testCheckRevocation_WhenOnlyASuspensionIsCleared_ThenTheListAndTheDetailsRefresh() async throws {
    // Given
    stubSweep(stored: ["a": .suspended], statuses: ["a": .valid])
    let listRefreshed = expectation(forNotification: NSNotification.DocumentTabRefresh, object: nil)
    let detailsRefreshed = expectation(forNotification: NSNotification.DocumentDetailsRefresh, object: nil) { notification in
      notification.userInfo?["ids"] as? [String] == ["a"]
    }
    let dashboardNotified = expectation(forNotification: NSNotification.RevocationDashboard, object: nil)
    dashboardNotified.isInverted = true

    // When
    try await workManager.checkRevocation()

    // Then
    await fulfillment(of: [listRefreshed, detailsRefreshed, dashboardNotified], timeout: 2)
  }

  func testCheckAfterReIssue_WhenTheOriginalGainedARecord_ThenACheckRunsNow() async {
    // Given
    stub(walletKitConfig) { mock in
      when(mock.revocationIntervalSeconds.get).thenReturn(3600)
    }
    stubSweep(stored: ["original": .revoked], statuses: [:])
    await workManager.start()

    // When
    await workManager.checkAfterReIssue(of: "original")

    // Then
    verify(walletKitController).fetchIssuedDocuments()
    await workManager.stop()
  }

  func testCheckAfterReIssue_WhenTheOriginalHasNoRecord_ThenNoCheckRuns() async {
    // Given
    stub(walletKitConfig) { mock in
      when(mock.revocationIntervalSeconds.get).thenReturn(3600)
    }
    stubSweep(stored: [:], statuses: [:])
    await workManager.start()

    // When
    await workManager.checkAfterReIssue(of: "original")

    // Then
    verify(walletKitController, never()).fetchIssuedDocuments()
    await workManager.stop()
  }

  func testCheckAfterReIssue_WhenTheChecksAreStopped_ThenNoCheckRuns() async {
    // Given
    stubSweep(stored: ["original": .revoked], statuses: [:])

    // When
    await workManager.checkAfterReIssue(of: "original")

    // Then
    verify(walletKitController, never()).fetchIssuedDocuments()
  }

  func testStop_WhenACheckIsUnderWay_ThenReturnsOnceItHasFinished() async {
    // Given
    let runner = SerialCheckRunner()
    let manager = RevocationWorkManagerImpl(
      configLogic: walletKitConfig,
      walletKitController: walletKitController,
      checkRunner: runner
    )
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

    // When
    let stopping = Task {
      await manager.stop()
      stoppedEarly.fulfill()
    }

    // Then
    await fulfillment(of: [stoppedEarly], timeout: 0.5)
    await gate.open()
    await stopping.value
    await underWay.value
  }
}

private extension TestRevocationWorkManager {

  /// Stubs one sweep: a document for every id in `statuses` and `failing`, the stored records, the
  /// documents whose last refresh failed, and the status each document's list reports. A document in
  /// `failing` cannot have its status fetched.
  func stubSweep(
    stored: [String: DocumentRevocationStatus],
    statuses: [String: CredentialStatus],
    failing: Set<String> = [],
    previousFailures: Set<String> = []
  ) {
    let ids = Set(statuses.keys).union(failing).sorted()
    stub(walletKitController) { mock in
      when(mock.fetchIssuedDocuments()).thenReturn(ids.map { StubDocument.make(id: $0) })
      when(mock.fetchRevokedDocumentStatuses()).thenReturn(stored)
      when(mock.fetchStatusRefreshFailures()).thenReturn(previousFailures)
      when(mock.getDocumentStatus(for: any(), docType: any())).then { statusList, _ in
        let id = String(statusList.uri.split(separator: "/").last ?? "")
        guard let status = statuses[id], !failing.contains(id) else {
          throw RuntimeError.genericError
        }
        return status
      }
    }
  }
}
