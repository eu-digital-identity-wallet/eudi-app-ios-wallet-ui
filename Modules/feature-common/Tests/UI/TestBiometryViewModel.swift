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
@testable import feature_common
@testable import feature_test
@testable import logic_test

final class TestBiometryViewModel: EudiTest {

  private var router: MockRouterHost!
  private var interactor: MockBiometryInteractor!

  override func setUp() {
    super.setUp()
    router = MockRouterHost()
    interactor = MockBiometryInteractor()
    stub(interactor) { mock in
      when(mock.isPinValid(with: any())).thenReturn(.success)
      when(mock.authenticate()).thenReturn(.authenticated)
      when(mock.resetPinThrottle()).thenDoNothing()
      when(mock.getBiometricsImage()).thenReturn(nil)
      when(mock.isBiometryEnabled()).thenReturn(true)
      when(mock.getPinLockoutState()).thenReturn(.idle)
      when(mock.getDeviceLockState()).thenReturn(.secure)
    }
  }

  override func tearDown() {
    router = nil
    interactor = nil
    super.tearDown()
  }

  @MainActor
  func testPinEntry_WhenLoginSucceeds_ThenUnlocksTheSessionBeforeTheWalletOpens() async {
    let order = expectUnlockBeforeNavigation()
    let viewModel = makeViewModel(isPreAuthorization: true)

    viewModel.uiPinInputField = "135792"

    await fulfillment(of: [order], timeout: 2)
    verify(interactor).unlockSession()
  }

  @MainActor
  func testOnBiometry_WhenLoginSucceeds_ThenUnlocksTheSessionBeforeTheWalletOpens() async {
    let order = expectUnlockBeforeNavigation()
    let viewModel = makeViewModel(isPreAuthorization: true)

    viewModel.onBiometry()

    await fulfillment(of: [order], timeout: 2)
    verify(interactor).unlockSession()
  }

  @MainActor
  func testPinEntry_WhenAPresentationIsConfirmed_ThenDoesNotUnlockTheSession() async {
    let continued = expectation(description: "presentation continued")
    stub(interactor) { mock in
      when(mock.unlockSession()).thenDoNothing()
    }
    stub(router) { mock in
      when(mock.push(with: any())).then { _ in continued.fulfill() }
    }
    let viewModel = makeViewModel(isPreAuthorization: false)

    viewModel.uiPinInputField = "135792"

    await fulfillment(of: [continued], timeout: 2)
    verify(interactor, never()).unlockSession()
  }

  @MainActor
  func testInitialize_WhenALoginDeviceHasNoPasscode_ThenWarnsAndThePinStillLogsIn() async {
    let order = expectUnlockBeforeNavigation()
    stubDeviceLockState(.missing)
    let viewModel = makeViewModel(isPreAuthorization: true)

    await viewModel.initialize()
    viewModel.uiPinInputField = "135792"

    XCTAssertEqual(viewModel.viewState.deviceLockNotice, .quickPinDeviceLockMissingWarning)
    XCTAssertFalse(viewModel.viewState.isDeviceLockRequired)
    await fulfillment(of: [order], timeout: 5)
  }

  @MainActor
  func testInitialize_WhenALoginRequiresAPasscodeAndThereIsNone_ThenRefusesThePinAndBiometrics() async {
    let opened = expectation(description: "wallet opened")
    opened.isInverted = true
    stub(router) { mock in
      when(mock.push(with: any())).then { _ in opened.fulfill() }
    }
    stubDeviceLockState(.required)
    let viewModel = makeViewModel(isPreAuthorization: true, shouldInitializeBiometricOnCreate: true)

    await viewModel.initialize()
    viewModel.uiPinInputField = "135792"
    viewModel.onBiometry()

    XCTAssertEqual(viewModel.viewState.deviceLockNotice, .quickPinDeviceLockRequiredWarning)
    XCTAssertTrue(viewModel.viewState.isDeviceLockRequired)
    XCTAssertFalse(viewModel.viewState.autoBiometryInitiated)
    await fulfillment(of: [opened], timeout: 1)
    verify(interactor, never()).isPinValid(with: any())
    verify(interactor, never()).authenticate()
  }

  @MainActor
  func testSetPhase_WhenTheUserReturnsWithAPasscodeSet_ThenTheLoginOpens() async {
    let order = expectUnlockBeforeNavigation()
    stubDeviceLockState(.required)
    let viewModel = makeViewModel(isPreAuthorization: true)
    await viewModel.initialize()

    stubDeviceLockState(.secure)
    await viewModel.setPhase(with: .active)
    viewModel.uiPinInputField = "135792"

    XCTAssertNil(viewModel.viewState.deviceLockNotice)
    await fulfillment(of: [order], timeout: 5)
  }

  @MainActor
  func testInitialize_WhenAConfirmationRuns_ThenThePasscodeIsNotChecked() async {
    let continued = expectation(description: "presentation continued")
    stub(router) { mock in
      when(mock.push(with: any())).then { _ in continued.fulfill() }
    }
    stubDeviceLockState(.required)
    let viewModel = makeViewModel(isPreAuthorization: false)

    await viewModel.initialize()
    await viewModel.setPhase(with: .active)
    viewModel.uiPinInputField = "135792"

    await fulfillment(of: [continued], timeout: 5)
    XCTAssertNil(viewModel.viewState.deviceLockNotice)
    verify(interactor, never()).getDeviceLockState()
  }

