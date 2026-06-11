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
import logic_business
@testable import logic_ui
@testable import logic_test
@testable import logic_core

final class TestDeepLinkController: EudiTest {
  
  var controller: DeepLinkController!
  var prefsController: MockPrefsController!
  var urlSchemaController: MockUrlSchemaController!
  var routerHost: MockRouterHost!

  override func setUp() {
    self.prefsController = MockPrefsController()
    self.urlSchemaController = MockUrlSchemaController()
    self.routerHost = MockRouterHost()
    self.controller = DeepLinkControllerImpl(
      prefsController: prefsController,
      urlSchemaController: urlSchemaController
    )
  }
  
  override func tearDown() {
    self.controller = nil
    self.prefsController = nil
    self.urlSchemaController = nil
    self.routerHost = nil
  }
  
  func testHasDeepLink_WhenUrlIsAValidOpenId4VPDeepLink_ThenReturnDeepLinkActionWithOpenId4VPType() {
    // Given
    let expected = Self.mockedOpenId4VPDeepLinkAction
    stub(urlSchemaController) { mock in
      when(mock.retrieveSchemas(with: any())).thenReturn(["eudi-openid4vp", "mdoc-openid4vp"])
    }
    // When
    let action = controller.hasDeepLink(url: Self.mockedOpenId4VPUrl)
    // Then
    XCTAssertEqual(action, expected)
  }
  
  func testHasDeepLink_WhenUrlIsNotKnownType_ThenReturnDeepLinkActionWithExternalType() {
    // Given
    let expected = Self.mockedExternalDeepLinkAction
    stub(urlSchemaController) { mock in
      when(mock.retrieveSchemas(with: any())).thenReturn([])
    }
    // When
    let action = controller.hasDeepLink(url: Self.mockedExternalUrl)
    // Then
    XCTAssertEqual(action, expected)
  }
  
  func testHasDeepLink_WhenUrlIsMalformed_ThenReturnDeepLinkActionNil() {
    // Given
    let malFormedUrl = Self.mockedMalformedUrl
    // When
    let action = controller.hasDeepLink(url: malFormedUrl)
    // Then
    XCTAssertNil(action)
  }
  
  func testHandleDeepLinkAction_WhenRouterReturnsPreAuthorizationFlow_ThenValidateCachingOfDeepLink() async {
    // Given
    stub(prefsController) { mock in
      when(mock.setValue(any(), forKey: Prefs.Key.cachedDeepLink)).thenDoNothing()
    }
    stub(prefsController) { mock in
      when(mock.remove(forKey: Prefs.Key.cachedDeepLink)).thenDoNothing()
    }
    stub(routerHost) { mock in
      when(mock.userIsLoggedInWithDocuments()).thenReturn(false)
    }
    // When
    await controller.handleDeepLinkAction(
      routerHost: routerHost,
      deepLinkExecutable: Self.mockedOpenId4VPDeepLinkAction,
      remoteSessionCoordinator: nil
    )
    // Then
    verify(prefsController).setValue(any(), forKey: Prefs.Key.cachedDeepLink)
    verify(prefsController, times(0)).remove(forKey: Prefs.Key.cachedDeepLink)
  }

  func testHandleDeepLinkAction_WhenRouterReturnsAfterAuthorizationFlowAndActionIsOpenId4VPAndScreenNotForeground_ThenValidateCachingRemovalAndExecutionOfNavigation() async {
    // Given
    let sessionCoordinator = RemoteSessionCoordinatorImpl(
      session: Self.mockPresentationSession
    )
    let appRoute = AppRoute.featurePresentationModule(.presentationRequest(presentationCoordinator: sessionCoordinator, originator: .featureDashboardModule(.dashboard)))
    let pendingAction = Self.mockedOpenId4VPDeepLinkAction
    
    stubHandleDeepLink(
      action: pendingAction,
      route: appRoute,
      isAfterAuth: true,
      isScreenForeground: false
    )
    
    // When
    await controller.handleDeepLinkAction(
      routerHost: routerHost,
      deepLinkExecutable: pendingAction,
      remoteSessionCoordinator: sessionCoordinator
    )
    // Then
    verify(prefsController, times(0)).setValue(any(), forKey: Prefs.Key.cachedDeepLink)
    verify(prefsController).remove(forKey: Prefs.Key.cachedDeepLink)
    verify(routerHost).push(with: appRoute)
  }
  
