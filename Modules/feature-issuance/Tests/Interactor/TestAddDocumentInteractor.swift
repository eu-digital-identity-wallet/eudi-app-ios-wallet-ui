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
  
  func testFetchScopedDocuments_whenScopedDocuments_thenReturnsSuccess() async throws {
    // Given
    stubGetScopedDocumentsSuccess(with: [
      Constants.scopedDocument
    ])
    
    // When
    let result = await interactor.fetchScopedDocuments(with: .extraDocument(filterType: nil))
    
    // Then
    switch result {
    case .success(let documents):
      XCTAssertEqual(documents.count, 1)
      let firstEntry = try XCTUnwrap(documents.elements.first)
      let firstModel = try XCTUnwrap(firstEntry.value.first)
      XCTAssertEqual(firstModel.configId, "test-config-id")
    default:
      XCTFail("Expected success but got \(result)")
    }
  }
  
  func testFetchScopedDocuments_whenScopedDocumentsCompare_thenReturnsSuccess() async throws {
    // Given
    stubGetScopedDocumentsSuccess(with: [
      Constants.scopedDocument,
      Constants.scopedDocumentNotPid
    ])
    
    // When
    let result = await interactor.fetchScopedDocuments(with: .extraDocument(filterType: nil))
    
    // Then
    switch result {
    case .success(let documents):
      let firstEntry = try XCTUnwrap(documents.elements.first)
      XCTAssertEqual(firstEntry.value.count, 2)
    default:
      XCTFail("Expected success but got \(result)")
    }
  }
  
  func testFetchScopedDocuments_whenGetScopedDocuments_thenReturnsSuccess() async {
    // Given
    stubGetScopedDocumentsSuccess(with: [
      Constants.scopedDocumentNotPid
    ])
    
    // When
    let result = await interactor.fetchScopedDocuments(with: .noDocument)
    
    // Then
    switch result {
    case .success(let documents):
      XCTAssertEqual(documents.count, 0)
    default:
      XCTFail("Expected success but got \(result)")
    }
  }
  
  func testFetchScopedDocuments_whenGetScopedDocuments_thenReturnsFailure() async {
    // Given
    stubGetScopedDocumentsFailure()
    
    // When
    let result = await interactor.fetchScopedDocuments(with: .extraDocument(filterType: nil))
    
    // Then
    switch result {
    case .failure(let error):
      XCTAssertTrue(error is WalletCoreError)
    default:
      XCTFail("Expected failure but got \(result)")
    }
  }
  
  func testIssueDocument_whenDefferedPendingDocument_thenReturnSuccess() async {
    // Given
    let configId = "deferred-doc"
    let issuerId = "issuer.dev"
    let identifier = DocumentTypeIdentifier(rawValue: "eu.europa.ec.eudi.pid.1")
    let document = Constants.defferedPendingDocument
    
    stubResumeDynamicIssuanceDefferedSuccess(document: document)
    
    // When
    let result = await interactor.issueDocument(
      issuerId: issuerId,
      configId: configId,
      docTypeIdentifier: identifier
    )
    
    // Then
    switch result {
    case .deferredSuccess:
      XCTAssertTrue(true)
    default:
      XCTFail("Expected .deferredSuccess but got \(result)")
    }
  }
  
  func testIssueDocument_whenIssuedDocument_thenReturnSuccess() async {
    // Given
    let issuerId = "issuer.dev"
    let configId = "deferred-doc"
    let identifier = DocumentTypeIdentifier(rawValue: "eu.europa.ec.eudi.pid.1")
    let document = Constants.issuedPendingDocument
    
    stubResumeDynamicIssuanceDefferedSuccess(document: document)
    
    // When
    let result = await interactor.issueDocument(
      issuerId: issuerId,
      configId: configId,
      docTypeIdentifier: identifier
    )
    
    // Then
    switch result {
    case .success:
      XCTAssertTrue(true)
    default:
      XCTFail("Expected .deferredSuccess but got \(result)")
    }
  }
  
  func testIssueDocument_whenDefferedPendingDocument_thenReturnsFailure() async {
    // Given
    let configId = "fail-doc"
    let issuerId = "issuer.dev"
    let identifier = DocumentTypeIdentifier(rawValue: "eu.europa.ec.eudi.pid.1")
    
    stubIssueDocumentFailure(
      issuerId: issuerId,
      configId: configId,
      docTypeIdentifier: identifier
    )
    
    // When
    let result = await interactor.issueDocument(
      issuerId: issuerId,
      configId: configId,
      docTypeIdentifier: identifier
    )
    
    // Then
    switch result {
    case .failure(let error):
      XCTAssertEqual(error as? WalletCoreError, WalletCoreError.unableToIssueAndStore)
    default:
      XCTFail("Expected .failure but got \(result)")
    }
  }
  
  func testResumeDynamicIssuance_whenDefferedPending_thenReturnDefferedSuccess() async {
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
  
  func testResumeDynamicIssuance_whenIssuePending_thenReturnSuccess() async {
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
  
  func testResumeDynamicIssuance_whenIssuePending_thenIssuanceFails() async {
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
  
  func testResumeDynamicIssuance_whenPending_thenReturnSuccess() async {
    // Given
    let pendingDoc = Constants.pendingDocument
    
    let pendingData = DynamicIssuancePendingData(
      pendingDoc: pendingDoc,
      url: URL(string: "https://example.com")!
    )
    
    stubResumeDynamicIssuanceIssued(pendingData: pendingData, pendingDoc: pendingDoc)
    
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
  
  func testResumeDynamicIssuance_whenReturnsNoPending_thenNoPendingDataExists() async {
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
  
  func testGetScopedDocument_whenScopedDocument_thenReturnsMatchingDocument() async throws {
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
  
  func testGetScopedDocument_whenGetScopedDocument_thenNoMatchingDocument() async throws {
    let configId = "non-existent-config"
    let scopedDocument = Constants.scopedDocument
    
    stubGetScopedDocuments(with: [
      scopedDocument
    ])
    
    let result = try await interactor.getScopedDocument(configId: configId)
    XCTAssertEqual(result, ScopedDocument.empty())
  }
  
  func testGetScopedDocument_whenGetScopedDocuments_thenNoDocumentsAvailable() async throws {
    let configId = "test-config-id"
    
    stub(walletKitController) { stub in
      when(stub.getScopedDocuments())
        .thenReturn([])
    }
    
    let result = try await interactor.getScopedDocument(configId: configId)
    XCTAssertEqual(result, ScopedDocument.empty())
  }
  
  func testGetScopedDocument_whenGetScopedDocuments_thenThrowError() async {
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
  
  func testFetchStoredDocuments_whenDocumentsExist_thenReturnsSuccess() async {
    // Given
    let documentIds = [
      "doc-id-1",
      "doc-id-2"
    ]
    let pidDocument = Constants.createEuPidModel()
    let mdlDocument = Constants.createIsoMdlModel()
    
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
  
  func testFetchStoredDocuments_whenDocumentsDoNotExist_thenReturnsFailure() async {
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
  
  func testFetchStoredDocuments_whenNoDocumentsReturned_thenReturnsFailure() async {
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
  
  func testFetchScopedDocuments_WhenDocumentsReturned_ThenReturnsSuccessMocks() async throws {
    // Given
    let issuerId = "issuer.dev"
    let secondaryIssuerId = "issuer2.dev"
    let scopedDocument1 = ScopedDocument(
      name: "Document name 1",
      issuer: issuerId,
      configId: "id1",
      isPid: true,
      docTypeIdentifier: .mDocPid
    )
    
    let scopedDocument2 = ScopedDocument(
      name: "Document name 2",
      issuer: issuerId,
      configId: "id2",
      isPid: true,
      docTypeIdentifier: .mDocPid
    )
    
    let scopedDocument3 = ScopedDocument(
      name: "Document name 3",
      issuer: issuerId,
      configId: "id3",
      isPid: true,
      docTypeIdentifier: .mDocPid
    )
    
    let scopedDocument4 = ScopedDocument(
      name: "Document name 4",
      issuer: secondaryIssuerId,
      configId: "id4",
      isPid: true,
      docTypeIdentifier: .mDocPid
    )
    
    stubGetScopedDocumentsSuccess(with: [
      scopedDocument1,
      scopedDocument2,
      scopedDocument3,
      scopedDocument4
    ])
    
    // When
    let result = await interactor.fetchScopedDocuments(with: .extraDocument(filterType: nil))
    
    // Then
    switch result {
    case .success(let documents):
      
      XCTAssertEqual(documents.count, 2)
      XCTAssertNotNil(documents[issuerId])
      XCTAssertNotNil(documents[secondaryIssuerId])
      
      let firstModel = try XCTUnwrap(documents[issuerId]?.first)
      XCTAssertEqual(firstModel.configId, scopedDocument1.configId)
      
      let secondaryModel = try XCTUnwrap(documents[secondaryIssuerId]?.first)
      XCTAssertEqual(secondaryModel.configId, scopedDocument4.configId)
    default:
      XCTFail("Expected success but got \(result)")
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
  
  func stubIssueDocumentFailure(issuerId: String, configId: String, docTypeIdentifier: DocumentTypeIdentifier) {
    stub(walletKitController) { stub in
      when(
        stub.issueDocuments(
          issuerId: equal(to: issuerId),
          identifiers: equal(to: [configId]),
          docTypeIdentifier: equal(to: docTypeIdentifier)
        )
      ).thenThrow(WalletCoreError.unableToIssueAndStore)
    }
  }
  
  func stubResumeDynamicIssuanceDefferedSuccess(
    document: WalletStorage.Document
  ) {
    stub(walletKitController) { stub in
      when(
        stub.issueDocuments(
          issuerId: equal(to: "issuer.dev"),
          identifiers: equal(to: ["deferred-doc"]),
          docTypeIdentifier: equal(to: DocumentTypeIdentifier.init(rawValue: "eu.europa.ec.eudi.pid.1"))
        )
      )
      .thenReturn([document])
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
