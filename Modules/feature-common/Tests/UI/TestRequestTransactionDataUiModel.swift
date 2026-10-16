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
import logic_core
import logic_ui
import logic_resources
@testable import feature_common
@testable import logic_test

final class TestRequestTransactionDataUiModel: EudiTest {

  private let sectionId = "transaction-data:0"

  func testToRequestTransactionDataUiModel_whenThereAreNoTransactions_thenIsNil() {
    // Given
    let transactions: [PresentationTransactionDataDomain] = []

    // When
    let model = transactions.toRequestTransactionDataUiModel(sectionId: sectionId)

    // Then
    XCTAssertNil(model)
  }

  func testToRequestTransactionDataUiModel_whenQesApproval_thenListsTheSignatureDetailsInOrder() throws {
    // Given
    let transactions = [approval()]

    // When
    let model = try XCTUnwrap(transactions.toRequestTransactionDataUiModel(sectionId: sectionId))

    // Then
    XCTAssertEqual(model.details.id, sectionId)
    XCTAssertEqual(model.details.title, LocalizableStringKey.requestTransactionDataSignatureDetails.toString)
    XCTAssertEqual(
      rows(model.details.listItems),
      [
        Row("\(sectionId)/framework", .requestTransactionDataTrustFramework, "eIDAS"),
        Row("\(sectionId)/transaction-0/type", .requestTransactionDataType, LocalizableStringKey.requestTransactionDataTypeQes.toString),
        Row("\(sectionId)/transaction-0/signature-type", .requestTransactionDataSignatureType, LocalizableStringKey.requestTransactionDataSignatureQes.toString),
        Row("\(sectionId)/transaction-0/query-0", .requestTransactionDataRequestedCredentials, "pid"),
        Row("\(sectionId)/transaction-0/query-1", .requestTransactionDataRequestedCredentials, "mdl"),
        Row("\(sectionId)/transaction-0/credential", .requestTransactionDataSigningCredentialId, "signing-certificate"),
        Row("\(sectionId)/transaction-0/count", .requestTransactionDataNumberOfSignatures, "2"),
        Row("\(sectionId)/transaction-0/document-0/name", .requestTransactionDataDocument, "Contract"),
        Row("\(sectionId)/transaction-0/document-0/location", .requestTransactionDataDocumentLocation, "https://tsp.example/contract.pdf"),
        Row("\(sectionId)/transaction-0/document-0/open", nil, LocalizableStringKey.requestTransactionDataOpenDocument.toString),
        Row("\(sectionId)/transaction-0/document-0/checksum", .requestTransactionDataExpectedChecksum, "Y2hlY2tzdW0"),
        Row("\(sectionId)/transaction-0/document-0/checksum-algorithm", .requestTransactionDataChecksumAlgorithm, "SHA-512"),
        Row("\(sectionId)/transaction-0/document-0/representation", .requestTransactionDataHashRepresentation, "SDR"),
        Row("\(sectionId)/transaction-0/document-0/hash", .requestTransactionDataTypedHash(["SDR"]), "aGFzaA"),
        Row("\(sectionId)/transaction-0/document-0/hash-algorithm", .requestTransactionDataTypedHashAlgorithm(["SDR"]), "SHA-256"),
        Row("\(sectionId)/transaction-0/document-0/attributes", nil, LocalizableStringKey.requestTransactionDataSignedAttributes.toString),
        Row("\(sectionId)/transaction-0/document-0/attribute-0", .custom("reason"), "Agreement"),
        Row("\(sectionId)/transaction-0/document-0/otp", .requestTransactionDataOneTimePassword, "1234")
      ]
    )
  }

  func testToRequestTransactionDataUiModel_whenQesRequest_thenListsEachSignatureRequest() throws {
    // Given
    let transactions = [request()]

    // When
    let model = try XCTUnwrap(transactions.toRequestTransactionDataUiModel(sectionId: sectionId))

    // Then
    XCTAssertEqual(
      rows(model.details.listItems),
      [
        Row("\(sectionId)/framework", .requestTransactionDataTrustFramework, "eIDAS"),
        Row("\(sectionId)/transaction-0/type", .requestTransactionDataType, LocalizableStringKey.requestTransactionDataTypeQesRequest.toString),
        Row("\(sectionId)/transaction-0/query-0", .requestTransactionDataRequestedCredentials, "pid"),
        Row("\(sectionId)/transaction-0/document-0/name", .requestTransactionDataDocument, LocalizableStringKey.requestTransactionDataDocumentNumbered(["1"]).toString),
        Row("\(sectionId)/transaction-0/document-0/signature-type", .requestTransactionDataSignatureType, "custom_qualifier"),
        Row("\(sectionId)/transaction-0/document-0/format", .requestTransactionDataSignatureFormat, "PAdES"),
        Row("\(sectionId)/transaction-0/document-0/conformance", .requestTransactionDataConformanceLevel, "AdES-B-B"),
        Row("\(sectionId)/transaction-0/document-0/attributes", nil, LocalizableStringKey.requestTransactionDataSignedAttributes.toString),
        Row("\(sectionId)/transaction-0/document-0/attribute-0", nil, "commitment"),
        Row("\(sectionId)/transaction-0/document-0/response-uri", .requestTransactionDataResponseUri, "https://tsp.example/response")
      ]
    )
    XCTAssertTrue(model.documentUrlsByItemId.isEmpty)
  }

