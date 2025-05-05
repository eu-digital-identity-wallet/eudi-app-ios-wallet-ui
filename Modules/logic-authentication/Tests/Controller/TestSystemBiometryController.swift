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
import Combine
@testable import logic_test
@testable import logic_authentication

final class TestSystemBiometryController: EudiTest {
  
  var biometryController: SystemBiometryController!
  var keyChainController: MockKeyChainController!
  var cancellables: Set<AnyCancellable> = []
  
  override func setUp() {
    super.setUp()
    self.keyChainController = MockKeyChainController()
    self.biometryController = SystemBiometryControllerImpl(
      keyChainController: keyChainController
    )
  }
  
  override func tearDown() {
    self.cancellables.removeAll()
    self.biometryController = nil
    self.keyChainController = nil
  }
  
  func testEvaluateBiometrics_success() {
    //Given
    let expectation = expectation(description: "Biometrics should succeed")
    
    stubValidateKeyChainBiometrySuccess()
    
    //When / Then
    biometryController.evaluateBiometrics()
      .sink(receiveCompletion: { completion in
        if case .failure = completion {
          XCTFail("Expected success, got failure")
        }
      }, receiveValue: {
        verify(self.keyChainController).validateKeyChainBiometry()
        expectation.fulfill()
      })
      .store(in: &cancellables)
    
    wait(for: [expectation], timeout: 1.0)
  }
  
  func testEvaluateBiometrics_failure() {
    //Given
    let expectation = expectation(description: "Biometrics should fail")
    
    stubValidateKeyChainBiometryFailure()
    
    //When / Then
    biometryController.evaluateBiometrics()
      .sink(receiveCompletion: { completion in
        if case let .failure(error) = completion {
          XCTAssertEqual(error, .biometricError)
          verify(self.keyChainController).clearKeyChainBiometry()
          expectation.fulfill()
        }
      }, receiveValue: {
        XCTFail("Should not succeed")
      })
      .store(in: &cancellables)
    
    wait(for: [expectation], timeout: 1.0)
  }
}

extension TestSystemBiometryController {
  func stubValidateKeyChainBiometrySuccess() {
    stub(keyChainController) { stub in
      when(stub.validateKeyChainBiometry())
        .thenDoNothing()
    }
  }
  
  func stubValidateKeyChainBiometryFailure() {
    stub(keyChainController) { stub in
      when(stub.validateKeyChainBiometry())
        .thenThrow(SystemBiometryError.biometricError)
      when(stub.clearKeyChainBiometry())
        .thenDoNothing()
    }
  }
}
