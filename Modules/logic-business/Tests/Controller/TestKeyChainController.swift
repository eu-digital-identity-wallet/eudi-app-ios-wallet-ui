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
@testable import logic_business
@testable import logic_test

final class TestKeyChainController: EudiTest {

  private struct Key: KeyChainWrapper {
    let value: String
  }

  var configLogic: MockConfigLogic!
  var keyChainController: KeyChainController!

  override func setUp() {
    super.setUp()
    self.configLogic = MockConfigLogic()
    stub(configLogic) { mock in
      when(mock.keyChainConfig.get).thenReturn(
        KeyChainConfig(documentStorageServiceName: "eu.europa.ec.euidi.tests", keychainAccessGroup: "")
      )
    }
    self.keyChainController = KeyChainControllerImpl(configLogic: configLogic)
  }

  override func tearDown() {
    self.keyChainController = nil
    self.configLogic = nil
    super.tearDown()
  }

  /// The module test bundle has no keychain entitlement, so every keychain call fails with
  /// `errSecMissingEntitlement`: the failed read must be reported, not taken for a missing item.
  func testFetchValue_WhenTheKeychainRefusesTheRead_ThenThrowsReadFailedWithTheStatus() {
    // Then
    XCTAssertThrowsError(try keyChainController.fetchValue(key: Key(value: "value"))) { error in
      XCTAssertEqual(error as? KeyChainError, .readFailed(status: errSecMissingEntitlement))
    }
  }

  /// See `testFetchValue_WhenTheKeychainRefusesTheRead_ThenThrowsReadFailedWithTheStatus`.
  func testFetchData_WhenTheKeychainRefusesTheRead_ThenThrowsReadFailedWithTheStatus() {
    // Then
    XCTAssertThrowsError(try keyChainController.fetchData(key: Key(value: "data"))) { error in
      XCTAssertEqual(error as? KeyChainError, .readFailed(status: errSecMissingEntitlement))
    }
  }

  /// See `testFetchValue_WhenTheKeychainRefusesTheRead_ThenThrowsReadFailedWithTheStatus`.
  func testSaveValue_WhenTheKeychainRefusesTheWrite_ThenThrowsWriteFailedWithTheStatus() {
    // Then
    XCTAssertThrowsError(try keyChainController.saveValue(key: Key(value: "value"), value: "v")) { error in
      XCTAssertEqual(error as? KeyChainError, .writeFailed(status: errSecMissingEntitlement))
    }
    XCTAssertThrowsError(try keyChainController.saveValue(key: Key(value: "data"), value: Data([1]))) { error in
      XCTAssertEqual(error as? KeyChainError, .writeFailed(status: errSecMissingEntitlement))
    }
  }

  func testValidateBiometricItem_WhenItemIsMissing_ThenThrowsItemNotFound() {
    // Then
    XCTAssertThrowsError(try KeyChainControllerImpl.validateBiometricItem(nil)) { error in
      XCTAssertEqual(error as? KeyChainError, .itemNotFound)
    }
  }

  func testValidateBiometricItem_WhenItemIsEmpty_ThenThrowsItemNotFound() {
    // Then
    XCTAssertThrowsError(try KeyChainControllerImpl.validateBiometricItem("")) { error in
      XCTAssertEqual(error as? KeyChainError, .itemNotFound)
    }
  }

  func testValidateBiometricItem_WhenItemIsPresent_ThenSucceeds() {
    // Then
    XCTAssertNoThrow(try KeyChainControllerImpl.validateBiometricItem("probe"))
  }

  func testAccessibility_WhenItemsAreWritten_ThenTheyStayOnThisDevice() {
    // When
    let accessibility = KeyChainControllerImpl.accessibility

    // Then
    XCTAssertEqual(accessibility, .whenUnlockedThisDeviceOnly)
  }

  func testPreviousClassQuery_WhenBuilt_ThenSelectsOnlyTheServicesWhenUnlockedPasswords() {
    // When
    let query = KeyChainControllerImpl.previousClassQuery(service: "service", accessGroup: "group")

    // Then
    XCTAssertEqual(query[kSecClass as String] as? String, kSecClassGenericPassword as String)
    XCTAssertEqual(query[kSecAttrService as String] as? String, "service")
    XCTAssertEqual(query[kSecAttrAccessGroup as String] as? String, "group")
    XCTAssertEqual(query[kSecAttrAccessible as String] as? String, kSecAttrAccessibleWhenUnlocked as String)
  }

  func testPreviousClassQuery_WhenThereIsNoAccessGroup_ThenLeavesItOut() {
    // When
    let query = KeyChainControllerImpl.previousClassQuery(service: "service", accessGroup: "")

    // Then
    XCTAssertNil(query[kSecAttrAccessGroup as String])
  }

  func testThisDeviceOnlyAttributes_WhenApplied_ThenMoveTheItemsToWhenUnlockedThisDeviceOnly() {
    // When
    let attributes = KeyChainControllerImpl.thisDeviceOnlyAttributes()

    // Then
    XCTAssertEqual(
      attributes[kSecAttrAccessible as String] as? String,
      kSecAttrAccessibleWhenUnlockedThisDeviceOnly as String
    )
  }

  func testBiometricProbePolicy_WhenTheProbeIsWritten_ThenItIsBoundToTheCurrentEnrolment() {
    // When
    let policy = KeyChainControllerImpl.biometricProbePolicy

    // Then
    XCTAssertEqual(policy, [.biometryCurrentSet])
  }

  func testIsMoveComplete_WhenTheUpdateSucceedsOrFindsNothing_ThenIsDone() {
    // When
    let afterSuccess = KeyChainControllerImpl.isMoveComplete(errSecSuccess)
    let afterNothingFound = KeyChainControllerImpl.isMoveComplete(errSecItemNotFound)

    // Then
    XCTAssertTrue(afterSuccess)
    XCTAssertTrue(afterNothingFound)
  }

  func testIsMoveComplete_WhenTheDeviceIsLocked_ThenIsRetried() {
    // When
    let isComplete = KeyChainControllerImpl.isMoveComplete(errSecInteractionNotAllowed)

    // Then
    XCTAssertFalse(isComplete)
  }
}
