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
import Combine
@testable import logic_test
@testable import logic_authentication
@preconcurrency import LocalAuthentication

final class TestSystemBiometryController: EudiTest {

  class StubLAContext: LAContext {
    var canEvaluateReturn = true
    var evaluateError: NSError? = nil

    var stubBiometryType: LABiometryType = .touchID
    override var biometryType: LABiometryType { stubBiometryType }

    override func canEvaluatePolicy(
      _ policy: LAPolicy,
      error: NSErrorPointer
    ) -> Bool {
      if let e = evaluateError {
        error?.pointee = e
      }
      return canEvaluateReturn
    }

    var evaluatePolicyResult: (success: Bool, error: Error?) = (true, nil)
    override func evaluatePolicy(
      _ policy: LAPolicy,
      localizedReason: String,
      reply: @escaping (Bool, Error?) -> Void
    ) {
      reply(evaluatePolicyResult.success, evaluatePolicyResult.error)
    }

    override func invalidate() {}
  }

  var biometryController: SystemBiometryController!
  var keyChainController: MockKeyChainController!
  var context: StubLAContext!
  var cancellables: Set<AnyCancellable> = []

  override func setUp() {
    super.setUp()
    self.keyChainController = MockKeyChainController()
    self.context = StubLAContext()
    self.biometryController = SystemBiometryControllerImpl(
      context: context,
      keyChainController: keyChainController
    )
  }

  override func tearDown() {
    self.cancellables.removeAll()
    self.biometryController = nil
    self.keyChainController = nil
    self.context = nil
  }

  func testRequestUnlock_WhenPolicyDenied_ThenDeniedAccess() {
    // Given
    context.canEvaluateReturn = false
    context.evaluateError = NSError(
      domain: LAErrorDomain,
      code: LAError.Code.userCancel.rawValue,
      userInfo: nil
    )

    let exp = expectation(description: "deniedAccess")
    // When
    biometryController.requestBiometricUnlock()
      .sink(
        receiveCompletion: { completion in
          // Then
          if case let .failure(err) = completion {
            XCTAssertEqual(err, .deniedAccess)
            XCTAssertEqual(
              err.errorDescription,
              NSLocalizedString(
                "You have denied access. Please go to the settings, locate this application and turn the Face ID on",
                comment: ""
              )
            )
            exp.fulfill()
          }
        },
        receiveValue: { _ in
          XCTFail("Should not send value when policy is denied")
        }
      )
      .store(in: &cancellables)

    wait(for: [exp], timeout: 0.5)
  }

  func testRequestBiometricUnlock_WhenFaceID_ThenNoFaceIdEnrolled() {
    // Given
    context.canEvaluateReturn = true
    context.evaluateError = NSError(
      domain: LAErrorDomain,
      code: LAError.Code.biometryNotEnrolled.rawValue,
      userInfo: nil
    )
    context.stubBiometryType = .faceID

    let exp = expectation(description: "noFaceIdEnrolled")
    // When
    biometryController.requestBiometricUnlock()
      .sink(
        receiveCompletion: { completion in
          // Then
          if case let .failure(err) = completion {
            XCTAssertEqual(err, .noFaceIdEnrolled)
            XCTAssertEqual(
              err.errorDescription,
              NSLocalizedString("You have not enabled Face ID yet", comment: "")
            )
            exp.fulfill()
          }
        },
        receiveValue: { _ in XCTFail("Should not send a value") }
      )
      .store(in: &cancellables)

    wait(for: [exp], timeout: 0.5)
  }

  func testRequestBiometricUnlock_WhenTouchID_ThenNoFingerprintEnrolled() {
    // Given
    context.canEvaluateReturn = true
    context.evaluateError = NSError(
      domain: LAErrorDomain,
      code: LAError.Code.biometryNotEnrolled.rawValue,
      userInfo: nil
    )
    context.stubBiometryType = .touchID

    let exp = expectation(description: "noFingerprintEnrolled")
    // When
    biometryController.requestBiometricUnlock()
      .sink(
        receiveCompletion: { completion in
          // Then
          if case let .failure(err) = completion {
            XCTAssertEqual(err, .noFingerprintEnrolled)
            XCTAssertEqual(
              err.errorDescription,
              NSLocalizedString("You have not enabled fingerprint yet", comment: "")
            )
            exp.fulfill()
          }
        },
        receiveValue: { _ in XCTFail() }
      )
      .store(in: &cancellables)

    wait(for: [exp], timeout: 0.5)
  }

  func testRequestBiometricUnlock_WhenBiometryNotSupported_yieldsBiometryNotSupported() {
    // Given
    context.canEvaluateReturn = true
    context.evaluateError = nil
    context.stubBiometryType = .none

    let exp = expectation(description: "biometryNotSupported")
    // When
    biometryController.requestBiometricUnlock()
      .sink(
        receiveCompletion: { completion in
          // Then
          if case let .failure(err) = completion {
            XCTAssertEqual(err, .biometryNotSupported)
            XCTAssertEqual(
              err.errorDescription,
              NSLocalizedString("This device does not support biometry", comment: "")
            )
            exp.fulfill()
          }
        },
        receiveValue: { _ in XCTFail() }
      )
      .store(in: &cancellables)

    wait(for: [exp], timeout: 0.5)
  }

