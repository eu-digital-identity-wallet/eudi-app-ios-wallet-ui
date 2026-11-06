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

@testable import logic_test
@testable import logic_authentication
@testable import logic_business

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
  
  func testHasPin_WhenAPinIsStored_ThenReturnsTrue() throws {
    //Given
    let expected = true
    stubHasPin(expected: expected)
    
    // When
    let result = try controller.hasPin()
    
    //Then
    XCTAssertEqual(result, expected, "The hasPin result should match the expected value.")
  }
  
  func testSetPin_WhenCalled_ThenPassesThePinToTheProvider() throws {
    // Given
    let myPin = "1111"
    stubSetPin(expected: myPin)
    
    // When
    try controller.setPin(with: myPin)
    
    // Then
    XCTAssertEqual(setPinCalledWith, myPin, "The provider should be called with the correct PIN.")
  }
  
  func testIsPinValid_WhenTheProviderAcceptsThePin_ThenReturnsTrue() {
    // Given
    let testPin = "1111"
    stubIsPinValid(result: true)
    
    // When
    let result = controller.isPinValid(with: testPin)
    
    // Then
    XCTAssertTrue(result, "The controller should return true for a valid pin.")
  }

  func testHasPin_WhenProviderReadFails_ThenThrowsTheProviderError() {
    stub(provider) { mock in
      when(mock.hasPin()).thenThrow(KeyChainError.readFailed(status: errSecInteractionNotAllowed))
    }

    XCTAssertThrowsError(try controller.hasPin()) { error in
      XCTAssertEqual(error as? KeyChainError, .readFailed(status: errSecInteractionNotAllowed))
    }
  }

  func testSetPin_WhenProviderWriteFails_ThenThrowsTheProviderError() {
    stub(provider) { mock in
      when(mock.setPin(with: any())).thenThrow(KeyChainError.writeFailed(status: errSecNotAvailable))
    }

    XCTAssertThrowsError(try controller.setPin(with: "1111")) { error in
      XCTAssertEqual(error as? KeyChainError, .writeFailed(status: errSecNotAvailable))
    }
  }
}

extension TestPinStorageController {
  func stubHasPin(expected: Bool) {
    stub(provider) { mock in
      when(mock.hasPin()).thenReturn(expected)
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
