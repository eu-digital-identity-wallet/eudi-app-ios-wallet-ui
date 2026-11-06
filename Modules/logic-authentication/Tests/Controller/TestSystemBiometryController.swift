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
import os
@testable import logic_test
@testable import logic_authentication
@testable import logic_business
import logic_resources
@preconcurrency import LocalAuthentication

final class TestSystemBiometryController: EudiTest {
  
  // MARK: - Stub LAContext
  class StubLAContext: LAContext {
    
    var canEvaluateReturn: Bool = true
    var evaluateError: NSError? = nil
    var stubBiometryType: LABiometryType = .touchID
    var evaluatePolicyResult: (success: Bool, error: Error?) = (true, nil)
    var evaluatedPolicies: [LAPolicy] = []
    var isInvalidated = false
    /// Set for the contexts the recorder hands out, which report to it instead of being kept.
    var recorder: RecordingLAContextProvider?
    var recordId = 0
    
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
    
    override func evaluatePolicy(
      _ policy: LAPolicy,
      localizedReason: String,
      reply: @escaping (Bool, Error?) -> Void
    ) {
      evaluatedPolicies.append(policy)
      recorder?.recordEvaluation(of: recordId, policy: policy, fallbackTitle: localizedFallbackTitle)
      reply(evaluatePolicyResult.success, evaluatePolicyResult.error)
    }
    
    override func invalidate() {
      isInvalidated = true
      recorder?.recordInvalidation(of: recordId)
    }
  }

  /// What the tests check about a context the controller asked for, as values: `LAContext` is not `Sendable`.
  struct ContextRecord: Sendable, Equatable {
    let id: Int
    var evaluatedPolicies: [LAPolicy] = []
    var fallbackTitle: String?
    var isInvalidated = false
    /// Whether the context was already invalidated when the Keychain probe was read with it; nil if it never was.
    var wasInvalidatedWhenProbed: Bool?
  }

  /// Hands out stub contexts that report what happens to them, and keeps only those reports.
  final class RecordingLAContextProvider: Sendable {

    private struct State: Sendable {
      var evaluatePolicyResult: (success: Bool, error: Error?) = (true, nil)
      var records: [ContextRecord] = []
    }

    private let state = OSAllocatedUnfairLock(initialState: State())

    var evaluatePolicyResult: (success: Bool, error: Error?) {
      get { state.withLock { $0.evaluatePolicyResult } }
      set { state.withLock { $0.evaluatePolicyResult = newValue } }
    }

    var records: [ContextRecord] { state.withLock { $0.records } }

    func makeContext() -> LAContext {
      let (id, result) = state.withLock { state in
        state.records.append(ContextRecord(id: state.records.count))
        return (state.records.count - 1, state.evaluatePolicyResult)
      }
      let context = StubLAContext()
      context.evaluatePolicyResult = result
      context.recorder = self
      context.recordId = id
      return context
    }

    func recordEvaluation(of id: Int, policy: LAPolicy, fallbackTitle: String?) {
      state.withLock {
        $0.records[id].evaluatedPolicies.append(policy)
        $0.records[id].fallbackTitle = fallbackTitle
      }
    }

    func recordInvalidation(of id: Int) {
      state.withLock { $0.records[id].isInvalidated = true }
    }

    /// Records the probe read with `context`, one of this recorder's.
    func recordProbe(with context: LAContext) {
      guard let context = context as? StubLAContext, context.recorder === self else { return }
      let id = context.recordId
      let wasInvalidated = context.isInvalidated
      state.withLock { $0.records[id].wasInvalidatedWhenProbed = wasInvalidated }
    }
  }

  // MARK: - Properties
  var biometryController: SystemBiometryController!
  var keyChainController: MockKeyChainController!
  var context: StubLAContext!
  var contextProvider: RecordingLAContextProvider!
  
  // MARK: - Lifecycle
  override func setUp() {
    super.setUp()
    self.keyChainController = MockKeyChainController()
    self.context = StubLAContext()
    let contextProvider = RecordingLAContextProvider()
    self.contextProvider = contextProvider
    self.biometryController = SystemBiometryControllerImpl(
      context: context,
      evaluationContextProvider: { contextProvider.makeContext() },
      keyChainController: keyChainController
    )
  }
  
