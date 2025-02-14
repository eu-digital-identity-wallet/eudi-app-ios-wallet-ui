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
import logic_business
import logic_resources
import logic_core
import OrderedCollections
@testable import feature_dashboard
@testable import logic_test
@testable import feature_test

final class TestDashboardInteractor: EudiTest {
  
  var interactor: DashboardInteractor!
  var reachabilityController: MockReachabilityController!
  var walletKitController: MockWalletKitController!
  var filterValidator: MockFilterValidator!
  var configLogic: MockConfigLogic!
  
  override func setUp() {
    self.reachabilityController = MockReachabilityController()
    self.walletKitController = MockWalletKitController()
    self.configLogic = MockConfigLogic()
    self.filterValidator = MockFilterValidator()
    self.interactor = DashboardInteractorImpl(
      walletController: walletKitController,
      filterValidator: filterValidator,
      reachabilityController: reachabilityController,
      configLogic: configLogic
    )
  }
  
  override func tearDown() {
    self.interactor = nil
    self.reachabilityController = nil
    self.walletKitController = nil
    self.configLogic = nil
  }
  
  func testHasIssuedDocuments_WhenControllerReturnsValues_ThenReturnTrue() {
    // Given
    stubFetchIssuedDocuments(
      with: [
        Constants.euPidModel,
        Constants.isoMdlModel
      ]
    )
    // When
    let result = interactor.hasIssuedDocuments()
    // Then
    XCTAssertTrue(result)
  }
  
  func testHasIssuedDocuments_WhenControllerReturnsNoValues_ThenReturnFalse() {
    // Given
    stubFetchIssuedDocuments(with: [])
    // When
    let result = interactor.hasIssuedDocuments()
    // Then
    XCTAssertFalse(result)
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
  
  func testOpenBleSettings_WhenMethodIsCalled_ThenVerifyAtLeastOnce() async {
    // Given
    stub(reachabilityController) { mock in
      when(mock.openBleSettings()).thenDoNothing()
    }
    // When
    await interactor.openBleSettings()
    // Then
    verify(reachabilityController).openBleSettings()
  }
  
  func testGetAppVersion_WhenConfigLogicHasAppVersion_ThenReturnAppVersion() {
    // Given
    let appVersion = "2024.2.1-dev"
    stub(configLogic) { mock in
      when(mock.appVersion.get).thenReturn(appVersion)
    }
    // When
    let version = interactor.getAppVersion()
    // Then
    XCTAssertEqual(version, appVersion)
  }
  
  func testGetBleAvailability_WhenBleIsAvailable_ThenReturnAvailableEnum() async {
    await checkBle(with: Reachability.BleAvailibity.available)
  }
  
  func testGetBleAvailability_WhenBleIsDisabled_ThenReturnDisabledEnum() async {
    await checkBle(with: Reachability.BleAvailibity.disabled)
  }
  
  func testFetchDashboard_WhenWalletKitControllerReturnsEmpty_ThenReturnError() async {
    // Given
    stubFetchDocuments(with: [])
    stubFetchIssuedDocuments(with: [])
    stubFetchDocumentsWithExclusion(with: [])
    stubFetchMainPidDocument(with: nil)
    // When
    let state = await interactor.fetchDashboard(failedDocuments: [])
    // Then
    switch state {
    case .failure(let error):
      XCTAssertEqual(error.localizedDescription, WalletCoreError.unableFetchDocuments.localizedDescription)
    default:
      XCTFail("Wrong state \(state)")
    }
  }
  
  func testFetchDashboard_WhenWalletKitControllerReturnsData_ThenReturnUiModels() async {
    // Given
    var documentsCategories: DocumentCategories {
      [
        .Government: [
          .mDocPid,
          .sdJwtPid,
          .mDocPseudonym,
          .other(formatType: "org.iso.18013.5.1.mDL"),
          .other(formatType: "eu.europa.ec.eudi.tax.1"),
          .other(formatType: "eu.europa.ec.eudi.pseudonym.age_over_18.deferred_endpoint")
        ],
        .Travel: [
          .other(formatType: "org.iso.23220.2.photoid.1"),
          .other(formatType: "org.iso.18013.5.1.reservation")
        ],
        .Finance: [
          .other(formatType: "eu.europa.ec.eudi.iban.1")
        ],
        .Education: [],
        .Health: [
          .other(formatType: "eu.europa.ec.eudi.hiid.1"),
          .other(formatType: "eu.europa.ec.eudi.ehic.1")
        ],
        .SocialSecurity: [
          .other(formatType: "eu.europa.ec.eudi.samplepda1.1")
        ],
        .Retail: [
          .other(formatType: "eu.europa.ec.eudi.loyalty.1"),
          .other(formatType: "eu.europa.ec.eudi.msisdn.1")
        ],
        .Other: [
          .other(formatType: "eu.europa.ec.eudi.por.1")
        ]
      ]
    }

    let expectedUsername = Constants.claimFirstName

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
    let state = await interactor.fetchDashboard(failedDocuments: [])
    // Then
    switch state {
    case .success(let username, _, let hasIssuedDocuments):
      XCTAssertEqual(expectedUsername, username)
      XCTAssertTrue(hasIssuedDocuments)
    default:
      XCTFail("Wrong state \(state)")
    }
  }
}

private extension TestDashboardInteractor {
  func checkBle(with status: Reachability.BleAvailibity) async {
    // Given
    let publisher = Just(status).eraseToAnyPublisher()
    stub(reachabilityController) { mock in
      when(mock.getBleAvailibity()).thenReturn(publisher)
    }
    // When
    let bleAvailability = await interactor.getBleAvailability()
    // Then
    XCTAssertEqual(bleAvailability, status)
  }
  
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
}
