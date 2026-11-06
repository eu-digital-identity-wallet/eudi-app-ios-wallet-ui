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
import UIKit
import logic_business
import feature_common
import EudiWalletKit
@testable import logic_core
@testable import feature_presentation
@testable import logic_test
@testable import feature_test

final class TestPresentationInteractor: EudiTest {
  var interactor: PresentationInteractor!
  var walletKitController: MockWalletKitController!
  var configUiLogic: MockConfigUiLogic!
  var presentationCoordinator: MockRemoteSessionCoordinator!

  override func setUp() {
    walletKitController = MockWalletKitController()
    configUiLogic = MockConfigUiLogic(themeConfiguration: .default)
    stub(configUiLogic) { mock in
      when(mock.userImageClaimKeys.get).thenReturn(["portrait", "picture"])
    }
    presentationCoordinator = MockRemoteSessionCoordinator(
      session: Constants.mockPresentationSession
    )

    stub(presentationCoordinator) { mock in
      when(mock.stopPresentation()).thenDoNothing()
      // Requests without a registration certificate: no policy, no violations.
      when(mock.relyingPartyRegistration.get).thenReturn(nil)
      when(mock.relyingPartyWarningViolations.get).thenReturn([])
      when(mock.isRelyingPartyNotBoundToRequester.get).thenReturn(false)
      when(mock.transactionIdentifier.get).thenReturn("transaction")
    }

    stub(walletKitController) { mock in
      // Registration mapping is exercised by its own tests; here it just needs to resolve.
      when(
        mock.getVerifierRegistration(
          policy: any(),
          trustViolations: any(),
          overaskedClaims: any(),
          verifierName: any(),
          verifierIsTrusted: any(),
          isNotBoundToRequester: any(),
          transactionIdentifier: any()
        )
      ).thenReturn(
        RelyingPartyRegistration(
          name: nil,
          uniqueId: nil,
          isVerified: true,
          logoUrl: nil,
          registration: .notSupported
        )
      )
    }

    interactor = PresentationInteractorImpl(
      with: presentationCoordinator,
      and: walletKitController,
      configUiLogic: configUiLogic
    )
  }

  override func tearDown() {
    interactor = nil
    walletKitController = nil
    presentationCoordinator = nil
  }

  func testGetSessionStatePublisher_WhenActiveCoordinatorReturnsStream_ThenResultIsSuccessWithThatStream() async {
    // Given
    let expectedStream: AsyncStream<PresentationState> = AsyncStream { completion in }

    stub(presentationCoordinator) { mock in
      when(mock.getStream()).thenReturn(expectedStream)
    }

    // When
    let result = await interactor.getSessionStatePublisher()

    // Then
    switch result {
      case .success(let stream):
        XCTAssertNotNil(stream)
      default:
        XCTFail("Expected success but got \(result)")
    }
  }

  func testGetCoordinator_WhenActiveCoordinatorExists_ThenReturnsSuccessWithCoordinator() async {
    // Given
    let expectedStream: AsyncStream<PresentationState> = AsyncStream { completion in }

    stub(presentationCoordinator) { mock in
      when(mock.getStream()).thenReturn(expectedStream)
    }

    // When
    let result = await interactor.getCoordinator()

    // Then
    switch result {
      case .success(let stream):
        XCTAssertNotNil(stream)
      default:
        XCTFail("Expected success but got \(result)")
    }
  }

  func testGetCoordinator_WhenBuilt_ThenReturnsTheCoordinatorOfItsRoute() async {
    let result = await interactor.getCoordinator()

    guard case .success(let coordinator) = result else {
      return XCTFail("Expected success but got \(result)")
    }
    XCTAssertTrue(coordinator as AnyObject === presentationCoordinator)
  }

