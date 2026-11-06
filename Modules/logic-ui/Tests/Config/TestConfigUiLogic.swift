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
@testable import logic_ui
@testable import logic_core
@testable import logic_test

final class TestConfigUiLogic: EudiTest {

  private let configUiLogic = ConfigUiLogicImpl(themeConfiguration: .default)

  func testIsProtectedFlow_WhenTheScreenBelongsToAnIssuancePresentationOrSigning_ThenIsTrue() {
    let remote = MockRemoteSessionCoordinator(session: PresentationSession.fixture)
    let proximity = MockProximitySessionCoordinator(session: PresentationSession.fixture)
    let dashboard = AppRoute.featureDashboardModule(.dashboard)
    let routes: [AppRoute] = [
      .featureIssuanceModule(.issuanceAddDocument(config: NoConfig())),
      .featureIssuanceModule(.credentialOfferRequest(config: NoConfig())),
      .featureIssuanceModule(.issuanceCode(config: NoConfig())),
      .featurePresentationModule(.presentationRequest(presentationCoordinator: remote, originator: dashboard)),
      .featurePresentationModule(
        .presentationLoader(
          relyingParty: "",
          relyingPartyisTrusted: false,
          presentationCoordinator: remote,
          originator: dashboard,
          items: []
        )
      ),
      .featureProximityModule(.proximityRequest(presentationCoordinator: proximity, originator: dashboard)),
      .featureProximityModule(
        .proximityLoader(
          relyingParty: "",
          relyingPartyisTrusted: false,
          presentationCoordinator: proximity,
          originator: dashboard,
          items: []
        )
      ),
      .featureDashboardModule(.signDocument),
      .featureCommonModule(.biometry(config: NoConfig()))
    ]

    for route in routes {
      XCTAssertTrue(configUiLogic.isProtectedFlow(route), route.info.key)
    }
  }

  func testHideContentWhileCaptured_WhenNotConfigured_ThenIsOff() {
    XCTAssertFalse(configUiLogic.hideContentWhileCaptured)
  }

  func testIsProtectedFlow_WhenTheScreenIsTheProximityQrScreen_ThenIsFalse() {
    let proximity = MockProximitySessionCoordinator(session: PresentationSession.fixture)
    let route = AppRoute.featureProximityModule(
      .proximityConnection(presentationCoordinator: proximity, originator: .featureDashboardModule(.dashboard))
    )

    XCTAssertFalse(configUiLogic.isProtectedFlow(route))
  }

  func testIsProtectedFlow_WhenTheScreenIsOutsideSuchAFlowOrMissing_ThenIsFalse() {
    let routes: [AppRoute] = [
      .featureDashboardModule(.dashboard),
      .featureDashboardModule(.documentDetails(id: "id")),
      .featureDashboardModule(.settingsMenu),
      .featureStartupModule(.startup),
      .featureCommonModule(.quickPin(config: NoConfig()))
    ]

    for route in routes {
      XCTAssertFalse(configUiLogic.isProtectedFlow(route), route.info.key)
    }
    XCTAssertFalse(configUiLogic.isProtectedFlow(nil))
  }

  func testIsLoginRoute_WhenTheScreenIsStartUpLoginPinCreationOrTheTrustMark_ThenIsTrue() {
    let routes: [AppRoute] = [
      .featureStartupModule(.startup),
      .featureCommonModule(.biometry(config: NoConfig())),
      .featureCommonModule(.quickPin(config: NoConfig())),
      .featureCommonModule(.trustMark(config: NoConfig()))
    ]

    for route in routes {
      XCTAssertTrue(configUiLogic.isLoginRoute(route), route.info.key)
    }
  }

  func testIsLoginRoute_WhenTheScreenShowsWalletContent_ThenIsFalse() {
    let routes: [AppRoute] = [
      .featureDashboardModule(.dashboard),
      .featureDashboardModule(.documentDetails(id: "id")),
      .featureIssuanceModule(.issuanceAddDocument(config: NoConfig())),
      .featureCommonModule(.genericSuccess(config: NoConfig())),
      .featureDashboardModule(.biometrySelection(isEnabled: true))
    ]

    for route in routes {
      XCTAssertFalse(configUiLogic.isLoginRoute(route), route.info.key)
    }
  }

  func testUserImageClaimKeys_WhenNotConfigured_ThenAreThePortraitAndThePicture() {
    XCTAssertEqual(configUiLogic.userImageClaimKeys, ["portrait", "picture"])
  }
}
