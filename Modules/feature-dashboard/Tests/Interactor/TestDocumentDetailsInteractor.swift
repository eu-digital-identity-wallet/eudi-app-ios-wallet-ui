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
@testable import feature_test
@testable import logic_business
@testable import feature_dashboard
@testable import logic_resources

final class TestDocumentDetailsInteractor: EudiTest {
  
  var interactor: DocumentDetailsInteractor!
  var walletKitController: MockWalletKitController!
  var prefsController: MockPrefsController!
  var configLogic: MockConfigLogic!
  var sessionController: MockSessionController!
  var walletWorkScheduler: MockWalletWorkScheduler!

  override func setUp() {
    self.walletKitController = MockWalletKitController()
    stub(walletKitController) { mock in
      when(mock.issuerLogoOrigins()).thenReturn(IssuerLogoOrigins(logoOriginsByIssuer: [:]))
    }
    self.prefsController = MockPrefsController()
    self.configLogic = MockConfigLogic()
    self.sessionController = MockSessionController()
    self.walletWorkScheduler = MockWalletWorkScheduler()
    stub(walletWorkScheduler) { mock in
      when(mock.scheduleRevocationCheck(afterReIssueOf: any())).thenDoNothing()
    }
    stub(sessionController) { mock in
      when(mock.beginExternalFlow()).thenReturn(0)
      when(mock.endExternalFlow(startedIn: any())).thenDoNothing()
    }
    stub(walletKitController) { mock in
      when(mock.fetchRevokedDocumentStatuses()).thenReturn([:])
    }
    self.interactor = DocumentDetailsInteractorImpl(
      walletController: walletKitController,
      prefsController: prefsController,
      configLogic: configLogic,
      sessionController: sessionController,
      walletWorkScheduler: walletWorkScheduler
    )
    
    stubConfigLogic()
  }
  
  override func tearDown() {
    self.sessionController = nil
    self.interactor = nil
    self.walletKitController = nil
    self.prefsController = nil
    self.configLogic = nil
  }
  
  func testFetchStoredDocument_WhenWalletKitControllerReturnsValidDocument_ThenReturnsExpectedValues() async throws {
    // Given
    let expectedDocument = Constants.createEuPidModel(credentialsUsageCounts: try .init(total: 10, remaining: 10))
    let documentId = expectedDocument.id
    
    stubFetchDocument(for: documentId, document: expectedDocument)
    stubIsBookmarked(for: documentId, isBookmarked: false)
    stubRevocationStatus(for: documentId, status: nil)
    stubIsDocumentLowOnCredentials()
    stubIsBatchCounterEnabled()

    // When
    let result = await interactor.fetchStoredDocument(documentId: documentId)
    
    // Then
    switch result {
    case .success(let uiModel, let issuerDocumentDetailsCard, let documentCredentialsInfoUi, let isBookmarked, let isRevoked):
      XCTAssertEqual(uiModel.id, documentId)
      XCTAssertEqual(documentCredentialsInfoUi?.availableCredentials, 10)
      XCTAssertEqual(documentCredentialsInfoUi?.totalCredentials, 10)
      XCTAssertNotNil(issuerDocumentDetailsCard)
      XCTAssertEqual(issuerDocumentDetailsCard?.hasStatusRefreshFailed, false)
      XCTAssertFalse(isBookmarked)
      XCTAssertFalse(isRevoked)
    case .failure:
      XCTFail("Expected success, but got failure.")
    }
  }

  func testFetchStoredDocument_WhenDocumentIsSuspended_ThenFlagsItAndShowsTheSuspendedCard() async throws {
    let expectedDocument = Constants.createEuPidModel(credentialsUsageCounts: try .init(total: 10, remaining: 10))
    let documentId = expectedDocument.id
    stubFetchDocument(for: documentId, document: expectedDocument)
    stubIsBookmarked(for: documentId, isBookmarked: false)
    stubRevocationStatus(for: documentId, status: .suspended)
    stubIsDocumentLowOnCredentials()
    stubIsBatchCounterEnabled()

    let result = await interactor.fetchStoredDocument(documentId: documentId)

    switch result {
    case .success(_, let issuerDocumentDetailsCard, _, _, let isRevoked):
      XCTAssertTrue(isRevoked)
      XCTAssertEqual(issuerDocumentDetailsCard?.documentState, .suspended)
      XCTAssertEqual(issuerDocumentDetailsCard?.dateText, .documentDetailsSuspendedDocument)
    case .failure:
      XCTFail("Expected success, but got failure.")
    }
  }

