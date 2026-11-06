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
import EudiWalletKit

@testable import logic_core
@testable import logic_test
@testable import feature_test
@testable import feature_common
@testable import feature_issuance

final class TestAddDocumentInteractor: EudiTest {
  
  var interactor: AddDocumentInteractor!
  var walletKitController: MockWalletKitController!
  var sessionController: MockSessionController!
  
  override func setUp() {
    super.setUp()
    self.walletKitController = MockWalletKitController()
    stub(walletKitController) { mock in
      when(mock.issuerLogoOrigins()).thenReturn(IssuerLogoOrigins(logoOriginsByIssuer: [:]))
    }

    stub(walletKitController) { mock in
      when(mock.getIssuerRegistration(issuerId: any(), configIds: any())).thenReturn(
        .verified(
          details: RegistrationDetails(
            tradeName: "issuer",
            uniqueId: "issuer",
            logoUrl: nil,
            intendedUse: nil,
            privacyPolicyUrl: nil,
            serviceDescription: nil
          )
        )
      )
    }

    self.sessionController = MockSessionController()
    stub(sessionController) { mock in
      when(mock.beginExternalFlow()).thenReturn(0)
      when(mock.endExternalFlow(startedIn: any())).thenDoNothing()
    }
    self.interactor = AddDocumentInteractorImpl(
      walletController: walletKitController,
      sessionController: sessionController
    )
  }
  
  override func tearDown() {
    self.sessionController = nil
    self.interactor = nil
    self.walletKitController = nil
  }
  
