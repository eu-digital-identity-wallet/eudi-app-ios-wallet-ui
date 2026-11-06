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
import logic_authentication
import logic_business
@testable import feature_common
@testable import logic_test
@testable import feature_test

final class TestQuickPinInteractor: EudiTest {

  var interactor: QuickPinInteractor!
  var pinStorageController: MockPinStorageController!
  var pinThrottleController: MockPinThrottleController!
  var authenticationConfig: MockAuthenticationConfig!
  var sessionController: MockSessionController!
  var deviceLockController: MockDeviceLockController!

  override func setUp() {
    self.pinStorageController = MockPinStorageController()
    self.pinThrottleController = MockPinThrottleController()
    self.authenticationConfig = MockAuthenticationConfig()
    self.sessionController = MockSessionController()
    self.deviceLockController = MockDeviceLockController()
    stub(deviceLockController) { mock in
      when(mock.isDeviceSecure()).thenReturn(true)
    }
    
    stub(authenticationConfig) { mock in
      when(mock.maxFailedPinAttempts.get).thenReturn(3)
      when(mock.pinLockoutDurations.get).thenReturn([30, 90, 300])
      when(mock.commonPins.get).thenReturn(["2580"])
      when(mock.requireDeviceSecure.get).thenReturn(false)
    }
    
    self.interactor = QuickPinInteractorImpl(
      pinStorageController: pinStorageController,
      pinThrottleController: pinThrottleController,
      authenticationConfig: authenticationConfig,
      sessionController: sessionController,
      deviceLockController: deviceLockController
    )
  }

  override func tearDown() {
    self.interactor = nil
    self.pinStorageController = nil
    self.pinThrottleController = nil
    self.authenticationConfig = nil
    self.sessionController = nil
  }

  func testUnlockSession_WhenCalled_ThenUnlocksTheSession() async {
    stub(sessionController) { mock in
      when(mock.unlock()).thenDoNothing()
    }

    await interactor.unlockSession()

    verify(sessionController).unlock()
  }
  
  func testSetPin_WhenNewPinIsSet_ThenVerifyAtLeastOnce() async {
    
    // Given
    let pin = "1357"
    stub(pinStorageController) { mock in
      when(mock.setPin(with: any())).thenDoNothing()
    }
    
    // When
    let state = await interactor.setPin(newPin: pin)
    
    // Then
    verify(pinStorageController).setPin(with: pin)
    guard case .success = state else {
      return XCTFail("Wrong state \(state)")
    }
  }

  func testSetPin_WhenStorageWriteFails_ThenReturnPartialStateFailure() async {
    stub(pinStorageController) { mock in
      when(mock.setPin(with: any())).thenThrow(KeyChainError.writeFailed(status: errSecNotAvailable))
    }

    let state = await interactor.setPin(newPin: "1357")

    guard case .failure(let error) = state else {
      return XCTFail("Wrong state \(state)")
    }
    XCTAssertEqual(error as? KeyChainError, .writeFailed(status: errSecNotAvailable))
  }

  func testChangePin_WhenStorageWriteFails_ThenReturnPartialStateFailure() async {
    stub(pinStorageController) { mock in
      when(mock.isPinValid(with: any())).thenReturn(true)
      when(mock.setPin(with: any())).thenThrow(KeyChainError.writeFailed(status: errSecNotAvailable))
    }

    let state = await interactor.changePin(currentPin: "1234", newPin: "2468")

    guard case .failure(let error) = state else {
      return XCTFail("Wrong state \(state)")
    }
    XCTAssertEqual(error as? KeyChainError, .writeFailed(status: errSecNotAvailable))
  }

  func testHasPin_WhenStorageReadFails_ThenThrowsTheStorageError() async {
    stub(pinStorageController) { mock in
      when(mock.hasPin()).thenThrow(KeyChainError.readFailed(status: errSecInteractionNotAllowed))
    }

    do {
      _ = try await interactor.hasPin()
      XCTFail("Expected hasPin to throw")
    } catch {
      XCTAssertEqual(error as? KeyChainError, .readFailed(status: errSecInteractionNotAllowed))
    }
  }
  