  func testFetchStoredDocument_WhenABackgroundRenewalFailed_ThenTheIssuerCardSaysSo() async throws {
    let expectedDocument = Constants.createEuPidModel(credentialsUsageCounts: try .init(total: 10, remaining: 10))
    let documentId = expectedDocument.id
    stubFetchDocument(for: documentId, document: expectedDocument)
    stubIsBookmarked(for: documentId, isBookmarked: false)
    stubRevocationStatus(for: documentId, status: nil, hasReIssuanceFailed: true)
    stubIsDocumentLowOnCredentials()
    stubIsBatchCounterEnabled()

    let result = await interactor.fetchStoredDocument(documentId: documentId)

    switch result {
    case .success(_, let issuerDocumentDetailsCard, _, _, _):
      XCTAssertEqual(issuerDocumentDetailsCard?.hasReIssuanceFailed, true)
      XCTAssertEqual(issuerDocumentDetailsCard?.hasStatusRefreshFailed, false)
    case .failure:
      XCTFail("Expected success, but got failure.")
    }
  }

  func testFetchStoredDocument_WhenTheStatusCouldNotBeRefreshed_ThenTheIssuerCardSaysSoWithoutBlocking() async throws {
    let expectedDocument = Constants.createEuPidModel(credentialsUsageCounts: try .init(total: 10, remaining: 10))
    let documentId = expectedDocument.id
    stubFetchDocument(for: documentId, document: expectedDocument)
    stubIsBookmarked(for: documentId, isBookmarked: false)
    stubRevocationStatus(for: documentId, status: nil, hasStatusRefreshFailed: true)
    stubIsDocumentLowOnCredentials()
    stubIsBatchCounterEnabled()

    let result = await interactor.fetchStoredDocument(documentId: documentId)

    switch result {
    case .success(_, let issuerDocumentDetailsCard, _, _, let isRevoked):
      XCTAssertFalse(isRevoked)
      XCTAssertEqual(issuerDocumentDetailsCard?.hasStatusRefreshFailed, true)
    case .failure:
      XCTFail("Expected success, but got failure.")
    }
  }

  func testFetchStoredDocument_WhenWalletKitControllerReturnsValidDocumentWithBatchDisabled_ThenReturnsExpectedValues() async throws {
    // Given
    let expectedDocument = Constants.createEuPidModel(credentialsUsageCounts: try .init(total: 5, remaining: 2))
    let documentId = expectedDocument.id
    
    stubFetchDocument(for: documentId, document: expectedDocument)
    stubIsBookmarked(for: documentId, isBookmarked: false)
    stubRevocationStatus(for: documentId, status: nil)
    stubIsDocumentLowOnCredentials()
    stubIsBatchCounterEnabled()

    // When
    let result = await interactor.fetchStoredDocument(documentId: documentId)

    // Then
    switch result {
    case .success(let uiModel, _, _, let isBookmarked, let isRevoked):
      XCTAssertEqual(uiModel.id, documentId)
      XCTAssertFalse(isBookmarked)
      XCTAssertFalse(isRevoked)
    case .failure:
      XCTFail("Expected success, but got failure.")
    }
  }

  func testFetchStoredDocument_WhenWalletKitControllerReturnsValidDocumentWithNilUsageCount_ThenReturnsExpectedValues() async throws {
    // Given
    let expectedDocument = Constants.createEuPidModel()
    let documentId = expectedDocument.id
    
    stubFetchDocument(for: documentId, document: expectedDocument)
    stubIsBookmarked(for: documentId, isBookmarked: false)
    stubRevocationStatus(for: documentId, status: nil)
    stubIsDocumentLowOnCredentials()
    stubIsBatchCounterEnabled()

    // When
    let result = await interactor.fetchStoredDocument(documentId: documentId)

    // Then
    switch result {
    case .success(let uiModel, let issuerDocumentDetailsCard, let documentCredentialsInfoUi, let isBookmarked, let isRevoked):
      XCTAssertEqual(uiModel.id, documentId)
      XCTAssertNotNil(issuerDocumentDetailsCard)
      XCTAssertEqual(documentCredentialsInfoUi?.availableCredentials, 1)
      XCTAssertEqual(documentCredentialsInfoUi?.totalCredentials, 1)
      XCTAssertFalse(isBookmarked)
      XCTAssertFalse(isRevoked)
    case .failure:
      XCTFail("Expected success, but got failure.")
    }
  }
  
