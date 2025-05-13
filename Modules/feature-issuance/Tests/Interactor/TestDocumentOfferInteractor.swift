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
import OpenID4VCI

final class TestDocumentOfferInteractor: EudiTest {

  var interactor: DocumentOfferInteractor!
  var walletKitController: MockWalletKitController!

  override func setUp() {
    super.setUp()
    self.walletKitController = MockWalletKitController()
    self.interactor = DocumentOfferInteractorImpl(
      walletController: walletKitController
    )
  }

  override func tearDown() {
    self.interactor = nil
    self.walletKitController = nil
  }

  func testResumeDynamicIssuance_WhenNoPendingData_ThenReturnNoPending() async {
    // Given
    let config = IssuanceCodeUiConfig(
      offerUri: "",
      issuerName: "Issuer Name",
      txCodeLength: 6,
      docOffers: [],
      successNavigation: .popTo(
        .featureIssuanceModule(
          .credentialOfferRequest(config: NoConfig())
        )
      ),
      navigationCancelType: .pop
    )

    stub(walletKitController) { mock in
      when(mock.getDynamicIssuancePendingData()).thenReturn(nil)
    }

    // When
    let result = await interactor.resumeDynamicIssuance(
      issuerName: config.issuerName,
      successNavigation: config.successNavigation
    )

    // Then
    switch result {
    case .noPending:
      XCTAssert(true)
    default:
      XCTFail("Expected noPending, but got \(result)")
    }
  }

  func testResumeDynamicIssuance_WhenDocumentIssued_ThenReturnFailure() async {
    // Given
    let exceptedError = WalletCoreError.unableToIssueAndStore

    let config = IssuanceCodeUiConfig(
      offerUri: "",
      issuerName: "Issuer Name",
      txCodeLength: 6,
      docOffers: [],
      successNavigation: .popTo(
        .featureIssuanceModule(
          .credentialOfferRequest(config: NoConfig())
        )
      ),
      navigationCancelType: .pop
    )

    let url = URL(filePath: "someURL")!

    let document = Document(
      id: "doc-id",
      docType: "type",
      docDataFormat: .sdjwt,
      data: Data(),
      secureAreaName: nil,
      createdAt: Date(),
      metadata: nil,
      displayName: "My Document",
      status: .issued
    )

    let mockPendingData = DynamicIssuancePendingData(
      pendingDoc: document,
      url: url
    )

    stub(walletKitController) { mock in
      when(mock.getDynamicIssuancePendingData()).thenReturn(mockPendingData)

      when(mock.resumePendingIssuance(
        pendingDoc: any(),
        webUrl: any()
      ))
      .thenThrow(exceptedError)

      when(mock.fetchDocuments(with: any())).thenReturn([])
    }

    // When
    let result = await interactor.resumeDynamicIssuance(
      issuerName: config.issuerName,
      successNavigation: config.successNavigation
    )

    // Then
    switch result {
    case .failure(let error):
      XCTAssertEqual(error.localizedDescription, exceptedError.localizedDescription)
    default:
      XCTFail("Expected success, but got \(result)")
    }
  }

  func testResumeDynamicIssuance_WhenDocumentIssued_ThenReturnSuccess() async {
    // Given
    let config = IssuanceCodeUiConfig(
      offerUri: "",
      issuerName: "Issuer Name",
      txCodeLength: 6,
      docOffers: [],
      successNavigation: .popTo(
        .featureIssuanceModule(
          .credentialOfferRequest(config: NoConfig())
        )
      ),
      navigationCancelType: .pop
    )

    let url = URL(filePath: "someURL")!

    let document = Document(
      id: "doc-id",
      docType: "type",
      docDataFormat: .sdjwt,
      data: Data(),
      secureAreaName: nil,
      createdAt: Date(),
      metadata: nil,
      displayName: "My Document",
      status: .issued
    )

    let mockPendingData = DynamicIssuancePendingData(
      pendingDoc: document,
      url: url
    )

    stub(walletKitController) { mock in
      when(mock.getDynamicIssuancePendingData()).thenReturn(mockPendingData)

      when(mock.resumePendingIssuance(
        pendingDoc: any(),
        webUrl: any()
      ))
      .thenReturn(document)

      when(mock.fetchDocuments(with: any())).thenReturn([Constants.euPidModel])
    }

    // When
    let result = await interactor.resumeDynamicIssuance(
      issuerName: config.issuerName,
      successNavigation: config.successNavigation
    )

    // Then
    switch result {
    case .success(let documents):
      XCTAssertNotNil(documents)
    default:
      XCTFail("Expected success, but got \(result)")
    }
  }