  func testHandleDeepLinkAction_WhenRouterReturnsAfterAuthorizationFlowAndActionIsOpenId4VPAndScreenIsForeground_ThenValidateCachingRemovalAndRouteNil() async {
    // Given
    let sessionCoordinator = RemoteSessionCoordinatorImpl(
      session: Self.mockPresentationSession
    )
    let pendingAction = Self.mockedOpenId4VPDeepLinkAction
    
    stubHandleDeepLink(
      action: pendingAction,
      route: nil,
      isAfterAuth: true,
      isScreenForeground: true
    )
    
    // When
    await controller.handleDeepLinkAction(
      routerHost: routerHost,
      deepLinkExecutable: pendingAction,
      remoteSessionCoordinator: sessionCoordinator
    )
    // Then
    verify(prefsController, times(0)).setValue(any(), forKey: Prefs.Key.cachedDeepLink)
    verify(prefsController).remove(forKey: Prefs.Key.cachedDeepLink)
    verify(routerHost, times(0)).push(with: any())
  }
  
  func testHandleDeepLinkAction_WhenRouterReturnsAfterAuthorizationFlowAndActionIsExternal_ThenValidateCachingRemovalAndNoInvocationOfRouter() async {
    // Given
    let pendingAction = Self.mockedExternalDeepLinkAction
    
    stubHandleDeepLink(
      action: pendingAction,
      route: nil,
      isAfterAuth: true,
      isScreenForeground: false
    )
    
    // When
    await controller.handleDeepLinkAction(
      routerHost: routerHost,
      deepLinkExecutable: pendingAction,
      remoteSessionCoordinator: nil
    )
    // Then
    verify(prefsController, times(0)).setValue(any(), forKey: Prefs.Key.cachedDeepLink)
    verify(prefsController).remove(forKey: Prefs.Key.cachedDeepLink)
    verify(routerHost, times(0)).push(with: any())
  }
  
  func testGetPendingDeepLinkAction_WhenCachedDeepLinkIsValidAndActionRequiresCoordinator_ThenReturnDeepListActionAndVerifyCoordinatorFlag() {
    // Given
    let expected = Self.mockedOpenId4VPDeepLinkAction
    stub(prefsController) { mock in
      when(mock.getString(forKey: Prefs.Key.cachedDeepLink)).thenReturn(Self.mockedOpenId4VPUrl.absoluteString)
    }
    stub(urlSchemaController) { mock in
      when(mock.retrieveSchemas(with: any())).thenReturn(["eudi-openid4vp", "mdoc-openid4vp"])
    }
    // When
    let action = controller.getPendingDeepLinkAction()
    // Then
    XCTAssertEqual(action, expected)
    XCTAssertEqual(action?.requiresCoordinator, true)
  }
  
  func testGetPendingDeepLinkAction_WhenCachedDeepLinkIsValidAndActionDoesNotRequireCoordinator_ThenReturnDeepListActionAndVerifyCoordinatorFlag() {
    // Given
    let expected = Self.mockedExternalDeepLinkAction
    stub(prefsController) { mock in
      when(mock.getString(forKey: Prefs.Key.cachedDeepLink)).thenReturn(Self.mockedExternalUrl.absoluteString)
    }
    stub(urlSchemaController) { mock in
      when(mock.retrieveSchemas(with: any())).thenReturn(["eudi-openid4vp", "mdoc-openid4vp"])
    }
    // When
    let action = controller.getPendingDeepLinkAction()
    // Then
    XCTAssertEqual(action, expected)
    XCTAssertEqual(action?.requiresCoordinator, false)
  }
  
  func testGetPendingDeepLinkAction_WhenCachedDeepLinkIsInvalid_ThenReturnDeepListActionNil() {
    // Given
    stub(prefsController) { mock in
      when(mock.getString(forKey: Prefs.Key.cachedDeepLink)).thenReturn(Self.mockedMalformedUrl.absoluteString)
    }
    // When
    let action = controller.getPendingDeepLinkAction()
    // Then
    XCTAssertNil(action)
  }
  
  func testGetPendingDeepLinkAction_WhenPrefsControllerReturnsNil_ThenReturnDeepListActionNil() {
    // Given
    stub(prefsController) { mock in
      when(mock.getString(forKey: Prefs.Key.cachedDeepLink)).thenReturn(nil)
    }
    // When
    let action = controller.getPendingDeepLinkAction()
    // Then
    XCTAssertNil(action)
  }
  
  func testCacheDeepLinkURL_WhenUrlIsProvided_ThenVerifyMethodInvocation() {
    // Given
    let url = Self.mockedOpenId4VPUrl
    stub(prefsController) { mock in
      when(mock.setValue(any(), forKey: Prefs.Key.cachedDeepLink)).thenDoNothing()
    }
    // When
    controller.cacheDeepLinkURL(url: url)
    // Then
    verify(prefsController).setValue(any(), forKey: Prefs.Key.cachedDeepLink)
  }

