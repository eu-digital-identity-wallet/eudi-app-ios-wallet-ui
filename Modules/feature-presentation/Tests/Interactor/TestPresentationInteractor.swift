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
import UIKit
import logic_business
import feature_common
@testable import logic_core
@testable import feature_presentation
@testable import logic_test
@testable import feature_test

final class TestPresentationInteractor: EudiTest {
  var interactor: PresentationInteractor!
  var walletKitController: MockWalletKitController!
  var sessionCoordinatorHolder: MockSessionCoordinatorHolder!
  var presentationCoordinator: MockRemoteSessionCoordinator!

  override func setUp() {
    walletKitController = MockWalletKitController()
    sessionCoordinatorHolder = MockSessionCoordinatorHolder()
    presentationCoordinator = MockRemoteSessionCoordinator(
      session: Constants.mockPresentationSession
    )

    stub(sessionCoordinatorHolder) { mock in
      when(mock.getActiveRemoteCoordinator()).thenReturn(presentationCoordinator)
    }

    stub(sessionCoordinatorHolder) { mock in
      when(mock.setActiveRemoteCoordinator(any())).thenDoNothing()
    }

    stub(presentationCoordinator) { mock in
      when(mock.stopPresentation()).thenDoNothing()
    }

    interactor = PresentationInteractorImpl(
      with: presentationCoordinator,
      and: walletKitController,
      also: sessionCoordinatorHolder
    )
  }

  override func tearDown() {
    interactor = nil
    walletKitController = nil
    sessionCoordinatorHolder = nil
    presentationCoordinator = nil
  }

  func testGetSessionStatePublisher_WhenActiveCoordinatorReturnsStream_ThenResultIsSuccessWithThatStream() {
    // Given
    let expectedStream: AsyncStream<PresentationState> = AsyncStream { completion in }

    stub(presentationCoordinator) { mock in
      when(mock.getStream()).thenReturn(expectedStream)
    }

    stub(sessionCoordinatorHolder) { mock in
      when(mock.getActiveRemoteCoordinator()).thenReturn(presentationCoordinator)
    }

    // When
    let result = interactor.getSessionStatePublisher()

    // Then
    switch result {
      case .success(let stream):
        XCTAssertNotNil(stream)
      default:
        XCTFail("Expected success but got \(result)")
    }
  }

  func testGetSessionStatePublisher_WhenActiveCoordinatorThrowsError_ThenReturnsFailureWithThatError() {
    // Given
    let expectedError = RuntimeError.genericError

    stub(sessionCoordinatorHolder) { mock in
      when(mock.getActiveRemoteCoordinator()).thenThrow(expectedError)
    }

    // When
    let result = interactor.getSessionStatePublisher()

    // Then
    switch result {
      case .failure(let error):
        XCTAssertEqual(error.localizedDescription, expectedError.localizedDescription)
      default:
        XCTFail("Expected success but got \(result)")
    }
  }

  func testGetCoordinator_WhenActiveCoordinatorExists_ThenReturnsSuccessWithCoordinator() {
    // Given
    let expectedStream: AsyncStream<PresentationState> = AsyncStream { completion in }

    stub(presentationCoordinator) { mock in
      when(mock.getStream()).thenReturn(expectedStream)
    }

    stub(sessionCoordinatorHolder) { mock in
      when(mock.getActiveRemoteCoordinator()).thenReturn(presentationCoordinator)
    }

    // When
    let result = interactor.getCoordinator()

    // Then
    switch result {
      case .success(let stream):
        XCTAssertNotNil(stream)
      default:
        XCTFail("Expected success but got \(result)")
    }
  }

  func testGetCoordinator_WhenActiveCoordinatorThrowsError_ThenReturnsFailureWithThatError() {
    // Given
    let expectedError = RuntimeError.genericError

    stub(sessionCoordinatorHolder) { mock in
      when(mock.getActiveRemoteCoordinator()).thenThrow(expectedError)
    }

    // When
    let result = interactor.getCoordinator()

    // Then
    switch result {
      case .failure(let error):
        XCTAssertEqual(error.localizedDescription, expectedError.localizedDescription)
      default:
        XCTFail("Expected success but got \(result)")
    }
  }