  func testIsPinValid_WhenStoredAndProvidedPinsMatch_ThenReturnPartialStateSuccess() async {
    
    // Given
    let pin = "1234"
    stub(pinStorageController) { mock in
      when(mock.isPinValid(with: any())).thenReturn(true)
    }
    
    // When
    let state = await interactor.isPinValid(pin: pin)
    
    // Then
    switch state {
    case .success:
      XCTAssert(true)
    default:
      XCTFail("Wrong state \(state)")
    }
  }
  
  func testIsPinValid_WhenStoredAndProvidedPinsDoNotMatch_ThenReturnPartialStateFailure() async {
    
    // Given
    let pin = "1234"
    stub(pinStorageController) { mock in
      when(mock.isPinValid(with: any())).thenReturn(false)
    }
    
    // When
    let state = await interactor.isPinValid(pin: pin)
    
    // Then
    switch state {
    case .failure(let error):
      XCTAssertEqual(error.localizedDescription, AuthenticationError.quickPinInvalid.localizedDescription)
    default:
      XCTFail("Wrong state \(state)")
    }
  }
  
  func testHasPin_WhenThereIsAStoredPin_ThenReturnTrue() async throws {
    
    // Given
    stub(pinStorageController) { mock in
      when(mock.hasPin()).thenReturn(true)
    }
    
    // When
    let answer = try await interactor.hasPin()
    
    // Then
    XCTAssertTrue(answer)
  }
  
  func testHasPin_WhenThereIsNoStoredPin_ThenReturnFalse() async throws {
    
    // Given
    stub(pinStorageController) { mock in
      when(mock.hasPin()).thenReturn(false)
    }
    
    // When
    let answer = try await interactor.hasPin()
    
    // Then
    XCTAssertFalse(answer)
  }
  
  func testChangePin_WhenCurrentPinIsValid_ThenReturnPartialStateSuccess() async {
    
    // Given
    let newPin = "2468"
    let currentPin = "1234"
    stub(pinStorageController) { mock in
      when(mock.isPinValid(with: any())).thenReturn(true)
    }
    stub(pinStorageController) { mock in
      when(mock.setPin(with: any())).thenDoNothing()
    }
    
    // When
    let state = await interactor.changePin(currentPin: currentPin, newPin: newPin)
    
    // Then
    verify(pinStorageController).setPin(with: newPin)
    
    switch state {
    case .success:
      XCTAssert(true)
    default:
      XCTFail("Wrong state \(state)")
    }
  }
  
  func testChangePin_WhenCurrentPinIsNotValid_ThenReturnPartialStateFailure() async {

    // Given
    let newPin = "2468"
    stub(pinStorageController) { mock in
      when(mock.isPinValid(with: any())).thenReturn(false)
    }
    stub(pinStorageController) { mock in
      when(mock.setPin(with: any())).thenDoNothing()
    }

    // When
    let state = await interactor.changePin(currentPin: newPin, newPin: newPin)

    // Then
    verify(pinStorageController, times(0)).setPin(with: any())

    switch state {
    case .failure(let error):
      XCTAssertEqual(error.localizedDescription, AuthenticationError.quickPinInvalid.localizedDescription)
    default:
      XCTFail("Wrong state \(state)")
    }
  }

  func testGetPinLockoutState_WhenThrottleControllerReturnsIdle_ThenReturnsIdle() async {
    // Given
    stub(pinThrottleController) { mock in
      when(mock.getState()).thenReturn(.idle)
    }

    // When
    let state = await interactor.getPinLockoutState()

    // Then
    XCTAssertEqual(state, .idle)
    verify(pinThrottleController).getState()
  }

  func testGetPinLockoutState_WhenThrottleControllerReturnsActiveLockout_ThenForwardsLockout() async {
    // Given
    let expected: PinLockoutState = .active(remaining: 30, total: 90)
    stub(pinThrottleController) { mock in
      when(mock.getState()).thenReturn(expected)
    }

    // When
    let state = await interactor.getPinLockoutState()

    // Then
    XCTAssertEqual(state, expected)
    verify(pinThrottleController).getState()
  }

  func testRecordPinFailure_WhenThrottleControllerReturnsLockout_ThenForwardsLockout() async {
    // Given
    let expected: PinLockoutState = .active(remaining: 60, total: 300)
    stub(pinThrottleController) { mock in
      when(mock.recordFailure()).thenReturn(expected)
    }

    // When
    let state = await interactor.recordPinFailure()

    // Then
    XCTAssertEqual(state, expected)
    verify(pinThrottleController).recordFailure()
  }