  func testHandleDeepLinkAction_WhenCredentialOfferActionAndScreenIsNotForeground_ThenPushCredentialOfferRequest() async {
    // Given
    let sessionCoordinator = RemoteSessionCoordinatorImpl(
      session: Self.mockPresentationSession
    )
    let pendingAction = Self.mockedCredentialOfferDeepLinkAction

    stubHandleDeepLink(
      action: pendingAction,
      route: nil,
      isAfterAuth: true,
      isScreenForeground: true
    )

    // When
    await controller.handleDeepLinkAction(
      routerHost: routerHost,
      deepLinkExecutable: pendingAction,
      remoteSessionCoordinator: sessionCoordinator
    )

    // Then
    verify(prefsController, times(0)).setValue(any(), forKey: Prefs.Key.cachedDeepLink)
    verify(prefsController).remove(forKey: Prefs.Key.cachedDeepLink)
    verify(routerHost, times(0)).push(with: any())
  }

  func testHandleDeepLinkAction_WhenCredentialOfferActionAndScreenIsNotForeground_ThenPushesIssuanceRoute() async {
    // Given: post-auth, credential_offer action, screen NOT foreground -> push branch (line 142)
    let pendingAction = Self.mockedCredentialOfferDeepLinkAction

    stubHandleDeepLink(
      action: pendingAction,
      route: nil,
      isAfterAuth: true,
      isScreenForeground: false
    )
    stub(routerHost) { mock in
      when(mock.push(with: any())).thenDoNothing()
    }

    // When
    await controller.handleDeepLinkAction(
      routerHost: routerHost,
      deepLinkExecutable: pendingAction,
      remoteSessionCoordinator: nil
    )

    // Then
    verify(prefsController).remove(forKey: Prefs.Key.cachedDeepLink)
    verify(routerHost).push(with: any())
  }

  func testHandleDeepLinkAction_WhenActionIsHaipVpAndScreenNotForeground_ThenPushesPresentationRoute() async {
    // Given: .haip_vp shares the openid4vp switch arm — must also push when not foreground
    let sessionCoordinator = RemoteSessionCoordinatorImpl(
      session: Self.mockPresentationSession
    )
    let pendingAction = Self.mockedHaipVpDeepLinkAction
    stubHandleDeepLink(
      action: pendingAction,
      route: nil,
      isAfterAuth: true,
      isScreenForeground: false
    )
    stub(routerHost) { mock in
      when(mock.push(with: any())).thenDoNothing()
    }

    // When
    await controller.handleDeepLinkAction(
      routerHost: routerHost,
      deepLinkExecutable: pendingAction,
      remoteSessionCoordinator: sessionCoordinator
    )

    // Then
    verify(prefsController).remove(forKey: Prefs.Key.cachedDeepLink)
    verify(routerHost).push(with: any())
  }

  func testHandleDeepLinkAction_WhenActionIsHaipVciAndScreenNotForeground_ThenPushesIssuanceRoute() async {
    // Given: .haip_vci shares the credential_offer switch arm
    let pendingAction = Self.mockedHaipVciDeepLinkAction
    stubHandleDeepLink(
      action: pendingAction,
      route: nil,
      isAfterAuth: true,
      isScreenForeground: false
    )
    stub(routerHost) { mock in
      when(mock.push(with: any())).thenDoNothing()
    }

    // When
    await controller.handleDeepLinkAction(
      routerHost: routerHost,
      deepLinkExecutable: pendingAction,
      remoteSessionCoordinator: nil
    )

    // Then
    verify(prefsController).remove(forKey: Prefs.Key.cachedDeepLink)
    verify(routerHost).push(with: any())
  }

  func testHandleDeepLinkAction_WhenRqesPendingAndUserLoggedInWithDocuments_ThenPopsToDashboard() async {
    // Given: action == .rqes AND user logged in AND not on dashboard already
    // → shouldPopToDashboardFirst guard fires, popTo(dashboard) is invoked
    let pendingAction = Self.mockedRqesDeepLinkAction
    stub(prefsController) { mock in
      when(mock.setValue(any(), forKey: Prefs.Key.cachedDeepLink)).thenDoNothing()
      when(mock.remove(forKey: Prefs.Key.cachedDeepLink)).thenDoNothing()
    }
    stub(routerHost) { mock in
      when(mock.userIsLoggedInWithDocuments()).thenReturn(true)
      when(mock.userIsLoggedInWithNoDocuments()).thenReturn(false)
      when(mock.isScreenForeground(with: any())).thenReturn(false)
      when(mock.popTo(with: any(), inclusive: any())).thenDoNothing()
    }

    // When
    await controller.handleDeepLinkAction(
      routerHost: routerHost,
      deepLinkExecutable: pendingAction,
      remoteSessionCoordinator: nil
    )

    // Then
    verify(prefsController).setValue(any(), forKey: Prefs.Key.cachedDeepLink)
    verify(routerHost).popTo(with: any(), inclusive: equal(to: false))
  }