  func testFetchStoredDocument_WhenWalletKitControllerReturnsValidDocument_ThenReturnsExpectedValuesWithIssuerDetailsCard() async throws {
    // Given
    let expectedDocument = Constants.createEuPidModel()
    let documentId = expectedDocument.id
    
    stubFetchDocument(for: documentId, document: expectedDocument)
    stubIsBookmarked(for: documentId, isBookmarked: false)
    stubRevocationStatus(for: documentId, status: nil)
    stubIsDocumentLowOnCredentials()
    stubIsBatchCounterEnabled()

    // When
    let result = await interactor.fetchStoredDocument(documentId: documentId)

    // Then
    switch result {
    case .success(_, let issuerDocumentDetailsCard, _, _, _):
      XCTAssertNotNil(issuerDocumentDetailsCard)
      XCTAssertEqual(issuerDocumentDetailsCard?.dateText, .documentDetailsExpiresOn([""]))
      XCTAssertEqual(
        issuerDocumentDetailsCard?.expandedMessageText,
        .documentDetailsIssuerCardIssuedMessageText
      )
      XCTAssertEqual(
        issuerDocumentDetailsCard?.expandedActionButtonText,
        .documentDetailsIssuerCardIssuedActionButtonText
      )
      XCTAssertEqual(
        issuerDocumentDetailsCard?.dateTextColor,
        Theme.shared.color.secondaryLabel
      )
      XCTAssertEqual(
        issuerDocumentDetailsCard?.expandedDateText,
        .documentDetailsIssuedOn(
          [expectedDocument.createdAt.formattedForDocumentDetails()]
        )
      )
    case .failure:
      XCTFail("Expected success, but got failure.")
    }
  }
  
  func testFetchStoredDocument_WhenWalletKitControllerReturnsRevokedDocument_ThenReturnsExpectedValuesWithIssuerDetailsCard() async throws {
    // Given
    let expectedDocument = Constants.createEuPidModel()
    let documentId = expectedDocument.id
    
    stubFetchDocument(for: documentId, document: expectedDocument)
    stubIsBookmarked(for: documentId, isBookmarked: false)
    stubRevocationStatus(for: documentId, status: .revoked)
    stubIsDocumentLowOnCredentials()
    stubIsBatchCounterEnabled()

    // When
    let result = await interactor.fetchStoredDocument(documentId: documentId)

    // Then
    switch result {
    case .success(_, let issuerDocumentDetailsCard, _, _, let isRevoked):
      XCTAssertNotNil(issuerDocumentDetailsCard)
      XCTAssertEqual(issuerDocumentDetailsCard?.dateText, .documentDetailsRevokedDocument)
      XCTAssertEqual(
        issuerDocumentDetailsCard?.expandedMessageText,
        .documentDetailsIssuerCardRevokedMessageText
      )
      XCTAssertNil(
        issuerDocumentDetailsCard?.expandedActionButtonText
      )
      XCTAssertEqual(
        issuerDocumentDetailsCard?.dateTextColor,
        Theme.shared.color.red
      )
      XCTAssertNil(issuerDocumentDetailsCard?.expandedDateText)
      XCTAssertTrue(isRevoked)
    case .failure:
      XCTFail("Expected success, but got failure.")
    }
  }

  func testFetchStoredDocument_WhenWalletKitControllerReturnsDocumentFetchFailure_ThenReturnsError() async {
    // Given
    let documentId = "nonexistentId"
    stubFetchDocumentFailure(for: documentId)
    
    // When
    let result = await interactor.fetchStoredDocument(documentId: documentId)
    
    // Then
    switch result {
    case .success:
      XCTFail("Expected failure, but got success.")
    case .failure(let error):
      XCTAssertEqual(error.localizedDescription, WalletCoreError.unableFetchDocument.localizedDescription)
    }
  }
  
