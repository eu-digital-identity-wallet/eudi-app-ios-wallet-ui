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

  func testToOveraskedClaims_whenViolationListsClaims_thenEachPathBecomesAClaim() {
    let violations = [
      overaskingViolation(
        docType: pidDocType,
        paths: [[nameSpace, "family_name"], [nameSpace, "age_over_18"]]
      )
    ]

    let claims = violations.toOveraskedClaims()

    XCTAssertEqual(claims.count, 2)
    XCTAssertTrue(claims.contains(overaskedClaim(pidDocType, [nameSpace, "family_name"])))
    XCTAssertTrue(claims.contains(overaskedClaim(pidDocType, [nameSpace, "age_over_18"])))
  }

  func testToOveraskedClaims_whenViolationListsNoClaims_thenTheWholeAttestationIsOverasked() {
    let violations = [overaskingViolation(docType: pidDocType, paths: nil)]

    let claims = violations.toOveraskedClaims()

    XCTAssertEqual(claims, [OveraskedClaim(attestationType: pidDocType, path: nil)])
  }

  func testToOveraskedClaims_whenViolationIsNotAboutOverasking_thenItIsIgnored() {
    let violations = [
      PresentationPolicyViolation(reason: .expired, message: "expired"),
      PresentationPolicyViolation(reason: .trustError, message: "untrusted")
    ]

    XCTAssertTrue(violations.toOveraskedClaims().isEmpty)
  }

  func testToOveraskedClaims_whenTheSameClaimIsReportedTwice_thenItIsKeptOnce() {
    let violations = [
      overaskingViolation(docType: pidDocType, paths: [[nameSpace, "family_name"]]),
      overaskingViolation(docType: pidDocType, paths: [[nameSpace, "family_name"]])
    ]

    XCTAssertEqual(violations.toOveraskedClaims().count, 1)
  }

  func testOveraskedPaths_whenNothingIsOverasked_thenNoDocumentIsMarked() {
    let documents = [mdocElements(docId: "doc-1", claims: ["family_name", "given_name"])]

    XCTAssertTrue(documents.overaskedPaths(from: []).isEmpty)
  }

  func testOveraskedPaths_whenSomeClaimsAreOverasked_thenOnlyThoseAreMarked() {
    let documents = [mdocElements(docId: "doc-1", claims: ["family_name", "age_over_18"])]

    let overasked = documents.overaskedPaths(
      from: [overaskedClaim(pidDocType, [nameSpace, "age_over_18"])]
    )

    XCTAssertEqual(overasked, ["doc-1": [[nameSpace, "age_over_18"]]])
  }

  func testOveraskedPaths_whenTheAttestationItselfIsNotRegistered_thenEveryClaimIsMarked() {
    let documents = [mdocElements(docId: "doc-1", claims: ["family_name", "age_over_18"])]

    let overasked = documents.overaskedPaths(
      from: [OveraskedClaim(attestationType: pidDocType, path: nil)]
    )

    XCTAssertEqual(
      overasked,
      ["doc-1": [[nameSpace, "family_name"], [nameSpace, "age_over_18"]]]
    )
  }

  func testOveraskedPaths_whenTheClaimBelongsToAnotherAttestation_thenNothingIsMarked() {
    let documents = [mdocElements(docId: "doc-1", claims: ["family_name"])]

    let overasked = documents.overaskedPaths(
      from: [overaskedClaim("org.iso.18013.5.1.mDL", [nameSpace, "family_name"])]
    )

    XCTAssertTrue(overasked.isEmpty)
  }

  func testOveraskedPaths_whenTheSameClaimIsRenderedByTwoDocuments_thenBothAreMarked() {
    let documents = [
      mdocElements(docId: "doc-1", claims: ["family_name"]),
      mdocElements(docId: "doc-2", claims: ["family_name"])
    ]

    let overasked = documents.overaskedPaths(
      from: [overaskedClaim(pidDocType, [nameSpace, "family_name"])]
    )

    XCTAssertEqual(
      overasked,
      [
        "doc-1": [[nameSpace, "family_name"]],
        "doc-2": [[nameSpace, "family_name"]]
      ]
    )
  }

  func testOveraskedPaths_whenTheOveraskedPathIsAnAncestor_thenItsLeavesAreMarked() {
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

    let overasked = documents.overaskedPaths(from: [overaskedClaim(vct, ["address"])])

    XCTAssertEqual(overasked, ["doc-1": [["address", "street"]]])
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