  func testResumeDynamicIssuance_WhenDocumentDeffered_ThenReturnSuccess() async {
    // Given
    let config = IssuanceCodeUiConfig(
      offerUri: "",
      issuerName: "Issuer Name",
      txCodeLength: 6,
      docOffers: [],
      successNavigation: .popTo(
        .featureIssuanceModule(
          .credentialOfferRequest(config: NoConfig())
        )
      ),
      navigationCancelType: .pop
    )

    let url = URL(filePath: "someURL")!

    let document = Document(
      id: "doc-id",
      docType: "type",
      docDataFormat: .sdjwt,
      data: Data(),
      secureAreaName: nil,
      createdAt: Date(),
      metadata: nil,
      displayName: "My Document",
      status: .deferred
    )

    let mockPendingData = DynamicIssuancePendingData(
      pendingDoc: document,
      url: url
    )

    stub(walletKitController) { mock in
      when(mock.getDynamicIssuancePendingData()).thenReturn(mockPendingData)

      when(mock.resumePendingIssuance(
        pendingDoc: any(),
        webUrl: any()
      ))
      .thenReturn(document)

      when(mock.fetchDocuments(with: any())).thenReturn([Constants.euPidModel])
    }

    // When
    let result = await interactor.resumeDynamicIssuance(
      issuerName: config.issuerName,
      successNavigation: config.successNavigation
    )

    // Then
    switch result {
    case .success(let route):
      XCTAssertNotNil(route)
    default:
      XCTFail("Expected success, but got \(result)")
    }
  }

  func testResumeDynamicIssuance_WhenDocumentPending_ThenReturnFailure() async {
    // Given
    let config = IssuanceCodeUiConfig(
      offerUri: "",
      issuerName: "Issuer Name",
      txCodeLength: 6,
      docOffers: [],
      successNavigation: .popTo(
        .featureIssuanceModule(
          .credentialOfferRequest(config: NoConfig())
        )
      ),
      navigationCancelType: .pop
    )

    let url = URL(filePath: "someURL")!

    let document = Document(
      id: "doc-id",
      docType: "type",
      docDataFormat: .sdjwt,
      data: Data(),
      secureAreaName: nil,
      createdAt: Date(),
      metadata: nil,
      displayName: "My Document",
      status: .pending
    )

    let mockPendingData = DynamicIssuancePendingData(
      pendingDoc: document,
      url: url
    )

    stub(walletKitController) { mock in
      when(mock.getDynamicIssuancePendingData()).thenReturn(mockPendingData)

      when(mock.resumePendingIssuance(
        pendingDoc: any(),
        webUrl: any()
      ))
      .thenReturn(document)

      when(mock.fetchDocuments(with: any())).thenReturn([Constants.euPidModel])
    }

    // When
    let result = await interactor.resumeDynamicIssuance(
      issuerName: config.issuerName,
      successNavigation: config.successNavigation
    )

    // Then
    switch result {
    case .failure(let error):
      XCTAssertEqual(error as! WalletCoreError, WalletCoreError.unableToIssueAndStore)
    default:
      XCTFail("Expected success, but got \(result)")
    }
  }

  func testIssueDocuments_WhenIssueDocumentsByOfferUrl_ThenReturnFailure() async {
    //Given
    let config = UIConfig.TwoWayNavigationType.push(
      .featureCommonModule(
        .genericSuccess(config: UIConfig.Success(
          title: .init(value: .addDocumentTitle),
          subtitle: .addDocumentTitle,
          buttons: [],
          visualKind: UIConfig.Success.VisualKind.defaultIcon)
        )
      )
    )

    let expectedError = WalletCoreError.unableToIssueAndStore

    let uri = "uri"
    let txCodeValue = "txCodeValue"

    stub(walletKitController) { mock in
      mock.issueDocumentsByOfferUrl(
        offerUri: uri,
        docTypes: any(),
        txCodeValue: txCodeValue
      )
      .thenThrow(expectedError)
    }

    // When
    let result = await interactor.issueDocuments(
      with: uri,
      issuerName: "issuerName",
      docOffers: [],
      successNavigation: config,
      txCodeValue: txCodeValue
    )

    // Then
    switch result {
    case .failure(let error):
      XCTAssertEqual(error as! WalletCoreError, WalletCoreError.unableToIssueAndStore)
    default:
      XCTFail("Expected success, but got \(result)")
    }
  }

