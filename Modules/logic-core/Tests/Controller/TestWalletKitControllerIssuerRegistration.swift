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
import EudiWalletKit
@testable import logic_core
@testable import logic_test

final class TestWalletKitControllerIssuerRegistration: EudiTest {

  func testMakeIssuerRegistration_WhenTheCheckIsOnAndNoRegistrationWasEstablished_ThenRefuses() {
    let registration = WalletKitControllerImpl.makeIssuerRegistration(
      policy: nil,
      warnings: ["issuer": [violation(.trustError)]],
      isRegistrationChecked: true
    )

    XCTAssertEqual(registration, .blocked(reason: .notRegisteredAsProvider))
  }

  func testMakeIssuerRegistration_WhenTheCheckIsOff_ThenEvaluatesNothing() {
    let registration = WalletKitControllerImpl.makeIssuerRegistration(
      policy: nil,
      warnings: nil,
      isRegistrationChecked: false
    )

    XCTAssertNil(registration)
  }

  func testMakeIssuerRegistration_WhenTheCheckIsOffAndARegistrationWasEvaluated_ThenEvaluatesNothing() throws {
    let registration = WalletKitControllerImpl.makeIssuerRegistration(
      policy: try policy(),
      warnings: ["issuer": [violation(.expired)]],
      isRegistrationChecked: false
    )

    XCTAssertNil(registration)
  }

  func testMakeIssuerRegistration_WhenTheRegistrationRaisesAWarning_ThenRefuses() throws {
    let registration = WalletKitControllerImpl.makeIssuerRegistration(
      policy: try policy(),
      warnings: ["issuer": [violation(.expired)]],
      isRegistrationChecked: true
    )

    XCTAssertEqual(registration, .blocked(reason: .notRegisteredAsProvider))
  }

  func testMakeIssuerRegistration_WhenTheOfferIsNotCovered_ThenRefusesTheAttestation() throws {
    let registration = WalletKitControllerImpl.makeIssuerRegistration(
      policy: try policy(),
      warnings: ["issuer": [violation(.credentialNotCovered(credentialId: "pid"))]],
      isRegistrationChecked: true
    )

    XCTAssertEqual(registration, .blocked(reason: .attestationNotRegistered))
  }

  func testMakeIssuerRegistration_WhenTheRegistrationIsValid_ThenIsVerified() throws {
    let registration = WalletKitControllerImpl.makeIssuerRegistration(
      policy: try policy(),
      warnings: nil,
      isRegistrationChecked: true
    )

    guard case .verified(let details) = registration else {
      return XCTFail("Expected a verified registration, got \(String(describing: registration))")
    }
    XCTAssertEqual(details.uniqueId, "issuer-1")
  }
}

private extension TestWalletKitControllerIssuerRegistration {

  func policy() throws -> WrpRegistrationPolicy {
    try JSONDecoder().decode(
      WrpRegistrationPolicy.self,
      from: Data(#"{"sub":"issuer-1","name":"Issuer","srv_description":[{"lang":"en","value":"Issuer"}]}"#.utf8)
    )
  }

  func violation(_ reason: RegistrationFailureReason) -> RegistrationPolicyViolation {
    RegistrationPolicyViolation(reason: reason, message: "")
  }
}
