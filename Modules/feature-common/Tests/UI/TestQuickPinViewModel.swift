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
import logic_authentication
@testable import feature_common
@testable import feature_test
@testable import logic_test

final class TestQuickPinViewModel: EudiTest {

  private var router: MockRouterHost!
  private var interactor: MockQuickPinInteractor!

  override func setUp() {
    super.setUp()
    router = MockRouterHost()
    interactor = MockQuickPinInteractor()
    stub(interactor) { mock in
      when(mock.getDeviceLockState()).thenReturn(.secure)
      when(mock.checkNewPin(any())).thenReturn(.success)
    }
  }

  override func tearDown() {
    router = nil
    interactor = nil
    super.tearDown()
  }

  @MainActor
  func testPinCreation_WhenThePinIsSet_ThenUnlocksTheSessionBeforeTheSuccessScreen() async throws {
    let unlocked = RecordingFlag()
    let shown = expectation(description: "success screen after the unlock")
    stub(interactor) { mock in
      when(mock.setPin(newPin: any())).thenReturn(.success)
      when(mock.unlockSession()).then { unlocked.set() }
    }
    stub(router) { mock in
      when(mock.push(with: any())).then { _ in
        if unlocked.isSet { shown.fulfill() }
      }
    }
    let viewModel = makeViewModel(flow: .setWithoutActivation)

    try await enterTwice("135792", in: viewModel)

    await fulfillment(of: [shown], timeout: 3)
  }

  @MainActor
  func testPinCreation_WhenSettingThePinFails_ThenDoesNotUnlock() async throws {
    let pinSet = expectation(description: "PIN set")
    let unlocked = expectation(description: "session unlocked or success screen shown")
    unlocked.isInverted = true
    unlocked.assertForOverFulfill = false
    stub(interactor) { mock in
      when(mock.setPin(newPin: any())).then { _ in
        pinSet.fulfill()
        return .failure(RuntimeError.genericError)
      }
      when(mock.unlockSession()).then { unlocked.fulfill() }
    }
    stub(router) { mock in
      when(mock.push(with: any())).then { _ in unlocked.fulfill() }
    }
    let viewModel = makeViewModel(flow: .setWithoutActivation)

    try await enterTwice("135792", in: viewModel)

    await fulfillment(of: [pinSet], timeout: 3)
    await fulfillment(of: [unlocked], timeout: 0.5)
  }

  @MainActor
  func testPinChange_WhenTheNewPinIsSet_ThenStoresItWithoutThePasscodeCheckAndDoesNotUnlock() async throws {
    let shown = expectation(description: "success screen")
    stub(interactor) { mock in
      when(mock.isPinValid(pin: any())).thenReturn(.success)
      when(mock.resetPinThrottle()).thenDoNothing()
      when(mock.updatePin(newPin: any())).thenReturn(.success)
    }
    stub(router) { mock in
      when(mock.push(with: any())).then { _ in shown.fulfill() }
    }
    let viewModel = makeViewModel(flow: .update)

    try await enter("135792", in: viewModel)
    try await enterTwice("246813", in: viewModel)

    await fulfillment(of: [shown], timeout: 3)
    verify(interactor).updatePin(newPin: "246813")
    verify(interactor, never()).setPin(newPin: any())
    verify(interactor, never()).unlockSession()
  }

  @MainActor
  func testSetPhase_WhenAPasscodeWasSetInTheDeviceSettings_ThenTheNoticeGoesAndEntryIsAllowed() async {
    stub(interactor) { mock in
      when(mock.getDeviceLockState()).thenReturn(.required)
    }
    let viewModel = makeViewModel(flow: .setWithoutActivation)
    await viewModel.initialize()
    XCTAssertTrue(viewModel.viewState.isDeviceLockRequired)

    stub(interactor) { mock in
      when(mock.getDeviceLockState()).thenReturn(.secure)
    }
    await viewModel.setPhase(with: .active)

    XCTAssertNil(viewModel.viewState.deviceLockNotice)
    XCTAssertFalse(viewModel.viewState.isDeviceLockRequired)
  }

  @MainActor
  func testPinCreation_WhenThePinIsEasyToGuess_ThenRefusesItAtEntry() async throws {
    stub(interactor) { mock in
      when(mock.getDeviceLockState()).thenReturn(.secure)
      when(mock.checkNewPin(any())).thenReturn(.failure(AuthenticationError.quickPinWeak))
    }
    let viewModel = makeViewModel(flow: .setWithoutActivation)

    try await enter("123456", in: viewModel)

    XCTAssertEqual(viewModel.viewState.pinError, .custom(AuthenticationError.quickPinWeak.errorMessage))
    guard case .firstInput = viewModel.viewState.step else {
      return XCTFail("Moved past the first entry")
    }
  }

  @MainActor
  func testPinCreation_WhenAPasscodeIsRequiredAndMissing_ThenAcceptsNoPin() async throws {
    stub(interactor) { mock in
      when(mock.getDeviceLockState()).thenReturn(.required)
    }
    let viewModel = makeViewModel(flow: .setWithoutActivation)
    await viewModel.initialize()

    try await enter("135792", in: viewModel)

    XCTAssertEqual(viewModel.viewState.deviceLockNotice, .quickPinDeviceLockRequiredWarning)
    verify(interactor, never()).checkNewPin(any())
    guard case .firstInput = viewModel.viewState.step else {
      return XCTFail("Moved past the first entry")
    }
  }
}

private extension TestQuickPinViewModel {

  @MainActor
  func enterTwice(_ pin: String, in viewModel: QuickPinViewModel<MockRouterHost>) async throws {
    try await enter(pin, in: viewModel)
    try await enter(pin, in: viewModel)
  }

  /// Waits past two 250 ms debounce windows: the entry's, and the one for the empty field the view model
  /// sets after it, so that the same PIN entered again is not dropped as a duplicate.
  @MainActor
  func enter(_ pin: String, in viewModel: QuickPinViewModel<MockRouterHost>) async throws {
    viewModel.uiPinInputField = pin
    try await Task.sleep(seconds: 0.8)
  }

  @MainActor
  func makeViewModel(flow: QuickPinUiConfig.Flow) -> QuickPinViewModel<MockRouterHost> {
    QuickPinViewModel(router: router, interactor: interactor, config: QuickPinUiConfig(flow: flow))
  }
}
