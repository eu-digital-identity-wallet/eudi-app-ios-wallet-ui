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

final class TestDocumentProviderPolicy: EudiTest {

  func testCheckRequest_WhenTheOfferingIsOff_ThenDeclines() {
    // Then
    XCTAssertThrowsError(
      try DocumentProviderPolicy.checkRequest(isOffering: false, requestedDocumentIds: ["a"], blockedDocumentIds: [])
    ) { error in
      XCTAssertEqual(error.localizedDescription, WalletCoreError.documentOfferingDisabled.localizedDescription)
    }
  }

  func testCheckRequest_WhenARequestedDocumentIsBlocked_ThenDeclines() {
    // Then
    XCTAssertThrowsError(
      try DocumentProviderPolicy.checkRequest(isOffering: true, requestedDocumentIds: ["a", "b"], blockedDocumentIds: ["b"])
    ) { error in
      XCTAssertEqual(error.localizedDescription, WalletCoreError.documentBlocked.localizedDescription)
    }
  }

  func testCheckRequest_WhenOfferingAndNothingIsBlocked_ThenPasses() {
    // Then
    XCTAssertNoThrow(
      try DocumentProviderPolicy.checkRequest(isOffering: true, requestedDocumentIds: ["a"], blockedDocumentIds: ["b"])
    )
  }

  func testRequestsUserImage_WhenAPortraitIsRequested_ThenIsTrue() {
    // When
    let withPortrait = DocumentProviderPolicy.requestsUserImage(
      claimNames: ["family_name", "portrait"],
      userImageClaimKeys: ["portrait"]
    )
    let withoutPortrait = DocumentProviderPolicy.requestsUserImage(
      claimNames: ["family_name"],
      userImageClaimKeys: ["portrait"]
    )

    // Then
    XCTAssertTrue(withPortrait)
    XCTAssertFalse(withoutPortrait)
  }

  func testOptions_WhenTheWalletHoldsTwoDocumentsOfTheRequestedType_ThenOffersEachAlone() throws {
    // Given
    let documents = [Self.document(id: "mdl-1", docType: "mdl"), Self.document(id: "mdl-2", docType: "mdl")]

    // When
    let options = try DocumentProviderPolicy.options(for: documents, isOffering: true, blockedDocumentIds: [])

    // Then
    XCTAssertEqual(options.map { $0.map(\.id) }, [["mdl-1"], ["mdl-2"]])
  }

  func testOptions_WhenOnlyOneRequestedTypeHasTwoDocuments_ThenEachOptionKeepsTheOtherType() throws {
    // Given
    let documents = [
      Self.document(id: "pid", docType: "pid"),
      Self.document(id: "mdl-1", docType: "mdl"),
      Self.document(id: "mdl-2", docType: "mdl")
    ]

    // When
    let options = try DocumentProviderPolicy.options(for: documents, isOffering: true, blockedDocumentIds: [])

    // Then
    XCTAssertEqual(options.map { $0.map(\.id) }, [["pid", "mdl-1"], ["pid", "mdl-2"]])
  }

  func testOptions_WhenEachRequestedTypeHasOneDocument_ThenOffersOneOptionWithAll() throws {
    // Given
    let documents = [Self.document(id: "pid", docType: "pid"), Self.document(id: "mdl", docType: "mdl")]

    // When
    let options = try DocumentProviderPolicy.options(for: documents, isOffering: true, blockedDocumentIds: [])

    // Then
    XCTAssertEqual(options.map { $0.map(\.id) }, [["pid", "mdl"]])
  }

  func testOptions_WhenOneOfTwoDocumentsIsBlocked_ThenOffersOnlyTheOther() throws {
    // Given
    let documents = [Self.document(id: "mdl-1", docType: "mdl"), Self.document(id: "mdl-2", docType: "mdl")]

    // When
    let options = try DocumentProviderPolicy.options(for: documents, isOffering: true, blockedDocumentIds: ["mdl-1"])

    // Then
    XCTAssertEqual(options.map { $0.map(\.id) }, [["mdl-2"]])
  }

  func testOptions_WhenEveryOptionIncludesABlockedDocument_ThenDeclines() {
    // Given
    let documents = [Self.document(id: "pid", docType: "pid"), Self.document(id: "mdl", docType: "mdl")]

    // Then
    XCTAssertThrowsError(
      try DocumentProviderPolicy.options(for: documents, isOffering: true, blockedDocumentIds: ["pid"])
    ) { error in
      XCTAssertEqual(error.localizedDescription, WalletCoreError.documentBlocked.localizedDescription)
    }
  }

  func testOptions_WhenTheOfferingIsOff_ThenDeclines() {
    // Given
    let documents = [Self.document(id: "mdl", docType: "mdl")]

    // Then
    XCTAssertThrowsError(
      try DocumentProviderPolicy.options(for: documents, isOffering: false, blockedDocumentIds: [])
    ) { error in
      XCTAssertEqual(error.localizedDescription, WalletCoreError.documentOfferingDisabled.localizedDescription)
    }
  }

  func testOptions_WhenNoDocumentMatches_ThenOffersNothing() throws {
    // When
    let options = try DocumentProviderPolicy.options(for: [], isOffering: true, blockedDocumentIds: [])

    // Then
    XCTAssertTrue(options.isEmpty)
  }
}

private extension TestDocumentProviderPolicy {

  /// A stored document of `docType` with one claim, as the DC API library returns it for a request.
  static func document(id: String, docType: String) -> DocClaimsModel {
    DocClaimsModel(
      configuration: DocClaimsModelConfiguration(
        id: id,
        docType: docType,
        displayName: nil,
        display: nil,
        credentialIssuerIdentifier: nil,
        configurationIdentifier: nil,
        validFrom: nil,
        validUntil: nil,
        statusList: nil,
        credentialsUsageCounts: nil,
        credentialPolicy: .rotateUse,
        secureAreaName: nil,
        modifiedAt: nil,
        docClaims: [DocClaim(name: "family_name", dataValue: .string("value"), stringValue: "value", namespace: docType)],
        docDataFormat: .cbor,
        hashingAlg: nil
      )
    )
  }
}