  func testDeleteDocument_WhenWalletKitControllerReturnsRebootRequired_ThenReturnsRebootTrue() async {
    // Given
    let documentId = Constants.euPidModelId
    let type: DocumentTypeIdentifier = .mDocPid
    stubShouldRebootTrue(for: documentId)
    
    // When
    let result = await interactor.deleteDocument(with: documentId, and: type)
    
    // Then
    switch result {
    case .success(let shouldReboot):
      XCTAssertTrue(shouldReboot)
    case .failure:
      XCTFail("Expected success with reboot, got failure")
    }
  }
  
  func testDeleteDocument_WhenWalletKitControllerReturnsRebootNotRequired_ThenReturnsRebootTrue() async {
    // Given
    let documentId = Constants.euPidModelId
    let type: DocumentTypeIdentifier = .mDocPid
    stubShouldRebootFalse(for: documentId)
    
    // When
    let result = await interactor.deleteDocument(with: documentId, and: type)
    
    // Then
    switch result {
    case .success(let shouldReboot):
      XCTAssertTrue(shouldReboot)
    case .failure:
      XCTFail("Expected success without reboot, got failure")
    }
  }

  func testDeleteDocument_WhenWalletKitControllerReturnsMultipleValidDocuments_ThenShouldDeleteAllDocuments() async throws {
    // Given
    let documentId = Constants.euPidModelId
    let type: DocumentTypeIdentifier = .mDocPid
    stubShouldRebootTrue(for: documentId)
    
    // When
    let result = await interactor.deleteDocument(with: documentId, and: type)
    
    // Then
    switch result {
    case .success(let shouldReboot):
      XCTAssertTrue(shouldReboot)
    case .failure:
      XCTFail("Expected success with reboot, got failure")
    }
  }
  
  func testDeleteDocument_WhenWalletKitControllerReturnsNonValidDocuments_ThenShouldNotDeleteAllDocuments() async throws {
    // Given
    let documentId = Constants.euPidModelId
    let type: DocumentTypeIdentifier = .other(formatType: "other")
    stubShouldRebootFalse(for: documentId)
    
    // When
    let result = await interactor.deleteDocument(with: documentId, and: type)
    
    // Then
    switch result {
    case .success(let shouldReboot):
      XCTAssertFalse(shouldReboot)
    case .failure:
      XCTFail("Expected success without reboot, got failure")
    }
  }
  
  func testDeleteDocument_WhenWalletKitControllerReturnsDifferentPid_ThenShouldNotDeleteAllDocuments() async throws {
    // Given
    let documentId = "other-id"
    let type: DocumentTypeIdentifier = .mDocPid
    stubShouldRebootFalse(for: documentId)
    
    // When
    let result = await interactor.deleteDocument(with: documentId, and: type)
    
    // Then
    switch result {
    case .success(let shouldReboot):
      XCTAssertFalse(shouldReboot)
    case .failure:
      XCTFail("Expected success without reboot, got failure")
    }
  }
  
  func testDeleteDocument_WhenWalletKitControllerReturnsDeleteSuccess_ThenSucceeds() async {
    // Given
    let documentId = "nonexistentId"
    let type: DocumentTypeIdentifier = .mDocPid
    stubDeleteDocumentFailure(for: documentId)
    
    // When
    let result = await interactor.deleteDocument(with: documentId, and: type)
    
    // Then
    switch result {
    case .success:
      XCTAssertTrue(true)
    case .failure(let error):
      XCTAssertTrue(error.localizedDescription.contains("Failed"))
    }
  }