  func testOnSendResponse_WhenAnotherSessionHasStarted_ThenSendsOnTheCoordinatorOfItsRoute() async {
    let otherCoordinator = MockRemoteSessionCoordinator(session: Constants.mockPresentationSession)
    let otherInteractor = PresentationInteractorImpl(
      with: otherCoordinator,
      and: walletKitController,
      configUiLogic: configUiLogic
    )
    stub(presentationCoordinator) { mock in
      when(mock.getState()).thenReturn(.responseToSend(Self.mockRequestItems))
      when(mock.sendResponse(response: any())).thenDoNothing()
    }
    stub(otherCoordinator) { mock in
      when(mock.getState()).thenReturn(.loading)
    }

    _ = await otherInteractor.getCoordinator()
    let result = await interactor.onSendResponse()

    guard case .sent = result else {
      return XCTFail("Expected sent but got \(result)")
    }
    verify(presentationCoordinator).sendResponse(response: any())
    verify(otherCoordinator, never()).sendResponse(response: any())
  }

  func testStoreDynamicIssuancePendingUrl_WhenCalledWithUrl_ThenCallsWalletKitControllerStoreDynamicIssuancePendingUrl() async {
    // Given
    let expectedURL = URL(string: "https://example.com/pending")!

    stub(walletKitController) { mock in
      when(mock.storeDynamicIssuancePendingUrl(with: any())).thenDoNothing()
    }

    // When
    await interactor.storeDynamicIssuancePendingUrl(with: expectedURL)

    // Then
    verify(walletKitController).storeDynamicIssuancePendingUrl(with: any())
  }

  func testStopPresentation_WhenInteractorMethodCalled_ThenStopsOnlyItsOwnSession() async {
    let ownSession = presentationCoordinator!
    stub(walletKitController) { mock in
      when(mock.stopRemotePresentation(any())).thenDoNothing()
    }

    await interactor.stopPresentation()

    verify(walletKitController).stopRemotePresentation(ParameterMatcher { $0 === ownSession })
    verify(walletKitController, never()).stopPresentation()
    verify(presentationCoordinator).stopPresentation()
  }

  func testOnDeclineRequest_WhenTheDeclineIsSent_ThenStopsOnlyItsOwnSession() async {
    let ownSession = presentationCoordinator!
    stub(presentationCoordinator) { mock in
      when(mock.declineResponse()).thenDoNothing()
    }
    stub(walletKitController) { mock in
      when(mock.stopRemotePresentation(any())).thenDoNothing()
    }

    await interactor.onDeclineRequest()

    verify(presentationCoordinator).declineResponse()
    verify(walletKitController).stopRemotePresentation(ParameterMatcher { $0 === ownSession })
    verify(walletKitController, never()).stopPresentation()
  }

  func testOnDeviceEngagement_WhenRequestReceivedAndClaimsParsed_ThenReturnsSuccessWithModel() async {
    // Given
    let request = Self.mockPresentationRequest
    let expectedStream: AsyncStream<PresentationState> = AsyncStream { completion in }

    stub(presentationCoordinator) { mock in
      when(mock.getStream()).thenReturn(expectedStream)
    }

    stub(presentationCoordinator) { mock in
      when(mock.initialize()).thenDoNothing()
    }

    stub(presentationCoordinator) { mock in
      when(mock.requestReceived()).thenReturn(request)
    }

    stubRevokedDocumentStatuses(with: ["revokedIdentifier"])

    // When
    let result = await interactor.onDeviceEngagement()

    // Then
    switch result {
      case .success(let model):
        XCTAssertNotNil(model)
      default:
        XCTFail("Expected success but got \(result)")
    }
  }

  func testOnResponsePrepare_WhenADocumentIsNotOnTheConsentScreen_ThenItIsNotInTheResponse() async {
    let request = Constants.mockPresentationRequest
    let shown = request.itemSets[0][0]
    let hidden = DocElements.msoMdoc(
      .init(docId: "hidden-doc", docType: "org.iso.18013.5.1.mDL", displayName: "Hidden", nameSpacedElements: [])
    )
    await stubReceivedRequest(
      PresentationRequest(
        itemSets: [[shown, hidden]],
        relyingParty: request.relyingParty,
        dataRequestInfo: request.dataRequestInfo,
        isTrusted: request.isTrusted,
        overaskedClaims: request.overaskedClaims,
        transactionDataSets: [],
        requestNames: []
      )
    )
    stub(presentationCoordinator) { mock in
      when(mock.setState(presentationState: any())).thenDoNothing()
    }
    _ = await interactor.onRequestReceived()

    let state = await interactor.onResponsePrepare(combinationIndex: 0)

    guard case .success(let response) = state else {
      return XCTFail("Wrong state \(state)")
    }
    XCTAssertNil(response.items["hidden-doc"])
    XCTAssertNotNil(response.items[shown.docId])
  }

