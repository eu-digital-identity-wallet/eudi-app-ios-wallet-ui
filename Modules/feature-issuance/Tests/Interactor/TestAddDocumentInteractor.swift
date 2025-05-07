/*
 * Copyright (c) 2023 European Commission
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
@testable import feature_common
@testable import feature_issuance

final class TestAddDocumentInteractor: EudiTest {
  
  var interactor: AddDocumentInteractor!
  var walletKitController: MockWalletKitController!
  
  override func setUp() {
    super.setUp()
    self.walletKitController = MockWalletKitController()
    self.interactor = AddDocumentInteractorImpl(
      walletController: walletKitController
    )
  }
  
  override func tearDown() {
    self.interactor = nil
    self.walletKitController = nil
  }
  
  func test_fetchScopedDocuments_withValidFlow_returnsSuccess() async {
    // Given
    stubGetScopedDocumentsSuccess(with: [
      Constants.scopedDocument
    ])
    
    // When
    let result = await interactor.fetchScopedDocuments(with: .extraDocument)
    
    // Then
    switch result {
    case .success(let documents):
      XCTAssertEqual(documents.count, 1)
      XCTAssertEqual(documents.first?.configId, "test-config-id")
    default:
      XCTFail("Expected success but got \(result)")
    }
  }
  
  func test_fetchScopedDocuments_whenThrowsError_returnsFailure() async {
    // Given
    stubGetScopedDocumentsFailure()
    
    // When
    let result = await interactor.fetchScopedDocuments(with: .extraDocument)
    
    // Then
    switch result {
    case .failure(let error):
      XCTAssertTrue(error is WalletCoreError)
    default:
      XCTFail("Expected failure but got \(result)")
    }
  }
  
  func test_issueDocument_returnsDeferredSuccess_whenDocumentIsDeferred() async {
    // Given
    let configId = "deferred-doc"
    let document = Constants.defferedPendingDocument
    
    stubResumeDynamicIssuanceDefferedSuccess(document: document)
    
    // When
    let result = await interactor.issueDocument(configId: configId)
    
    // Then
    switch result {
    case .deferredSuccess:
      XCTAssertTrue(true)
    default:
      XCTFail("Expected .deferredSuccess but got \(result)")
    }
  }
  
  func test_issueDocument_returnsFailure_whenIssuanceThrowsError() async {
    // Given
    let configId = "fail-doc"
    
    stubIssueDocumentFailure(configId: configId)
    
    // When
    let result = await interactor.issueDocument(configId: configId)
    
    // Then
    switch result {
    case .failure(let error):
      XCTAssertEqual(error as? WalletCoreError, WalletCoreError.unableToIssueAndStore)
    default:
      XCTFail("Expected .failure but got \(result)")
    }
  }
  
  func test_resumeDynamicIssuance_returnsDeferredSuccess_whenDocumentIsDeferred() async {
    // Given
    let pendingDoc = Constants.defferedPendingDocument
    
    let pendingData = DynamicIssuancePendingData(
      pendingDoc: pendingDoc,
      url: URL(string: "https://example.com")!
    )
    
    stubResumeDynamicIssuanceDeffered(pendingData: pendingData, pendingDoc: pendingDoc)
    
    // When
    let result = await interactor.resumeDynamicIssuance()
    
    // Then
    switch result {
    case .deferredSuccess:
      XCTAssertTrue(true)
    default:
      XCTFail("Expected .deferredSuccess but got \(result)")
    }
  }
  
  func test_resumeDynamicIssuance_returnsSuccess_whenDocumentIsIssued() async {
    // Given
    let pendingDoc = Constants.issuedPendingDocument
    
    
    let pendingData = DynamicIssuancePendingData(
      pendingDoc: pendingDoc,
      url: URL(string: "https://example.com")!
    )
    
    stubResumeDynamicIssuanceIssued(pendingData: pendingData, pendingDoc: pendingDoc)
    
    // When
    let result = await interactor.resumeDynamicIssuance()
    
    // Then
    switch result {
    case .success(let id):
      XCTAssertEqual(id, "doc-id")
    default:
      XCTFail("Expected .success but got \(result)")
    }
  }
  
  func test_resumeDynamicIssuance_returnsFailure_whenIssuanceFails() async {
    // Given
    let pendingDoc = Constants.issuedPendingDocument
    
    let pendingData = DynamicIssuancePendingData(
      pendingDoc: pendingDoc,
      url: URL(string: "https://example.com")!
    )
    
    stubResumeDynamicIssuanceIssuedFailuer(pendingData: pendingData, pendingDoc: pendingDoc)
    
    // When
    let result = await interactor.resumeDynamicIssuance()
    
    // Then
    switch result {
    case .failure(let error):
      XCTAssertEqual(error as? WalletCoreError, WalletCoreError.unableToIssueAndStore)
    default:
      XCTFail("Expected .failure but got \(result)")
    }
  }
  
  func test_resumeDynamicIssuance_returnsNoPending_whenNoPendingDataExists() async {
    // Given
    stub(walletKitController) { stub in
      when(stub.getDynamicIssuancePendingData()
      ).thenReturn(nil)
    }
    
    // When
    let result = await interactor.resumeDynamicIssuance()
    
    // Then
    switch result {
    case .noPending:
      XCTAssertTrue(true)
    default:
      XCTFail("Expected .noPending but got \(result)")
    }
  }
  
  func test_getScopedDocument_returnsMatchingDocument() async throws {
    // Given
    let configId = "test-config-id"
    let scopedDocument = Constants.scopedDocument
    
    stubGetScopedDocuments(with: [
      scopedDocument
    ])
    
    // When
    let result = try await interactor.getScopedDocument(configId: configId)
    
    // Then
    XCTAssertEqual(result, scopedDocument)
  }
  
  func test_getScopedDocument_returnsEmpty_whenNoMatchingDocument() async throws {
    let configId = "non-existent-config"
    let scopedDocument = Constants.scopedDocument
    
    stubGetScopedDocuments(with: [
      scopedDocument
    ])
    
    let result = try await interactor.getScopedDocument(configId: configId)
    XCTAssertEqual(result, ScopedDocument.empty())
  }
  
  func test_getScopedDocument_returnsEmpty_whenNoDocumentsAvailable() async throws {
    let configId = "test-config-id"
    
    stub(walletKitController) { stub in
      when(stub.getScopedDocuments())
        .thenReturn([])
    }
    
    let result = try await interactor.getScopedDocument(configId: configId)
    XCTAssertEqual(result, ScopedDocument.empty())
  }
  
  func test_getScopedDocument_throwsError_whenFetchingFails() async {
    let configId = "test-config-id"
    
    stub(walletKitController) { stub in
      when(stub.getScopedDocuments())
        .thenThrow(WalletCoreError.unableFetchDocument)
    }
    
    do {
      _ = try await interactor.getScopedDocument(configId: configId)
      XCTFail("Expected error but got success")
    } catch {
      XCTAssertEqual(error as? WalletCoreError, .unableFetchDocument)
    }
  }
  
  func test_getHoldersName_returnsFullName_whenDocumentExists() {
    // Given
    let documentIdentifier = Constants.euPidModelId
    let document = Constants.euPidModel
    
    stub(walletKitController) { stub in
      when(stub.fetchDocument(with: equal(to: documentIdentifier)))
        .thenReturn(document)
    }
    
    // When
    let result = interactor.getHoldersName(for: documentIdentifier)
    
    // Then
    XCTAssertEqual(result, "John Doe", "Expected the holder's name to be 'John Doe' but got \(String(describing: result))")
  }
  
  func test_getHoldersName_returnsNil_whenDocumentNotFound() {
    // Given
    let documentIdentifier = "test-config-id"
    
    stub(walletKitController) { stub in
      when(stub.fetchDocument(with: equal(to: documentIdentifier)))
        .thenReturn(nil)
    }
    
    // When
    let result = interactor.getHoldersName(for: documentIdentifier)
    
    // Then
    XCTAssertNil(result, "Expected result to be nil when document does not exist")
  }
  
  func test_getHoldersName_returnsNil_whenNameIsMissing() {
    // Given
    let documentIdentifier = Constants.euPidModelId
    var document = Constants.euPidModel
    document.docClaims = []  // Χωρίς όνομα
    
    stub(walletKitController) { stub in
      when(stub.fetchDocument(with: equal(to: documentIdentifier)))
        .thenReturn(document)
    }
    
    // When
    let result = interactor.getHoldersName(for: documentIdentifier)
    
    // Then
    XCTAssertNil(result, "Expected nil when holder's name is missing")
  }
  
  func test_getDocumentSuccessCaption_returnsCaption_whenDocumentExistsWithDisplayName() {
    // Given
    let documentIdentifier = Constants.euPidModelId
    let document = Constants.euPidModel
    
    stub(walletKitController) { stub in
      when(stub.fetchDocument(with: equal(to: documentIdentifier)))
        .thenReturn(document)
    }
    
    // When
    let result = interactor.getDocumentSuccessCaption(for: documentIdentifier)
    
    // Then
    XCTAssertEqual(result, .issuanceSuccessCaption([Constants.euPidName]))
  }
  
  func test_getDocumentSuccessCaption_returnsCaptionWithEmptyString_whenDocumentExistsWithoutDisplayName() {
    // Given
    let documentIdentifier = Constants.euPidModelId
    var document = Constants.euPidModel
    document.displayName = nil
    
    stub(walletKitController) { stub in
      when(stub.fetchDocument(with: equal(to: documentIdentifier)))
        .thenReturn(document)
    }
    
    // When
    let result = interactor.getDocumentSuccessCaption(for: documentIdentifier)
    
    // Then
    XCTAssertEqual(result, .issuanceSuccessCaption([""]))
  }
  
  func test_getDocumentSuccessCaption_returnsNil_whenDocumentDoesNotExist() {
    // Given
    let documentIdentifier = "non-existent-document"
    
    stub(walletKitController) { stub in
      when(stub.fetchDocument(with: equal(to: documentIdentifier)))
        .thenReturn(nil)
    }
    
    // When
    let result = interactor.getDocumentSuccessCaption(for: documentIdentifier)
    
    // Then
    XCTAssertNil(result, "Expected nil when document does not exist")
  }
  
  func test_fetchStoredDocuments_returnsSuccess_whenDocumentsExist() async {
    // Given
    let documentIds = [
      "doc-id-1",
      "doc-id-2"
    ]
    let pidDocument = Constants.euPidModel
    let mdlDocument = Constants.isoMdlModel
    
    let transformedPidDocument = pidDocument.transformToDocumentUi(isSensitive: false)
    let transformedMdlDocument = mdlDocument.transformToDocumentUi(isSensitive: false)
    
    stub(walletKitController) { stub in
      when(stub.fetchDocuments(with: equal(to: documentIds)))
        .thenReturn([pidDocument, mdlDocument])
    }
    
    // When
    let result = await interactor.fetchStoredDocuments(documentIds: documentIds)
    
    // Then
    switch result {
    case .success(let documents):
      XCTAssertEqual(documents.count, 2)
      XCTAssertEqual(documents[0], transformedPidDocument)
      XCTAssertEqual(documents[1], transformedMdlDocument)
    default:
      XCTFail("Expected .success but got \(result)")
    }
  }
  
  func test_fetchStoredDocuments_returnsFailure_whenDocumentsDoNotExist() async {
    // Given
    let documentIds = ["non-existent-doc"]
    
    stub(walletKitController) { stub in
      when(stub.fetchDocuments(with: equal(to: documentIds)))
        .thenReturn([])
    }
    
    // When
    let result = await interactor.fetchStoredDocuments(documentIds: documentIds)
    
    // Then
    switch result {
    case .failure(let error):
      XCTAssertEqual(error as! WalletCoreError, WalletCoreError.unableFetchDocument)
    default:
      XCTFail("Expected .failure but got \(result)")
    }
  }
  
  func test_fetchStoredDocuments_returnsFailure_whenNoDocumentsReturned() async {
    // Given
    let documentIds: [String] = []
    
    stub(walletKitController) { stub in
      when(stub.fetchDocuments(with: equal(to: documentIds)))
        .thenReturn([])
    }
    
    // When
    let result = await interactor.fetchStoredDocuments(documentIds: documentIds)
    
    // Then
    switch result {
    case .failure(let error):
      XCTAssertEqual(error as! WalletCoreError, WalletCoreError.unableFetchDocument)
    default:
      XCTFail("Expected .failure but got \(result)")
    }
  }
}

private extension TestAddDocumentInteractor {
  func stubGetScopedDocuments(with document: [ScopedDocument]) {
    stub(walletKitController) { stub in
      when(stub.getScopedDocuments())
        .thenReturn(document)
    }
  }
  
  func stubGetScopedDocumentsSuccess(with documents: [ScopedDocument]) {
    stub(walletKitController) { stub in
      when(stub.getScopedDocuments()
      ).thenReturn(documents)
    }
  }
  
  func stubGetScopedDocumentsFailure() {
    stub(walletKitController) { stub in
      when(stub.getScopedDocuments()
      ).thenThrow(WalletCoreError.unableFetchDocument)
    }
  }
  
  func stubIssueDocumentFailure(configId: String) {
    stub(walletKitController) { stub in
      when(stub.issueDocument(
        identifier: equal(to: configId))
      ).thenThrow(WalletCoreError.unableToIssueAndStore)
    }
  }
  
  func stubResumeDynamicIssuanceDefferedSuccess(
    document: WalletStorage.Document
  ) {
    stub(walletKitController) { stub in
      when(stub.issueDocument(identifier: equal(to: "deferred-doc")))
        .thenReturn(document)
    }
  }
  
  func stubResumeDynamicIssuanceDeffered(
    pendingData: DynamicIssuancePendingData,
    pendingDoc: WalletStorage.Document
  ) {
    stub(walletKitController) { stub in
      when(stub.getDynamicIssuancePendingData()
      ).thenReturn(pendingData)
      
      when(stub.resumePendingIssuance(
        pendingDoc: any(),
        webUrl: equal(to: pendingData.url))
      ).thenReturn(pendingDoc)
    }
  }
  
  func stubResumeDynamicIssuanceIssued(
    pendingData: DynamicIssuancePendingData,
    pendingDoc: WalletStorage.Document
  ) {
    stub(walletKitController) { stub in
      when(stub.getDynamicIssuancePendingData()
      ).thenReturn(pendingData)
      
      when(stub.resumePendingIssuance(
        pendingDoc: any(),
        webUrl: equal(to: pendingData.url))
      ).thenReturn(pendingDoc)
    }
  }
  
  func stubResumeDynamicIssuanceIssuedFailuer(
    pendingData: DynamicIssuancePendingData,
    pendingDoc: WalletStorage.Document
  ) {
    stub(walletKitController) { stub in
      when(stub.getDynamicIssuancePendingData()
      ).thenReturn(pendingData)
      
      when(stub.resumePendingIssuance(
        pendingDoc: any(),
        webUrl: equal(to: pendingData.url))
      ).thenThrow(WalletCoreError.unableToIssueAndStore)
    }
  }
}