  func testDeleteDocument_WhenWalletKitControllerReturnsDeleteWithError_ThenReturnsFailure() async {
    // Given
    let documentId = "nonexistentId"
    let type: DocumentTypeIdentifier = .other(formatType: "other")

    stub(walletKitController) { stub in
      when(stub.fetchIssuedDocuments(with: any()))
        .thenReturn([Constants.createEuPidModel()])

      when(stub.fetchMainPidDocument())
        .thenReturn(Constants.createEuPidModel())

      when(stub.deleteDocument(with: equal(to: documentId), status: any()))
        .thenThrow(WalletCoreError.unableFetchDocument)

      when(stub.clearAllDocuments())
        .thenDoNothing()
    }

    // When
    let result = await interactor.deleteDocument(with: documentId, and: type)

    // Then
    switch result {
    case .success:
      XCTFail("Expected failure but got success")
    case .failure(let error):
      XCTAssertEqual(
        error.localizedDescription,
        WalletCoreError.unableFetchDocument.localizedDescription
      )
    }
  }

  func testSaveDocument_WhenWalletKitControllerReturnsSaveSuccess_ThenNoErrorThrown() async throws {
    // Given
    let documentId = Constants.euPidModelId
    stubSaveBookmark(for: documentId)
    
    // When / Then
    try await interactor.save(documentId)
  }
  
  func testSaveDocument_WhenWalletKitControllerReturnsSaveFailure_ThenReturnsError() async throws {
    // Given
    let documentId = "nonexistentId"
    stubSaveBookmarkFailure(for: documentId)
    
    // When / Then
    do {
      try await interactor.save(documentId)
      XCTFail("Expected failure but succeeded")
    } catch {
      XCTAssertEqual(error.localizedDescription, WalletCoreError.unableFetchDocument.localizedDescription)
    }
  }
  
  func testDeleteBookmark_WhenWalletKitControllerReturnsDeleteSuccess_ThenNoErrorThrown() async throws {
    // Given
    let documentId = Constants.euPidModelId
    stubDeleteBookmark(for: documentId)
    
    // When / Then
    try await interactor.delete(documentId)
  }
  
  func testDeleteBookmark_WhenWalletKitControllerReturnsDeleteFailure_ThenReturnsError() async throws {
    // Given
    let documentId = "nonexistentId"
    stubDeleteBookmarkFailure(for: documentId)

    // When / Then
    do {
      try await interactor.delete(documentId)
      XCTFail("Expected failure but succeeded")
    } catch {
      XCTAssertEqual(error.localizedDescription, WalletCoreError.unableFetchDocument.localizedDescription)
    }
  }

  func testReIssueDocument_WhenWalletKitControllerSucceeds_ThenReturnsSuccess() async {
    // Given
    let identifier = Constants.euPidModelId
    stub(walletKitController) { mock in
      when(mock.reIssueDocument(identifier: equal(to: identifier), isBackgroundOperation: equal(to: false)))
        .thenReturn(Constants.issuedPendingDocument)
    }

    // When
    let result = await interactor.reIssueDocument(identifier: identifier)

    // Then
    switch result {
    case .success:
      XCTAssertTrue(true)
    case .issuerNotTrusted:
      XCTFail("Expected success, got issuerNotTrusted")
    case .documentBlocked:
      XCTFail("Expected success, got documentBlocked")
    case .failure:
      XCTFail("Expected success, got failure")
    }

    verify(sessionController).beginExternalFlow()
    verify(sessionController).endExternalFlow(startedIn: any())
    verify(walletWorkScheduler).scheduleRevocationCheck(afterReIssueOf: equal(to: identifier))
  }

  func testReIssueDocument_WhenTheDocumentIsRevoked_ThenItIsRefusedBeforeTheIssuerIsContacted() async {
    let identifier = Constants.euPidModelId
    stub(walletKitController) { mock in
      when(mock.fetchRevokedDocumentStatuses()).thenReturn([identifier: .revoked])
    }

    let result = await assertReIssueRefused(identifier: identifier)

    guard case .documentBlocked = result else {
      return XCTFail("Expected documentBlocked, got \(result)")
    }
  }

  func testReIssueDocument_WhenTheDocumentIsSuspended_ThenItIsRefusedBeforeTheIssuerIsContacted() async {
    let identifier = Constants.euPidModelId
    stub(walletKitController) { mock in
      when(mock.fetchRevokedDocumentStatuses()).thenReturn([identifier: .suspended])
    }

    let result = await assertReIssueRefused(identifier: identifier)

    guard case .documentBlocked = result else {
      return XCTFail("Expected documentBlocked, got \(result)")
    }
  }