  func testOnRequestReceived_WhenThePortraitIsRequested_ThenItsRowIsMarkedAsAPictureOfTheHolder() async {
    let request = Constants.mockPresentationRequest
    let element: (String) -> MsoMdocElement = { name in
      .init(
        elementIdentifier: name,
        isOptional: false,
        stringValue: "value",
        docClaim: .init(name: name, dataValue: .string("value"), stringValue: "value"),
        isValid: true
      )
    }
    let portraitRequest = PresentationRequest(
      itemSets: [
        [
          .msoMdoc(
            .init(
              docId: Constants.isoMdlModelId,
              docType: Constants.isoMdlDocType,
              displayName: Constants.isoMdlName,
              nameSpacedElements: [.init(nameSpace: "nameSpace", elements: [element("portrait"), element("family_name")])]
            )
          )
        ]
      ],
      relyingParty: request.relyingParty,
      dataRequestInfo: request.dataRequestInfo,
      isTrusted: request.isTrusted,
      overaskedClaims: request.overaskedClaims,
      transactionDataSets: [],
      requestNames: []
    )
    await stubReceivedRequest(portraitRequest)

    let state = await interactor.onRequestReceived()

    guard case .success(let successModel) = state else {
      return XCTFail("Wrong state \(state)")
    }
    let document = successModel.requestDataCombinations.first?.documents.first
    let portraitIds = Set(
      document?.section.listItems.compactMap { item -> String? in
        guard case .primitive(let id, _, _, _, let path, _, _, _)? = item.domainModel, path.last == "portrait" else {
          return nil
        }
        return id
      } ?? []
    )
    XCTAssertEqual(portraitIds.count, 1)
    XCTAssertEqual(document?.userImageItemIds, portraitIds)
  }

  func testOnRequestReceived_WhenCoordinatorReturnsRequest_ThenEmitsSuccessStateWithParsedUiModels() async {
    // Given
    let request = Self.mockPresentationRequest

    let expectedUiModels = Self.mockUiModels()

    stub(presentationCoordinator) { mock in
      when(mock.requestReceived()).thenReturn(request)
    }

    stubRevokedDocumentStatuses(with: [])

    // When
    let state = await interactor.onRequestReceived()

    // Then
    switch state {
    case .success(let successModel):
      XCTAssertEqual(successModel.requestDataCombinations, [.init(documents: expectedUiModels)])
      XCTAssertEqual(successModel.relyingParty, request.relyingParty)
      XCTAssertEqual(successModel.dataRequestInfo, request.dataRequestInfo)
      XCTAssertEqual(successModel.isTrusted, request.isTrusted)
    default:
      XCTFail("Wrong state \(state)")
    }
  }

  func testOnRequestReceived_WhenCoordinatorRequestReceivedThrowsError_ThenReturnsFailureWithThatError() async {
    // Given
    let expectedError = PresentationSessionError.conversionToRequestItemModel

    stub(presentationCoordinator) { mock in
      when(mock.requestReceived()).thenThrow(expectedError)
    }

    stubRevokedDocumentStatuses(with: ["revokedIdentifier"])

    // When
    let state = await interactor.onRequestReceived()

    // Then
    switch state {
    case .failure(let error):
      XCTAssertEqual(
        error.localizedDescription,
        expectedError.localizedDescription
      )
    default:
      XCTFail("Wrong state \(state)")
    }
  }

  func testOnRequestReceived_WhenCoordinatorRequestReceivedThrowsTrustError_ThenReturnsNotSecuredRequest() async {
    // Given
    stub(presentationCoordinator) { mock in
      when(mock.requestReceived())
        .thenThrow(WalletError(description: "verifier not trusted", code: .trustError))
    }

    stubRevokedDocumentStatuses(with: [])

    // When
    let state = await interactor.onRequestReceived()

    // Then
    switch state {
    case .notSecuredRequest:
      XCTAssertTrue(true)
    default:
      XCTFail("Wrong state \(state)")
    }
  }

