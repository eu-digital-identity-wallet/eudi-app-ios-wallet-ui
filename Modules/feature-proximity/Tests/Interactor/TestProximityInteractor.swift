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
import logic_resources
import logic_business
import feature_common
@testable import logic_core
@testable import feature_proximity
@testable import logic_test
@testable import feature_test

final class TestProximityInteractor: EudiTest {
  
  var interactor: ProximityInteractor!
  var walletKitController: MockWalletKitController!
  var presentationSessionCoordinator: MockProximitySessionCoordinator!
  var sessionHolder: MockSessionCoordinatorHolder!
  
  override func setUp() {
    self.walletKitController = MockWalletKitController()
    self.presentationSessionCoordinator = MockProximitySessionCoordinator(
      session: Constants.mockPresentationSession
    )
    self.sessionHolder = MockSessionCoordinatorHolder()
    
    stub(sessionHolder) { mock in
      when(mock.getActiveProximityCoordinator()).thenReturn(presentationSessionCoordinator)
    }
    
    stub(sessionHolder) { mock in
      when(mock.setActiveProximityCoordinator(any())).thenDoNothing()
    }
    
    stub(presentationSessionCoordinator) { mock in
      when(mock.stopPresentation()).thenDoNothing()
    }
    
    self.interactor = ProximityInteractorImpl(
      with: presentationSessionCoordinator,
      and: walletKitController,
      also: sessionHolder
    )
  }
  
  override func tearDown() {
    self.interactor = nil
    self.walletKitController = nil
    self.presentationSessionCoordinator = nil
  }
  
  func testOnDeviceEngagement_WhenCoordinatorInitialize_ThenVerifyCoordinatorInitializedAndState() async {
    // Given
    stub(presentationSessionCoordinator) { mock in
      when(mock.initialize()).thenDoNothing()
    }
    // When
    await interactor.onDeviceEngagement()
    // Then
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
    let state = interactor.getSessionStatePublisher()
    // Then
    switch state {
    case .success:
      XCTAssertTrue(true)
    default:
      XCTFail("Wrong state \(state)")
    }
  }
  
  func testGetSessionStatePublisher_WhenCoordinatorIsNotValid_ThenVerifyStateFailure() async {
    // Given
    let expectedError = RuntimeError.genericError
    stub(sessionHolder) { mock in
      when(mock.getActiveProximityCoordinator()).thenThrow(expectedError)
    }
    // When
    let state = interactor.getSessionStatePublisher()
    // Then
    switch state {
    case .failure(let error):
      XCTAssertEqual(error.localizedDescription, expectedError.localizedDescription)
    default:
      XCTFail("Wrong state \(state)")
    }
  }
  
  func testGetCoordinator_WhenCoordinatorIsValid_ThenVerifyStateSuccess() async {
    // When
    let state = interactor.getCoordinator()
    // Then
    switch state {
    case .success:
      XCTAssertTrue(true)
    default:
      XCTFail("Wrong state \(state)")
    }
  }
  