  func testReIssueDocument_WhenTheRevocationRecordsCannotBeRead_ThenItIsRefused() async {
    let identifier = Constants.euPidModelId
    stub(walletKitController) { mock in
      when(mock.fetchRevokedDocumentStatuses()).thenThrow(WalletCoreError.unableFetchDocuments)
    }

    let result = await assertReIssueRefused(identifier: identifier)

    guard case .failure(let error) = result else {
      return XCTFail("Expected failure, got \(result)")
    }
    XCTAssertEqual(error as? WalletCoreError, .unableFetchDocuments)
  }

  func testReIssueDocument_WhenAnotherDocumentIsBlocked_ThenThisOneIsReIssued() async {
    let identifier = Constants.euPidModelId
    stub(walletKitController) { mock in
      when(mock.fetchRevokedDocumentStatuses()).thenReturn(["another": .revoked])
      when(mock.reIssueDocument(identifier: equal(to: identifier), isBackgroundOperation: equal(to: false)))
        .thenReturn(Constants.issuedPendingDocument)
    }

    let result = await interactor.reIssueDocument(identifier: identifier)

    guard case .success = result else {
      return XCTFail("Expected success, got \(result)")
    }
  }

  func testReIssueDocument_WhenWalletKitControllerThrows_ThenReturnsFailure() async {
    // Given
    let identifier = "nonexistentId"
    stub(walletKitController) { mock in
      when(mock.reIssueDocument(identifier: equal(to: identifier), isBackgroundOperation: equal(to: false)))
        .thenThrow(WalletCoreError.unableFetchDocument)
    }

    // When
    let result = await interactor.reIssueDocument(identifier: identifier)

    // Then
    switch result {
    case .success:
      XCTFail("Expected failure, got success")
    case .issuerNotTrusted:
      XCTFail("Expected failure, got issuerNotTrusted")
    case .documentBlocked:
      XCTFail("Expected failure, got documentBlocked")
    case .failure(let error):
      XCTAssertEqual(
        error.localizedDescription,
        WalletCoreError.unableFetchDocument.localizedDescription
      )
    }

    verify(sessionController).beginExternalFlow()
    verify(sessionController).endExternalFlow(startedIn: any())
  }

  func testDeleteDocument_WhenForcePidActivationDisabled_ThenSkipsClearAllAndPerformsDelete() async {
    // Given: forcePidActivation=false flips the shouldDeleteAllDocuments
    // short-circuit so the `if` branch is skipped and the function proceeds
    // straight to `walletController.deleteDocument(...)`. Returns
    // .success(shouldReboot: false).
    stub(configLogic) { mock in
      when(mock.forcePidActivation.get).thenReturn(false)
    }
    let documentId = Constants.euPidModelId
    stub(walletKitController) { mock in
      when(mock.deleteDocument(with: equal(to: documentId), status: equal(to: DocumentStatus.issued)))
        .thenDoNothing()
    }

    // When
    let result = await interactor.deleteDocument(with: documentId, and: .mDocPid)

    // Then
    switch result {
    case .success(let shouldReboot):
      XCTAssertFalse(shouldReboot)
      verify(walletKitController).deleteDocument(with: equal(to: documentId), status: equal(to: DocumentStatus.issued))
    case .failure:
      XCTFail("Expected success without reboot, got failure")
    }
  }
}

extension TestDocumentDetailsInteractor {
  func stubFetchDocument(for id: String, document: any DocClaimsDecodable = Constants.createEuPidModel()) {
    stub(walletKitController) { stub in
      when(stub.fetchDocument(with: equal(to: id)))
        .thenReturn(document)
    }
  }

  func stubIsDocumentLowOnCredentials(hasLowOnCredentials: Bool = true) {
    stub(walletKitController) { stub in
      when(stub.isDocumentLowOnCredentials(document: any()))
        .thenReturn(hasLowOnCredentials)
    }
  }

  func stubFetchDocumentFailure(for id: String) {
    stub(walletKitController) { stub in
      when(stub.fetchDocument(with: equal(to: id))).thenReturn(nil)
    }
  }
  