  func testOnResponsePrepare_WhenCoordinatorSetState_ThenReturnsSuccessWithMappedRequestItemsAndCallsSetState() async {
    // Given
    let expectedRequestItems = Self.mockRequestItems

    await stubReceivedRequest()

    stub(presentationCoordinator) { mock in
      when(mock.setState(presentationState: any())).thenDoNothing()
    }

    // When
    let state = await interactor.onResponsePrepare(combinationIndex: 0)

    // Then
    switch state {
    case .success(let request):
      XCTAssertEqual(request.items, expectedRequestItems)
    default:
      XCTFail("Wrong state \(state)")
    }

    verify(presentationCoordinator).setState(presentationState: any())
  }

  func testOnRequestReceived_WhenTransactionDataCannotBeShownInFull_ThenTheRequestIsDeclined() async {
    for transactionData: [String: [PresentationTransactionDataDomain]] in [
      [Constants.isoMdlModelId: [.unavailable]],
      ["another-document": [.qes(.init(credentialIds: [], signatureRequests: []))]]
    ] {
      await stubReceivedRequest(Self.presentationRequest(transactionDataSets: [transactionData], requestNames: ["option-1"]))

      let state = await interactor.onRequestReceived()

      guard case .failure(let error) = state else {
        return XCTFail("Wrong state \(state)")
      }
      XCTAssertEqual(error.localizedDescription, WalletCoreError.transactionDataNotShown.localizedDescription)
    }
  }

  func testOnRequestReceived_WhenTransactionDataIsReadableAndBoundToAShownDocument_ThenTheOptionShowsIt() async throws {
    let transaction: PresentationTransactionDataDomain = .qes(.init(credentialIds: ["pid"], signatureRequests: []))
    await stubReceivedRequest(
      Self.presentationRequest(transactionDataSets: [[Constants.isoMdlModelId: [transaction]]], requestNames: ["option-1"])
    )

    let state = await interactor.onRequestReceived()

    guard case .success(let model) = state else {
      return XCTFail("Wrong state \(state)")
    }
    let transactionData = try XCTUnwrap(model.requestDataCombinations.first?.transactionData)
    XCTAssertEqual(transactionData.details.id, "transaction-data:0")
    XCTAssertEqual(
      transactionData.details.listItems.map(\.id),
      [
        "transaction-data:0/framework",
        "transaction-data:0/transaction-0/type",
        "transaction-data:0/transaction-0/query-0"
      ]
    )
  }

  func testOnRequestReceived_WhenAnOptionThatIsNotOfferedCarriesTransactionData_ThenTheOfferedOptionsAreCheckedOnTheirOwn() async {
    let request = Constants.mockPresentationRequest
    let revoked = DocElements.sdJwt(.init(docId: "pid-sd", vct: "urn:eudi:pid:1", sdJwtElements: []))
    await stubReceivedRequest(
      PresentationRequest(
        itemSets: [[revoked], request.itemSets[0]],
        relyingParty: request.relyingParty,
        dataRequestInfo: request.dataRequestInfo,
        isTrusted: request.isTrusted,
        overaskedClaims: request.overaskedClaims,
        transactionDataSets: [["pid-sd": [.unavailable]], [:]],
        requestNames: [nil, nil]
      )
    )
    stubRevokedDocumentStatuses(with: ["pid-sd"])

    let state = await interactor.onRequestReceived()

    guard case .success = state else {
      return XCTFail("Wrong state \(state)")
    }
  }

  func testCanShowTransactionData_WhenEveryEntryIsReadableAndBoundToAShownDocument_ThenIsTrue() {
    let sdJwt = DocElements.sdJwt(.init(docId: "pid-sd", vct: "urn:eudi:pid:1", sdJwtElements: []))
    let mdoc = Constants.mockPresentationRequest.itemSets[0][0]
    let readable: [PresentationTransactionDataDomain] = [.qes(.init(credentialIds: [], signatureRequests: []))]

    XCTAssertTrue(PresentationInteractorImpl.canShowTransactionData([:], shownDocuments: [mdoc]))
    XCTAssertTrue(PresentationInteractorImpl.canShowTransactionData(["pid-sd": readable], shownDocuments: [sdJwt]))
    XCTAssertFalse(PresentationInteractorImpl.canShowTransactionData(["pid-sd": [.unavailable]], shownDocuments: [sdJwt]))
    XCTAssertTrue(PresentationInteractorImpl.canShowTransactionData([mdoc.docId: readable], shownDocuments: [mdoc]))
    XCTAssertFalse(PresentationInteractorImpl.canShowTransactionData(["elsewhere": readable], shownDocuments: [sdJwt]))
  }

