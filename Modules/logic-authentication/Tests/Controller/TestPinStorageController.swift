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

@testable import logic_test
@testable import logic_authentication

final class TestPinStorageController: EudiTest {
  
  var controller: PinStorageController!
  var provider: MockPinStorageProvider!
  var setPinCalledWith: String?
  
  override func setUp() {
    super.setUp()
    self.provider = MockPinStorageProvider()
    self.controller = PinStorageControllerImpl(
      provider: provider
    )
  }
  
  override func tearDown() {
    self.controller = nil
    self.provider = nil
  }
  
  func testRetrievePin() {
    //Given
    let expectedPin = "1111"
    stubRetrievePin(expectedPin: expectedPin)
    
    // When
    let retrievedPin = controller.retrievePin()
    
    //Then
    XCTAssertEqual(retrievedPin, expectedPin, "The retrieved PIN should match the expected value.")
  }
  
  func testSetPin() {
    // Given
    let myPin = "1111"
    stubSetPin(expected: myPin)
    
    // When
    controller.setPin(with: myPin)
    
    // Then
    XCTAssertEqual(setPinCalledWith, myPin, "The provider should be called with the correct PIN.")
  }
  
  func testIsPinValid() {
    // Given
    let testPin = "1111"
    stubIsPinValid(result: true)
    
    // When
    let result = controller.isPinValid(with: testPin)
    
    // Then
    XCTAssertTrue(result, "The controller should return true for a valid pin.")
  }
  
}

extension TestPinStorageController {
  func stubRetrievePin(expectedPin: String) {
    stub(provider) { mock in
      when(mock.retrievePin()).thenReturn(expectedPin)
    }
  }
  
  func stubSetPin(expected pin: String) {
    stub(provider) { mock in
      when(mock.setPin(with: any())).then { [weak self] passedPin in
        self?.setPinCalledWith = passedPin
      }
    }
  }
  
  func stubIsPinValid(result: Bool) {
    stub(provider) { mock in
      when(mock.isPinValid(with: any())).thenReturn(result)
    }
  }
}