  @MainActor
  func testOnPop_WhenTheUserLeavesBeforeASuccessLands_ThenTheSuccessDoesNothing() async {
    let continued = expectation(description: "flow continued")
    continued.isInverted = true
    stub(router) { mock in
      when(mock.pop()).thenDoNothing()
      when(mock.push(with: any())).then { _ in continued.fulfill() }
    }
    let viewModel = makeViewModel(isPreAuthorization: false, navigationBackType: .pop)

    viewModel.onPop()
    viewModel.uiPinInputField = "135792"

    await fulfillment(of: [continued], timeout: 1)
    verify(router).pop()
  }

  @MainActor
  func testPinEntry_WhenABiometricAlsoSucceedsOnAScreenWithBack_ThenTheFlowContinuesOnce() async {
    let continued = expectation(description: "flow continued")
    continued.assertForOverFulfill = false
    let continuedAgain = expectation(description: "flow continued again")
    continuedAgain.expectedFulfillmentCount = 2
    continuedAgain.isInverted = true
    stub(router) { mock in
      when(mock.push(with: any())).then { _ in
        continued.fulfill()
        continuedAgain.fulfill()
      }
    }
    let viewModel = makeViewModel(isPreAuthorization: false, navigationBackType: .pop)

    viewModel.uiPinInputField = "135792"
    viewModel.onBiometry()

    await fulfillment(of: [continued], timeout: 5)
    await fulfillment(of: [continuedAgain], timeout: 0.5)
  }

  @MainActor
  func testOnPop_WhenASuccessHasEndedTheScreen_ThenBackDoesNothing() async {
    let continued = expectation(description: "flow continued")
    stub(router) { mock in
      when(mock.pop()).thenDoNothing()
      when(mock.push(with: any())).then { _ in continued.fulfill() }
    }
    let viewModel = makeViewModel(isPreAuthorization: false, navigationBackType: .pop)

    viewModel.uiPinInputField = "135792"
    await fulfillment(of: [continued], timeout: 5)
    viewModel.onPop()

    verify(router, never()).pop()
  }

  @MainActor
  func testOnBiometry_WhenALoginSucceedsAgain_ThenTheWalletOpensAgain() async {
    let opened = expectation(description: "wallet opened twice")
    opened.expectedFulfillmentCount = 2
    stub(interactor) { mock in
      when(mock.unlockSession()).thenDoNothing()
    }
    stub(router) { mock in
      when(mock.push(with: any())).then { _ in opened.fulfill() }
    }
    let viewModel = makeViewModel(isPreAuthorization: true)

    viewModel.onBiometry()
    viewModel.onBiometry()

    await fulfillment(of: [opened], timeout: 5)
  }

  @MainActor
  func testSetPhase_WhenASuccessLandedWhileInactive_ThenItsNavigationRunsOnceOnReturn() async {
    let continued = expectation(description: "flow continued")
    continued.assertForOverFulfill = false
    let continuedAgain = expectation(description: "flow continued again")
    continuedAgain.expectedFulfillmentCount = 2
    continuedAgain.isInverted = true
    stub(router) { mock in
      when(mock.push(with: any())).then { _ in
        continued.fulfill()
        continuedAgain.fulfill()
      }
    }
    let viewModel = makeViewModel(isPreAuthorization: false)
    await viewModel.setPhase(with: .inactive)

    viewModel.onBiometry()
    let held = expectation(description: "navigation held")
    withObservationTracking { _ = viewModel.viewState.pendingNavigation } onChange: { held.fulfill() }
    await fulfillment(of: [held], timeout: 5)
    verify(router, never()).push(with: any())
    await viewModel.setPhase(with: .active)
    await viewModel.setPhase(with: .active)

    await fulfillment(of: [continued], timeout: 5)
    await fulfillment(of: [continuedAgain], timeout: 0.5)
  }
}

private extension TestBiometryViewModel {

  func expectUnlockBeforeNavigation() -> XCTestExpectation {
    let opened = expectation(description: "wallet opened after the unlock")
    let unlocked = RecordingFlag()
    stub(interactor) { mock in
      when(mock.unlockSession()).then { unlocked.set() }
    }
    stub(router) { mock in
      when(mock.push(with: any())).then { _ in
        if unlocked.isSet { opened.fulfill() }
      }
    }
    return opened
  }

  func stubDeviceLockState(_ state: DeviceLockState) {
    stub(interactor) { mock in
      when(mock.getDeviceLockState()).thenReturn(state)
    }
  }

  @MainActor
  func makeViewModel(
    isPreAuthorization: Bool,
    shouldInitializeBiometricOnCreate: Bool = false,
    navigationBackType: UIConfig.ThreeWayNavigationType? = nil
  ) -> BiometryViewModel<MockRouterHost> {
    BiometryViewModel(
      router: router,
      interactor: interactor,
      config: UIConfig.Biometry(
        navigationTitle: .enterYourPin,
        caption: .loginCaption,
        quickPinOnlyCaption: .loginCaptionQuickPinOnly,
        navigationSuccessType: .push(.featureDashboardModule(.dashboard)),
        navigationBackType: navigationBackType,
        isPreAuthorization: isPreAuthorization,
        shouldInitializeBiometricOnCreate: shouldInitializeBiometricOnCreate
      ),
      throttlePinInput: false
    )
  }
}