  func testOnResponsePrepare_WhenTheCombinationHasARequestName_ThenTheResponseToSendCarriesIt() async {
    // Given
    await stubReceivedRequest(
      Self.presentationRequest(transactionDataSets: [], requestNames: ["option-1"])
    )

    stub(presentationCoordinator) { mock in
      when(mock.setState(presentationState: any())).thenDoNothing()
    }

    // When
    let state = await interactor.onResponsePrepare(combinationIndex: 0)

    // Then
    switch state {
    case .success(let response):
      XCTAssertEqual(response.items, Self.mockRequestItems)
      XCTAssertEqual(response.requestName, "option-1")
    default:
      XCTFail("Wrong state \(state)")
    }

    let stateCaptor = ArgumentCaptor<PresentationState>()
    verify(presentationCoordinator).setState(presentationState: stateCaptor.capture())
    guard case .responseToSend(let response)? = stateCaptor.value else {
      return XCTFail("Expected a response to send")
    }
    XCTAssertEqual(response.requestName, "option-1")
  }

  func testOnResponsePrepare_WhenTheCombinationIndexIsOutOfRange_ThenReturnsFailureWithConversionError() async {
    // Given
    let expectedError = PresentationSessionError.conversionToRequestItemModel

    await stubReceivedRequest()

    // When
    let state = await interactor.onResponsePrepare(combinationIndex: 1)

    // Then
    switch state {
    case .failure(let error):
      XCTAssertEqual(error.localizedDescription, expectedError.localizedDescription)
    default:
      XCTFail("Wrong state \(state)")
    }
  }

  func testOnSendResponse_WhenCoordinatorStateIsResponseToSend_ThenReturnsSentAndInvokesSendResponse() async {
    // Given
    let presetationState: PresentationState = .responseToSend(Self.mockRequestItems)

    stub(presentationCoordinator) { mock in
      when(mock.getState()).thenReturn(presetationState)
    }

    stub(presentationCoordinator) { mock in
      when(
        mock.sendResponse(
          response: any()
        )
      ).thenDoNothing()
    }

    // When
    let state = await interactor.onSendResponse()

    // Then
    switch state {
    case .sent:
      XCTAssertTrue(true)
    default:
      XCTFail("Wrong state \(state)")
    }

    verify(presentationCoordinator).getState()
    verify(presentationCoordinator).sendResponse(
      response: any()
    )
  }

  func testOnSendResponse_WhenCoordinatorStateIsNotResponseToSend_ThenReturnsFailureWithInvalidStateError() async {
    // Given
    let presetationState: PresentationState = .prepareQr
    let expectedError = PresentationSessionError.invalidState

    stub(presentationCoordinator) { mock in
      when(mock.getState()).thenReturn(presetationState)
    }

    // When
    let state = await interactor.onSendResponse()

    // Then
    switch state {
    case .failure(let error):
      XCTAssertEqual(error.localizedDescription, expectedError.localizedDescription)
    default:
      XCTFail("Wrong state \(state)")
    }

    verify(presentationCoordinator).getState()
  }

  func testOnRequestReceived_WhenAllDocumentsRevoked_ThenReturnsSuccessWithNoCombinations() async {
    // Given
    let mockResponse = Self.mockPresentationRequest
    let allDocIds = mockResponse.itemSets.flatMap { $0 }.map { $0.docId }

    stub(presentationCoordinator) { mock in
      when(mock.requestReceived()).thenReturn(mockResponse)
    }
    stub(walletKitController) { mock in
      when(mock.fetchRevokedDocumentStatuses()).thenReturn(Self.statuses(allDocIds, as: .revoked))
    }

    // When
    let result = await interactor.onRequestReceived()

    // Then
    switch result {
    case .success(let model):
      XCTAssertTrue(model.requestDataCombinations.isEmpty)
    default:
      XCTFail("Expected success, got \(result)")
    }
  }

