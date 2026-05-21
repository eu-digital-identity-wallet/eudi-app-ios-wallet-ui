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

  private var provider: PinStorageProvider!
  private var keyChainController: MockKeyChainController!

  override func setUp() {
    super.setUp()
    self.storedStrings = [:]
    self.storedData = [:]
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

  func testHasPin_WhenNothingStored_ThenFalse() {
    XCTAssertFalse(provider.hasPin())
  }

  func testHasPin_AfterSetPin_ThenTrue() {
    provider.setPin(with: "123456")
    XCTAssertTrue(provider.hasPin())
  }

  func testHasPin_WhenIterationsMissing_ThenFalse() {
    provider.setPin(with: "123456")
    storedStrings.removeValue(forKey: KeychainPinStorageProvider.KeyIdentifier.devicePinIterations.rawValue)

    XCTAssertFalse(provider.hasPin())
  }

  func testHasPin_WhenSaltMissing_ThenFalse() {
    provider.setPin(with: "123456")
    storedData.removeValue(forKey: KeychainPinStorageProvider.KeyIdentifier.devicePinSalt.rawValue)

    XCTAssertFalse(provider.hasPin())
  }

  func testHasPin_WhenHashMissing_ThenFalse() {
    provider.setPin(with: "123456")
    storedData.removeValue(forKey: KeychainPinStorageProvider.KeyIdentifier.devicePinHash.rawValue)

    XCTAssertFalse(provider.hasPin())
  }

  func testHasPin_WhenIterationsIsZero_ThenFalse() {
    provider.setPin(with: "123456")
    storedStrings[KeychainPinStorageProvider.KeyIdentifier.devicePinIterations.rawValue] = "0"

    XCTAssertFalse(provider.hasPin())
  }

  func testHasPin_WhenIterationsIsNotNumeric_ThenFalse() {
    provider.setPin(with: "123456")
    storedStrings[KeychainPinStorageProvider.KeyIdentifier.devicePinIterations.rawValue] = "not_a_number"

    XCTAssertFalse(provider.hasPin())
  }

  func testSetPin_WhenEmptyString_ThenNothingStored() {
    provider.setPin(with: "")

    XCTAssertNil(storedData[KeychainPinStorageProvider.KeyIdentifier.devicePinSalt.rawValue])
    XCTAssertNil(storedData[KeychainPinStorageProvider.KeyIdentifier.devicePinHash.rawValue])
    XCTAssertNil(storedStrings[KeychainPinStorageProvider.KeyIdentifier.devicePinIterations.rawValue])
  }

  func testSetPin_StoresSaltHashAndIterations() {
    provider.setPin(with: "654321")

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

  func testSetPin_UsesFreshSaltOnEverySet() {
    provider.setPin(with: "111111")
    let salt1 = storedData[KeychainPinStorageProvider.KeyIdentifier.devicePinSalt.rawValue]

    provider.setPin(with: "111111")
    let salt2 = storedData[KeychainPinStorageProvider.KeyIdentifier.devicePinSalt.rawValue]

    XCTAssertNotNil(salt1)
    XCTAssertNotNil(salt2)
    XCTAssertNotEqual(salt1, salt2)
  }

  func testIsPinValid_WhenEmptyPin_ThenFalse() {
    provider.setPin(with: "123456")
    XCTAssertFalse(provider.isPinValid(with: ""))
  }

  func testIsPinValid_WhenNoStoredPin_ThenFalse() {
    XCTAssertFalse(provider.isPinValid(with: "123456"))
  }

  func testIsPinValid_WhenCorrectPin_ThenTrue() {
    provider.setPin(with: "123456")
    XCTAssertTrue(provider.isPinValid(with: "123456"))
  }

  func testIsPinValid_WhenWrongPin_ThenFalse() {
    provider.setPin(with: "123456")

    XCTAssertFalse(provider.isPinValid(with: "111111"))
    XCTAssertFalse(provider.isPinValid(with: "654321"))
    XCTAssertFalse(provider.isPinValid(with: "1234567"))
    XCTAssertFalse(provider.isPinValid(with: "12345"))
  }

  func testIsPinValid_AfterPinChange_OldPinFailsNewPinSucceeds() {
    provider.setPin(with: "111111")
    XCTAssertTrue(provider.isPinValid(with: "111111"))

    provider.setPin(with: "222222")
    XCTAssertFalse(provider.isPinValid(with: "111111"))
    XCTAssertTrue(provider.isPinValid(with: "222222"))
  }

  func testIsPinValid_WhenIterationsMissing_ThenFalse() {
    provider.setPin(with: "123456")
    storedStrings.removeValue(forKey: KeychainPinStorageProvider.KeyIdentifier.devicePinIterations.rawValue)

    XCTAssertFalse(provider.isPinValid(with: "123456"))
  }

  func testIsPinValid_WhenIterationsIsZero_ThenFalse() {
    provider.setPin(with: "123456")
    storedStrings[KeychainPinStorageProvider.KeyIdentifier.devicePinIterations.rawValue] = "0"

    XCTAssertFalse(provider.isPinValid(with: "123456"))
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
    }
  }
}
