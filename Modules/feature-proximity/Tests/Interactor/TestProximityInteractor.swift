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
import logic_resources
import logic_business
import feature_common
import EudiWalletKit
@testable import logic_core
@testable import feature_proximity
@testable import logic_test
@testable import feature_test

final class TestProximityInteractor: EudiTest {
  
  var interactor: ProximityInteractor!
  var walletKitController: MockWalletKitController!
  var configUiLogic: MockConfigUiLogic!
  var presentationSessionCoordinator: MockProximitySessionCoordinator!
  
  override func setUp() {
    self.walletKitController = MockWalletKitController()
    self.configUiLogic = MockConfigUiLogic(themeConfiguration: .default)
    stub(configUiLogic) { mock in
      when(mock.userImageClaimKeys.get).thenReturn(["portrait", "picture"])
    }
    self.presentationSessionCoordinator = MockProximitySessionCoordinator(
      session: Constants.mockPresentationSession
    )
    
    stub(presentationSessionCoordinator) { mock in
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

    self.interactor = ProximityInteractorImpl(
      with: presentationSessionCoordinator,
      and: walletKitController,
      configUiLogic: configUiLogic
    )
  }
  
  override func tearDown() {
    self.interactor = nil
    self.walletKitController = nil
    self.presentationSessionCoordinator = nil
  }
  
  func testOnDeviceEngagement_WhenCoordinatorInitializeSuccess_ThenVerifyCoordinatorInitializedAndState() async {
    // Given
    stub(presentationSessionCoordinator) { mock in
      when(mock.initialize()).thenDoNothing()
    }

    // When
    let state = await interactor.onDeviceEngagement()

    // Then
    switch state {
    case .success:
      XCTAssertTrue(true)
    default:
      XCTFail("Wrong state \(state)")
    }
    verify(presentationSessionCoordinator).initialize()
  }
  
  func testOnDeviceEngagement_WhenCoordinatorInitializeThrowsError_ThenVerifyStateError() async {
    // Given
    let expectedError = RuntimeError.genericError
    stub(presentationSessionCoordinator) { mock in
      when(mock.initialize()).thenThrow(expectedError)
    }

    // When
    let state = await interactor.onDeviceEngagement()

    // Then
    switch state {
    case .failure(let error):
      XCTAssertEqual(error.localizedDescription, expectedError.localizedDescription)
    default:
      XCTFail("Wrong state \(state)")
    }
    verify(presentationSessionCoordinator).initialize()
  }
  
  func testGetSessionStatePublisher_WhenCoordinatorIsValid_ThenVerifyStateSuccess() async {
    // Given
    let sendableCurrentValueSubject: SendableCurrentValueSubject<PresentationState> = SendableCurrentValueSubject(.loading)
    let stream: AsyncStream<PresentationState> = AsyncStream { completion in }
    
    stub(presentationSessionCoordinator) { mock in
      when(mock.sendableCurrentValueSubject.get).thenReturn(sendableCurrentValueSubject)
    }
    stub(presentationSessionCoordinator) { mock in
      when(mock.getStream()).thenReturn(stream)
    }

    // When
    let state = await interactor.getSessionStatePublisher()

    // Then
    switch state {
    case .success:
      XCTAssertTrue(true)
    default:
      XCTFail("Wrong state \(state)")
    }
  }
  
  func testGetCoordinator_WhenCoordinatorIsValid_ThenVerifyStateSuccess() async {
    // When
    let state = await interactor.getCoordinator()

    // Then
    switch state {
    case .success:
      XCTAssertTrue(true)
    default:
      XCTFail("Wrong state \(state)")
    }
  }
  
  func testGetCoordinator_WhenBuilt_ThenReturnsTheCoordinatorOfItsRoute() async {
    // When
    let state = await interactor.getCoordinator()

    // Then
    guard case .success(let coordinator) = state else {
      return XCTFail("Wrong state \(state)")
    }
    XCTAssertTrue(coordinator as AnyObject === presentationSessionCoordinator)
  }

  func testOnQRGeneration_WhenCoordinatorStartQrEngagementReturnsValidData_ThenVerifySuccessAndImage() async throws {
    // Given
    let expectedImage = try XCTUnwrap(UIImage(systemName: "qrcode"))
    stub(presentationSessionCoordinator) { mock in
      when(mock.startQrEngagement()).thenReturn(expectedImage)
    }

    // When
    let state = await interactor.onQRGeneration()
    
    // Then
    switch state {
    case .success(let image):
      let imageData = try XCTUnwrap(image.pngData())
      let expectedImageData = try XCTUnwrap(expectedImage.pngData())
      XCTAssertEqual(imageData.count, expectedImageData.count)
    default:
      XCTFail("Wrong state \(state)")
    }
    verify(presentationSessionCoordinator).startQrEngagement()
  }
  
  func testOnQRGeneration_WhenCoordinatorStartQrEngagementThrowsError_ThenVerifyFailure() async {
    // Given
    let expectedError = PresentationSessionError.qrGeneration
    
    stub(presentationSessionCoordinator) { mock in
      when(mock.startQrEngagement()).thenThrow(expectedError)
    }

    // When
    let state = await interactor.onQRGeneration()
    
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
    verify(presentationSessionCoordinator).startQrEngagement()
  }
  
  func testOnQRGeneration_WhenCoordinatorStartQrEngagementReturnsInValidData_ThenVerifyFailure() async {
    // Given
    let expectedError = PresentationSessionError.qrGeneration
    
    stub(presentationSessionCoordinator) { mock in
      when(mock.startQrEngagement()).thenThrow(expectedError)
    }

    // When
    let state = await interactor.onQRGeneration()
    
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
    verify(presentationSessionCoordinator).startQrEngagement()
  }
  
  func testStopPresentation_WhenInteractorMethodCalled_ThenStopsOnlyItsOwnSession() async {
    // Given
    let ownSession = presentationSessionCoordinator!
    stub(walletKitController) { mock in
      when(mock.stopProximityPresentation(any())).thenDoNothing()
    }

    // When
    await interactor.stopPresentation()

    // Then
    verify(walletKitController).stopProximityPresentation(ParameterMatcher { $0 === ownSession })
    verify(walletKitController, never()).stopPresentation()
    verify(presentationSessionCoordinator).stopPresentation()
  }

  func testStopPresentationOnceTheReaderLeaves_WhenTheReaderLeaves_ThenStopsThePresentationWithoutWaitingForTheTimeout() async {
    // Given
    let ownSession = presentationSessionCoordinator!
    stub(presentationSessionCoordinator) { mock in
      when(mock.waitForReaderDisconnect()).thenReturn(true)
    }
    stub(walletKitController) { mock in
      when(mock.stopProximityPresentation(any())).thenDoNothing()
    }
    let interactor = makeInteractor(with: ownSession, readerLeaveTimeout: 60)
    let start = Date()

    // When
    await interactor.stopPresentationOnceTheReaderLeaves()

    // Then
    XCTAssertLessThan(Date().timeIntervalSince(start), 5)
    verify(walletKitController).stopProximityPresentation(ParameterMatcher { $0 === ownSession })
    verify(presentationSessionCoordinator).stopPresentation()
  }

  func testStopPresentationOnceTheReaderLeaves_WhenTheReaderHasNotLeftYet_ThenTheSessionStaysOpen() async throws {
    // Given
    let session = ReaderStaysCoordinator(session: Constants.mockPresentationSession)
    stub(session) { mock in
      when(mock.stopPresentation()).thenDoNothing()
    }
    stub(walletKitController) { mock in
      when(mock.stopProximityPresentation(any())).thenDoNothing()
    }
    let interactor = makeInteractor(with: session, readerLeaveTimeout: 60)

    // When
    let waiting = Task { await interactor.stopPresentationOnceTheReaderLeaves() }
    try await Task.sleep(seconds: 0.3)

    // Then
    verify(walletKitController, never()).stopProximityPresentation(any())
    verify(session, never()).stopPresentation()
    waiting.cancel()
    await waiting.value
  }

  func testStopPresentationOnceTheReaderLeaves_WhenTheReaderNeverLeaves_ThenStopsThePresentationAfterTheTimeout() async {
    // Given
    let session = ReaderStaysCoordinator(session: Constants.mockPresentationSession)
    stub(session) { mock in
      when(mock.stopPresentation()).thenDoNothing()
    }
    stub(walletKitController) { mock in
      when(mock.stopProximityPresentation(any())).thenDoNothing()
    }
    let interactor = makeInteractor(with: session, readerLeaveTimeout: 0.2)

    // When
    await interactor.stopPresentationOnceTheReaderLeaves()

    // Then
    verify(walletKitController).stopProximityPresentation(ParameterMatcher { $0 === session })
    verify(session).stopPresentation()
  }
  
  /// Proximity carries no registration certificate
  func testOnRequestReceived_WhenCoordinatorRequestReceivedReturnsSuccess_ThenVerifySuccessState() async {
    
    // Given
    let request = Self.mockPresentationRequest
    
    let expectedUiModels = Self.mockUiModels()
    
    stub(presentationSessionCoordinator) { mock in
      when(mock.requestReceived()).thenReturn(request)
    }
    
    stubRevokedDocumentStatuses(with: [])
    
    // When
    let state = await interactor.onRequestReceived()
    
    // Then
    switch state {
    case .success(let uimodels, let relyingParty, let dataRequestInfo, let isTrusted, let registration):
      XCTAssertEqual(uimodels, [RequestCombinationUiModel(documents: expectedUiModels)])
      XCTAssertEqual(relyingParty, request.relyingParty)
      XCTAssertEqual(dataRequestInfo, request.dataRequestInfo)
      XCTAssertEqual(isTrusted, request.isTrusted)
      XCTAssertEqual(registration.registration, .notSupported)
    default:
      XCTFail("Wrong state \(state)")
    }
  }

  func testOnRequestReceived_WhenThePortraitIsRequested_ThenItsRowIsMarkedAsAPictureOfTheHolder() async {
    // Given
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
      requestNames: [],
      credentialQueries: []
    )
    stub(presentationSessionCoordinator) { mock in
      when(mock.requestReceived()).thenReturn(portraitRequest)
    }
    stubRevokedDocumentStatuses(with: [])

    // When
    let state = await interactor.onRequestReceived()

    // Then
    guard case .success(let combinations, _, _, _, _) = state else {
      return XCTFail("Wrong state \(state)")
    }
    let document = combinations.first?.documents.first
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

  func testOnRequestReceived_WhenTwoDocumentSetsSatisfyTheRequest_ThenOffersBoth() async {
    // Given
    let single = Self.mockPresentationRequest
    let request = PresentationRequest(
      itemSets: single.itemSets + single.itemSets,
      relyingParty: single.relyingParty,
      dataRequestInfo: single.dataRequestInfo,
      isTrusted: single.isTrusted,
      overaskedClaims: single.overaskedClaims,
      transactionDataSets: single.transactionDataSets,
      requestNames: single.requestNames + single.requestNames,
      credentialQueries: []
    )

    let expectedUiModels = Self.mockUiModels()

    stub(presentationSessionCoordinator) { mock in
      when(mock.requestReceived()).thenReturn(request)
    }

    stubRevokedDocumentStatuses(with: [])

    // When
    let state = await interactor.onRequestReceived()

    // Then
    switch state {
    case .success(let uimodels, let relyingParty, let dataRequestInfo, let isTrusted, let registration):
      XCTAssertEqual(uimodels, [RequestCombinationUiModel(documents: expectedUiModels), RequestCombinationUiModel(documents: expectedUiModels)])
      XCTAssertEqual(relyingParty, request.relyingParty)
      XCTAssertEqual(dataRequestInfo, request.dataRequestInfo)
      XCTAssertEqual(isTrusted, request.isTrusted)
      XCTAssertEqual(registration.registration, .notSupported)
    default:
      XCTFail("Wrong state \(state)")
    }
  }
  
  func testOnRequestReceived_WhenReaderIsNotAuthenticated_ThenStateIsUntrusted() async {
    // Given
    let trusted = Self.mockPresentationRequest
    let request = PresentationRequest(
      itemSets: trusted.itemSets,
      relyingParty: "Self-signed reader",
      dataRequestInfo: trusted.dataRequestInfo,
      isTrusted: false,
      overaskedClaims: trusted.overaskedClaims,
      transactionDataSets: trusted.transactionDataSets,
      requestNames: trusted.requestNames,
      credentialQueries: []
    )
    stub(presentationSessionCoordinator) { mock in
      when(mock.requestReceived()).thenReturn(request)
    }
    stub(walletKitController) { mock in
      when(
        mock.getVerifierRegistration(
          policy: any(),
          trustViolations: any(),
          overaskedClaims: any(),
          verifierName: any(),
          verifierIsTrusted: equal(to: false),
          isNotBoundToRequester: any(),
          transactionIdentifier: any()
        )
      ).thenReturn(
        RelyingPartyRegistration(
          name: "Self-signed reader",
          uniqueId: nil,
          isVerified: false,
          logoUrl: nil,
          registration: .notSupported
        )
      )
    }
    stubRevokedDocumentStatuses(with: [])

    // When
    let state = await interactor.onRequestReceived()

    // Then
    switch state {
    case .success(_, let relyingParty, _, let isTrusted, _):
      XCTAssertEqual(relyingParty, "Self-signed reader")
      XCTAssertFalse(isTrusted)
    default:
      XCTFail("Wrong state \(state)")
    }
    verify(walletKitController).getVerifierRegistration(
      policy: any(),
      trustViolations: any(),
      overaskedClaims: any(),
      verifierName: any(),
      verifierIsTrusted: equal(to: false),
      isNotBoundToRequester: any(),
      transactionIdentifier: any()
    )
  }

  func testOnRequestReceived_WhenCoordinatorRequestReceivedThrowsError_ThenVerifyFailureState() async {
    // Given
    let expectedError = PresentationSessionError.conversionToRequestItemModel

    stub(presentationSessionCoordinator) { mock in
      when(mock.requestReceived()).thenThrow(expectedError)
    }

    stubRevokedDocumentStatuses(with: [])

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

  func testOnRequestReceived_WhenCoordinatorRequestReceivedThrowsTrustError_ThenVerifyNotSecuredRequest() async {
    // Given
    stub(presentationSessionCoordinator) { mock in
      when(mock.requestReceived())
        .thenThrow(WalletError(description: "reader not trusted", code: .trustError))
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
  
  func testOnResponsePrepare_WhenRequestItemsContainDataOrVerificationRows_ThenVerifySuccessStateAndRequestItems() async {
    // Given
    let expectedRequestItems = Self.mockRequestItems
    
    stub(presentationSessionCoordinator) { mock in
      when(mock.setState(presentationState: any())).thenDoNothing()
    }
    
    // When
    let state = await interactor.onResponsePrepare(requestItems: Self.mockUiModels())
    
    // Then
    switch state {
    case .success(let request):
      XCTAssertEqual(request.items, expectedRequestItems)
    default:
      XCTFail("Wrong state \(state)")
    }
    
    verify(presentationSessionCoordinator).setState(presentationState: any())
  }
  
  func testOnResponsePrepare_WhenRequestItemsDoNotContainDataOrVerificationRows_ThenVerifyFailureState() async {
    // Given
    let expectedError = PresentationSessionError.conversionToRequestItemModel
    
    // When
    let state = await interactor.onResponsePrepare(requestItems: Self.mockUiModels().dropLast())
    
    // Then
    switch state {
    case .failure(let error):
      XCTAssertEqual(error.localizedDescription, expectedError.localizedDescription)
    default:
      XCTFail("Wrong state \(state)")
    }
  }
  
  func testOnSendResponse_WhenCoordinatorPresentationStateIsResponseToSend_ThenVerifySuccessState() async {
    // Given
    let presetationState: PresentationState = .responseToSend(Self.mockRequestItems)
    
    stub(presentationSessionCoordinator) { mock in
      when(mock.getState()).thenReturn(presetationState)
    }
    
    stub(presentationSessionCoordinator) { mock in
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
    
    verify(presentationSessionCoordinator).getState()
    verify(presentationSessionCoordinator).sendResponse(
      response: any()
    )
  }
  
  func testOnSendResponse_WhenCoordinatorPresentationStateIsNotResponseToSend_ThenVerifyFailureState() async {
    // Given
    let presetationState: PresentationState = .prepareQr
    let expectedError = PresentationSessionError.invalidState
    
    stub(presentationSessionCoordinator) { mock in
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
    
    verify(presentationSessionCoordinator).getState()
  }
  
  func testOnSendResponse_WhenCoordinatorPresentationStateIsResponseToSendAndSendResponseThrowsError_ThenVerifyFailureState() async {
    // Given
    let presetationState: PresentationState = .responseToSend(Self.mockRequestItems)
    let expectedError = RuntimeError.genericError
    
    stub(presentationSessionCoordinator) { mock in
      when(mock.getState()).thenReturn(presetationState)
      when(mock.sendResponse(response: any())).thenThrow(expectedError)
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
    
    verify(presentationSessionCoordinator).sendResponse(response: any())
  }

  func testOnRequestReceived_WhenAllDocumentsAreRevoked_ThenVerifySuccessWithNoItems() async {
    // Given
    let mockResponse = Self.mockPresentationRequest
    let revokedDocIds = mockResponse.itemSets.flatMap { $0 }.map { $0.docId }

    stub(presentationSessionCoordinator) { mock in
      when(mock.requestReceived()).thenReturn(mockResponse)
    }
    stub(walletKitController) { mock in
      when(mock.fetchRevokedDocumentStatuses()).thenReturn(Self.statuses(revokedDocIds, as: .revoked))
    }

    // When
    let state = await interactor.onRequestReceived()

    // Then
    switch state {
    case .success(let items, _, _, _, _):
      XCTAssertTrue(items.isEmpty)
    default:
      XCTFail("Expected success state, got \(state)")
    }
  }

  func testOnRequestReceived_WhenTheRevocationRecordsCannotBeRead_ThenFails() async {
    // Given
    stub(presentationSessionCoordinator) { mock in
      when(mock.requestReceived()).thenReturn(Self.mockPresentationRequest)
    }
    stub(walletKitController) { mock in
      when(mock.fetchRevokedDocumentStatuses()).thenThrow(RuntimeError.genericError)
    }

    // When
    let state = await interactor.onRequestReceived()

    // Then
    switch state {
    case .failure:
      break
    default:
      XCTFail("Expected failure state, got \(state)")
    }
  }

  func testOnRequestReceived_WhenTheDocumentIsSuspendedOrUnrecognised_ThenItIsLeftOut() async {
    // Given
    let docIds = Self.mockPresentationRequest.itemSets.flatMap { $0 }.map(\.docId)
    stub(presentationSessionCoordinator) { mock in
      when(mock.requestReceived()).thenReturn(Self.mockPresentationRequest)
    }

    // Then
    for status in [DocumentRevocationStatus.suspended, .unrecognised] {
      stubRevokedDocumentStatuses(with: docIds, as: status)

      let state = await interactor.onRequestReceived()

      switch state {
      case .success(let items, _, _, _, _):
        XCTAssertTrue(items.isEmpty, "\(status)")
      default:
        XCTFail("Expected success state for \(status), got \(state)")
      }
    }
  }
}

private extension TestProximityInteractor {
  
  static let mockPresentationRequest = Constants.mockPresentationRequest
  
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
                  trailingContent: .checkbox(
                    true,
                    true,
                    { _ in }
                  )
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
  
  func stubRevokedDocumentStatuses(with documentIds: [String], as status: DocumentRevocationStatus = .revoked) {
    stub(walletKitController) { mock in
      when(mock.fetchRevokedDocumentStatuses()).thenReturn(Self.statuses(documentIds, as: status))
    }
  }

  static func statuses(_ documentIds: [String], as status: DocumentRevocationStatus) -> [String: DocumentRevocationStatus] {
    Dictionary(documentIds.map { ($0, status) }, uniquingKeysWith: { first, _ in first })
  }

  func makeInteractor(
    with coordinator: ProximitySessionCoordinator,
    readerLeaveTimeout: TimeInterval
  ) -> ProximityInteractor {
    ProximityInteractorImpl(
      with: coordinator,
      and: walletKitController,
      configUiLogic: configUiLogic,
      readerLeaveTimeout: readerLeaveTimeout
    )
  }
}

private final class ReaderStaysCoordinator: MockProximitySessionCoordinator, @unchecked Sendable {

  override func waitForReaderDisconnect() async -> Bool {
    while !Task.isCancelled {
      try? await Task.sleep(seconds: 0.01)
    }
    return false
  }
}
