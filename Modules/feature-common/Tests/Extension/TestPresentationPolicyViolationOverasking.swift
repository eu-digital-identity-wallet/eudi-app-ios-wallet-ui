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
import MdocDataModel18013
import struct OpenID4VP.ClaimPath
@testable import logic_core
@testable import logic_test

final class TestPresentationPolicyViolationOverasking: EudiTest {

  private let pidDocType = "eu.europa.ec.eudi.pid.1"
  private let nameSpace = "eu.europa.ec.eudi.pid.1"
  private let vct = "urn:eu.europa.ec.eudi:pid:1"

  func testToOveraskedClaims_WhenViolationListsClaims_ThenEachPathBecomesAClaim() {
    // Given
    let violations = [
      overaskingViolation(
        docType: pidDocType,
        paths: [[nameSpace, "family_name"], [nameSpace, "age_over_18"]]
      )
    ]

    // When
    let claims = violations.toOveraskedClaims()

    // Then
    XCTAssertEqual(claims.count, 2)
    XCTAssertTrue(claims.contains(overaskedClaim(pidDocType, [nameSpace, "family_name"])))
    XCTAssertTrue(claims.contains(overaskedClaim(pidDocType, [nameSpace, "age_over_18"])))
  }

  func testToOveraskedClaims_WhenViolationListsNoClaims_ThenTheWholeAttestationIsOverasked() {
    // Given
    let violations = [overaskingViolation(docType: pidDocType, paths: nil)]

    // When
    let claims = violations.toOveraskedClaims()

    // Then
    XCTAssertEqual(claims, [OveraskedClaim(attestationType: pidDocType, path: nil)])
  }

  func testToOveraskedClaims_WhenViolationIsNotAboutOverasking_ThenItIsIgnored() {
    // Given
    let violations = [
      PresentationPolicyViolation(reason: .expired, message: "expired"),
      PresentationPolicyViolation(reason: .trustError, message: "untrusted")
    ]

    // When
    let result = violations.toOveraskedClaims().isEmpty

    // Then
    XCTAssertTrue(result)
  }

  func testToOveraskedClaims_WhenTheSameClaimIsReportedTwice_ThenItIsKeptOnce() {
    // Given
    let violations = [
      overaskingViolation(docType: pidDocType, paths: [[nameSpace, "family_name"]]),
      overaskingViolation(docType: pidDocType, paths: [[nameSpace, "family_name"]])
    ]

    // When
    let result = violations.toOveraskedClaims().count

    // Then
    XCTAssertEqual(result, 1)
  }

  func testOveraskedPaths_WhenNothingIsOverasked_ThenNoDocumentIsMarked() {
    // Given
    let documents = [mdocElements(docId: "doc-1", claims: ["family_name", "given_name"])]

    // When
    let result = documents.overaskedPaths(from: []).isEmpty

    // Then
    XCTAssertTrue(result)
  }

  func testOveraskedPaths_WhenSomeClaimsAreOverasked_ThenOnlyThoseAreMarked() {
    // Given
    let documents = [mdocElements(docId: "doc-1", claims: ["family_name", "age_over_18"])]

    // When
    let overasked = documents.overaskedPaths(
      from: [overaskedClaim(pidDocType, [nameSpace, "age_over_18"])]
    )

    // Then
    XCTAssertEqual(overasked, ["doc-1": [[nameSpace, "age_over_18"]]])
  }

  func testOveraskedPaths_WhenTheAttestationItselfIsNotRegistered_ThenEveryClaimIsMarked() {
    // Given
    let documents = [mdocElements(docId: "doc-1", claims: ["family_name", "age_over_18"])]

    // When
    let overasked = documents.overaskedPaths(
      from: [OveraskedClaim(attestationType: pidDocType, path: nil)]
    )

    // Then
    XCTAssertEqual(
      overasked,
      ["doc-1": [[nameSpace, "family_name"], [nameSpace, "age_over_18"]]]
    )
  }

  func testOveraskedPaths_WhenTheClaimBelongsToAnotherAttestation_ThenNothingIsMarked() {
    // Given
    let documents = [mdocElements(docId: "doc-1", claims: ["family_name"])]

    // When
    let overasked = documents.overaskedPaths(
      from: [overaskedClaim("org.iso.18013.5.1.mDL", [nameSpace, "family_name"])]
    )

    // Then
    XCTAssertTrue(overasked.isEmpty)
  }

  func testOveraskedPaths_WhenTheSameClaimIsRenderedByTwoDocuments_ThenBothAreMarked() {
    // Given
    let documents = [
      mdocElements(docId: "doc-1", claims: ["family_name"]),
      mdocElements(docId: "doc-2", claims: ["family_name"])
    ]

    // When
    let overasked = documents.overaskedPaths(
      from: [overaskedClaim(pidDocType, [nameSpace, "family_name"])]
    )

    // Then
    XCTAssertEqual(
      overasked,
      [
        "doc-1": [[nameSpace, "family_name"]],
        "doc-2": [[nameSpace, "family_name"]]
      ]
    )
  }

