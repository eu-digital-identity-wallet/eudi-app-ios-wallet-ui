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
      docKeyInfo: nil,
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
      docKeyInfo: nil,
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

      when(mock.fetchDocuments(with: any())).thenReturn([Constants.createEuPidModel()])
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
      docKeyInfo: nil,
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

      when(mock.fetchDocuments(with: any())).thenReturn([Constants.createEuPidModel()])
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
      docKeyInfo: nil,
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

      when(mock.fetchDocuments(with: any())).thenReturn([Constants.createEuPidModel()])
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
    // Given
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
    // Given
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
    // Given
    let document = Document(
      id: "doc-id",
      docType: "type",
      docDataFormat: .sdjwt,
      data: Data(),
      docKeyInfo: nil,
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
    // Given
    let document = Document(
      id: "doc-id",
      docType: "type",
      docDataFormat: .sdjwt,
      data: Data(),
      docKeyInfo: nil,
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

      when(mock.fetchDocuments(with: any())).thenReturn([Constants.createEuPidModel()])
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
    case .partialSuccess(let route):
      XCTAssertNotNil(route)
    default:
      XCTFail("Expected success, but got \(result)")
    }
  }

  func testIssueDocuments_WhenIssueDocumentsByOfferUrlWithDocOffers_ThenReturnSuccess() async {
    // Given
    let document = Document(
      id: "doc-id",
      docType: "type",
      docDataFormat: .sdjwt,
      data: Data(),
      docKeyInfo: nil,
      createdAt: Date(),
      metadata: nil,
      displayName: "My Document",
      status: .issued
    )

    let docOffers = [
      OfferedDocModel(
        credentialConfigurationIdentifier: "id",
        scope: "scope",
        identifier: "identifier",
        displayName: "My Document",
        algValuesSupported: [],
        keyOptions: KeyOptions(credentialPolicy: .oneTimeUse, batchSize: 1)
      )
    ]

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
        docTypes: docOffers,
        txCodeValue: txCodeValue
      )
      .thenReturn([document])

      when(mock.fetchDocuments(with: any())).thenReturn([Constants.createEuPidModel()])
    }

    // When
    let result = await interactor.issueDocuments(
      with: uri,
      issuerName: "issuerName",
      docOffers: docOffers,
      successNavigation: config,
      txCodeValue: txCodeValue
    )

    // Then
    switch result {
    case .success(let route):
      XCTAssertNotNil(route)
    default:
      XCTFail("Expected success, but got \(result)")
    }
  }

  func testProcessOfferRequest_WhenResolveOfferUrlDocTypes_ThenReturnFailure() async {
    // Given
    let uri = "uri"
    let exceptedError = WalletCoreError.unableToIssueAndStore

    stub(walletKitController) { mock in
      mock.resolveOfferUrlDocTypes(uriOffer: uri).thenThrow(exceptedError)

      mock.fetchIssuedDocuments(with: any()).thenReturn([Constants.createEuPidModel()])
    }

    // When
    let result = await interactor.processOfferRequest(with: uri)

    // Then
    switch result {
    case .failure(let error):
      XCTAssertEqual(error as! WalletCoreError, WalletCoreError.unableToIssueAndStore)
    default:
      XCTFail("Expected success, but got \(result)")
    }
  }

  func testOfferedIssuance_WhenModelTransforms_ThenToDocumentOfferUIModel() {
    let docModel = OfferedDocModel(
      credentialConfigurationIdentifier: "id",
      docType: "type",
      scope: "scope",
      identifier: "identifier",
      displayName: "Display Name",
      algValuesSupported: [],
      keyOptions: KeyOptions(credentialPolicy: .oneTimeUse, batchSize: 1)
    )

    let issuanceModel = OfferedIssuanceModel(
      issuerName: "Issuer",
      issuerLogoUrl: "https://logo.com/logo.png",
      docModels: [docModel],
      txCodeSpec: TxCode(inputMode: .text, length: 6, description: "description")
    )

    let offerUI = issuanceModel.transformToDocumentOfferUi()

    XCTAssertEqual(offerUI.issuerName, "Issuer")
    XCTAssertEqual(offerUI.issuerLogo?.absoluteString, "https://logo.com/logo.png")
    XCTAssertEqual(offerUI.uiOffers.count, 1)
    XCTAssertEqual(offerUI.uiOffers.first?.documentName, "Display Name")
    XCTAssertEqual(offerUI.txCode?.isRequired, true)
    XCTAssertEqual(offerUI.txCode?.codeLenght, 6)
  }

  func testDocumentOffer_MockUIModel() {
    // Given
    let mock = DocumentOfferUIModel.mock()

    // When / Then
    XCTAssertEqual(mock.issuerName, LocalizableStringKey.unknownIssuer.toString)
    XCTAssertNil(mock.issuerLogo)
    XCTAssertNil(mock.txCode)
    XCTAssertEqual(mock.uiOffers.count, 5)
    XCTAssertEqual(mock.uiOffers.first?.documentName, "Document Name")

    for offer in mock.uiOffers {
      XCTAssertEqual(offer.listItem.mainText.toString, "Document Name")
    }
    XCTAssertEqual(mock.docOffers.count, 0)
  }

  func testProcessOfferRequest_WhenResolveOfferUrlDocTypes_ThenReturnSuccess() async {
    // Given
    let expectedDocumentOfferUIModel = DocumentOfferUIModel(
      issuerName: "issuerName",
      issuerLogo: URL(string: "issuerLogoUrl"),
      txCode: DocumentOfferUIModel.TxCode(isRequired: true, codeLenght: 6),
      uiOffers: [],
      docOffers: []
    )

    let uri = "uri"
    let docModels = [
      OfferedDocModel(
        credentialConfigurationIdentifier: "id",
        scope: "scope",
        identifier: "identifier",
        displayName: "My Document",
        algValuesSupported: [],
        keyOptions: KeyOptions(credentialPolicy: .oneTimeUse, batchSize: 1)
      )
    ]

    let offeredIssuanceModel =  OfferedIssuanceModel(
      issuerName: "issuerName",
      issuerLogoUrl: "issuerLogoUrl",
      docModels: docModels,
      txCodeSpec: nil
    )

    stub(walletKitController) { mock in
      mock.resolveOfferUrlDocTypes(uriOffer: uri).thenReturn(offeredIssuanceModel)

      mock.fetchIssuedDocuments(with: any()).thenReturn([Constants.createEuPidModel()])
    }

    // When
    let result = await interactor.processOfferRequest(with: uri)

    // Then
    switch result {
    case .success(let doc):
      XCTAssertEqual(doc.issuerName, expectedDocumentOfferUIModel.issuerName)
    default:
      XCTFail("Expected success, but got \(result)")
    }
  }
}
