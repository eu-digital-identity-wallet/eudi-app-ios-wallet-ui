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
import MdocDataModel18013
@testable import logic_core
@testable import logic_test

final class TestRevocationRecordUpdate: EudiTest {

  func testAfter_WhenTheStatusIsValid_ThenClearsOnlyASuspendedOrUnrecognisedRecord() {
    // When
    let suspended = RevocationRecordUpdate.after(stored: .suspended, observed: .valid)
    let unrecognised = RevocationRecordUpdate.after(stored: .unrecognised, observed: .valid)
    let revoked = RevocationRecordUpdate.after(stored: .revoked, observed: .valid)
    let nothing = RevocationRecordUpdate.after(stored: nil, observed: .valid)

    // Then
    XCTAssertEqual(suspended, .clear)
    XCTAssertEqual(unrecognised, .clear)
    XCTAssertEqual(revoked, .keep)
    XCTAssertEqual(nothing, .keep)
  }

  func testAfter_WhenTheDocumentIsRevoked_ThenKeepsTheRecordWhateverIsReported() {
    // Given
    let observed: [CredentialStatus] = [.valid, .invalid, .suspended, .applicationSpecific(3), .reserved(3)]

    // Then
    for status in observed {
      XCTAssertEqual(RevocationRecordUpdate.after(stored: .revoked, observed: status), .keep, "\(status)")
    }
  }

  func testAfter_WhenTheStatusIsInvalid_ThenRecordsARevocation() {
    // Then
    for stored: DocumentRevocationStatus? in [nil, .suspended, .unrecognised] {
      XCTAssertEqual(
        RevocationRecordUpdate.after(stored: stored, observed: .invalid),
        .record(.revoked),
        "\(String(describing: stored))"
      )
    }
  }

  func testAfter_WhenTheStatusIsSuspended_ThenRecordsASuspensionUnlessOneIsStored() {
    // When
    let nothing = RevocationRecordUpdate.after(stored: nil, observed: .suspended)
    let unrecognised = RevocationRecordUpdate.after(stored: .unrecognised, observed: .suspended)
    let suspended = RevocationRecordUpdate.after(stored: .suspended, observed: .suspended)

    // Then
    XCTAssertEqual(nothing, .record(.suspended))
    XCTAssertEqual(unrecognised, .record(.suspended))
    XCTAssertEqual(suspended, .keep)
  }

  func testAfter_WhenTheStatusCannotBeInterpreted_ThenRecordsItAsUnrecognisedUnlessOneIsStored() {
    // Given
    let observed: [CredentialStatus] = [.applicationSpecific(3), .reserved(3)]

    // Then
    for status in observed {
      XCTAssertEqual(RevocationRecordUpdate.after(stored: nil, observed: status), .record(.unrecognised), "\(status)")
      XCTAssertEqual(
        RevocationRecordUpdate.after(stored: .suspended, observed: status),
        .record(.unrecognised),
        "\(status)"
      )
      XCTAssertEqual(RevocationRecordUpdate.after(stored: .unrecognised, observed: status), .keep, "\(status)")
    }
  }
}
