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

final class TestWalletKitControllerRegistrations: EudiTest {

  func testRegistrationDescriptors_WhenOffering_ThenRegistersTheUnblockedDocuments() {
    let descriptors = WalletKitControllerImpl.registrationDescriptors(
      candidates: [candidate("mdl"), candidate("pid")],
      blockedDocumentIds: ["pid"],
      isOffering: true
    )

    XCTAssertEqual(descriptors.map(\.documentIdentifier), ["mdl"])
  }

  func testRegistrationDescriptors_WhenTheOfferingIsOff_ThenRegistersNothing() {
    let descriptors = WalletKitControllerImpl.registrationDescriptors(
      candidates: [candidate("mdl")],
      blockedDocumentIds: [],
      isOffering: false
    )

    XCTAssertTrue(descriptors.isEmpty)
  }

  func testRegistrationDescriptors_WhenTheRecordsCannotBeRead_ThenRegistersNothing() {
    let descriptors = WalletKitControllerImpl.registrationDescriptors(
      candidates: [candidate("mdl")],
      blockedDocumentIds: nil,
      isOffering: true
    )

    XCTAssertTrue(descriptors.isEmpty)
  }
}

private extension TestWalletKitControllerRegistrations {

  func candidate(_ id: String) -> RegistrationDescriptor {
    RegistrationDescriptor(documentIdentifier: id, mobileDocumentType: "org.iso.18013.5.1.mDL", invalidationDate: nil)
  }

}