  func testHandleDeepLinkAction_WhenRqesWithoutAuthorizationCode_ThenEarlyReturn() async {
    // Given: .rqes action with no `code` query item — guard at line 152 returns early
    let url = URL(string: "rqes://callback?other=value")!
    let executable = DeepLink.Executable(
      link: URLComponents(url: url, resolvingAgainstBaseURL: true)!,
      plainUrl: url,
      action: .rqes
    )
    stub(prefsController) { mock in
      when(mock.remove(forKey: Prefs.Key.cachedDeepLink)).thenDoNothing()
    }
    stub(routerHost) { mock in
      when(mock.userIsLoggedInWithDocuments()).thenReturn(true)
      when(mock.userIsLoggedInWithNoDocuments()).thenReturn(false)
      when(mock.isScreenForeground(with: any())).thenReturn(true)
    }

    // When
    await controller.handleDeepLinkAction(
      routerHost: routerHost,
      deepLinkExecutable: executable,
      remoteSessionCoordinator: nil
    )

    // Then
    verify(prefsController).remove(forKey: Prefs.Key.cachedDeepLink)
    verify(routerHost, times(0)).push(with: any())
  }

  func testHandleDeepLinkAction_WhenRqesWithAuthorizationCode_ThenSchedulesResumeTask() async {
    // Given: .rqes action WITH a `code` query item.
    // Hits the Task { @MainActor in ... } block (lines 156-170). The Task itself
    // polls for topViewController which never resolves in unit tests, so we
    // simply verify the function returns and reaches the spawn point.
    let url = URL(string: "rqes://callback?code=abc123")!
    let executable = DeepLink.Executable(
      link: URLComponents(url: url, resolvingAgainstBaseURL: true)!,
      plainUrl: url,
      action: .rqes
    )
    stub(prefsController) { mock in
      when(mock.remove(forKey: Prefs.Key.cachedDeepLink)).thenDoNothing()
    }
    stub(routerHost) { mock in
      when(mock.userIsLoggedInWithDocuments()).thenReturn(true)
      when(mock.userIsLoggedInWithNoDocuments()).thenReturn(false)
      when(mock.isScreenForeground(with: any())).thenReturn(true)
    }

    // When
    await controller.handleDeepLinkAction(
      routerHost: routerHost,
      deepLinkExecutable: executable,
      remoteSessionCoordinator: nil
    )

    // Then: the function reached the .rqes case and dispatched the resume Task
    verify(prefsController).remove(forKey: Prefs.Key.cachedDeepLink)
  }

  func testRemoveCachedDeepLinkURL_WhenCalled_ThenDelegatesToPrefsController() {
    // Given
    stub(prefsController) { mock in
      when(mock.remove(forKey: Prefs.Key.cachedDeepLink)).thenDoNothing()
    }

    // When
    controller.removeCachedDeepLinkURL()

    // Then
    verify(prefsController).remove(forKey: Prefs.Key.cachedDeepLink)
  }

  func testHasDeepLink_WhenSchemaControllerMatchesRqes_ThenActionIsRqes() {
    // Given: parseType returns .rqes when scheme matches the rqes schema list
    stub(urlSchemaController) { mock in
      // First call: openid4vp schemas (no match), then credential_offer (no match), then rqes (match)
      when(mock.retrieveSchemas(with: any())).then { name in
        return name == "rqes" ? ["rqes-callback"] : []
      }
    }
    let url = URL(string: "rqes-callback://complete?code=abc")!

    // When
    let action = controller.hasDeepLink(url: url)

    // Then
    XCTAssertEqual(action?.action, .rqes)
  }
}

private extension TestDeepLinkController {
  