  func testUpdatePresentationCoordinator_WhenUpdatingWithCoordinator_ThenCallsSetActiveRemoteCoordinatorTwice() {
    // Given
    let expectedStream: AsyncStream<PresentationState> = AsyncStream { completion in }

    stub(presentationCoordinator) { mock in
      when(mock.getStream()).thenReturn(expectedStream)
    }

    // When
    let _ = interactor.updatePresentationCoordinator(with: presentationCoordinator)

    // Then
    verify(sessionCoordinatorHolder, times(2)).setActiveRemoteCoordinator(any())
  }

  func testStoreDynamicIssuancePendingUrl_WhenCalledWithUrl_ThenCallsWalletKitControllerStoreDynamicIssuancePendingUrl() {
    // Given
    let expectedURL = URL(string: "https://example.com/pending")!

    stub(walletKitController) { mock in
      when(mock.storeDynamicIssuancePendingUrl(with: any())).thenDoNothing()
    }

    // When
    interactor.storeDynamicIssuancePendingUrl(with: expectedURL)

    // Then
    verify(walletKitController).storeDynamicIssuancePendingUrl(with: any())
  }

  func testStopPresentation_WhenInteractorMethodCalled_ThenCallsWalletKitControllerStopPresentation() {
    // Given
    stub(walletKitController) { mock in
      when(mock.stopPresentation()).thenDoNothing()
    }
    // When
    interactor.stopPresentation()
    // Then
    verify(walletKitController).stopPresentation()
  }

