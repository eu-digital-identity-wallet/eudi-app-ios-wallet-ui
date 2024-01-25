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
@testable import feature_common
@testable import logic_test
@testable import feature_test

final class TestQuickPinInteractor: EudiTest {
  
  var interactor: QuickPinInteractorType!
  var keyChainController: MockKeyChainControllerType!
  
  override func setUp() {
    self.keyChainController = MockKeyChainControllerType()
    self.interactor = QuickPinInteractor(keyChainController: keyChainController)
  }
  
  override func tearDown() {
    self.interactor = nil
    self.keyChainController = nil
  }
  
  func testSetPin_WhenNewPinIsSet_ThenVerifyKeychainStoreValue() {
    
    // Given
    let pin = "1234"
    stub(keyChainController) { mock in
      when(mock).storeValue(key: any(), value: any()).thenDoNothing()
    }
    
    // When
    interactor.setPin(newPin: pin)
    
    // Then
    verify(keyChainController).storeValue(key: KeychainWrapper.devicePin, value: pin)
    
  }
  
  func testIsPinValid_WhenStoredAndProvidedPinsMatch_ThenReturnPartialStateSuccess() {
    
    // Given
    let pin = "1234"
    stub(keyChainController) { mock in
      when(mock).getValue(key: KeychainWrapper.devicePin).thenReturn(pin)
    }
    
    // When
    let state = interactor.isPinValid(pin: pin)
    
    // Then
    switch state {
    case .success:
      XCTAssert(true)
    default:
      XCTFail("Wrong state \(state)")
    }
  }
  
  func testIsPinValid_WhenStoredAndProvidedPinsDoNotMatch_ThenReturnPartialStateFailure() {
    
    // Given
    let pin = "1234"
    let storedPin = "4321"
    stub(keyChainController) { mock in
      when(mock).getValue(key: KeychainWrapper.devicePin).thenReturn(storedPin)
    }
    
    // When
    let state = interactor.isPinValid(pin: pin)
    
    // Then
    switch state {
    case .failure(let error):
      XCTAssertEqual(error.localizedDescription, RuntimeError.quickPinInvalid.localizedDescription)
    default:
      XCTFail("Wrong state \(state)")
    }
  }
  
  func testHasPin_WhenThereIsAStoredPin_ThenReturnTrue() {
    
    // Given
    let pin = "1234"
    stub(keyChainController) { mock in
      when(mock).getValue(key: KeychainWrapper.devicePin).thenReturn(pin)
    }
    
    // When
    let answer = interactor.hasPin()
    
    // Then
    XCTAssertTrue(answer)
  }
  
  func testHasPin_WhenThereIsNoStoredPin_ThenReturnFalse() {
    
    // Given
    stub(keyChainController) { mock in
      when(mock).getValue(key: KeychainWrapper.devicePin).thenReturn(nil)
    }
    
    // When
    let answer = interactor.hasPin()
    
    // Then
    XCTAssertFalse(answer)
  }
  
  func testChangePin_WhenCurrentPinIsValid_ThenReturnPartialStateSuccess() {
    
    // Given
    let newPin = "4321"
    let currentPin = "1234"
    stub(keyChainController) { mock in
      when(mock).getValue(key: KeychainWrapper.devicePin).thenReturn(currentPin)
    }
    stub(keyChainController) { mock in
      when(mock).storeValue(key: any(), value: any()).thenDoNothing()
    }
    
    // When
    let state = interactor.changePin(currentPin: currentPin, newPin: newPin)
    
    // Then
    verify(keyChainController).storeValue(key: KeychainWrapper.devicePin, value: newPin)
    
    switch state {
    case .success:
      XCTAssert(true)
    default:
      XCTFail("Wrong state \(state)")
    }
  }
  
  func testChangePin_WhenCurrentPinIsNotValid_ThenReturnPartialStateFailure() {
    
    // Given
    let newPin = "4321"
    let currentPin = "1234"
    stub(keyChainController) { mock in
      when(mock).getValue(key: KeychainWrapper.devicePin).thenReturn(currentPin)
    }
    stub(keyChainController) { mock in
      when(mock).storeValue(key: any(), value: any()).thenDoNothing()
    }
    
    // When
    let state = interactor.changePin(currentPin: newPin, newPin: newPin)
    
    // Then
    verify(keyChainController, times(0)).storeValue(key: any(), value: any())
    
    switch state {
    case .failure(let error):
      XCTAssertEqual(error.localizedDescription, RuntimeError.quickPinInvalid.localizedDescription)
    default:
      XCTFail("Wrong state \(state)")
    }
  }
  
}