  func testRequestBiometricUnlock_WhenKeychainValidates_ThenReturnSuccess() {
    // Given
    context.canEvaluateReturn = true
    context.evaluateError = nil
    context.stubBiometryType = .touchID

    stub(keyChainController) { stub in
      when(stub.validateKeyChainBiometry()).thenDoNothing()
    }

    let exp = expectation(description: "success")
    // When
    biometryController.requestBiometricUnlock()
      .sink(
        receiveCompletion: { completion in
          // Then
          if case let .failure(err) = completion {
            XCTFail("Expected success but got \(err)")
          }
        },
        receiveValue: {
          exp.fulfill()
        }
      )
      .store(in: &cancellables)

    wait(for: [exp], timeout: 0.5)
  }

  func testRequestBiometricUnlock_WhenKeychainThrows_ThenReturnBiometricError() {
    // Given
    context.canEvaluateReturn = true
    context.evaluateError = nil
    context.stubBiometryType = .touchID

    stub(keyChainController) { stub in
      when(stub.validateKeyChainBiometry())
        .thenThrow(SystemBiometryError.biometricError)
      when(stub.clearKeyChainBiometry())
        .thenDoNothing()
    }

    let exp = expectation(description: "biometricError")
    // When
    biometryController.requestBiometricUnlock()
      .sink(
        receiveCompletion: { completion in
          // Then
          if case let .failure(err) = completion {
            XCTAssertEqual(err, .biometricError)
            XCTAssertEqual(
              err.errorDescription,
              NSLocalizedString("Your biometric method has not been recognized", comment: "")
            )
            exp.fulfill()
          }
        },
        receiveValue: { _ in XCTFail() }
      )
      .store(in: &cancellables)

    wait(for: [exp], timeout: 0.5)
  }

  func testRequestBiometricUnlock_WhenLAContextErrorIsMinus6_ThenDeniedAccess() {
    // Given
    context.canEvaluateReturn = true
    context.evaluateError = NSError(
      domain: LAErrorDomain,
      code: -6,
      userInfo: nil
    )
    context.stubBiometryType = .touchID

    let exp = expectation(description: "deniedAccess")
    // When
    biometryController.requestBiometricUnlock()
      .sink(
        receiveCompletion: { completion in
          // Then
          if case let .failure(err) = completion {
            XCTAssertEqual(err, .deniedAccess)
            exp.fulfill()
          }
        },
        receiveValue: { _ in
          XCTFail("Should not send value when code is -6")
        }
      )
      .store(in: &cancellables)

    wait(for: [exp], timeout: 0.5)
  }

  func testRequestBiometricUnlock_WhenLAContextErrorIsUserFallback_ThenDeniedAccess() {
    // Given
    context.canEvaluateReturn = true
    context.evaluateError = NSError(
      domain: LAErrorDomain,
      code: LAError.Code.userFallback.rawValue,
      userInfo: nil
    )
    context.stubBiometryType = .touchID

    let exp = expectation(description: "deniedAccess")
    // When
    biometryController.requestBiometricUnlock()
      .sink(
        receiveCompletion: { completion in
          // Then
          if case let .failure(err) = completion {
            XCTAssertEqual(err, .biometricError)
            exp.fulfill()
          }
        },
        receiveValue: { _ in
          XCTFail("Should not send value when code is -6")
        }
      )
      .store(in: &cancellables)

    wait(for: [exp], timeout: 0.5)
  }

  func testRequestBiometricUnlock_WhenSelfIsDeallocated_ThenReturnsBiometricError() {
    // Given
    var biometryController: SystemBiometryControllerImpl? = SystemBiometryControllerImpl(
      context: context,
      keyChainController: keyChainController
    )
    weak var weakBiometryController = biometryController
    var cancellables = Set<AnyCancellable>()
    let publisher = biometryController!.requestBiometricUnlock()
    biometryController = nil

    let exp = expectation(description: "biometricErrorOnDeinit")
    // When
    publisher
      .sink(
        receiveCompletion: { completion in
          // Then
          if case let .failure(error) = completion {
            XCTAssertEqual(error, .biometricError)
            exp.fulfill()
          }
        },
        receiveValue: { _ in
          XCTFail("Should not receive a value")
        }
      )
      .store(in: &cancellables)

    wait(for: [exp], timeout: 0.5)
    XCTAssertNil(weakBiometryController) // Confirm deallocation
  }

  func testSystemBiometryError_id_ReturnsLocalizedDescription() {
    // Given
    let allErrors: [SystemBiometryError] = [
      .deniedAccess,
      .noFaceIdEnrolled,
      .noFingerprintEnrolled,
      .biometricError,
      .biometryNotSupported
    ]
    // When & Then
    for error in allErrors {
      XCTAssertEqual(error.id, error.localizedDescription)
      XCTAssertEqual(error.id, error.errorDescription)
    }
  }

  func testBiometryType_ReturnsContextBiometryType() {
    // Given
    context.stubBiometryType = .faceID
    // When & Then
    XCTAssertEqual(biometryController.biometryType, .faceID)

    // Given
    context.stubBiometryType = .touchID
    // When & Then
    XCTAssertEqual(biometryController.biometryType, .touchID)

    // Given
    context.stubBiometryType = .none
    // When & Then
    XCTAssertEqual(biometryController.biometryType, .none)
  }
}
