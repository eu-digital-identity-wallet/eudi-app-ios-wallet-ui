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
@testable import logic_assembly
@testable import logic_authentication
@testable import logic_ui
@testable import logic_test

final class TestRouterHost: EudiTest {

  private var configUiLogic: MockConfigUiLogic!
  private var analyticsController: MockAnalyticsController!
  private var sessionController: MockSessionController!

  private let dashboard = AppRoute.featureDashboardModule(.dashboard)
  private let login = AppRoute.featureCommonModule(.biometry(config: NoConfig()))

  override func setUp() {
    super.setUp()
    configUiLogic = MockConfigUiLogic(themeConfiguration: .default)
    analyticsController = MockAnalyticsController()
    sessionController = MockSessionController()
    stub(configUiLogic) { mock in
      when(mock.dashboardRoute.get).thenReturn(AppRoute.featureDashboardModule(.dashboard))
      when(mock.issuanceRoute.get).thenReturn(AppRoute.featureIssuanceModule(.issuanceAddDocument(config: NoConfig())))
      when(mock.loginRouteKeys.get).thenReturn(["Startup", "Biometry"])
      when(mock.protectedFlowRouteKeys.get).thenReturn(["Biometry"])
    }
    stub(analyticsController) { mock in
      when(mock.logScreen(screen: any(), arguments: any())).thenDoNothing()
    }
  }

  override func tearDown() {
    configUiLogic = nil
    analyticsController = nil
    sessionController = nil
    super.tearDown()
  }

  @MainActor
  func testUserIsLoggedInWithDocuments_WhenTheDashboardIsOnThePath_ThenNeedsAnUnlockedSession() {
    // Given
    let host = makeHost(isUnlocked: true)
    host.push(with: dashboard)

    // When
    let result = host.userIsLoggedInWithDocuments()

    // Then
    XCTAssertTrue(result)

    // When
    stubSession(isUnlocked: false)

    // Then
    XCTAssertFalse(host.userIsLoggedInWithDocuments())
  }

  @MainActor
  func testUserIsLoggedInWithNoDocuments_WhenAddDocumentIsOnThePath_ThenNeedsAnUnlockedSession() {
    // Given
    let host = makeHost(isUnlocked: true)
    host.push(with: .featureIssuanceModule(.issuanceAddDocument(config: NoConfig())))

    // When
    let result = host.userIsLoggedInWithNoDocuments()

    // Then
    XCTAssertTrue(result)

    // When
    stubSession(isUnlocked: false)

    // Then
    XCTAssertFalse(host.userIsLoggedInWithNoDocuments())
  }

  @MainActor
  func testPush_WhenLocked_ThenOpensOnlyALoginScreen() {
    // Given
    let host = makeHost(isUnlocked: false)

    // When
    host.push(with: dashboard)

    // Then
    XCTAssertNil(host.getCurrentScreen())

    // When
    host.push(with: login)

    // Then
    XCTAssertEqual(host.getCurrentScreen(), login)
  }

  @MainActor
  func testRequireLoginIfLocked_WhenLockedWithAWalletScreenOnThePath_ThenClearsThePath() {
    // Given
    let host = makeHost(isUnlocked: true)
    host.push(with: dashboard)

    // When
    stubSession(isUnlocked: false)
    host.requireLoginIfLocked()

    // Then
    XCTAssertNil(host.getCurrentScreen())
  }

  @MainActor
  func testRequireLoginIfLocked_WhenUnlocked_ThenKeepsThePath() {
    // Given
    let host = makeHost(isUnlocked: true)
    host.push(with: dashboard)

    // When
    host.requireLoginIfLocked()

    // Then
    XCTAssertEqual(host.getCurrentScreen(), dashboard)
  }

  @MainActor
  func testRequireLoginIfLocked_WhenOnlyLoginScreensAreOnThePath_ThenKeepsThem() {
    // Given
    let host = makeHost(isUnlocked: false)
    host.push(with: login)

    // When
    host.requireLoginIfLocked()

    // Then
    XCTAssertEqual(host.getCurrentScreen(), login)
  }

  @MainActor
  func testIsInProtectedFlow_WhenAProtectedScreenFollowsAScreenPastLogin_ThenIsTrue() async throws {
    // Given
    let host = makeHost(isUnlocked: true)
    XCTAssertFalse(host.isInProtectedFlow())

    // When
    host.push(with: dashboard)
    host.push(with: login)
    try await Task.sleep(seconds: 1)

    // Then
    XCTAssertEqual(host.getCurrentScreen(), login)
    XCTAssertTrue(host.isInProtectedFlow())
  }

  @MainActor
  func testIsInProtectedFlow_WhenLoginIsAllThePathHolds_ThenIsFalse() {
    // Given
    let host = makeHost(isUnlocked: true)

    host.push(with: login)

    // When
    let result = host.isInProtectedFlow()

    // Then
    XCTAssertFalse(result)
  }

  @MainActor
  func testPop_WhenThePathIsEmpty_ThenDoesNothing() {
    // Given
    let host = makeHost(isUnlocked: true)

    // When
    host.pop()

    // Then
    XCTAssertNil(host.getCurrentScreen())
  }
}

private extension TestRouterHost {

  @MainActor
  func makeHost(isUnlocked: Bool) -> RouterHostImpl {
    stubSession(isUnlocked: isUnlocked)
    return RouterHostImpl(
      uiConfigLogic: configUiLogic,
      analyticsController: analyticsController,
      sessionController: sessionController
    )
  }

  func stubSession(isUnlocked: Bool) {
    stub(sessionController) { mock in
      when(mock.isUnlocked.get).thenReturn(isUnlocked)
    }
  }
}