  func testStopPresentation_WhenInteractorCalled_ThenCallsWalletKitControllerStopPresentation() async {
    // Given
    stub(walletKitController) { mock in
      when(mock.stopPresentation()).thenDoNothing()
    }
    // When
    interactor.stopPresentation()

    // Then
    verify(walletKitController).stopPresentation()
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

    stub(walletKitController) { mock in
      when(
        mock.parseDocClaim(
          docId: any(),
          groupId: any(),
          docClaim: any(),
          type: any(),
          parser: any()
        )
      ).thenReturn(
       [
        .primitive(
          id: Constants.randomIdentifier,
          title: "elementIdentifier",
          documentId: Constants.isoMdlModelId,
          nameSpace: "nameSpace",
          path: ["elementIdentifier"],
          type: .mdoc,
          value: .string("value"),
          status: .available(isRequired: false)
        ),
        .primitive(
          id: "revokedIdentifier",
          title: "elementIdentifier",
          documentId: Constants.isoMdlModelId,
          nameSpace: "nameSpace",
          path: ["elementIdentifier"],
          type: .mdoc,
          value: .string("value"),
          status: .available(isRequired: false)
        )
       ]
      )
    }

    stubFetchRevokedDocuments(with: ["revokedIdentifier"])

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

  func testOnRequestReceived_WhenCoordinatorReturnsRequest_ThenEmitsSuccessStateWithParsedUiModels() async {
    // Given
    let request = Self.mockPresentationRequest

    let expectedUiModels = Self.mockUiModels()

    stub(presentationCoordinator) { mock in
      when(mock.requestReceived()).thenReturn(request)
    }

    stub(walletKitController) { mock in
      when(
        mock.parseDocClaim(
          docId: any(),
          groupId: any(),
          docClaim: any(),
          type: any(),
          parser: any()
        )
      ).thenReturn(
       [
        .primitive(
          id: Constants.randomIdentifier,
          title: "elementIdentifier",
          documentId: Constants.isoMdlModelId,
          nameSpace: "nameSpace",
          path: ["elementIdentifier"],
          type: .mdoc,
          value: .string("value"),
          status: .available(isRequired: false)
        )
       ]
      )
    }

    stubFetchRevokedDocuments(with: [])

    // When
    let state = await interactor.onRequestReceived()

    // Then
    switch state {
    case .success(let successModel):
      XCTAssertEqual(successModel.requestDataCells, expectedUiModels)
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

    stubFetchRevokedDocuments(with: ["revokedIdentifier"])

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

  func testOnResponsePrepare_WhenCoordinatorSetState_ThenReturnsSuccessWithMappedRequestItemsAndCallsSetState() async {
    // Given
    let expectedRequestItems = Self.mockRequestItems

    stub(presentationCoordinator) { mock in
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

    verify(presentationCoordinator).setState(presentationState: any())
  }

  func testOnResponsePrepare_WhenSessionCoordinatorThrowsInvalidStateError_ThenReturnsFailureWithThatError() async {
    // Given
    let expectedError = PresentationSessionError.invalidState

    stub(presentationCoordinator) { mock in
      when(mock.setState(presentationState: any())).thenDoNothing()
    }

    stub(sessionCoordinatorHolder) { mock in
      when(mock.getActiveRemoteCoordinator()).thenThrow(expectedError)
    }

    // When
    let state = await interactor.onResponsePrepare(requestItems: Self.mockUiModels())

    // Then
    switch state {
    case .failure(let error):
      XCTAssertEqual(error.localizedDescription, expectedError.localizedDescription)
    default:
      XCTFail("Wrong state \(state)")
    }
  }

  func testOnResponsePrepare_WhenRequestItemsMissingDataOrVerificationRows_ThenReturnsFailureWithConversionError() async {
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

  func testOnSendResponse_WhenCoordinatorStateIsResponseToSendAndActiveCoordinatorThrowsError_ThenReturnsFailureWithThatError() async {
    // Given
    let presetationState: PresentationState = .responseToSend(Self.mockRequestItems)
    let expectedError = PresentationSessionError.invalidState

    stub(presentationCoordinator) { mock in
      when(mock.getState()).thenReturn(presetationState)
    }

    stub(sessionCoordinatorHolder) { mock in
      when(mock.getActiveRemoteCoordinator()).thenThrow(expectedError)
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
  }

  func testOnSendResponse_WhenSecondGetActiveRemoteCoordinatorThrows_ThenReturnsFailure() async {
    // Given
    let presentationState: PresentationState = .responseToSend(Self.mockRequestItems)
    let expectedError = PresentationSessionError.invalidState

    stub(sessionCoordinatorHolder) { mock in
      when(mock.getActiveRemoteCoordinator())
          .thenReturn(presentationCoordinator)
          .thenThrow(expectedError)
    }
    stub(presentationCoordinator) { mock in
      when(mock.getState()).thenReturn(presentationState)
    }

    // When
    let result = await interactor.onSendResponse()

    // Then
    switch result {
    case .failure(let error):
      XCTAssertEqual(error.localizedDescription, expectedError.localizedDescription)
    default:
      XCTFail("Expected failure, got \(result)")
    }
  }

  func testOnRequestReceived_WhenAllDocumentsRevoked_ThenReturnsFailure() async {
    // Given
    let mockResponse = Self.mockPresentationRequest
    let allDocIds = mockResponse.items.map { $0.docId }

    stub(presentationCoordinator) { mock in
      when(mock.requestReceived()).thenReturn(mockResponse)
    }
    stub(walletKitController) { mock in
      when(mock.fetchRevokedDocuments()).thenReturn(allDocIds)
    }

    stub(walletKitController) { mock in
      when(
        mock.parseDocClaim(
          docId: any(),
          groupId: any(),
          docClaim: any(),
          type: any(),
          parser: any()
        )
      ).thenReturn([])
    }

    // When
    let result = await interactor.onRequestReceived()

    // Then
    switch result {
    case .failure(let error):
      XCTAssertEqual(
        error.localizedDescription,
        WalletCoreError.unableFetchDocuments.localizedDescription
      )
    default:
      XCTFail("Expected failure, got \(result)")
    }
  }

  func testOnRequestReceived_WhenFetchRevokedDocumentsThrows_ThenReturnsSuccess() async {
    // Given
    let mockResponse = Self.mockPresentationRequest

    stub(presentationCoordinator) { mock in
        when(mock.requestReceived()).thenReturn(mockResponse)
    }
    stub(walletKitController) { mock in
        when(mock.fetchRevokedDocuments()).thenThrow(RuntimeError.genericError)
    }
    // Also stub parseDocClaim
    stub(walletKitController) { mock in
      when(
        mock.parseDocClaim(
          docId: any(),
          groupId: any(),
          docClaim: any(),
          type: any(),
          parser: any()
        )
      ).thenReturn([
        .primitive(
          id: Constants.randomIdentifier,
          title: "elementIdentifier",
          documentId: Constants.isoMdlModelId,
          nameSpace: "nameSpace",
          path: ["elementIdentifier"],
          type: .mdoc,
          value: .string("value"),
          status: .available(isRequired: false)
        )
      ])
    }

    // When
    let result = await interactor.onRequestReceived()

    // Then
    switch result {
    case .success:
      XCTAssertTrue(true)
    default:
      XCTFail("Expected success, got \(result)")
    }
  }
}

private extension TestPresentationInteractor {

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
                  mainText: .custom("value"),
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

  func stubFetchRevokedDocuments(with revokedDocuments: [String]) {
    stub(walletKitController) { mock in
      when(mock.fetchRevokedDocuments()).thenReturn(revokedDocuments)
    }
  }
}