  func testGetCoordinator_WhenCoordinatorIsNotValid_ThenVerifyStateSuccess() async {
    // Given
    let expectedError = RuntimeError.genericError
    stub(sessionHolder) { mock in
      when(mock.getActiveProximityCoordinator()).thenThrow(expectedError)
    }
    // When
    let state = interactor.getCoordinator()
    // Then
    switch state {
    case .failure(let error):
      XCTAssertEqual(error.localizedDescription, expectedError.localizedDescription)
    default:
      XCTFail("Wrong state \(state)")
    }
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
      XCTAssertEqual(expectedImageData.count, imageData.count)
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
  
  func testStopPresentation_WhenWalletKitControllerStopPresenation_ThenVerifyWalletKitControllerStopPresentation() async {
    // Given
    stub(walletKitController) { mock in
      when(mock.stopPresentation()).thenDoNothing()
    }
    // When
    interactor.stopPresentation()
    // Then
    verify(walletKitController).stopPresentation()
  }
  
  func testOnRequestReceived_WhenCoordinatorRequestReceivedReturnsSuccess_ThenVerifySuccessState() async {
    
    // Given
    let request = Self.mockPresentationRequest
    
    let expectedUiModels = Self.mockUiModels()
    
    stub(presentationSessionCoordinator) { mock in
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
    case .success(let uimodels, let relyingParty, let dataRequestInfo, let isTrusted):
      XCTAssertEqual(uimodels, expectedUiModels)
      XCTAssertEqual(relyingParty, request.relyingParty)
      XCTAssertEqual(dataRequestInfo, request.dataRequestInfo)
      XCTAssertEqual(isTrusted, request.isTrusted)
    default:
      XCTFail("Wrong state \(state)")
    }
  }
  
  func testOnRequestReceived_WhenCoordinatorRequestReceivedThrowsError_ThenVerifyFailureState() async {
    // Given
    let expectedError = PresentationSessionError.conversionToRequestItemModel
    
    stub(presentationSessionCoordinator) { mock in
      when(mock.requestReceived()).thenThrow(expectedError)
    }
    
    stubFetchRevokedDocuments(with: [])
    
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
  
  func testOnSendResponse_WhenCoordinatorPresentationStateIsResponseToSend_ThenverifySuccessState() async {
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
    }
    
    stub(sessionHolder) { mock in
      when(
        mock.getActiveProximityCoordinator()
      ).thenThrow(expectedError)
    }
    
    // When
    let state = await interactor.onSendResponse()
    
    // Then
    switch state {
    case .failure(let error):
      XCTAssertEqual(error.localizedDescription, PresentationSessionError.invalidState.localizedDescription)
    default:
      XCTFail("Wrong state \(state)")
    }
    
    verify(presentationSessionCoordinator, times(0)).getState()
    verify(presentationSessionCoordinator, times(0)).sendResponse(response: any())
  }

  func testOnResponsePrepare_WhenGetActiveProximityCoordinatorThrowsError_ThenVerifyFailureState() async {
    // Given
    let expectedError = RuntimeError.genericError
    let validRequestItems = Self.mockUiModels()

    stub(sessionHolder) { mock in
      when(mock.getActiveProximityCoordinator()).thenThrow(expectedError)
    }

    // When
    let state = await interactor.onResponsePrepare(requestItems: validRequestItems)

    // Then
    switch state {
    case .failure(let error):
      XCTAssertEqual(error.localizedDescription, expectedError.localizedDescription)
    default:
      XCTFail("Expected failure state, got \(state)")
    }
  }

  func testOnSendResponse_WhenGetActiveProximityCoordinatorThrowsError_ThenVerifyFailureState() async {
    // Given
    let presetationState: PresentationState = .responseToSend(Self.mockRequestItems)
    let expectedError = PresentationSessionError.invalidState

    stub(sessionHolder) { mock in
      when(
        mock.getActiveProximityCoordinator()
      )
      .thenReturn(presentationSessionCoordinator)
      .thenThrow(expectedError)
    }

    stub(presentationSessionCoordinator) { mock in
      when(mock.getState()).thenReturn(presetationState)
    }

    // When
    let state = await interactor.onSendResponse()

    // Then
    switch state {
    case .failure(let error):
      XCTAssertEqual(
        error.localizedDescription,
        expectedError.localizedDescription
      )
    default:
      XCTFail("Expected failure state, got \(state)")
    }
  }

  func testOnRequestReceived_WhenAllDocumentsAreRevoked_ThenVerifyFailureState() async {
    // Given
    let mockResponse = Self.mockPresentationRequest
    let revokedDocIds = mockResponse.items.map { $0.docId }

    stub(presentationSessionCoordinator) { mock in
      when(mock.requestReceived()).thenReturn(mockResponse)
    }
    stub(walletKitController) { mock in
      when(mock.fetchRevokedDocuments()).thenReturn(revokedDocIds)
    }

    // When
    let state = await interactor.onRequestReceived()

    // Then
    switch state {
    case .failure(let error):
      XCTAssertEqual(
        error.localizedDescription,
        WalletCoreError.unableFetchDocuments.localizedDescription
      )
    default:
      XCTFail("Expected failure state, got \(state)")
    }
  }

  func testOnRequestReceived_WhenFetchRevokedDocumentsThrowsAndItemsNotEmpty_ThenVerifySuccessState() async {
    // Given
    let mockResponse = Self.mockPresentationRequest

    stub(presentationSessionCoordinator) { mock in
      when(mock.requestReceived()).thenReturn(mockResponse)
    }

    stub(walletKitController) { mock in
      when(mock.fetchRevokedDocuments()).thenThrow(RuntimeError.genericError)
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

    // When
    let state = await interactor.onRequestReceived()

    // Then
    switch state {
    case .success:
      XCTAssertTrue(true)
    default:
      XCTFail("Expected success state, got \(state)")
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
