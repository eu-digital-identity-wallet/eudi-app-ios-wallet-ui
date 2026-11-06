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

final class TestKeychainPinStorageProvider: EudiTest {

  private var storedStrings: [String: String] = [:]
  private var storedData: [String: Data] = [:]
  private var failingReadKeys: Set<String> = []
  private var failingWriteKeys: Set<String> = []
  private var failingWriteAttempts: [String: Set<Int>] = [:]
  private var writeAttempts: [String: Int] = [:]
  private let pinKeys: [KeychainPinStorageProvider.KeyIdentifier] = [
    .devicePinSalt,
    .devicePinHash,
    .devicePinIterations
  ]

  private var provider: PinStorageProvider!
  private var keyChainController: MockKeyChainController!

  override func setUp() {
    super.setUp()
    self.storedStrings = [:]
    self.storedData = [:]
    self.failingReadKeys = []
    self.failingWriteKeys = []
    self.failingWriteAttempts = [:]
    self.writeAttempts = [:]
    self.keyChainController = MockKeyChainController()
    
    stubKeyChainController()

    self.provider = KeychainPinStorageProvider(keyChainController: keyChainController)
  }

  override func tearDown() {
    self.provider = nil
    self.keyChainController = nil
    self.storedStrings.removeAll()
    self.storedData.removeAll()
    super.tearDown()
  }

  func testHasPin_WhenNothingStored_ThenFalse() throws {
    XCTAssertFalse(try provider.hasPin())
  }

  func testHasPin_AfterSetPin_ThenTrue() throws {
    try provider.setPin(with: "123456")
    XCTAssertTrue(try provider.hasPin())
  }

  func testHasPin_WhenIterationsMissing_ThenFalse() throws {
    try provider.setPin(with: "123456")
    storedStrings.removeValue(forKey: KeychainPinStorageProvider.KeyIdentifier.devicePinIterations.rawValue)

    XCTAssertFalse(try provider.hasPin())
  }

  func testHasPin_WhenSaltMissing_ThenFalse() throws {
    try provider.setPin(with: "123456")
    storedData.removeValue(forKey: KeychainPinStorageProvider.KeyIdentifier.devicePinSalt.rawValue)

    XCTAssertFalse(try provider.hasPin())
  }

  func testHasPin_WhenHashMissing_ThenFalse() throws {
    try provider.setPin(with: "123456")
    storedData.removeValue(forKey: KeychainPinStorageProvider.KeyIdentifier.devicePinHash.rawValue)

    XCTAssertFalse(try provider.hasPin())
  }

  func testHasPin_WhenIterationsIsZero_ThenFalse() throws {
    try provider.setPin(with: "123456")
    storedStrings[KeychainPinStorageProvider.KeyIdentifier.devicePinIterations.rawValue] = "0"

    XCTAssertFalse(try provider.hasPin())
  }

  func testHasPin_WhenIterationsIsNotNumeric_ThenFalse() throws {
    try provider.setPin(with: "123456")
    storedStrings[KeychainPinStorageProvider.KeyIdentifier.devicePinIterations.rawValue] = "not_a_number"

    XCTAssertFalse(try provider.hasPin())
  }

  func testSetPin_WhenEmptyString_ThenThrowsAndStoresNothing() {
    XCTAssertThrowsError(try provider.setPin(with: "")) { error in
      guard case .quickPinInvalid? = error as? AuthenticationError else {
        return XCTFail("Wrong error \(error)")
      }
    }

    XCTAssertNil(storedData[KeychainPinStorageProvider.KeyIdentifier.devicePinSalt.rawValue])
    XCTAssertNil(storedData[KeychainPinStorageProvider.KeyIdentifier.devicePinHash.rawValue])
    XCTAssertNil(storedStrings[KeychainPinStorageProvider.KeyIdentifier.devicePinIterations.rawValue])
  }

  func testSetPin_StoresSaltHashAndIterations() throws {
    try provider.setPin(with: "654321")

    let salt = storedData[KeychainPinStorageProvider.KeyIdentifier.devicePinSalt.rawValue]
    let hash = storedData[KeychainPinStorageProvider.KeyIdentifier.devicePinHash.rawValue]
    let iterations = storedStrings[KeychainPinStorageProvider.KeyIdentifier.devicePinIterations.rawValue]

    XCTAssertNotNil(salt)
    XCTAssertNotNil(hash)
    XCTAssertNotNil(iterations)
    XCTAssertEqual(salt?.count, 32)
    XCTAssertEqual(hash?.count, 32)
    XCTAssertEqual(iterations, "210000")
  }