  func testOnRequestReceived_WhenTheRevocationRecordsCannotBeRead_ThenFails() async {
    stub(presentationCoordinator) { mock in
      when(mock.requestReceived()).thenReturn(Self.mockPresentationRequest)
    }
    stub(walletKitController) { mock in
      when(mock.fetchRevokedDocumentStatuses()).thenThrow(RuntimeError.genericError)
    }

    let result = await interactor.onRequestReceived()

    switch result {
    case .failure:
      break
    default:
      XCTFail("Expected failure, got \(result)")
    }
  }

  func testOnRequestReceived_WhenTheDocumentIsSuspendedOrUnrecognised_ThenItIsLeftOut() async {
    let docIds = Self.mockPresentationRequest.itemSets.flatMap { $0 }.map(\.docId)
    stub(presentationCoordinator) { mock in
      when(mock.requestReceived()).thenReturn(Self.mockPresentationRequest)
    }

    for status in [DocumentRevocationStatus.suspended, .unrecognised] {
      stubRevokedDocumentStatuses(with: docIds, as: status)

      let result = await interactor.onRequestReceived()

      switch result {
      case .success(let model):
        XCTAssertTrue(model.requestDataCombinations.isEmpty, "\(status)")
      default:
        XCTFail("Expected success for \(status), got \(result)")
      }
    }
  }
}

private extension TestPresentationInteractor {

  static let mockPresentationRequest = Constants.mockPresentationRequest

  static func presentationRequest(
    transactionDataSets: [[String: [PresentationTransactionDataDomain]]],
    requestNames: [String?]
  ) -> PresentationRequest {
    let request = Constants.mockPresentationRequest
    return PresentationRequest(
      itemSets: request.itemSets,
      relyingParty: request.relyingParty,
      dataRequestInfo: request.dataRequestInfo,
      isTrusted: request.isTrusted,
      overaskedClaims: request.overaskedClaims,
      transactionDataSets: transactionDataSets,
      requestNames: requestNames
    )
  }

  static func mockUiModels() -> [RequestDataUiModel] {
    let claim = DocumentElementClaim.primitive(
      id: Constants.randomIdentifier,
      title: "elementIdentifier",
      documentId: Constants.isoMdlModelId,
      nameSpace: "nameSpace",
      path: ["nameSpace", "elementIdentifier"],
      type: .mdoc,
      value: .string("value"),
      status: .available(isRequired: false)
    )
    return [
      RequestDataUiModel(
        section: .init(
          id: Constants.isoMdlModelId,
          title: Constants.isoMdlName,
          listItems: [
            .single(
              .init(
                collapsed: .init(
                  mainContent: .text(.custom("value")),
                  overlineText: .custom("elementIdentifier"),
                  isEnable: true,
                  trailingContent: .empty
                ),
                domainModel: claim
              )
            )
          ]
        )
      )
    ]
  }

  static let mockRequestItems = [
    Constants.isoMdlModelId : [
      "nameSpace": [
        RequestItem(elementPath: ["elementIdentifier"])
      ]
    ]
  ]

  func stubReceivedRequest(_ request: PresentationRequest = TestPresentationInteractor.mockPresentationRequest) async {
    stub(presentationCoordinator) { mock in
      when(mock.requestReceived()).thenReturn(request)
    }
    stubRevokedDocumentStatuses(with: [])
    _ = await interactor.onRequestReceived()
  }

  func stubRevokedDocumentStatuses(with documentIds: [String], as status: DocumentRevocationStatus = .revoked) {
    stub(walletKitController) { mock in
      when(mock.fetchRevokedDocumentStatuses()).thenReturn(Self.statuses(documentIds, as: status))
    }
  }

  static func statuses(_ documentIds: [String], as status: DocumentRevocationStatus) -> [String: DocumentRevocationStatus] {
    Dictionary(documentIds.map { ($0, status) }, uniquingKeysWith: { first, _ in first })
  }
}
