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
    XCTAssertEqual(Self.check(.verified(details: details, overaskedClaims: [])), .verified)
    XCTAssertEqual(Self.check(.notVerified(details: nil)), .notVerified)
    XCTAssertEqual(Self.check(.notVerified(details: details), isNotBoundToRequester: true), .notBoundToRequester)
    XCTAssertEqual(Self.check(.notSupported), .notEvaluated)
  }

  func testInit_WhenTheRequesterDidNotAuthenticate_ThenAVerifiedRegistrationIsNotRecordedAsVerified() {
    XCTAssertEqual(
      Self.check(.verified(details: details, overaskedClaims: []), isRequesterAuthenticated: false),
      .notVerified
    )
  }

  func testProvider_WhenTheOutcomeIsRemoved_ThenOnlyItsOwnPresentationGetsIt() async {
    let provider = RegistrationCheckProviderImpl()
    await provider.record(.notBoundToRequester, for: "presentation-a")

    let other = await provider.removeCheck(for: "presentation-b")
    let own = await provider.removeCheck(for: "presentation-a")
    let again = await provider.removeCheck(for: "presentation-a")

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