  func testFetchScopedDocuments_WhenScopedDocuments_ThenReturnsSuccess() async throws {
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
      XCTAssertEqual(firstModel.configIds, ["test-config-id"])
    default:
      XCTFail("Expected success but got \(result)")
    }
  }
  
  func testFetchScopedDocuments_WhenScopedDocumentsCompare_ThenReturnsSuccess() async throws {
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
  
  func testFetchScopedDocuments_WhenGetScopedDocuments_ThenReturnsSuccess() async {
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
  
  func testFetchScopedDocuments_WhenGetScopedDocuments_ThenReturnsFailure() async {
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
  
  func testFetchScopedDocuments_WhenOneIssuerFailsAndAnotherSucceeds_ThenReturnsSuccessSilently() async throws {
    // Given
    stubGetScopedDocuments(
      documents: [Constants.scopedDocument],
      errors: [WalletError(description: "trust", code: .trustError)],
      totalIssuers: 2
    )

    // When
    let result = await interactor.fetchScopedDocuments(with: .extraDocument(filterType: nil))

    // Then
    switch result {
    case .success(let documents):
      XCTAssertEqual(documents.count, 1)
    default:
      XCTFail("Expected success but got \(result)")
    }
  }

  func testFetchScopedDocuments_WhenAllIssuersFailAndOneIsUntrusted_ThenReturnsIssuerNotTrusted() async {
    // Given a mix of a generic and a trust failure, the trust failure wins.
    stubGetScopedDocuments(
      documents: [],
      errors: [
        WalletCoreError.unableFetchDocument,
        WalletError(description: "trust", code: .trustError)
      ],
      totalIssuers: 2
    )

    // When
    let result = await interactor.fetchScopedDocuments(with: .extraDocument(filterType: nil))

    // Then
    switch result {
    case .issuerNotTrusted:
      break
    default:
      XCTFail("Expected issuerNotTrusted but got \(result)")
    }
  }

  func testIssueDocument_WhenIssuerRegistrationDoesNotVouch_ThenBlocksAndDiscardsTheDocuments() async {
    // Given
    let issuerId = "issuer.dev"
    let configIds = ["doc"]
    let identifier = DocumentTypeIdentifier(rawValue: "eu.europa.ec.eudi.pid.1")
    let document = Constants.issuedPendingDocument

    stub(walletKitController) { mock in
      when(mock.issueDocuments(
        issuerId: equal(to: issuerId),
        identifiers: equal(to: configIds),
        docTypeIdentifier: equal(to: identifier)
      )).thenReturn(
        IssuanceResult(documents: [document], issuerRegistration: .blocked(reason: .notRegisteredAsProvider))
      )
      when(mock.deleteDocument(with: any(), status: any())).thenDoNothing()
    }

    // When
    let result = await interactor.issueDocument(
      issuerId: issuerId,
      configIds: configIds,
      docTypeIdentifier: identifier
    )

    // Then
    switch result {
    case .issuerNotTrusted:
      verify(walletKitController).deleteDocument(with: equal(to: document.id), status: any())
    default:
      XCTFail("Expected issuerNotTrusted, got \(result)")
    }
  }

  func testIssueDocument_WhenDefferedPendingDocument_ThenReturnSuccess() async {
    // Given
    let configIds = ["deferred-doc"]
    let issuerId = "issuer.dev"
    let identifier = DocumentTypeIdentifier(rawValue: "eu.europa.ec.eudi.pid.1")
    let document = Constants.defferedPendingDocument
    let scopedDocument = Constants.scopedDocument
    
    stubResumeDynamicIssuanceDefferedSuccess(document: document)
    
    stubGetScopedDocuments(with: [
      scopedDocument
    ])
    
    // When
    let result = await interactor.issueDocument(
      issuerId: issuerId,
      configIds: configIds,
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
  
  func testIssueDocument_WhenOneOfTheRequestedFormatsIsNotIssued_ThenNamesIt() async {
    let metadata = DocMetadata(
      credentialIssuerIdentifier: "https://issuer.dev",
      configurationIdentifier: "pid_mdoc",
      docType: "eu.europa.ec.eudi.pid.1",
      display: nil,
      issuerDisplay: nil,
      claims: nil,
      authorizedRequestData: nil,
      keyOptions: nil,
      credentialOptions: nil
    )
    let document = WalletStorage.Document(
      id: "pid-id",
      docType: "eu.europa.ec.eudi.pid.1",
      docDataFormat: .cbor,
      data: Data(),
      docKeyInfo: nil,
      createdAt: nil,
      metadata: metadata.toData(),
      displayName: "PID",
      status: .issued
    )
    stub(walletKitController) { stub in
      when(stub.issueDocuments(issuerId: any(), identifiers: any(), docTypeIdentifier: any()))
        .thenReturn(IssuanceResult(documents: [document], issuerRegistration: nil))
      when(stub.getScopedDocuments()).thenReturn(
        ScopedDocumentsResult(
          documents: [
            ScopedDocument(
              name: "PID (SD-JWT VC)",
              issuer: "issuer.dev",
              order: 0,
              configId: "pid_sdjwt",
              isPid: true,
              docTypeIdentifier: .sdJwtPid
            )
          ],
          errors: [],
          totalIssuers: 1
        )
      )
    }

    let result = await interactor.issueDocument(
      issuerId: "issuer.dev",
      configIds: ["pid_mdoc", "pid_sdjwt"],
      docTypeIdentifier: .mDocPid
    )

    guard case .success(let ids, let notIssuedDocumentNames) = result else {
      return XCTFail("Expected a success, got \(result)")
    }
    XCTAssertEqual(ids, ["pid-id"])
    XCTAssertEqual(notIssuedDocumentNames, ["PID (SD-JWT VC)"])
  }

  func testNotIssuedConfigIds_WhenEveryReturnedDocumentNamesItsConfiguration_ThenListsTheMissingOnes() {
    XCTAssertEqual(
      AddDocumentInteractorImpl.notIssuedConfigIds(requested: ["mdoc", "sdjwt"], returned: ["mdoc"]),
      ["sdjwt"]
    )
    XCTAssertEqual(
      AddDocumentInteractorImpl.notIssuedConfigIds(requested: ["mdoc", "sdjwt"], returned: ["sdjwt", "mdoc"]),
      []
    )
  }

  func testNotIssuedConfigIds_WhenAReturnedDocumentDoesNotNameItsConfiguration_ThenNamesNothing() {
    XCTAssertEqual(
      AddDocumentInteractorImpl.notIssuedConfigIds(requested: ["mdoc", "sdjwt"], returned: [nil]),
      []
    )
  }

  func testIssueDocument_WhenIssuedDocument_ThenReturnSuccess() async {
    // Given
    let issuerId = "issuer.dev"
    let configIds = ["deferred-doc"]
    let identifier = DocumentTypeIdentifier(rawValue: "eu.europa.ec.eudi.pid.1")
    let document = Constants.issuedPendingDocument
    
    stubResumeDynamicIssuanceDefferedSuccess(document: document)
    
    // When
    let result = await interactor.issueDocument(
      issuerId: issuerId,
      configIds: configIds,
      docTypeIdentifier: identifier
    )
    
    // Then
    switch result {
    case .success:
      XCTAssertTrue(true)
    default:
      XCTFail("Expected .deferredSuccess but got \(result)")
    }

    verify(sessionController).beginExternalFlow()
    verify(sessionController).endExternalFlow(startedIn: any())
  }
  
  func testIssueDocument_WhenDefferedPendingDocument_ThenReturnsFailure() async {
    // Given
    let configIds = ["fail-doc"]
    let issuerId = "issuer.dev"
    let identifier = DocumentTypeIdentifier(rawValue: "eu.europa.ec.eudi.pid.1")
    
    stubIssueDocumentFailure(
      issuerId: issuerId,
      configIds: configIds,
      docTypeIdentifier: identifier
    )
    
    // When
    let result = await interactor.issueDocument(
      issuerId: issuerId,
      configIds: configIds,
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
  
  func testIssueDocument_WhenWalletThrowsTrustError_ThenReturnsIssuerNotTrusted() async {
    // Given
    let configIds = ["untrusted-doc"]
    let issuerId = "issuer.dev"
    let identifier = DocumentTypeIdentifier(rawValue: "eu.europa.ec.eudi.pid.1")

    stub(walletKitController) { mock in
      when(
        mock.issueDocuments(
          issuerId: equal(to: issuerId),
          identifiers: equal(to: configIds),
          docTypeIdentifier: equal(to: identifier)
        )
      ).thenThrow(WalletError(description: "issuer not trusted", code: .trustError))
    }

    // When
    let result = await interactor.issueDocument(
      issuerId: issuerId,
      configIds: configIds,
      docTypeIdentifier: identifier
    )

    // Then
    switch result {
    case .issuerNotTrusted:
      XCTAssertTrue(true)
    default:
      XCTFail("Expected .issuerNotTrusted but got \(result)")
    }

    verify(sessionController).beginExternalFlow()
    verify(sessionController).endExternalFlow(startedIn: any())
  }

  func testResumeDynamicIssuance_WhenWalletThrowsTrustError_ThenReturnsIssuerNotTrusted() async {
    // Given
    let pendingData = DynamicIssuancePendingData(
      pendingDoc: Constants.issuedPendingDocument,
      url: URL(string: "https://example.com")!
    )

    stub(walletKitController) { mock in
      when(mock.getDynamicIssuancePendingData()).thenReturn(pendingData)

      when(mock.resumePendingIssuance(
        pendingDoc: any(),
        webUrl: equal(to: pendingData.url)
      )).thenThrow(WalletError(description: "issuer not trusted", code: .trustError))
    }

    // When
    let result = await interactor.resumeDynamicIssuance()

    // Then
    switch result {
    case .issuerNotTrusted:
      XCTAssertTrue(true)
    default:
      XCTFail("Expected .issuerNotTrusted but got \(result)")
    }
  }

  func testResumeDynamicIssuance_WhenDefferedPending_ThenReturnDefferedSuccess() async {
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
  
  func testResumeDynamicIssuance_WhenIssuePending_ThenReturnSuccess() async {
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
  
  func testResumeDynamicIssuance_WhenIssuePending_ThenIssuanceFails() async {
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
  
  func testResumeDynamicIssuance_WhenPending_ThenReturnSuccess() async {
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
  
  func testResumeDynamicIssuance_WhenReturnsNoPending_ThenNoPendingDataExists() async {
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
  
  func testFetchStoredDocuments_WhenDocumentsExist_ThenReturnsSuccess() async {
    // Given
    let documentIds = [
      "doc-id-1",
      "doc-id-2"
    ]
    let pidDocument = Constants.createEuPidModel()
    let mdlDocument = Constants.createIsoMdlModel()
    
    let transformedPidDocument = pidDocument.transformToDocumentUi(isSensitive: false, issuerLogoOrigins: .init(logoOriginsByIssuer: [:]))
    let transformedMdlDocument = mdlDocument.transformToDocumentUi(isSensitive: false, issuerLogoOrigins: .init(logoOriginsByIssuer: [:]))
    
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
  
  func testFetchStoredDocuments_WhenDocumentsDoNotExist_ThenReturnsFailure() async {
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
  
  func testFetchStoredDocuments_WhenNoDocumentsReturned_ThenReturnsFailure() async {
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
  
  func testFetchScopedDocuments_WhenExtraDocumentFilterTypeIsSet_ThenNonMatchingDocsFilteredOut() async {
    // Given: extraDocument(filterType: .mDocPid) keeps only documents whose
    // docTypeIdentifier matches; everything else hits the `continue` on line 64.
    let pidDoc = ScopedDocument(
      name: "PID Doc", issuer: "issuer.dev", order: 0, configId: "pid",
      isPid: true, docTypeIdentifier: .mDocPid
    )
    let unrelatedDoc = ScopedDocument(
      name: "MDL Doc", issuer: "issuer.dev", order: 1, configId: "mdl",
      isPid: false, docTypeIdentifier: .other(formatType: "mDL")
    )
    stubGetScopedDocumentsSuccess(with: [pidDoc, unrelatedDoc])

    // When
    let result = await interactor.fetchScopedDocuments(with: .extraDocument(filterType: .mDocPid))

    // Then: the .mDL doc was skipped; only PID-bucket remains
    switch result {
    case .success(let documents):
      let allModels = documents.values.flatMap { $0 }
      XCTAssertTrue(allModels.allSatisfy { $0.docTypeIdentifier == .mDocPid })
    default:
      XCTFail("Expected success, got \(result)")
    }
  }

  func testIssueDocument_WhenWalletReturnsEmptyDocs_ThenReturnsFailure() async {
    // Given: walletController.issueDocuments returns an empty array, hitting
    // the `guard !docs.isEmpty` failure branch (lines 155-157).
    let issuerId = "issuer.dev"
    let configIds = ["empty"]
    let identifier = DocumentTypeIdentifier(rawValue: "eu.europa.ec.eudi.pid.1")
    stub(walletKitController) { mock in
      when(mock.issueDocuments(
        issuerId: equal(to: issuerId),
        identifiers: equal(to: configIds),
        docTypeIdentifier: equal(to: identifier)
      )).thenReturn(IssuanceResult(documents: [], issuerRegistration: nil))
    }

    // When
    let result = await interactor.issueDocument(
      issuerId: issuerId, configIds: configIds, docTypeIdentifier: identifier
    )

    // Then
    switch result {
    case .failure(let error):
      XCTAssertEqual(error as? WalletCoreError, .unableToIssueAndStore)
    default:
      XCTFail("Expected .failure, got \(result)")
    }
  }

  func testIssueDocument_WhenDeferredDocHasNilMetadata_ThenReturnsFailure() async {
    // Given: a deferred doc with metadata: nil so `DocMetadata(from: doc.metadata)?
    // .configurationIdentifier` evaluates to nil, the guard on lines 166-168 fails,
    // and `error = .unableToIssueAndStore` is set before the loop continues.
    let issuerId = "issuer.dev"
    let configIds = ["deferred-orphan"]
    let identifier = DocumentTypeIdentifier(rawValue: "eu.europa.ec.eudi.pid.1")
    let deferredDocNoMeta = Document(
      id: "deferred-orphan",
      docType: "type",
      docDataFormat: .sdjwt,
      data: Data(),
      docKeyInfo: nil,
      createdAt: Date(),
      metadata: nil,
      displayName: "Orphan",
      status: .deferred
    )

    stub(walletKitController) { mock in
      when(mock.issueDocuments(
        issuerId: equal(to: issuerId),
        identifiers: equal(to: configIds),
        docTypeIdentifier: equal(to: identifier)
      )).thenReturn(IssuanceResult(documents: [deferredDocNoMeta], issuerRegistration: nil))
    }

    // When
    let result = await interactor.issueDocument(
      issuerId: issuerId, configIds: configIds, docTypeIdentifier: identifier
    )

    // Then
    switch result {
    case .failure(let error):
      XCTAssertEqual(error as? WalletCoreError, .unableToIssueAndStore)
    default:
      XCTFail("Expected .failure, got \(result)")
    }
  }

  func testFetchScopedDocuments_WhenDocumentsReturned_ThenReturnsSuccessMocks() async throws {
    // Given
    let issuerId = "issuer.dev"
    let secondaryIssuerId = "issuer2.dev"
    let scopedDocument1 = ScopedDocument(
      name: "Document name 1",
      issuer: issuerId,
      order: 0,
      configId: "id1",
      isPid: true,
      docTypeIdentifier: .mDocPid
    )
    
    let scopedDocument2 = ScopedDocument(
      name: "Document name 2",
      issuer: issuerId,
      order: 0,
      configId: "id2",
      isPid: true,
      docTypeIdentifier: .mDocPid
    )
    
    let scopedDocument3 = ScopedDocument(
      name: "Document name 3",
      issuer: issuerId,
      order: 1,
      configId: "id3",
      isPid: true,
      docTypeIdentifier: .mDocPid
    )
    
    let scopedDocument4 = ScopedDocument(
      name: "Document name 4",
      issuer: secondaryIssuerId,
      order: 1,
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
      XCTAssertTrue(firstModel.configIds.contains(scopedDocument1.configId))
      
      let secondaryModel = try XCTUnwrap(documents[secondaryIssuerId]?.first)
      XCTAssertTrue(secondaryModel.configIds.contains(scopedDocument4.configId))
    default:
      XCTFail("Expected success but got \(result)")
    }
  }

  func testIssueDocument_WhenProviderRegistrationIsBlocked_ThenIssuanceNeverStarts() async {
    // Given
    stubIssuerRegistration(.blocked(reason: .notRegisteredAsProvider))

    // When
    let result = await interactor.issueDocument(
      issuerId: "issuer.dev",
      configIds: ["doc"],
      docTypeIdentifier: DocumentTypeIdentifier(rawValue: "eu.europa.ec.eudi.pid.1")
    )

    // Then
    switch result {
    case .registrationBlocked(let reason):
      XCTAssertEqual(reason, .notRegisteredAsProvider)
      verify(walletKitController, never()).issueDocuments(
        issuerId: any(),
        identifiers: any(),
        docTypeIdentifier: any()
      )
    default:
      XCTFail("Expected .registrationBlocked, got \(result)")
    }
  }

  func testIssueDocument_WhenTheRegistrationLookupFails_ThenIssuanceNeverStartsAndFails() async {
    stub(walletKitController) { stub in
      when(stub.getIssuerRegistration(issuerId: any(), configIds: any())).thenThrow(WalletCoreError.unableFetchDocument)
    }

    let result = await interactor.issueDocument(
      issuerId: "issuer.dev",
      configIds: ["doc"],
      docTypeIdentifier: DocumentTypeIdentifier(rawValue: "eu.europa.ec.eudi.pid.1")
    )

    guard case .failure = result else {
      return XCTFail("Expected .failure, got \(result)")
    }
    verify(walletKitController, never()).issueDocuments(
      issuerId: any(),
      identifiers: any(),
      docTypeIdentifier: any()
    )
  }
}

private extension TestAddDocumentInteractor {

  /// Issuer registration now comes from the wallet controller rather than a dedicated controller,
  /// so scenarios are expressed by stubbing the lookup.
  func stubIssuerRegistration(_ registration: IssuerRegistration) {
    stub(walletKitController) { stub in
      when(stub.getIssuerRegistration(issuerId: any(), configIds: any())).thenReturn(registration)
    }
  }
}

private extension TestAddDocumentInteractor {
  func stubGetScopedDocuments(with document: [ScopedDocument]) {
    stubGetScopedDocumentsSuccess(with: document)
  }

  func stubGetScopedDocuments(documents: [ScopedDocument], errors: [Error], totalIssuers: Int) {
    stub(walletKitController) { stub in
      when(stub.getScopedDocuments())
        .thenReturn(
          ScopedDocumentsResult(documents: documents, errors: errors, totalIssuers: totalIssuers)
        )
    }
  }

  func stubGetScopedDocumentsSuccess(with documents: [ScopedDocument]) {
    stub(walletKitController) { stub in
      when(stub.getScopedDocuments())
        .thenReturn(
          ScopedDocumentsResult(documents: documents, errors: [], totalIssuers: 1)
        )
    }
  }

  /// Every configured issuer failed, which is the only case that surfaces an error to the caller.
  func stubGetScopedDocumentsFailure(with error: Error = WalletCoreError.unableFetchDocument) {
    stub(walletKitController) { stub in
      when(stub.getScopedDocuments())
        .thenReturn(
          ScopedDocumentsResult(documents: [], errors: [error], totalIssuers: 1)
        )
    }
  }
  
  func stubIssueDocumentFailure(issuerId: String, configIds: [String], docTypeIdentifier: DocumentTypeIdentifier) {
    stub(walletKitController) { stub in
      when(
        stub.issueDocuments(
          issuerId: equal(to: issuerId),
          identifiers: equal(to: configIds),
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
      .thenReturn(IssuanceResult(documents: [document], issuerRegistration: nil))
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
