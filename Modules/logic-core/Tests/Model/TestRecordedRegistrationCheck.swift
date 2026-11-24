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
@testable import logic_core
@testable import logic_test

final class TestRecordedRegistrationCheck: EudiTest {

  private let details = RegistrationDetails(
    tradeName: "RP", uniqueId: "rp", logoUrl: nil, intendedUse: nil, privacyPolicyUrl: nil, serviceDescription: nil
  )

  func testInit_WhenTheRegistrationWasChecked_ThenRecordsItsOutcome() {
    // When
    let verified = Self.check(.verified(details: details, overaskedClaims: []))
    let notVerified = Self.check(.notVerified(details: nil))
    let notBound = Self.check(.notVerified(details: details), isNotBoundToRequester: true)
    let notSupported = Self.check(.notSupported)

    // Then
    XCTAssertEqual(verified, .verified)
    XCTAssertEqual(notVerified, .notVerified)
    XCTAssertEqual(notBound, .notBoundToRequester)
    XCTAssertEqual(notSupported, .notEvaluated)
  }

  func testInit_WhenTheRequesterDidNotAuthenticate_ThenAVerifiedRegistrationIsNotRecordedAsVerified() {
    // When
    let recorded = Self.check(.verified(details: details, overaskedClaims: []), isRequesterAuthenticated: false)

    // Then
    XCTAssertEqual(recorded, .notVerified)
  }

  func testProvider_WhenTheOutcomeIsRemoved_ThenOnlyItsOwnPresentationGetsIt() async {
    // Given
    let provider = RegistrationCheckProviderImpl()
    await provider.record(.notBoundToRequester, for: "presentation-a")

    // When
    let other = await provider.removeCheck(for: "presentation-b")
    let own = await provider.removeCheck(for: "presentation-a")
    let again = await provider.removeCheck(for: "presentation-a")

    // Then
    XCTAssertNil(other)
    XCTAssertEqual(own, .notBoundToRequester)
    XCTAssertNil(again)
  }
}

private extension TestRecordedRegistrationCheck {

  static func check(
    _ status: RegistrationStatus,
    isNotBoundToRequester: Bool = false,
    isRequesterAuthenticated: Bool = true
  ) -> RecordedRegistrationCheck {
    RecordedRegistrationCheck(
      status: status,
      isNotBoundToRequester: isNotBoundToRequester,
      isRequesterAuthenticated: isRequesterAuthenticated
    )
  }
}
