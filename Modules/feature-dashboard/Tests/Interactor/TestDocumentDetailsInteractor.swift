/*
 * Copyright (c) 2025 European Commission
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

final class TestDocumentDetailsInteractor: EudiTest {
  
  var interactor: DocumentDetailsInteractor!
  var walletKitController: MockWalletKitController!
  var prefsController: MockPrefsController!

  override func setUp() {
    self.walletKitController = MockWalletKitController()
    self.prefsController = MockPrefsController()
    self.interactor = DocumentDetailsInteractorImpl(
      walletController: walletKitController,
      prefsController: prefsController
    )
  }
  
  override func tearDown() {
    self.interactor = nil
    self.walletKitController = nil
    self.prefsController = nil
  }
  
  func testFetchStoredDocument_WhenWalletKitControllerReturnsValidDocument_ThenReturnsExpectedValues() async throws {
    // Given
    let expectedDocument = Constants.createEuPidModel(credentialsUsageCounts: try .init(total: 10, remaining: 10))
    let documentId = expectedDocument.id
    
    stubFetchDocument(for: documentId, document: expectedDocument)
    stubIsBookmarked(for: documentId, isBookmarked: false)
    stubIsRevoked(for: documentId, isRevoked: false)
    stubIsDocumentLowOnCredentials()

    // When
    let result = await interactor.fetchStoredDocument(documentId: documentId)
    
    // Then
    switch result {
    case .success(let uiModel, let documentCredentialsInfoUi, let isBookmarked, let isRevoked):
      XCTAssertEqual(uiModel.id, documentId)
      XCTAssertEqual(documentCredentialsInfoUi?.availableCredentials, 10)
      XCTAssertEqual(documentCredentialsInfoUi?.totalCredentials, 10)
      XCTAssertFalse(isBookmarked)
      XCTAssertFalse(isRevoked)
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
    stubIsRevoked(for: documentId, isRevoked: false)
    stubIsDocumentLowOnCredentials()

    // When
    let result = await interactor.fetchStoredDocument(documentId: documentId)

    // Then
    switch result {
    case .success(let uiModel, _, let isBookmarked, let isRevoked):
      XCTAssertEqual(uiModel.id, documentId)
      XCTAssertFalse(isBookmarked)
      XCTAssertFalse(isRevoked)
    case .failure:
      XCTFail("Expected success, but got failure.")
    }
  }

  func testFetchStoredDocument_WhenWalletKitControllerReturnsValidDocumentWithNilUsageCount_ThenReturnsExpectedValues() async {
    // Given
    let expectedDocument = Constants.createEuPidModel()
    let documentId = expectedDocument.id
    
    stubFetchDocument(for: documentId, document: expectedDocument)
    stubIsBookmarked(for: documentId, isBookmarked: false)
    stubIsRevoked(for: documentId, isRevoked: false)
    stubIsDocumentLowOnCredentials()

    // When
    let result = await interactor.fetchStoredDocument(documentId: documentId)

    // Then
    switch result {
    case .success(let uiModel, let documentCredentialsInfoUi, let isBookmarked, let isRevoked):
      XCTAssertEqual(uiModel.id, documentId)
      XCTAssertEqual(documentCredentialsInfoUi?.availableCredentials, 1)
      XCTAssertEqual(documentCredentialsInfoUi?.totalCredentials, 1)
      XCTAssertFalse(isBookmarked)
      XCTAssertFalse(isRevoked)
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
}

extension TestDocumentDetailsInteractor {
  func stubFetchDocument(for id: String, document: DocClaimsDecodable = Constants.createEuPidModel()) {
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

  func stubIsRevoked(for id: String, isRevoked: Bool) {
    stub(walletKitController) { stub in
      when(stub.isDocumentRevoked(with: equal(to: id)))
        .thenReturn(isRevoked)
    }
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
}
