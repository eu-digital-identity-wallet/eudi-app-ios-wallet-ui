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
  var walletKitController: MockWalletKitController!

  override func setUp() {
    self.prefsController = MockPrefsController()
    self.urlSchemaController = MockUrlSchemaController()
    self.routerHost = MockRouterHost()
    self.walletKitController = MockWalletKitController()
    stub(prefsController) { mock in
      when(mock.remove(forKey: any())).thenDoNothing()
    }
    stub(urlSchemaController) { mock in
      when(mock.retrieveSchemas(with: any())).then { type in Self.mockedSchemas[type] ?? [] }
    }
    stub(walletKitController) { mock in
      when(mock.stopPresentation()).thenDoNothing()
    }
    self.controller = DeepLinkControllerImpl(
      prefsController: prefsController,
      urlSchemaController: urlSchemaController,
      walletKitController: walletKitController,
      rqesCallbackUris: ["rqes://oauth/callback"]
    )
    controller.setDocumentsLoaded()
  }
  
  override func tearDown() {
    self.controller = nil
    self.prefsController = nil
    self.urlSchemaController = nil
    self.routerHost = nil
    self.walletKitController = nil
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
  
  func testHasDeepLink_WhenTheLinkStartsNoWalletFlow_ThenReturnsNothing() {
    stub(urlSchemaController) { mock in
      when(mock.retrieveSchemas(with: any())).thenReturn([])
    }

    XCTAssertNil(controller.hasDeepLink(url: Self.mockedExternalUrl))
  }
  
  func testHasDeepLink_WhenAnRqesLinkIsTheSigningServiceCallback_ThenReturnsTheRqesAction() {
    stub(urlSchemaController) { mock in
      when(mock.retrieveSchemas(with: any())).then { type in type == "rqes" ? ["rqes"] : [] }
    }

    let action = controller.hasDeepLink(url: URL(string: "rqes://oauth/callback?code=abc&state=xyz")!)

    XCTAssertEqual(action?.action, .rqes)
  }

  func testHasDeepLink_WhenAnRqesLinkHasAnotherHostOrPath_ThenReturnsNothing() {
    stub(urlSchemaController) { mock in
      when(mock.retrieveSchemas(with: any())).then { type in type == "rqes" ? ["rqes"] : [] }
    }

    XCTAssertNil(controller.hasDeepLink(url: URL(string: "rqes://attacker/callback?code=abc")!))
    XCTAssertNil(controller.hasDeepLink(url: URL(string: "rqes://oauth/elsewhere?code=abc")!))
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
    stub(routerHost) { mock in
      when(mock.userIsLoggedInWithDocuments()).thenReturn(false)
    }
    // When
    await controller.handleDeepLinkAction(
      routerHost: routerHost,
      deepLinkExecutable: Self.mockedOpenId4VPDeepLinkAction
    )
    // Then
    XCTAssertNotNil(controller.getPendingDeepLinkAction())
    verify(walletKitController, never()).startSameDevicePresentation(deepLink: any())
  }

  func testHandleDeepLinkAction_WhenLoggedInAndActionIsOpenId4VPAwayFromTheDashboard_ThenKeepsTheLinkAndReturnsToTheDashboardWithoutASession() async {
    stubHandleDeepLink(
      action: Self.mockedOpenId4VPDeepLinkAction,
      route: nil,
      isAfterAuth: true,
      isScreenForeground: false
    )
    stub(routerHost) { mock in
      when(mock.popTo(with: any(), inclusive: any())).thenDoNothing()
    }

    await controller.handleDeepLinkAction(
      routerHost: routerHost,
      deepLinkExecutable: Self.mockedOpenId4VPDeepLinkAction
    )

    XCTAssertNotNil(controller.getPendingDeepLinkAction())
    verify(routerHost).popTo(with: equal(to: AppRoute.featureDashboardModule(.dashboard)), inclusive: equal(to: false))
    verify(routerHost, never()).push(with: any())
    verify(walletKitController, never()).startSameDevicePresentation(deepLink: any())
  }

  func testHandleDeepLinkAction_WhenLoggedInAndActionIsOpenId4VPOnTheDashboard_ThenStartsTheSessionAndPushesItsRequest() async {
    let sessionCoordinator = RemoteSessionCoordinatorImpl(
      session: PresentationSession.fixture
    )
    let expectedRoute = AppRoute.featurePresentationModule(
      .presentationRequest(
        presentationCoordinator: sessionCoordinator,
        originator: .featureDashboardModule(.dashboard)
      )
    )
    stubHandleDeepLink(
      action: Self.mockedOpenId4VPDeepLinkAction,
      route: nil,
      isAfterAuth: true,
      isScreenForeground: true
    )
    stub(walletKitController) { mock in
      when(mock.startSameDevicePresentation(deepLink: any())).thenReturn(sessionCoordinator)
    }
    let pushed = expectation(description: "request pushed")
    stub(routerHost) { mock in
      when(mock.push(with: equal(to: expectedRoute))).then { _ in pushed.fulfill() }
    }

    await controller.handleDeepLinkAction(
      routerHost: routerHost,
      deepLinkExecutable: Self.mockedOpenId4VPDeepLinkAction
    )
    await fulfillment(of: [pushed], timeout: 2)

    XCTAssertNil(controller.getPendingDeepLinkAction())
    verify(walletKitController).startSameDevicePresentation(deepLink: equal(to: Self.mockedOpenId4VPDeepLinkAction.link))
    verify(routerHost).push(with: equal(to: expectedRoute))
  }

  
  func testGetPendingDeepLinkAction_WhenAPresentationLinkIsKept_ThenReturnsIt() {
    stub(urlSchemaController) { mock in
      when(mock.retrieveSchemas(with: any())).thenReturn(["eudi-openid4vp", "mdoc-openid4vp"])
    }

    controller.cacheDeepLinkURL(url: Self.mockedOpenId4VPUrl)

    XCTAssertEqual(controller.getPendingDeepLinkAction(), Self.mockedOpenId4VPDeepLinkAction)
  }

  func testGetPendingDeepLinkAction_WhenTheKeptLinkStartsNoWalletFlow_ThenIsNil() {
    controller.cacheDeepLinkURL(url: Self.mockedExternalUrl)

    XCTAssertNil(controller.getPendingDeepLinkAction())
  }

  func testGetPendingDeepLinkAction_WhenTheKeptLinkIsMalformed_ThenIsNil() {
    controller.cacheDeepLinkURL(url: Self.mockedMalformedUrl)

    XCTAssertNil(controller.getPendingDeepLinkAction())
  }

  func testGetPendingDeepLinkAction_WhenNothingIsKept_ThenIsNil() {
    XCTAssertNil(controller.getPendingDeepLinkAction())
  }

  func testCacheDeepLinkURL_WhenALinkIsKept_ThenItStaysInMemoryAndIsNotPersisted() {
    controller.cacheDeepLinkURL(url: Self.mockedOpenId4VPUrl)

    XCTAssertEqual(controller.getPendingDeepLinkAction()?.plainUrl, Self.mockedOpenId4VPUrl)
    verify(prefsController, never()).setValue(any(), forKey: any())
  }

  func testInit_WhenCreated_ThenRemovesALinkAnEarlierBuildKeptInUserDefaults() {
    verify(prefsController).remove(forKey: equal(to: Prefs.Key.cachedDeepLink))
  }

  func testHandleDeepLinkAction_WhenLoggedInAndActionIsCredentialOfferOnTheDashboard_ThenPushesTheOfferScreen() async {
    stubHandleDeepLink(
      action: Self.mockedCredentialOfferDeepLinkAction,
      route: nil,
      isAfterAuth: true,
      isScreenForeground: true
    )
    stub(routerHost) { mock in
      when(mock.push(with: any())).thenDoNothing()
    }

    await controller.handleDeepLinkAction(
      routerHost: routerHost,
      deepLinkExecutable: Self.mockedCredentialOfferDeepLinkAction
    )

    XCTAssertNil(controller.getPendingDeepLinkAction())
    verify(routerHost).push(with: any())
  }

  func testHandleDeepLinkAction_WhenLoggedInAndActionIsCredentialOfferAwayFromTheDashboard_ThenKeepsTheLinkAndReturnsToTheDashboard() async {
    stubHandleDeepLink(
      action: Self.mockedCredentialOfferDeepLinkAction,
      route: nil,
      isAfterAuth: true,
      isScreenForeground: false
    )
    stub(routerHost) { mock in
      when(mock.popTo(with: any(), inclusive: any())).thenDoNothing()
    }

    await controller.handleDeepLinkAction(
      routerHost: routerHost,
      deepLinkExecutable: Self.mockedCredentialOfferDeepLinkAction
    )

    XCTAssertNotNil(controller.getPendingDeepLinkAction())
    verify(routerHost).popTo(with: equal(to: AppRoute.featureDashboardModule(.dashboard)), inclusive: equal(to: false))
    verify(routerHost, never()).push(with: any())
  }

  func testHandleDeepLinkAction_WhenWalletHasNoDocumentsAndCredentialOfferArrivesAwayFromAddDocument_ThenReturnsToAddDocument() async {
    stubHandleDeepLink(
      action: Self.mockedCredentialOfferDeepLinkAction,
      route: nil,
      isAfterAuth: false,
      isScreenForeground: false
    )
    stub(routerHost) { mock in
      when(mock.userIsLoggedInWithNoDocuments()).thenReturn(true)
      when(mock.popTo(with: any(), inclusive: any())).thenDoNothing()
    }

    await controller.handleDeepLinkAction(
      routerHost: routerHost,
      deepLinkExecutable: Self.mockedCredentialOfferDeepLinkAction
    )

    XCTAssertNotNil(controller.getPendingDeepLinkAction())
    verify(routerHost).popTo(
      with: equal(to: AppRoute.featureIssuanceModule(.issuanceAddDocument(config: NoConfig()))),
      inclusive: equal(to: false)
    )
    verify(routerHost, never()).push(with: any())
  }

  func testHandleDeepLinkAction_WhenWalletHasNoDocumentsAndCredentialOfferArrivesOnAddDocument_ThenPushesTheOfferScreen() async {
    stubHandleDeepLink(
      action: Self.mockedCredentialOfferDeepLinkAction,
      route: nil,
      isAfterAuth: false,
      isScreenForeground: true
    )
    stub(routerHost) { mock in
      when(mock.userIsLoggedInWithNoDocuments()).thenReturn(true)
      when(mock.push(with: any())).thenDoNothing()
    }

    await controller.handleDeepLinkAction(
      routerHost: routerHost,
      deepLinkExecutable: Self.mockedCredentialOfferDeepLinkAction
    )

    XCTAssertNil(controller.getPendingDeepLinkAction())
    verify(routerHost).push(with: any())
  }

  func testHandleDeepLinkAction_WhenActionIsHaipVpOnTheDashboard_ThenStartsTheSessionAndPushesItsRequest() async {
    let sessionCoordinator = RemoteSessionCoordinatorImpl(
      session: PresentationSession.fixture
    )
    stubHandleDeepLink(
      action: Self.mockedHaipVpDeepLinkAction,
      route: nil,
      isAfterAuth: true,
      isScreenForeground: true
    )
    let pushed = expectation(description: "request pushed")
    stub(routerHost) { mock in
      when(mock.push(with: any())).then { _ in pushed.fulfill() }
    }
    stub(walletKitController) { mock in
      when(mock.startSameDevicePresentation(deepLink: any())).thenReturn(sessionCoordinator)
    }

    await controller.handleDeepLinkAction(
      routerHost: routerHost,
      deepLinkExecutable: Self.mockedHaipVpDeepLinkAction
    )
    await fulfillment(of: [pushed], timeout: 2)

    XCTAssertNil(controller.getPendingDeepLinkAction())
    verify(walletKitController).startSameDevicePresentation(deepLink: any())
    verify(routerHost).push(with: any())
  }

  func testHandleDeepLinkAction_WhenLoggedInAndActionIsHaipVpAwayFromTheDashboard_ThenReturnsToTheDashboard() async {
    stubHandleDeepLink(
      action: Self.mockedHaipVpDeepLinkAction,
      route: nil,
      isAfterAuth: true,
      isScreenForeground: false
    )
    stub(routerHost) { mock in
      when(mock.popTo(with: any(), inclusive: any())).thenDoNothing()
    }

    await controller.handleDeepLinkAction(
      routerHost: routerHost,
      deepLinkExecutable: Self.mockedHaipVpDeepLinkAction
    )

    XCTAssertNotNil(controller.getPendingDeepLinkAction())
    verify(routerHost).popTo(with: equal(to: AppRoute.featureDashboardModule(.dashboard)), inclusive: equal(to: false))
    verify(walletKitController, never()).startSameDevicePresentation(deepLink: any())
  }

  func testHandleDeepLinkAction_WhenActionIsHaipVciOnTheDashboard_ThenPushesTheOfferScreen() async {
    stubHandleDeepLink(
      action: Self.mockedHaipVciDeepLinkAction,
      route: nil,
      isAfterAuth: true,
      isScreenForeground: true
    )
    stub(routerHost) { mock in
      when(mock.push(with: any())).thenDoNothing()
    }

    await controller.handleDeepLinkAction(
      routerHost: routerHost,
      deepLinkExecutable: Self.mockedHaipVciDeepLinkAction
    )

    XCTAssertNil(controller.getPendingDeepLinkAction())
    verify(routerHost).push(with: any())
  }

  func testHandleDeepLinkAction_WhenRqesPendingAndUserLoggedInWithDocuments_ThenPopsToDashboard() async {
    // Given: action == .rqes AND user logged in AND not on dashboard already
    // → the link is kept and popTo(dashboard) is invoked
    let pendingAction = Self.mockedRqesDeepLinkAction
    stub(routerHost) { mock in
      when(mock.userIsLoggedInWithDocuments()).thenReturn(true)
      when(mock.userIsLoggedInWithNoDocuments()).thenReturn(false)
      when(mock.isScreenForeground(with: any())).thenReturn(false)
      when(mock.popTo(with: any(), inclusive: any())).thenDoNothing()
    }

    // When
    await controller.handleDeepLinkAction(
      routerHost: routerHost,
      deepLinkExecutable: pendingAction
    )

    // Then
    XCTAssertNotNil(controller.getPendingDeepLinkAction())
    verify(routerHost).popTo(with: any(), inclusive: equal(to: false))
  }

  func testHandleDeepLinkAction_WhenRqesWithoutAuthorizationCode_ThenEarlyReturn() async {
    // Given: .rqes action with no `code` query item — the `code` guard returns early
    let url = URL(string: "rqes://oauth/callback?other=value")!
    let executable = DeepLink.Executable(
      link: URLComponents(url: url, resolvingAgainstBaseURL: true)!,
      plainUrl: url,
      action: .rqes
    )
    stub(routerHost) { mock in
      when(mock.userIsLoggedInWithDocuments()).thenReturn(true)
      when(mock.userIsLoggedInWithNoDocuments()).thenReturn(false)
      when(mock.isScreenForeground(with: any())).thenReturn(true)
    }

    // When
    await controller.handleDeepLinkAction(
      routerHost: routerHost,
      deepLinkExecutable: executable
    )

    // Then
    XCTAssertNil(controller.getPendingDeepLinkAction())
    verify(routerHost, times(0)).push(with: any())
  }

  func testHandleDeepLinkAction_WhenRqesWithAuthorizationCode_ThenSchedulesResumeTask() async {
    // Given: .rqes action WITH a `code` query item.
    // Hits the Task { @MainActor in ... } block of the .rqes case. The Task itself
    // polls for topViewController which never resolves in unit tests, so we
    // simply verify the function returns and reaches the spawn point.
    let url = URL(string: "rqes://oauth/callback?code=abc123")!
    let executable = DeepLink.Executable(
      link: URLComponents(url: url, resolvingAgainstBaseURL: true)!,
      plainUrl: url,
      action: .rqes
    )
    stub(routerHost) { mock in
      when(mock.userIsLoggedInWithDocuments()).thenReturn(true)
      when(mock.userIsLoggedInWithNoDocuments()).thenReturn(false)
      when(mock.isScreenForeground(with: any())).thenReturn(true)
    }

    // When
    await controller.handleDeepLinkAction(
      routerHost: routerHost,
      deepLinkExecutable: executable
    )

    // Then: the function reached the .rqes case and dispatched the resume Task
    XCTAssertNil(controller.getPendingDeepLinkAction())
  }

  func testHandleDeepLinkAction_WhenTheDashboardHasNotLoadedTheDocuments_ThenKeepsTheLinkForIt() async {
    let controller = DeepLinkControllerImpl(
      prefsController: prefsController,
      urlSchemaController: urlSchemaController,
      walletKitController: walletKitController,
      rqesCallbackUris: ["rqes://oauth/callback"]
    )
    stub(routerHost) { mock in
      when(mock.userIsLoggedInWithDocuments()).thenReturn(true)
      when(mock.userIsLoggedInWithNoDocuments()).thenReturn(false)
      when(mock.isScreenForeground(with: any())).thenReturn(true)
    }

    await controller.handleDeepLinkAction(routerHost: routerHost, deepLinkExecutable: Self.mockedOpenId4VPDeepLinkAction)

    XCTAssertNotNil(controller.getPendingDeepLinkAction())
    verify(walletKitController, never()).startSameDevicePresentation(deepLink: any())
    verify(routerHost, never()).push(with: any())
  }

  func testRemoveCachedDeepLinkURL_WhenALinkIsKept_ThenForgetsIt() {
    controller.cacheDeepLinkURL(url: Self.mockedOpenId4VPUrl)

    controller.removeCachedDeepLinkURL()

    XCTAssertNil(controller.getPendingDeepLinkAction())
  }

  func testHandleDeepLinkAction_WhenLockedAndACredentialOfferArrives_ThenKeepsItAndOpensNothing() async {
    for isScreenForeground in [false, true] {
      controller.removeCachedDeepLinkURL()
      stub(routerHost) { mock in
        when(mock.userIsLoggedInWithDocuments()).thenReturn(false)
        when(mock.userIsLoggedInWithNoDocuments()).thenReturn(false)
        when(mock.isScreenForeground(with: any())).thenReturn(isScreenForeground)
      }

      await controller.handleDeepLinkAction(
        routerHost: routerHost,
        deepLinkExecutable: Self.mockedCredentialOfferDeepLinkAction
      )

      XCTAssertNotNil(controller.getPendingDeepLinkAction())
    }
    verify(routerHost, never()).push(with: any())
    verify(routerHost, never()).popTo(with: any(), inclusive: any())
  }

  func testHandleDeepLinkAction_WhenAPresentationLinkOpensOnTheDashboard_ThenItsRequestCarriesTheSessionJustStarted() async throws {
    let sessionCoordinator = RemoteSessionCoordinatorImpl(session: PresentationSession.fixture)
    let pushed = expectation(description: "request pushed")
    let captor = ArgumentCaptor<AppRoute>()
    stubHandleDeepLink(action: Self.mockedOpenId4VPDeepLinkAction, route: nil, isAfterAuth: true, isScreenForeground: true)
    stub(walletKitController) { mock in
      when(mock.startSameDevicePresentation(deepLink: any())).thenReturn(sessionCoordinator)
    }
    stub(routerHost) { mock in
      when(mock.push(with: captor.capture())).then { _ in pushed.fulfill() }
    }
    controller.cacheDeepLinkURL(url: Self.mockedOpenId4VPUrl)

    await controller.handleDeepLinkAction(routerHost: routerHost, deepLinkExecutable: Self.mockedOpenId4VPDeepLinkAction)
    await fulfillment(of: [pushed], timeout: 2)

    guard case .featurePresentationModule(.presentationRequest(let coordinator, _)) = try XCTUnwrap(captor.value) else {
      return XCTFail("Expected the presentation request")
    }
    XCTAssertTrue(coordinator as AnyObject === sessionCoordinator)
    XCTAssertNil(controller.getPendingDeepLinkAction())
  }

  @MainActor
  func testHandleDeepLinkAction_WhenAnOfferOpensOnTheDashboard_ThenItsScreenCarriesTheOfferAndReturnsToTheDashboard() throws {
    try assertOfferRoute(hasDocuments: true, expectedSuccess: .popTo(.featureDashboardModule(.dashboard)))
  }

  @MainActor
  func testHandleDeepLinkAction_WhenAnOfferOpensWithoutDocuments_ThenItsScreenCarriesTheOfferAndOpensTheDashboard() throws {
    try assertOfferRoute(hasDocuments: false, expectedSuccess: .push(.featureDashboardModule(.dashboard)))
  }

  func testHandleDeepLinkAction_WhenALinkReturnsToTheDashboard_ThenTheRunningPresentationIsStopped() async {
    let stopped = expectation(description: "presentation stopped")
    stub(walletKitController) { mock in
      when(mock.stopPresentation()).then { stopped.fulfill() }
    }
    stubHandleDeepLink(
      action: Self.mockedCredentialOfferDeepLinkAction,
      route: nil,
      isAfterAuth: true,
      isScreenForeground: false
    )
    stub(routerHost) { mock in
      when(mock.popTo(with: any(), inclusive: any())).thenDoNothing()
    }

    await controller.handleDeepLinkAction(
      routerHost: routerHost,
      deepLinkExecutable: Self.mockedCredentialOfferDeepLinkAction
    )

    await fulfillment(of: [stopped], timeout: 5)
    verify(routerHost).popTo(with: equal(to: AppRoute.featureDashboardModule(.dashboard)), inclusive: equal(to: false))
  }

  func testHasDeepLink_WhenSchemaControllerMatchesRqes_ThenActionIsRqes() {
    // Given: parseType returns .rqes when scheme matches the rqes schema list
    stub(urlSchemaController) { mock in
      // First call: openid4vp schemas (no match), then credential_offer (no match), then rqes (match)
      when(mock.retrieveSchemas(with: any())).then { name in
        return name == "rqes" ? ["rqes"] : []
      }
    }
    let url = URL(string: "rqes://oauth/callback?code=abc")!

    // When
    let action = controller.hasDeepLink(url: url)

    // Then
    XCTAssertEqual(action?.action, .rqes)
  }
}