  func testOveraskedPaths_WhenTheOveraskedPathIsAnAncestor_ThenItsLeavesAreMarked() {
    // Given
    let documents = [
      sdJwtElements(
        docId: "doc-1",
        claim: DocClaim(
          name: "address",
          path: ["address"],
          dataValue: .string(""),
          stringValue: "",
          children: [
            DocClaim(
              name: "street",
              path: ["address", "street"],
              dataValue: .string("street"),
              stringValue: "street"
            )
          ]
        )
      )
    ]

    // When
    let overasked = documents.overaskedPaths(from: [overaskedClaim(vct, ["address"])])

    // Then
    XCTAssertEqual(overasked, ["doc-1": [["address", "street"]]])
  }

  func testOveraskedPaths_WhenTheOveraskedPathIsAMemberOfAnObjectShownWhole_ThenItsRowIsMarked() {
    // Given
    let documents = [sdJwtElements(docId: "doc-1", claim: leafClaim(["place_of_birth"]))]

    // When
    let overasked = documents.overaskedPaths(from: [overaskedClaim(vct, ["place_of_birth", "country"])])

    // Then
    XCTAssertEqual(overasked, ["doc-1": [["place_of_birth"]]])
  }

  func testOveraskedPaths_WhenTheOveraskedPathSelectsEveryArrayElement_ThenTheArrayRowIsMarked() {
    // Given
    let documents = [sdJwtElements(docId: "doc-1", claim: leafClaim(["nationalities"]))]

    // When
    let overasked = documents.overaskedPaths(
      from: [
        OveraskedClaim(
          attestationType: vct,
          path: ClaimPath([.claim(name: "nationalities"), .allArrayElements])
        )
      ]
    )

    // Then
    XCTAssertEqual(overasked, ["doc-1": [["nationalities"]]])
  }

  func testOveraskedPaths_WhenTheRowShowsEveryArrayElement_ThenTheOverAskedArrayMarksIt() {
    // Given
    let documents = [sdJwtElements(docId: "doc-1", claim: leafClaim(["nationalities", ""]))]

    // When
    let overasked = documents.overaskedPaths(
      from: [
        OveraskedClaim(
          attestationType: vct,
          path: ClaimPath([.claim(name: "nationalities"), .allArrayElements])
        )
      ]
    )

    // Then
    XCTAssertEqual(overasked, ["doc-1": [["nationalities", ""]]])
  }

  func testOveraskedPaths_WhenTheRowShowsOneArrayElement_ThenOnlyThatOverAskedElementMarksIt() {
    // Given
    let documents = [
      sdJwtElements(docId: "doc-1", claim: leafClaim(["nationalities", "0"])),
      sdJwtElements(docId: "doc-2", claim: leafClaim(["nationalities", "1"]))
    ]

    // When
    let overasked = documents.overaskedPaths(
      from: [
        OveraskedClaim(
          attestationType: vct,
          path: ClaimPath([.claim(name: "nationalities"), .arrayElement(index: 0)])
        )
      ]
    )

    // Then
    XCTAssertEqual(overasked, ["doc-1": [["nationalities", "0"]]])
  }

  func testOveraskedPaths_WhenTheOveraskedPathIsASibling_ThenTheRowIsNotMarked() {
    // Given
    let documents = [
      sdJwtElements(
        docId: "doc-1",
        claim: DocClaim(
          name: "address",
          path: ["address"],
          dataValue: .string(""),
          stringValue: "",
          children: [leafClaim(["address", "street"])]
        )
      )
    ]

    // When
    let overasked = documents.overaskedPaths(from: [overaskedClaim(vct, ["address", "locality"])])

    // Then
    XCTAssertTrue(overasked.isEmpty)
  }
}

private extension TestPresentationPolicyViolationOverasking {

  func overaskingViolation(docType: String, paths: [[String]]?) -> PresentationPolicyViolation {
    PresentationPolicyViolation(
      reason: .overAskedClaims(
        docType: docType,
        claims: paths?.map { claimPath($0) }
      ),
      message: "overasked"
    )
  }

  func overaskedClaim(_ attestationType: String, _ path: [String]) -> OveraskedClaim {
    OveraskedClaim(attestationType: attestationType, path: claimPath(path))
  }

  func claimPath(_ path: [String]) -> ClaimPath {
    ClaimPath(path.map { .claim(name: $0) })
  }

  func leafClaim(_ path: [String]) -> DocClaim {
    DocClaim(
      name: path.last ?? "",
      path: path,
      dataValue: .string(path.joined(separator: ".")),
      stringValue: path.joined(separator: ".")
    )
  }

  func mdocElements(docId: String, claims: [String]) -> DocElements {
    .msoMdoc(
      .init(
        docId: docId,
        docType: pidDocType,
        displayName: pidDocType,
        nameSpacedElements: [
          .init(
            nameSpace: nameSpace,
            elements: claims.map { claim in
              .init(
                elementIdentifier: claim,
                isOptional: false,
                stringValue: claim,
                docClaim: DocClaim(
                  name: claim,
                  path: [nameSpace, claim],
                  dataValue: .string(claim),
                  stringValue: claim
                ),
                isValid: true
              )
            }
          )
        ]
      )
    )
  }

  func sdJwtElements(docId: String, claim: DocClaim) -> DocElements {
    .sdJwt(
      .init(
        docId: docId,
        vct: vct,
        displayName: vct,
        sdJwtElements: [
          .init(
            elementPath: claim.path,
            isOptional: false,
            stringValue: claim.stringValue,
            docClaim: claim,
            isValid: true
          )
        ]
      )
    )
  }
}