  override func tearDown() {
    self.biometryController = nil
    self.keyChainController = nil
    self.context = nil
    self.contextProvider = nil
    super.tearDown()
  }
  
  // MARK: - Tests
  func testRequestUnlock_WhenPolicyDenied_ThenDeniedAccess() async {
    // Given: canEvaluatePolicy fails with no specific error
    context.canEvaluateReturn = false
    context.evaluateError = nil
    
    // When / Then
    do {
      try await biometryController.requestBiometricUnlock()
      XCTFail("Expected requestBiometricUnlock to throw")
    } catch let error as SystemBiometryError {
      XCTAssertEqual(error, .deniedAccess)
      XCTAssertEqual(error.errorDescription, LocalizableStringKey.biometryDeniedAccessError.toString)
    } catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testRequestBiometricUnlock_WhenFaceID_ThenNoFaceIdEnrolled() async {
    // Given: canEvaluatePolicy fails with biometryNotEnrolled and Face ID
    context.canEvaluateReturn = false
    context.evaluateError = NSError(
      domain: LAErrorDomain,
      code: LAError.Code.biometryNotEnrolled.rawValue,
      userInfo: nil
    )
    context.stubBiometryType = .faceID
    
    // When / Then
    do {
      try await biometryController.requestBiometricUnlock()
      XCTFail("Expected requestBiometricUnlock to throw")
    } catch let error as SystemBiometryError {
      XCTAssertEqual(error, .noFaceIdEnrolled)
      XCTAssertEqual(error.errorDescription, LocalizableStringKey.biometryNoFaceIdEnrolledError.toString)
    } catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testRequestBiometricUnlock_WhenTouchID_ThenNoFingerprintEnrolled() async {
    // Given: canEvaluatePolicy fails with biometryNotEnrolled and Touch ID
    context.canEvaluateReturn = false
    context.evaluateError = NSError(
      domain: LAErrorDomain,
      code: LAError.Code.biometryNotEnrolled.rawValue,
      userInfo: nil
    )
    context.stubBiometryType = .touchID
    
    // When / Then
    do {
      try await biometryController.requestBiometricUnlock()
      XCTFail("Expected requestBiometricUnlock to throw")
    } catch let error as SystemBiometryError {
      XCTAssertEqual(error, .noFingerprintEnrolled)
      XCTAssertEqual(error.errorDescription, LocalizableStringKey.biometryNoFingerprintEnrolledError.toString)
    } catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testRequestBiometricUnlock_WhenBiometryNotSupported_yieldsBiometryNotSupported() async {
    // Given: canEvaluatePolicy succeeds, but biometryType is .none
    context.canEvaluateReturn = true
    context.evaluateError = nil
    context.stubBiometryType = .none
    
    // When / Then
    do {
      try await biometryController.requestBiometricUnlock()
      XCTFail("Expected requestBiometricUnlock to throw")
    } catch let error as SystemBiometryError {
      XCTAssertEqual(error, .biometryNotSupported)
      XCTAssertEqual(error.errorDescription, LocalizableStringKey.biometryNotSupportedError.toString)
    } catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testRequestBiometricUnlock_WhenKeychainValidates_ThenReturnSuccess() async {
    // Given: canEvaluate is OK, biometryType is valid, keychain validation succeeds
    context.canEvaluateReturn = true
    context.evaluateError = nil
    context.stubBiometryType = .touchID
    
    stub(keyChainController) { stub in
      when(stub.validateKeyChainBiometry(with: any())).thenDoNothing()
    }
    
    // When / Then: no error thrown
    do {
      try await biometryController.requestBiometricUnlock()
    } catch {
      XCTFail("Expected success but got error: \(error)")
    }
  }
  
  func testRequestBiometricUnlock_WhenKeychainThrows_ThenReturnBiometricError() async {
    // Given: canEvaluate is OK, but keychain validation throws
    context.canEvaluateReturn = true
    context.evaluateError = nil
    context.stubBiometryType = .touchID
    
    stub(keyChainController) { stub in
      when(stub.validateKeyChainBiometry(with: any()))
        .thenThrow(SystemBiometryError.biometricError)
      when(stub.clearKeyChainBiometry())
        .thenDoNothing()
    }
    
    // When / Then
    do {
      try await biometryController.requestBiometricUnlock()
      XCTFail("Expected requestBiometricUnlock to throw")
    } catch let error as SystemBiometryError {
      XCTAssertEqual(error, .biometricError)
      XCTAssertEqual(error.errorDescription, LocalizableStringKey.biometryNotRecognizedError.toString)
    } catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testRequestBiometricUnlock_WhenLAContextErrorIsMinus6_ThenDeniedAccess() async {
    // Given: canEvaluatePolicy fails with custom error code -6
    context.canEvaluateReturn = false
    context.evaluateError = NSError(
      domain: LAErrorDomain,
      code: -6,
      userInfo: nil
    )
    context.stubBiometryType = .touchID
    
    // When / Then
    do {
      try await biometryController.requestBiometricUnlock()
      XCTFail("Expected requestBiometricUnlock to throw")
    } catch let error as SystemBiometryError {
      XCTAssertEqual(error, .deniedAccess)
    } catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testRequestBiometricUnlock_WhenLAContextErrorIsUserFallback_ThenBiometricError() async {
    // Given: canEvaluatePolicy fails with userFallback; we treat as generic biometricError
    context.canEvaluateReturn = false
    context.evaluateError = NSError(
      domain: LAErrorDomain,
      code: LAError.Code.userFallback.rawValue,
      userInfo: nil
    )
    context.stubBiometryType = .touchID
    
    // When / Then
    do {
      try await biometryController.requestBiometricUnlock()
      XCTFail("Expected requestBiometricUnlock to throw")
    } catch let error as SystemBiometryError {
      XCTAssertEqual(error, .biometricError)
    } catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testRequestBiometricUnlock_WhenPolicyEvaluationReturnsFalse_ThenBiometricErrorWithoutKeychainProbe() async {
    stubCanEvaluateBiometrics()
    contextProvider.evaluatePolicyResult = (false, nil)

    await assertUnlockFails(with: .biometricError)

    verify(keyChainController, never()).validateKeyChainBiometry(with: any())
    verify(keyChainController, never()).clearKeyChainBiometry()
    XCTAssertEqual(contextProvider.records.map(\.isInvalidated), [true])
  }

  func testRequestBiometricUnlock_WhenPolicyEvaluationIsCancelled_ThenBiometricErrorWithoutKeychainProbe() async {
    stubCanEvaluateBiometrics()
    contextProvider.evaluatePolicyResult = (
      false,
      NSError(domain: LAErrorDomain, code: LAError.Code.userCancel.rawValue, userInfo: nil)
    )

    await assertUnlockFails(with: .biometricError)

    verify(keyChainController, never()).validateKeyChainBiometry(with: any())
  }

  func testRequestBiometricUnlock_WhenTheProbeCannotBeRead_ThenBiometricErrorAndTheProbeStays() async {
    stubCanEvaluateBiometrics()
    stub(keyChainController) { stub in
      when(stub.validateKeyChainBiometry(with: any())).thenThrow(KeyChainError.itemNotFound)
      when(stub.clearKeyChainBiometry()).thenDoNothing()
    }

    await assertUnlockFails(with: .biometricError)

    verify(keyChainController, never()).clearKeyChainBiometry()
  }

  func testEnableBiometricUnlock_WhenThePolicyIsEvaluated_ThenWritesTheProbe() async throws {
    stubCanEvaluateBiometrics()
    stub(keyChainController) { stub in
      when(stub.storeBiometricProbe()).thenDoNothing()
    }

    try await biometryController.enableBiometricUnlock()

    verify(keyChainController).storeBiometricProbe()
    XCTAssertEqual(contextProvider.records.map(\.isInvalidated), [true])
  }

  func testEnableBiometricUnlock_WhenThePolicyFails_ThenBiometricErrorWithoutAProbe() async {
    stubCanEvaluateBiometrics()
    contextProvider.evaluatePolicyResult = (false, nil)

    do {
      try await biometryController.enableBiometricUnlock()
      XCTFail("Expected enableBiometricUnlock to throw")
    } catch {
      XCTAssertEqual(error as? SystemBiometryError, .biometricError)
    }

    verify(keyChainController, never()).storeBiometricProbe()
  }

  func testDisableBiometricUnlock_WhenCalled_ThenRemovesTheProbeWithoutAPrompt() async throws {
    stubClearKeyChainBiometry()

    try await biometryController.disableBiometricUnlock()

    verify(keyChainController).clearKeyChainBiometry()
    XCTAssertTrue(contextProvider.records.isEmpty)
  }

  func testDisableBiometricUnlock_WhenBiometricsAreLockedOut_ThenStillRemovesTheProbe() async throws {
    context.canEvaluateReturn = false
    context.evaluateError = NSError(domain: LAErrorDomain, code: LAError.Code.biometryLockout.rawValue, userInfo: nil)
    stubClearKeyChainBiometry()

    try await biometryController.disableBiometricUnlock()

    verify(keyChainController).clearKeyChainBiometry()
    XCTAssertTrue(contextProvider.records.isEmpty)
  }

  func testRequestBiometricUnlock_WhenPolicyEvaluated_ThenProbeReadsWithTheEvaluatedContext() async throws {
    stubCanEvaluateBiometrics()
    let recorder: RecordingLAContextProvider = contextProvider
    stub(keyChainController) { stub in
      when(stub.validateKeyChainBiometry(with: any())).then { context in
        recorder.recordProbe(with: context)
      }
    }

    try await biometryController.requestBiometricUnlock()

    let record = try XCTUnwrap(contextProvider.records.first)
    XCTAssertEqual(contextProvider.records.count, 1)
    XCTAssertEqual(record.evaluatedPolicies, [.deviceOwnerAuthenticationWithBiometrics])
    XCTAssertEqual(record.fallbackTitle, "")
    XCTAssertEqual(record.wasInvalidatedWhenProbed, false)
    XCTAssertTrue(record.isInvalidated)
    XCTAssertTrue(context.evaluatedPolicies.isEmpty)
  }

  func testRequestBiometricUnlock_WhenCalledTwice_ThenEachAttemptEvaluatesANewContext() async throws {
    stubCanEvaluateBiometrics()
    stub(keyChainController) { stub in
      when(stub.validateKeyChainBiometry(with: any())).thenDoNothing()
    }

    try await biometryController.requestBiometricUnlock()
    try await biometryController.requestBiometricUnlock()

    let records = contextProvider.records
    XCTAssertEqual(records.map(\.id), [0, 1])
    XCTAssertEqual(records.map(\.evaluatedPolicies.count), [1, 1])
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
  
  func testBiometryType_ReturnsContextBiometryType() async {

    var type: LABiometryType = .none

    // Given
    context.stubBiometryType = .faceID
    type = await biometryController.getBiometryType()
    // Then
    XCTAssertEqual(type, .faceID)

    // Given
    context.stubBiometryType = .touchID
    type = await biometryController.getBiometryType()
    // Then
    XCTAssertEqual(type, .touchID)

    // Given
    context.stubBiometryType = .none
    type = await biometryController.getBiometryType()
    // Then
    XCTAssertEqual(type, .none)
  }

  func testOpenSettings_WhenCalled_ThenDoesNotCrash() async {
    // Exercises the body of openSettings(action:): URL resolution and the
    // dispatch into UIApplication.shared.open. The completion-handler
    // `action()` branch fires only when the real Settings app opens, so it
    // remains uncovered in unit tests by design.
    await biometryController.openSettings(action: {})
  }
}

private extension TestSystemBiometryController {

  func stubClearKeyChainBiometry() {
    stub(keyChainController) { stub in
      when(stub.clearKeyChainBiometry()).thenDoNothing()
    }
  }

  func stubCanEvaluateBiometrics() {
    context.canEvaluateReturn = true
    context.evaluateError = nil
    context.stubBiometryType = .faceID
    stubClearKeyChainBiometry()
  }

  func assertUnlockFails(with expectedError: SystemBiometryError) async {
    do {
      try await biometryController.requestBiometricUnlock()
      XCTFail("Expected requestBiometricUnlock to throw")
    } catch let error as SystemBiometryError {
      XCTAssertEqual(error, expectedError)
    } catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
}