  func testSetPin_UsesFreshSaltOnEverySet() throws {
    try provider.setPin(with: "111111")
    let salt1 = storedData[KeychainPinStorageProvider.KeyIdentifier.devicePinSalt.rawValue]

    try provider.setPin(with: "111111")
    let salt2 = storedData[KeychainPinStorageProvider.KeyIdentifier.devicePinSalt.rawValue]

    XCTAssertNotNil(salt1)
    XCTAssertNotNil(salt2)
    XCTAssertNotEqual(salt1, salt2)
  }

  func testIsPinValid_WhenEmptyPin_ThenFalse() throws {
    try provider.setPin(with: "123456")
    XCTAssertFalse(provider.isPinValid(with: ""))
  }

  func testIsPinValid_WhenNoStoredPin_ThenFalse() {
    XCTAssertFalse(provider.isPinValid(with: "123456"))
  }

  func testIsPinValid_WhenCorrectPin_ThenTrue() throws {
    try provider.setPin(with: "123456")
    XCTAssertTrue(provider.isPinValid(with: "123456"))
  }

  func testIsPinValid_WhenWrongPin_ThenFalse() throws {
    try provider.setPin(with: "123456")

    XCTAssertFalse(provider.isPinValid(with: "111111"))
    XCTAssertFalse(provider.isPinValid(with: "654321"))
    XCTAssertFalse(provider.isPinValid(with: "1234567"))
    XCTAssertFalse(provider.isPinValid(with: "12345"))
  }

  func testIsPinValid_AfterPinChange_OldPinFailsNewPinSucceeds() throws {
    try provider.setPin(with: "111111")
    XCTAssertTrue(provider.isPinValid(with: "111111"))

    try provider.setPin(with: "222222")
    XCTAssertFalse(provider.isPinValid(with: "111111"))
    XCTAssertTrue(provider.isPinValid(with: "222222"))
  }

  func testIsPinValid_WhenIterationsMissing_ThenFalse() throws {
    try provider.setPin(with: "123456")
    storedStrings.removeValue(forKey: KeychainPinStorageProvider.KeyIdentifier.devicePinIterations.rawValue)

    XCTAssertFalse(provider.isPinValid(with: "123456"))
  }

  func testIsPinValid_WhenIterationsIsZero_ThenFalse() throws {
    try provider.setPin(with: "123456")
    storedStrings[KeychainPinStorageProvider.KeyIdentifier.devicePinIterations.rawValue] = "0"

    XCTAssertFalse(provider.isPinValid(with: "123456"))
  }

  func testHasPin_WhenSaltIsEmptyData_ThenFalse() throws {
    try provider.setPin(with: "123456")
    storedData[KeychainPinStorageProvider.KeyIdentifier.devicePinSalt.rawValue] = Data()

    XCTAssertFalse(try provider.hasPin())
  }

  func testHasPin_WhenHashIsEmptyData_ThenFalse() throws {
    try provider.setPin(with: "123456")
    storedData[KeychainPinStorageProvider.KeyIdentifier.devicePinHash.rawValue] = Data()

    XCTAssertFalse(try provider.hasPin())
  }

  func testHasPin_WhenAnyReadFails_ThenThrowsReadFailed() throws {
    try provider.setPin(with: "123456")

    for key in pinKeys {
      failingReadKeys = [key.rawValue]

      XCTAssertThrowsError(try provider.hasPin(), key.rawValue) { error in
        XCTAssertEqual(error as? KeyChainError, .readFailed(status: errSecInteractionNotAllowed))
      }
    }
  }

  func testSetPin_WhenReadingThePreviousRecordFails_ThenThrowsAndWritesNothing() throws {
    try provider.setPin(with: "111111")

    for key in pinKeys {
      failingReadKeys = [key.rawValue]

      XCTAssertThrowsError(try provider.setPin(with: "222222"), key.rawValue) { error in
        XCTAssertEqual(error as? KeyChainError, .readFailed(status: errSecInteractionNotAllowed))
      }
    }

    failingReadKeys = []
    verify(keyChainController, times(2)).saveValue(key: any(), value: any(Data.self))
    verify(keyChainController, times(1)).saveValue(key: any(), value: any(String.self))
    verify(keyChainController, never()).storeValue(key: any(), value: any(Data.self))
    verify(keyChainController, never()).storeValue(key: any(), value: any(String.self))
    verify(keyChainController, never()).removeObject(key: any())
    XCTAssertTrue(provider.isPinValid(with: "111111"))
  }

