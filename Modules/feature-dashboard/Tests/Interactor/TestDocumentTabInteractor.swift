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
import logic_core
import OrderedCollections
@testable import feature_dashboard
@testable import logic_test
@testable import feature_test

final class TestDocumentTabInteractor: EudiTest {
  
  var interactor: DocumentTabInteractor!
  var walletKitController: MockWalletKitController!
  var filterValidator: MockFilterValidator!
  var configLogic: MockConfigLogic!
  
  override func setUp() {
    self.walletKitController = MockWalletKitController()
    self.configLogic = MockConfigLogic()
    self.filterValidator = MockFilterValidator()
    self.interactor = DocumentTabInteractorImpl(
      walletKitController: walletKitController,
      filterValidator: filterValidator
    )
  }
  
  override func tearDown() {
    self.interactor = nil
    self.walletKitController = nil
    self.configLogic = nil
  }
  
  func testHasDeferredDocuments_WhenControllerReturnsValues_ThenReturnTrue() {
    // Given
    stubFetchDeferredDocuments(
      with: [
        .init(
          docType: nil,
          docDataFormat: .cbor,
          data: Data(),
          secureAreaName: nil,
          createdAt: nil,
          metadata: nil,
          displayName: "",
          status: .deferred
        )
      ]
    )
    // When
    let result = interactor.hasDeferredDocuments()
    // Then
    XCTAssertTrue(result)
  }
  
  func testHasDeferredDocuments_WhenControllerReturnsNoValues_ThenReturnFalse() {
    // Given
    stubFetchDeferredDocuments(with: [])
    // When
    let result = interactor.hasDeferredDocuments()
    // Then
    XCTAssertFalse(result)
  }
  
  func testFetchDocuments_WhenWalletKitControllerReturnsEmpty_ThenReturnError() async {
    // Given
    stubFetchRevokedDocuments(with: [])
    stubFetchDocuments(with: [])
    stubFetchIssuedDocuments(with: [])
    stubFetchDocumentsWithExclusion(with: [])
    stubFetchMainPidDocument(with: nil)
    // When
    let state = await interactor.fetchDocuments(failedDocuments: [])
    // Then
    switch state {
    case .failure(let error):
      XCTAssertEqual(error.localizedDescription, WalletCoreError.unableFetchDocuments.localizedDescription)
    default:
      XCTFail("Wrong state \(state)")
    }
  }
  
  func testFetchDocuments_WhenWalletKitControllerReturnsData_ThenReturnUiModels() async {
    // Given
    var documentsCategories: DocumentCategories {
      [
        .Government: [],
        .Travel: [],
        .Finance: [],
        .Education: [],
        .Health: [],
        .SocialSecurity: [],
        .Retail: [],
        .Other: []
      ]
    }
    stubFetchRevokedDocuments(
      with: []
    )
    stubFetchDocuments(
      with: [
        Constants.euPidModel,
        Constants.isoMdlModel
      ]
    )
    stubFetchIssuedDocuments(
      with: [
        Constants.euPidModel,
        Constants.isoMdlModel
      ]
    )
    stubFetchDocumentCategories(with: documentsCategories)
    stubFetchDocumentsWithExclusion(with: [Constants.isoMdlModel])
    stubFetchMainPidDocument(with: Constants.euPidModel)
    // When
    let state = await interactor.fetchDocuments(failedDocuments: [])
    // Then
    switch state {
    case .success:
      XCTAssertTrue(true)
    default:
      XCTFail("Wrong state \(state)")
    }
  }
}

private extension TestDocumentTabInteractor {
  
  func stubFetchDocuments(with documents: [DocClaimsDecodable]) {
    stub(walletKitController) { mock in
      when(mock.fetchAllDocuments()).thenReturn(documents)
    }
  }
  
  func stubFetchIssuedDocuments(with documents: [DocClaimsDecodable]) {
    stub(walletKitController) { mock in
      when(mock.fetchIssuedDocuments()).thenReturn(documents)
    }
  }
  
  func stubFetchDeferredDocuments(with documents: [WalletStorage.Document]) {
    stub(walletKitController) { mock in
      when(mock.fetchDeferredDocuments()).thenReturn(documents)
    }
  }
  
  func stubFetchDocumentsWithExclusion(with documents: [DocClaimsDecodable]) {
    stub(walletKitController) { mock in
      when(mock.fetchIssuedDocuments(excluded: any())).thenReturn(documents)
    }
  }
  
  func stubFetchMainPidDocument(with document: DocClaimsDecodable?) {
    stub(walletKitController) { mock in
      when(mock.fetchMainPidDocument()).thenReturn(document)
    }
  }

  func stubFetchDocumentCategories(with categories: OrderedDictionary<DocumentCategory, [DocumentTypeIdentifier]>) {
    stub(walletKitController) { mock in
      when(mock.getDocumentCategories()).thenReturn(categories)
    }
  }
  
  func stubFetchRevokedDocuments(with revokedDocuments: [String]) {
    stub(walletKitController) { mock in
      when(mock.fetchRevokedDocuments()).thenReturn(revokedDocuments)
    }
  }
}
