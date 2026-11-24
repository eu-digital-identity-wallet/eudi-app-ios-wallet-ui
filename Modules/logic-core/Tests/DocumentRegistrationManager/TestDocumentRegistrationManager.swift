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
import IdentityDocumentServices
@testable import logic_core
@testable import logic_test

final class TestDocumentRegistrationManager: EudiTest {

  func testMayRegister_WhenIosHasNotDeterminedTheAuthorisation_ThenRegistersSoThatItIsAuthorised() throws {
    guard #available(iOS 26.0, *) else { throw XCTSkip("IdentityDocumentServices needs iOS 26") }

    // When
    let notDetermined = DocumentRegistrationManagerImpl.mayRegister(with: .notDetermined)
    let authorized = DocumentRegistrationManagerImpl.mayRegister(with: .authorized)

    // Then
    XCTAssertTrue(notDetermined)
    XCTAssertTrue(authorized)
  }

  func testMayRegister_WhenTheUserTurnedTheProviderOffOrTheDeviceCannotProvide_ThenDoesNotRegister() throws {
    guard #available(iOS 26.0, *) else { throw XCTSkip("IdentityDocumentServices needs iOS 26") }

    // When
    let notAuthorized = DocumentRegistrationManagerImpl.mayRegister(with: .notAuthorized)
    let notSupported = DocumentRegistrationManagerImpl.mayRegister(with: .notSupported)

    // Then
    XCTAssertFalse(notAuthorized)
    XCTAssertFalse(notSupported)
  }
}