  func testToRequestTransactionDataUiModel_whenThereAreSeveralTransactions_thenNumbersThemAndShowsTheTrustFrameworkOnce() throws {
    // Given
    let transactions: [PresentationTransactionDataDomain] = [approval(), .unavailable]

    // When
    let model = try XCTUnwrap(transactions.toRequestTransactionDataUiModel(sectionId: sectionId))
    let allRows = rows(model.details.listItems)

    // Then
    XCTAssertEqual(allRows.filter { $0.id.hasSuffix("/framework") }.count, 1)
    XCTAssertEqual(
      allRows.filter { $0.id.hasSuffix("/title") },
      [
        Row("\(sectionId)/transaction-0/title", nil, LocalizableStringKey.requestTransactionDataNumbered(["1"]).toString),
        Row("\(sectionId)/transaction-1/title", nil, LocalizableStringKey.requestTransactionDataNumbered(["2"]).toString)
      ]
    )
    XCTAssertEqual(
      allRows.last,
      Row("\(sectionId)/transaction-1/unavailable", nil, LocalizableStringKey.requestTransactionDataUnavailable.toString)
    )
  }

  func testToRequestTransactionDataUiModel_whenTheDocumentIsAWebLink_thenOffersToOpenIt() throws {
    // Given
    let transactions = [approval(href: "https://tsp.example/contract.pdf")]

    // When
    let model = try XCTUnwrap(transactions.toRequestTransactionDataUiModel(sectionId: sectionId))

    // Then
    XCTAssertEqual(
      model.documentUrlsByItemId,
      ["\(sectionId)/transaction-0/document-0/open": URL(string: "https://tsp.example/contract.pdf")!]
    )
  }

  func testToRequestTransactionDataUiModel_whenTheDocumentLocationIsNotAWebLink_thenOffersNoAction() throws {
    for href in ["ftp://tsp.example/contract.pdf", "https://user@tsp.example/contract.pdf", "https:///contract.pdf", "contract.pdf"] {
      // Given
      let transactions = [approval(href: href)]

      // When
      let model = try XCTUnwrap(transactions.toRequestTransactionDataUiModel(sectionId: sectionId))

      // Then
      XCTAssertTrue(model.documentUrlsByItemId.isEmpty, href)
      XCTAssertFalse(rows(model.details.listItems).contains { $0.id.hasSuffix("/open") }, href)
      XCTAssertTrue(rows(model.details.listItems).contains { $0.value == href }, href)
    }
  }

  func testToRecordedTransactionDataItems_whenRecorded_thenShowsNoTransactionTypeAndNoDocumentAction() {
    // Given
    let transactions = [approval()]

    // When
    let items: [ExpandableListItem<Sendable>] = transactions.toRecordedTransactionDataItems(sectionId: "transaction-data")
    let allRows = rows(items)

    // Then
    XCTAssertFalse(allRows.contains { $0.id.hasSuffix("/type") })
    XCTAssertFalse(allRows.contains { $0.id.hasSuffix("/open") })
    XCTAssertTrue(allRows.contains { $0.id == "transaction-data/transaction-0/document-0/location" })
  }

  func testToRecordedTransactionDataItems_whenThereAreNoTransactions_thenIsEmpty() {
    // Given
    let transactions: [PresentationTransactionDataDomain] = []

    // When
    let items: [ExpandableListItem<Sendable>] = transactions.toRecordedTransactionDataItems(sectionId: "transaction-data")

    // Then
    XCTAssertTrue(items.isEmpty)
  }
}

private struct Row: Equatable, CustomStringConvertible {
  let id: String
  let label: String?
  let value: String

  init(_ id: String, _ label: LocalizableStringKey?, _ value: String) {
    self.id = id
    self.label = label?.toString
    self.value = value
  }

  var description: String {
    "\(id) | \(label ?? "-") | \(value)"
  }
}

private extension TestRequestTransactionDataUiModel {

  func rows<T: Sendable>(_ items: [ExpandableListItem<T>]) -> [Row] {
    items.compactMap { item in
      guard case .single(let data) = item else { return nil }
      return Row(data.collapsed.id, data.collapsed.overlineText, data.collapsed.mainContent.asString)
    }
  }

  func approval(href: String = "https://tsp.example/contract.pdf") -> PresentationTransactionDataDomain {
    .qesApproval(
      .init(
        credentialIds: ["pid", "mdl"],
        credentialId: "signing-certificate",
        signatureQualifier: "eu_eidas_qes",
        numSignatures: 2,
        hashAlgorithmOid: "2.16.840.1.101.3.4.2.1",
        documentDigests: [
          .init(
            label: "Contract",
            hash: "aGFzaA",
            hashType: "sdr",
            signedProperties: [.init(name: "reason", value: "Agreement")],
            href: href,
            checksum: .init(value: "Y2hlY2tzdW0", algorithmOid: "2.16.840.1.101.3.4.2.3"),
            oneTimePassword: "1234"
          )
        ]
      )
    )
  }

  func request() -> PresentationTransactionDataDomain {
    .qes(
      .init(
        credentialIds: ["pid"],
        signatureRequests: [
          .init(
            label: nil,
            signatureQualifier: "custom_qualifier",
            responseUri: "https://tsp.example/response",
            signatureFormat: "P",
            conformanceLevel: "AdES-B-B",
            signedProperties: [.init(name: "commitment", value: nil)],
            href: nil,
            checksum: nil,
            oneTimePassword: nil
          )
        ]
      )
    )
  }
}
