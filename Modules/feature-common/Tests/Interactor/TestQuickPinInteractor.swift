/*
 * Copyright (c) 2025 European Commission
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
  
  override func setUp() {
    self.pinStorageController = MockPinStorageController()
    self.interactor = QuickPinInteractorImpl(pinStorageController: pinStorageController)
  }
  
  override func tearDown() {
    self.interactor = nil
    self.pinStorageController = nil
  }
  
  func testSetPin_WhenNewPinIsSet_ThenVerifyAtLeastOnce() {
    
    // Given
    let pin = "1234"
    stub(pinStorageController) { mock in
      when(mock.setPin(with: any())).thenDoNothing()
    }
    
    // When
    interactor.setPin(newPin: pin)
    
    // Then
    verify(pinStorageController).setPin(with: pin)
    
  }
  
  func testIsPinValid_WhenStoredAndProvidedPinsMatch_ThenReturnPartialStateSuccess() {
    
    // Given
    let pin = "1234"
    stub(pinStorageController) { mock in
      when(mock.isPinValid(with: any())).thenReturn(true)
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
    stub(pinStorageController) { mock in
      when(mock.isPinValid(with: any())).thenReturn(false)
    }
    
    // When
    let state = interactor.isPinValid(pin: pin)
    
    // Then
    switch state {
    case .failure(let error):
      XCTAssertEqual(error.localizedDescription, AuthenticationError.quickPinInvalid.localizedDescription)
    default:
      XCTFail("Wrong state \(state)")
    }
  }
  
  func testHasPin_WhenThereIsAStoredPin_ThenReturnTrue() {
    
    // Given
    let pin = "1234"
    stub(pinStorageController) { mock in
      when(mock.retrievePin()).thenReturn(pin)
    }
    
    // When
    let answer = interactor.hasPin()
    
    // Then
    XCTAssertTrue(answer)
  }
  
  func testHasPin_WhenThereIsNoStoredPin_ThenReturnFalse() {
    
    // Given
    stub(pinStorageController) { mock in
      when(mock.retrievePin()).thenReturn(nil)
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
    stub(pinStorageController) { mock in
      when(mock.isPinValid(with: any())).thenReturn(true)
    }
    stub(pinStorageController) { mock in
      when(mock.setPin(with: any())).thenDoNothing()
    }
    
    // When
    let state = interactor.changePin(currentPin: currentPin, newPin: newPin)
    
    // Then
    verify(pinStorageController).setPin(with: newPin)
    
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
    stub(pinStorageController) { mock in
      when(mock.isPinValid(with: any())).thenReturn(false)
    }
    stub(pinStorageController) { mock in
      when(mock.setPin(with: any())).thenDoNothing()
    }
    
    // When
    let state = interactor.changePin(currentPin: newPin, newPin: newPin)
    
    // Then
    verify(pinStorageController, times(0)).setPin(with: any())
    
    switch state {
    case .failure(let error):
      XCTAssertEqual(error.localizedDescription, AuthenticationError.quickPinInvalid.localizedDescription)
    default:
      XCTFail("Wrong state \(state)")
    }
  }
}
