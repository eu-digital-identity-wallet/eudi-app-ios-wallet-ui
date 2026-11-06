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
@testable import logic_business
@testable import logic_core
@testable import logic_test

final class TestReIssuanceWorkManager: EudiTest {

  var walletKitController: MockWalletKitController!
  var walletKitConfig: MockWalletKitConfig!
  var workManager: ReIssuanceWorkManagerImpl!
  var revocationWorkManager: MockRevocationWorkManager!

  override func setUp() {
    walletKitController = MockWalletKitController()
    walletKitConfig = MockWalletKitConfig()
    stub(walletKitConfig) { mock in
      when(mock.documentIssuanceConfig.get).thenReturn(
        DocumentIssuanceConfig(
          defaultCredentialOptions: CredentialOptions(credentialPolicy: .rotateUse, batchSize: 1),
          documentSpecificCredentialOptions: [:],
          reIssuanceBackgroundRule: ReIssuanceBackgroundRule(backgroundIntervalSeconds: 300)
        )
      )
    }
    revocationWorkManager = MockRevocationWorkManager()
    stub(revocationWorkManager) { mock in
      when(mock.checkAfterReIssue(of: any())).thenDoNothing()
    }
    workManager = ReIssuanceWorkManagerImpl(
      configLogic: walletKitConfig,
      walletKitController: walletKitController,
      revocationWorkManager: revocationWorkManager
    )
    stub(walletKitController) { mock in
      when(mock.getDocumentCredentialOptions(with: any())).thenReturn(nil)
      when(mock.reIssueDocument(identifier: any(), isBackgroundOperation: any())).thenThrow(RuntimeError.genericError)
      when(mock.removeAllFailedReIssuedDocuments()).thenDoNothing()
      when(mock.storeFailedReIssuedDocuments(ids: any())).thenDoNothing()
    }
  }

  override func tearDown() {
    walletKitController = nil
    walletKitConfig = nil
    workManager = nil
    revocationWorkManager = nil
  }

  func testCheckReIssuance_WhenDocumentsAreRevokedSuspendedOrUnrecognised_ThenOnlyTheOthersAreReIssued() async throws {
    stub(walletKitController) { mock in
      when(mock.fetchRevokedDocumentStatuses()).thenReturn(["a": .revoked, "b": .suspended, "c": .unrecognised])
      when(mock.fetchIssuedDocuments()).thenReturn(["a", "b", "c", "d"].map { StubDocument.make(id: $0) })
    }

    try await workManager.checkReIssuance()

    verify(walletKitController).reIssueDocument(identifier: equal(to: "d"), isBackgroundOperation: equal(to: true))
    for id in ["a", "b", "c"] {
      verify(walletKitController, never()).reIssueDocument(identifier: equal(to: id), isBackgroundOperation: any())
    }
  }

  func testCheckReIssuance_WhenADocumentIsReIssued_ThenTheRevocationCheckIsAskedAboutItsOriginal() async throws {
    stub(walletKitController) { mock in
      when(mock.fetchRevokedDocumentStatuses()).thenReturn([:])
      when(mock.fetchIssuedDocuments()).thenReturn([StubDocument.make(id: "d")])
      when(mock.reIssueDocument(identifier: equal(to: "d"), isBackgroundOperation: any()))
        .thenReturn(
          WalletStorage.Document(
            id: "newD",
            docType: "",
            docDataFormat: .cbor,
            data: Data(),
            docKeyInfo: nil,
            createdAt: nil,
            metadata: nil,
            displayName: "",
            status: .issued
          )
        )
    }

    try await workManager.checkReIssuance()

    verify(revocationWorkManager).checkAfterReIssue(of: equal(to: "d"))
  }

  func testCheckReIssuance_WhenNothingIsDue_ThenTheOldFailureRecordsAreCleared() async throws {
    stub(walletKitController) { mock in
      when(mock.fetchRevokedDocumentStatuses()).thenReturn(["a": .revoked])
      when(mock.fetchIssuedDocuments()).thenReturn([StubDocument.make(id: "a")])
    }

    try await workManager.checkReIssuance()

    verify(walletKitController).removeAllFailedReIssuedDocuments()
    verify(walletKitController, never()).reIssueDocument(identifier: any(), isBackgroundOperation: any())
  }

  func testCheckReIssuance_WhenTheRevocationRecordsCannotBeRead_ThenReIssuesNothing() async {
    stub(walletKitController) { mock in
      when(mock.fetchRevokedDocumentStatuses()).thenThrow(RuntimeError.genericError)
      when(mock.fetchIssuedDocuments()).thenReturn([StubDocument.make(id: "d")])
    }

    do {
      try await workManager.checkReIssuance()
      XCTFail("Expected the round to stop")
    } catch {
      verify(walletKitController, never()).reIssueDocument(identifier: any(), isBackgroundOperation: any())
    }
  }

  func testCheckReIssuance_WhenTheRoundIsCancelled_ThenNoFailureIsRecorded() async {
    stub(walletKitController) { mock in
      when(mock.fetchRevokedDocumentStatuses()).thenReturn([:])
      when(mock.fetchIssuedDocuments()).thenReturn(["a", "b"].map { StubDocument.make(id: $0) })
      when(mock.reIssueDocument(identifier: any(), isBackgroundOperation: any())).then { _, _ in
        withUnsafeCurrentTask { $0?.cancel() }
        throw CancellationError()
      }
    }
    let manager = workManager!

    _ = await Task { try await manager.checkReIssuance() }.result

    verify(walletKitController, never()).storeFailedReIssuedDocuments(ids: any())
  }

  func testStop_WhenARoundIsUnderWay_ThenReturnsOnceItHasFinished() async {
    let runner = SerialCheckRunner()
    let manager = ReIssuanceWorkManagerImpl(
      configLogic: walletKitConfig,
      walletKitController: walletKitController,
      revocationWorkManager: revocationWorkManager,
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

    let stopping = Task {
      await manager.stop()
      stoppedEarly.fulfill()
    }

    await fulfillment(of: [stoppedEarly], timeout: 0.5)
    await gate.open()
    await stopping.value
    await underWay.value
  }
}