  func testSetPin_WhenSecondWriteFailsWithoutPreviousRecord_ThenLeavesNoPartialRecord() throws {
    failingWriteKeys = [KeychainPinStorageProvider.KeyIdentifier.devicePinHash.rawValue]

    XCTAssertThrowsError(try provider.setPin(with: "123456")) { error in
      XCTAssertEqual(error as? KeyChainError, .writeFailed(status: errSecNotAvailable))
    }

    XCTAssertTrue(storedData.isEmpty)
    XCTAssertTrue(storedStrings.isEmpty)
    XCTAssertFalse(try provider.hasPin())
  }

  func testSetPin_WhenLastWriteFailsDuringChange_ThenRestoresThePreviousPin() throws {
    try provider.setPin(with: "111111")
    failingWriteAttempts = [KeychainPinStorageProvider.KeyIdentifier.devicePinIterations.rawValue: [2]]

    XCTAssertThrowsError(try provider.setPin(with: "222222")) { error in
      XCTAssertEqual(error as? KeyChainError, .writeFailed(status: errSecNotAvailable))
    }

    XCTAssertTrue(try provider.hasPin())
    XCTAssertTrue(provider.isPinValid(with: "111111"))
    XCTAssertFalse(provider.isPinValid(with: "222222"))
  }

  func testSetPin_WhenRestoringThePreviousRecordFails_ThenLeavesNoRecord() throws {
    try provider.setPin(with: "111111")
    failingWriteAttempts = [
      KeychainPinStorageProvider.KeyIdentifier.devicePinHash.rawValue: [2],
      KeychainPinStorageProvider.KeyIdentifier.devicePinSalt.rawValue: [3]
    ]

    XCTAssertThrowsError(try provider.setPin(with: "222222")) { error in
      XCTAssertEqual(error as? KeyChainError, .writeFailed(status: errSecNotAvailable))
    }

    XCTAssertTrue(storedData.isEmpty)
    XCTAssertTrue(storedStrings.isEmpty)
    XCTAssertFalse(try provider.hasPin())
  }

  private func stubKeyChainController() {
    stub(keyChainController) { mock in
      when(mock.storeValue(key: any(), value: any(String.self))).then { [weak self] (key, value) in
        self?.storedStrings[key.value] = value
      }
      when(mock.storeValue(key: any(), value: any(Data.self))).then { [weak self] (key, value) in
        self?.storedData[key.value] = value
      }
      when(mock.getValue(key: any())).then { [weak self] key in
        self?.storedStrings[key.value]
      }
      when(mock.getData(key: any())).then { [weak self] key in
        self?.storedData[key.value]
      }
      when(mock.removeObject(key: any())).then { [weak self] key in
        self?.storedStrings.removeValue(forKey: key.value)
        self?.storedData.removeValue(forKey: key.value)
      }
      when(mock.fetchValue(key: any())).then { [weak self] key in
        guard let self else { return nil }
        if self.failingReadKeys.contains(key.value) {
          throw KeyChainError.readFailed(status: errSecInteractionNotAllowed)
        }
        return self.storedStrings[key.value]
      }
      when(mock.fetchData(key: any())).then { [weak self] key in
        guard let self else { return nil }
        if self.failingReadKeys.contains(key.value) {
          throw KeyChainError.readFailed(status: errSecInteractionNotAllowed)
        }
        return self.storedData[key.value]
      }
      when(mock.saveValue(key: any(), value: any(String.self))).then { [weak self] (key, value) in
        guard let self else { return }
        try self.recordWriteAttempt(for: key.value)
        self.storedStrings[key.value] = value
      }
      when(mock.saveValue(key: any(), value: any(Data.self))).then { [weak self] (key, value) in
        guard let self else { return }
        try self.recordWriteAttempt(for: key.value)
        self.storedData[key.value] = value
      }
    }
  }

  private func recordWriteAttempt(for key: String) throws {
    let attempt = (writeAttempts[key] ?? 0) + 1
    writeAttempts[key] = attempt
    if failingWriteKeys.contains(key) || failingWriteAttempts[key]?.contains(attempt) == true {
      throw KeyChainError.writeFailed(status: errSecNotAvailable)
    }
  }
}