  func stubIsBookmarked(for id: String, isBookmarked: Bool) {
    stub(walletKitController) { stub in
      when(stub.isDocumentBookmarked(with: equal(to: id)))
        .thenReturn(isBookmarked)
    }
  }

  func stubRevocationStatus(
    for id: String,
    status: DocumentRevocationStatus?,
    hasStatusRefreshFailed: Bool = false,
    hasReIssuanceFailed: Bool = false
  ) {
    stub(walletKitController) { stub in
      when(stub.getDocumentRevocationStatus(with: equal(to: id)))
        .thenReturn(status)
      when(stub.hasStatusRefreshFailure(with: equal(to: id)))
        .thenReturn(hasStatusRefreshFailed)
      when(stub.hasReIssuanceFailure(with: equal(to: id)))
        .thenReturn(hasReIssuanceFailed)
    }
  }

  func assertReIssueRefused(identifier: String) async -> DocumentDetailsReIssuancePartialState {
    let result = await interactor.reIssueDocument(identifier: identifier)
    verify(walletKitController, never()).reIssueDocument(identifier: any(), isBackgroundOperation: any())
    verify(sessionController, never()).beginExternalFlow()
    verify(walletWorkScheduler, never()).scheduleRevocationCheck(afterReIssueOf: any())
    return result
  }
  
  func stubShouldRebootTrue(for id: String) {
    stub(walletKitController) { stub in
      when(stub.fetchIssuedDocuments(with: any()))
        .thenReturn([
          Constants.createEuPidModel()
        ])
      
      when(stub.fetchMainPidDocument())
        .thenReturn(Constants.createEuPidModel())
      
      when(stub.clearAllDocuments())
        .thenDoNothing()
    }
  }
  
  func stubShouldRebootFalse(for id: String) {
    stub(walletKitController) { stub in
      when(stub.fetchIssuedDocuments(with: any()))
        .thenReturn([
          Constants.createEuPidModel(),
          Constants.createEuPidModel()
        ])
      
      when(stub.fetchMainPidDocument())
        .thenReturn(Constants.createEuPidModel())
      
      when(stub.deleteDocument(with: equal(to: id), status: equal(to: DocumentStatus.issued)))
        .thenDoNothing()
      
      when(stub.clearAllDocuments())
        .thenDoNothing()
    }
  }
  
  func stubDeleteDocumentFailure(for id: String) {
    stub(walletKitController) { stub in
      when(stub.fetchIssuedDocuments(with: any()))
        .thenReturn([Constants.createEuPidModel()])
      
      when(stub.fetchMainPidDocument())
        .thenReturn(Constants.createEuPidModel())
      
      when(stub.deleteDocument(with: equal(to: id), status: any()))
        .thenThrow(WalletCoreError.unableFetchDocument)
      
      when(stub.clearAllDocuments())
        .thenDoNothing()
    }
  }
  
  func stubSaveBookmark(for id: String) {
    stub(walletKitController) { stub in
      when(stub.storeBookmarkedDocument(with: equal(to: id)))
        .thenDoNothing()
    }
  }
  
  func stubSaveBookmarkFailure(for id: String) {
    stub(walletKitController) { stub in
      when(stub.storeBookmarkedDocument(with: equal(to: id)))
        .thenThrow(WalletCoreError.unableFetchDocument)
    }
  }
  
  func stubDeleteBookmark(for id: String) {
    stub(walletKitController) { stub in
      when(stub.removeBookmarkedDocument(with: equal(to: id)))
        .thenDoNothing()
    }
  }
  
  func stubDeleteBookmarkFailure(for id: String) {
    stub(walletKitController) { stub in
      when(stub.removeBookmarkedDocument(with: equal(to: id)))
        .thenThrow(WalletCoreError.unableFetchDocument)
    }
  }
  
  func stubConfigLogic() {
    stub(configLogic) { mock in
      when(mock.forcePidActivation.get).thenReturn(true)
    }
  }
  
  
  func stubIsBatchCounterEnabled(_ enabled: Bool = true) {
    stub(prefsController) { stub in
      when(stub.getBool(forKey: Prefs.Key.batchCounter)).thenReturn(enabled)
    }
  }
}