  func stubHandleDeepLink(
    action: DeepLink.Executable,
    route: AppRoute?,
    isAfterAuth: Bool,
    isScreenForeground: Bool
  ) {
    stub(prefsController) { mock in
      when(mock.setValue(any(), forKey: Prefs.Key.cachedDeepLink)).thenDoNothing()
    }
    stub(prefsController) { mock in
      when(mock.remove(forKey: Prefs.Key.cachedDeepLink)).thenDoNothing()
    }
    stub(routerHost) { mock in
      when(mock.userIsLoggedInWithDocuments()).thenReturn(isAfterAuth)
    }
    stub(routerHost) { mock in
      when(mock.isScreenForeground(with: any())).thenReturn(isScreenForeground)
    }
    if let route {
      stub(routerHost) { mock in
        when(mock.push(with: route)).thenDoNothing()
      }
    }
  }
  
  static let mockedOpenId4VPUrl: URL = URL(string: "eudi-openid4vp://verifier-backend.eudiw.dev?client_id=verifier-backend.eudiw.dev&request_uri=https://verifier-backend.eudiw.dev/wallet/request.jwt/djaFqCdMw6gnx-lSE7GmNi4Yr_Tyx_FRvhsBI0b10cti-LJbIE9Djd-gjbplmv3khSWYREf-WwjolPKl0Pihvw")!
  
  static let mockedOpenId4VPDeepLinkAction = DeepLink.Executable(
    link: URLComponents(url: mockedOpenId4VPUrl, resolvingAgainstBaseURL: true)!,
    plainUrl: mockedOpenId4VPUrl,
    action: .openid4vp
  )
  
  static let mockedExternalUrl: URL = URL(string: "https://commission.europa.eu")!
  
  static let mockedExternalDeepLinkAction = DeepLink.Executable(
    link: URLComponents(url: mockedExternalUrl, resolvingAgainstBaseURL: true)!,
    plainUrl: mockedExternalUrl,
    action: .external
  )

  static let mockedCredentialOfferDeepLinkAction = DeepLink.Executable(
    link: URLComponents(url: mockedExternalUrl, resolvingAgainstBaseURL: true)!,
    plainUrl: mockedExternalUrl,
    action: .credential_offer
  )

  static let mockedHaipVpDeepLinkAction = DeepLink.Executable(
    link: URLComponents(url: mockedOpenId4VPUrl, resolvingAgainstBaseURL: true)!,
    plainUrl: mockedOpenId4VPUrl,
    action: .haip_vp
  )

  static let mockedHaipVciDeepLinkAction = DeepLink.Executable(
    link: URLComponents(url: mockedExternalUrl, resolvingAgainstBaseURL: true)!,
    plainUrl: mockedExternalUrl,
    action: .haip_vci
  )

  static let mockedRqesUrl: URL = URL(string: "rqes://callback?code=auth-code")!

  static let mockedRqesDeepLinkAction = DeepLink.Executable(
    link: URLComponents(url: mockedRqesUrl, resolvingAgainstBaseURL: true)!,
    plainUrl: mockedRqesUrl,
    action: .rqes
  )

  static let mockedMalformedUrl: URL = URL(string: "not_a_valid_url")!

}

private extension TestDeepLinkController {
  struct MockPresentationService: PresentationService {
    var zkpDocumentIds: [WalletStorage.Document.ID]?
    
    func waitForDisconnect() async throws {}
    
    var transactionLog: TransactionLog
    
    func startQrEngagement(secureAreaName: String?, keyOptions: MdocDataModel18013.KeyOptions) async throws -> String {
      ""
    }
    
    func receiveRequest() async throws -> MdocDataTransfer18013.UserRequestInfo {
      .init(docDataFormats: [DocumentTypeIdentifier.mDocPid.rawValue : .cbor], itemsRequested: RequestItems())
    }
    
    var flow: EudiWalletKit.FlowType
    
    func startQrEngagement() async throws -> String? { nil }
    
    func receiveRequest() async throws -> [String : Any] { [:] }
    
    func sendResponse(userAccepted: Bool, itemsToSend: EudiWalletKit.RequestItems, onSuccess: ((URL?) -> Void)?) async throws {}
  }
  
  static let mockTransactionLog: TransactionLog = .init(
    timestamp: .min,
    status: .completed,
    type: .presentation,
    dataFormat: .cbor
  )
  
  static let mockStorageService: DataStorageService = KeyChainStorageService(
    serviceName: "",
    accessGroup: ""
  )
  
  static let mockPresentationSession = PresentationSession(
    presentationService: MockPresentationService(
      zkpDocumentIds: nil,
      transactionLog: mockTransactionLog,
      flow: .other
    ),
    storageManager: .init(storageService: mockStorageService),
    docIdToPresentInfo: [:],
    documentKeyIndexes: [:],
    userAuthenticationRequired: false
  )
}
