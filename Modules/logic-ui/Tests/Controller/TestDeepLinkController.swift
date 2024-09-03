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
@testable import logic_ui
@testable import logic_test
@testable import logic_core

final class TestDeepLinkController: EudiTest {
  
  var controller: DeepLinkController!
  var prefsController: MockPrefsController!
  var walletKitController: MockWalletKitController!
  var urlSchemaController: MockUrlSchemaController!
  var routerHost: MockRouterHost!
  
  override func setUp() {
    self.prefsController = MockPrefsController()
    self.walletKitController = MockWalletKitController()
    self.urlSchemaController = MockUrlSchemaController()
    self.routerHost = MockRouterHost()
    self.controller = DeepLinkControllerImpl(
      prefsController: prefsController,
      walletKitController: walletKitController,
      urlSchemaController: urlSchemaController
    )
  }
  
  override func tearDown() {
    self.controller = nil
    self.prefsController = nil
    self.walletKitController = nil
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
  
  func testHandleDeepLinkAction_WhenRouterReturnsPreAuthorizationFlow_ThenValidateCachingOfDeepLink() {
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
    controller.handleDeepLinkAction(routerHost: routerHost, deepLinkExecutable: Self.mockedOpenId4VPDeepLinkAction)
    // Then
    verify(prefsController).setValue(any(), forKey: Prefs.Key.cachedDeepLink)
    verify(prefsController, times(0)).remove(forKey: Prefs.Key.cachedDeepLink)
  }
  
  func testHandleDeepLinkAction_WhenRouterReturnsAfterAuthorizationFlowAndActionIsOpenId4VPAndScreenNotForeground_ThenValidateCachingRemovalAndExecutionOfNavigation() {
    // Given
    let sessionCoordinator = RemoteSessionCoordinator(
      session: Self.mockPresentationSession
    )
    let appRoute = AppRoute.presentationRequest(presentationCoordinator: sessionCoordinator, originator: .dashboard)
    let pendingAction = Self.mockedOpenId4VPDeepLinkAction
    
    stubHandleDeepLink(
      coordinator: sessionCoordinator,
      action: pendingAction,
      route: appRoute,
      isAfterAuth: true,
      isScreenForeground: false
    )
    
    // When
    controller.handleDeepLinkAction(routerHost: routerHost, deepLinkExecutable: pendingAction)
    // Then
    verify(prefsController, times(0)).setValue(any(), forKey: Prefs.Key.cachedDeepLink)
    verify(prefsController).remove(forKey: Prefs.Key.cachedDeepLink)
    verify(walletKitController).startSameDevicePresentation(deepLink: pendingAction.link)
    verify(routerHost).push(with: appRoute)
  }
  
  func testHandleDeepLinkAction_WhenRouterReturnsAfterAuthorizationFlowAndActionIsOpenId4VPAndScreenIsForeground_ThenValidateCachingRemovalAndRouteNil() {
    // Given
    let sessionCoordinator = RemoteSessionCoordinator(
      session: Self.mockPresentationSession
    )
    let pendingAction = Self.mockedOpenId4VPDeepLinkAction
    
    stubHandleDeepLink(
      coordinator: sessionCoordinator,
      action: pendingAction,
      route: nil,
      isAfterAuth: true,
      isScreenForeground: true
    )
    
    // When
    controller.handleDeepLinkAction(routerHost: routerHost, deepLinkExecutable: pendingAction)
    // Then
    verify(prefsController, times(0)).setValue(any(), forKey: Prefs.Key.cachedDeepLink)
    verify(prefsController).remove(forKey: Prefs.Key.cachedDeepLink)
    verify(walletKitController).startSameDevicePresentation(deepLink: pendingAction.link)
    verify(routerHost, times(0)).push(with: any())
  }
  
  func testHandleDeepLinkAction_WhenRouterReturnsAfterAuthorizationFlowAndActionIsExternal_ThenValidateCachingRemovalAndNoInvocationOfRouter() {
    // Given
    let pendingAction = Self.mockedExternalDeepLinkAction
    
    stubHandleDeepLink(
      coordinator: nil,
      action: pendingAction,
      route: nil,
      isAfterAuth: true,
      isScreenForeground: false
    )
    
    // When
    controller.handleDeepLinkAction(routerHost: routerHost, deepLinkExecutable: pendingAction)
    // Then
    verify(prefsController, times(0)).setValue(any(), forKey: Prefs.Key.cachedDeepLink)
    verify(prefsController).remove(forKey: Prefs.Key.cachedDeepLink)
    verify(walletKitController, times(0)).startSameDevicePresentation(deepLink: any())
    verify(routerHost, times(0)).push(with: any())
  }
  
  func testGetPendingDeepLinkAction_WhenCachedDeepLinkIsValid_ThenReturnDeepListAction() {
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
}

private extension TestDeepLinkController {
  
  func stubHandleDeepLink(
    coordinator: PresentationSessionCoordinator?,
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
    if let coordinator {
      stub(walletKitController) { mock in
        when(mock.startSameDevicePresentation(deepLink: action.link)).thenReturn(coordinator)
      }
    }
  }
  
  static let mockedOpenId4VPUrl: URL = URL(string: "eudi-openid4vp://verifier-backend.eudiw.dev?client_id=verifier-backend.eudiw.dev&request_uri=https%3A%2F%2Fverifier-backend.eudiw.dev%2Fwallet%2Frequest.jwt%2FdjaFqCdMw6gnx-lSE7GmNi4Yr_Tyx_FRvhsBI0b10cti-LJbIE9Djd-gjbplmv3khSWYREf-WwjolPKl0Pihvw")!
  
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
  
  static let mockedMalformedUrl: URL = URL(string: "not_a_valid_url")!
  
}

private extension TestDeepLinkController {
  struct MockPresentationService: PresentationService {
    
    var flow: EudiWalletKit.FlowType
    
    func startQrEngagement() async throws -> String? { nil }
    
    func receiveRequest() async throws -> [String : Any] { [:] }
    
    func sendResponse(userAccepted: Bool, itemsToSend: EudiWalletKit.RequestItems, onSuccess: ((URL?) -> Void)?) async throws {}
  }
  
  static let mockPresentationSession = PresentationSession(
    presentationService: MockPresentationService(flow: .other),
    docIdAndTypes: [:],
    userAuthenticationRequired: false
  )
}