private extension TestDeepLinkController {

  @MainActor
  func assertOfferRoute(
    hasDocuments: Bool,
    expectedSuccess: UIConfig.TwoWayNavigationType
  ) throws {
    let captor = ArgumentCaptor<AppRoute>()
    stub(routerHost) { mock in
      when(mock.userIsLoggedInWithDocuments()).thenReturn(hasDocuments)
      when(mock.userIsLoggedInWithNoDocuments()).thenReturn(!hasDocuments)
      when(mock.isScreenForeground(with: any())).thenReturn(true)
      when(mock.push(with: captor.capture())).thenDoNothing()
    }

    controller.handleDeepLinkAction(routerHost: routerHost, deepLinkExecutable: Self.mockedCredentialOfferDeepLinkAction)

    guard
      case .featureIssuanceModule(.credentialOfferRequest(let config)) = try XCTUnwrap(captor.value),
      let generic = config as? UIConfig.Generic
    else {
      return XCTFail("Expected the offer screen")
    }
    XCTAssertEqual(generic.arguments["uri"], Self.mockedCredentialOfferDeepLinkAction.plainUrl.absoluteString)
    XCTAssertEqual(generic.navigationSuccessType, expectedSuccess)
  }
  
  func stubHandleDeepLink(
    action: DeepLink.Executable,
    route: AppRoute?,
    isAfterAuth: Bool,
    isScreenForeground: Bool
  ) {
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

  /// The schemes the app registers for each link type, as `Wallet.plist` lists them.
  static let mockedSchemas: [String: [String]] = [
    "openid4vp": ["eudi-openid4vp", "mdoc-openid4vp", "openid4vp"],
    "haip-vp": ["haip-vp"],
    "credential-offer": ["openid-credential-offer"],
    "haip-vci": ["haip-vci"],
    "rqes": ["rqes"]
  ]

  static let mockedCredentialOfferUrl: URL = URL(string: "openid-credential-offer://?credential_offer_uri=https://issuer.example/offer")!

  static let mockedHaipVciUrl: URL = URL(string: "haip-vci://?credential_offer_uri=https://issuer.example/offer")!

  static let mockedCredentialOfferDeepLinkAction = DeepLink.Executable(
    link: URLComponents(url: mockedCredentialOfferUrl, resolvingAgainstBaseURL: true)!,
    plainUrl: mockedCredentialOfferUrl,
    action: .credential_offer
  )

  static let mockedHaipVpDeepLinkAction = DeepLink.Executable(
    link: URLComponents(url: mockedOpenId4VPUrl, resolvingAgainstBaseURL: true)!,
    plainUrl: mockedOpenId4VPUrl,
    action: .haip_vp
  )

  static let mockedHaipVciDeepLinkAction = DeepLink.Executable(
    link: URLComponents(url: mockedHaipVciUrl, resolvingAgainstBaseURL: true)!,
    plainUrl: mockedHaipVciUrl,
    action: .haip_vci
  )

  static let mockedRqesUrl: URL = URL(string: "rqes://oauth/callback?code=auth-code")!

  static let mockedRqesDeepLinkAction = DeepLink.Executable(
    link: URLComponents(url: mockedRqesUrl, resolvingAgainstBaseURL: true)!,
    plainUrl: mockedRqesUrl,
    action: .rqes
  )

  static let mockedMalformedUrl: URL = URL(string: "not_a_valid_url")!

}