  func testResetPinThrottle_WhenCalled_ThenDelegatesToThrottleController() async {
    // Given
    stub(pinThrottleController) { mock in
      when(mock.recordSuccess()).thenDoNothing()
    }

    // When
    await interactor.resetPinThrottle()

    // Then
    verify(pinThrottleController).recordSuccess()
  }

  func testSetPin_WhenThePinIsEasyToGuess_ThenRefusesItWithoutStoringIt() async {
    for pin in ["1111", "1234", "9876", "2580"] {
      let state = await interactor.setPin(newPin: pin)

      guard case .failure(let error) = state else {
        return XCTFail("\(pin) was accepted")
      }
      XCTAssertEqual(error.localizedDescription, AuthenticationError.quickPinWeak.localizedDescription)
    }
    verify(pinStorageController, never()).setPin(with: any())
  }

  func testCheckNewPin_WhenThePinIsEasyToGuess_ThenFailsAndOtherwiseSucceeds() async {
    guard case .failure = await interactor.checkNewPin("0000") else {
      return XCTFail("0000 was accepted")
    }
    guard case .success = await interactor.checkNewPin("1357") else {
      return XCTFail("1357 was refused")
    }
  }

  func testGetDeviceLockState_WhenAPasscodeIsSet_ThenIsSecure() async {
    stubDeviceLock(isSecure: true, isRequired: true)

    let state = await interactor.getDeviceLockState()

    XCTAssertEqual(state, .secure)
  }

  func testGetDeviceLockState_WhenNoPasscodeIsSet_ThenIsMissing() async {
    stubDeviceLock(isSecure: false, isRequired: false)

    let state = await interactor.getDeviceLockState()

    XCTAssertEqual(state, .missing)
  }

  func testGetDeviceLockState_WhenNoPasscodeIsSetAndOneIsRequired_ThenIsRequired() async {
    stubDeviceLock(isSecure: false, isRequired: true)

    let state = await interactor.getDeviceLockState()

    XCTAssertEqual(state, .required)
  }

  func testSetPin_WhenAPasscodeIsRequiredAndMissing_ThenRefusesIt() async {
    stubDeviceLock(isSecure: false, isRequired: true)

    let state = await interactor.setPin(newPin: "1357")

    guard case .failure(let error) = state else {
      return XCTFail("Wrong state \(state)")
    }
    XCTAssertEqual(error.localizedDescription, AuthenticationError.deviceLockRequired.localizedDescription)
    verify(pinStorageController, never()).setPin(with: any())
  }

  func testChangePin_WhenAPasscodeIsRequiredAndMissing_ThenStillChangesIt() async {
    stubDeviceLock(isSecure: false, isRequired: true)
    stub(pinStorageController) { mock in
      when(mock.isPinValid(with: any())).thenReturn(true)
      when(mock.setPin(with: any())).thenDoNothing()
    }

    let state = await interactor.changePin(currentPin: "1357", newPin: "2468")

    guard case .success = state else {
      return XCTFail("Wrong state \(state)")
    }
  }

  func testUpdatePin_WhenAPasscodeIsRequiredAndMissing_ThenStillStoresTheNewPin() async {
    stubDeviceLock(isSecure: false, isRequired: true)
    stub(pinStorageController) { mock in
      when(mock.setPin(with: any())).thenDoNothing()
    }

    let state = await interactor.updatePin(newPin: "2468")

    guard case .success = state else {
      return XCTFail("Wrong state \(state)")
    }
    verify(pinStorageController).setPin(with: "2468")
  }

  func testUpdatePin_WhenTheNewPinIsEasyToGuess_ThenRefusesIt() async {
    stub(pinStorageController) { mock in
      when(mock.setPin(with: any())).thenDoNothing()
    }

    let state = await interactor.updatePin(newPin: "111111")

    guard case .failure(let error) = state else {
      return XCTFail("Wrong state \(state)")
    }
    XCTAssertEqual(error.localizedDescription, AuthenticationError.quickPinWeak.localizedDescription)
    verify(pinStorageController, never()).setPin(with: any())
  }

  private func stubDeviceLock(isSecure: Bool, isRequired: Bool) {
    stub(deviceLockController) { mock in
      when(mock.isDeviceSecure()).thenReturn(isSecure)
    }
    stub(authenticationConfig) { mock in
      when(mock.requireDeviceSecure.get).thenReturn(isRequired)
    }
  }

}