  func testIssueDocuments_WhenIssueDocumentsByOfferUrlEmptyDocuments_ThenReturnFailure() async {
    //Given
    let config = UIConfig.TwoWayNavigationType.push(
      .featureCommonModule(
        .genericSuccess(config: UIConfig.Success(
          title: .init(value: .addDocumentTitle),
          subtitle: .addDocumentTitle,
          buttons: [],
          visualKind: UIConfig.Success.VisualKind.defaultIcon)
        )
      )
    )

    let uri = "uri"
    let txCodeValue = "txCodeValue"

    stub(walletKitController) { mock in
      mock.issueDocumentsByOfferUrl(
        offerUri: uri,
        docTypes: any(),
        txCodeValue: txCodeValue
      )
      .thenReturn([])
    }

    // When
    let result = await interactor.issueDocuments(
      with: uri,
      issuerName: "issuerName",
      docOffers: [],
      successNavigation: config,
      txCodeValue: txCodeValue
    )

    // Then
    switch result {
    case .failure(let error):
      XCTAssertEqual(error as! WalletCoreError, WalletCoreError.unableToIssueAndStore)
    default:
      XCTFail("Expected success, but got \(result)")
    }
  }

  func testIssueDocuments_WhenIssueDocumentsByOfferUrl_ThenReturnSuccess() async {
    //Given
    let document = Document(
      id: "doc-id",
      docType: "type",
      docDataFormat: .sdjwt,
      data: Data(),
      secureAreaName: nil,
      createdAt: Date(),
      metadata: nil,
      displayName: "My Document",
      status: .deferred
    )

    let config = UIConfig.TwoWayNavigationType.push(
      .featureCommonModule(
        .genericSuccess(config: UIConfig.Success(
          title: .init(value: .addDocumentTitle),
          subtitle: .addDocumentTitle,
          buttons: [],
          visualKind: UIConfig.Success.VisualKind.defaultIcon)
        )
      )
    )

    let uri = "uri"
    let txCodeValue = "txCodeValue"

    stub(walletKitController) { mock in
      mock.issueDocumentsByOfferUrl(
        offerUri: uri,
        docTypes: any(),
        txCodeValue: txCodeValue
      )
      .thenReturn([document])
    }

    // When
    let result = await interactor.issueDocuments(
      with: uri,
      issuerName: "issuerName",
      docOffers: [],
      successNavigation: config,
      txCodeValue: txCodeValue
    )

    // Then
    switch result {
    case .deferredSuccess(let route):
      XCTAssertNotNil(route)
    default:
      XCTFail("Expected success, but got \(result)")
    }
  }

  func testIssueDocuments_WhenIssueDocumentsByOfferUrlauthorizePresentationUrl_ThenReturnSuccess() async {
    //Given
    let document = Document(
      id: "doc-id",
      docType: "type",
      docDataFormat: .sdjwt,
      data: Data(),
      secureAreaName: nil,
      createdAt: Date(),
      metadata: nil,
      displayName: "My Document",
      status: .issued
    )

    let config = UIConfig.TwoWayNavigationType.push(
      .featureCommonModule(
        .genericSuccess(config: UIConfig.Success(
          title: .init(value: .addDocumentTitle),
          subtitle: .addDocumentTitle,
          buttons: [],
          visualKind: UIConfig.Success.VisualKind.defaultIcon)
        )
      )
    )

    let uri = "uri"
    let txCodeValue = "txCodeValue"

    stub(walletKitController) { mock in
      mock.issueDocumentsByOfferUrl(
        offerUri: uri,
        docTypes: any(),
        txCodeValue: txCodeValue
      )
      .thenReturn([document])

      when(mock.fetchDocuments(with: any())).thenReturn([Constants.euPidModel])
    }

    // When
    let result = await interactor.issueDocuments(
      with: uri,
      issuerName: "issuerName",
      docOffers: [],
      successNavigation: config,
      txCodeValue: txCodeValue
    )

    // Then
    switch result {
    case .partialSuccess(let documents):
      XCTAssertNotNil(documents)
    default:
      XCTFail("Expected success, but got \(result)")
    }
  }

}
