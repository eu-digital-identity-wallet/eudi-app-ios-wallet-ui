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

final class TestPresentationTransactionDataDomain: EudiTest {

  private let time = Date(timeIntervalSince1970: 1_700_000_000)

  private let approvalJson = """
    {
      "type": "https://cloudsignatureconsortium.org/2025/qes-approval",
      "credential_ids": ["pid", "mdl"],
      "credentialID": "signing-certificate",
      "signatureQualifier": "eu_eidas_qes",
      "numSignatures": 2,
      "hashAlgorithmOID": "2.16.840.1.101.3.4.2.1",
      "documentDigests": [
        {
          "label": "Contract",
          "hash": "aGFzaA",
          "hashType": "sdr",
          "href": "https://tsp.example/contract.pdf",
          "checksum": { "value": "Y2hlY2tzdW0", "algorithmOID": "2.16.840.1.101.3.4.2.3" },
          "access": { "type": "OTP", "oneTimePassword": "1234" },
          "signed_props": [{ "attribute_name": "reason", "attribute_value": "Agreement" }]
        }
      ]
    }
    """

  private let requestJson = """
    {
      "type": "https://cloudsignatureconsortium.org/2025/qes",
      "credential_ids": ["pid"],
      "signatureRequests": [
        {
          "signatureQualifier": "eu_eidas_aes",
          "signAlgo": "1.2.840.10045.4.3.2",
          "label": "Invoice",
          "href": "https://tsp.example/invoice.pdf",
          "checksum": { "value": "Y2hlY2tzdW0", "algorithmOID": "2.16.840.1.101.3.4.2.1" },
          "access": { "type": "OTP", "oneTimePassword": "5678" },
          "signature_format": "P",
          "conformance_level": "AdES-B-B",
          "signed_props": [{ "attribute_name": "commitment" }],
          "responseURI": "https://tsp.example/response"
        }
      ]
    }
    """

  private let customJson = """
    { "type": "https://example.com/custom", "credential_ids": ["pid"], "amount": "10" }
    """

  private var expectedApproval: PresentationTransactionDataDomain {
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
            href: "https://tsp.example/contract.pdf",
            checksum: .init(value: "Y2hlY2tzdW0", algorithmOid: "2.16.840.1.101.3.4.2.3"),
            oneTimePassword: "1234"
          )
        ]
      )
    )
  }

  private var expectedRequest: PresentationTransactionDataDomain {
    .qes(
      .init(
        credentialIds: ["pid"],
        signatureRequests: [
          .init(
            label: "Invoice",
            signatureQualifier: "eu_eidas_aes",
            responseUri: "https://tsp.example/response",
            signatureFormat: "P",
            conformanceLevel: "AdES-B-B",
            signedProperties: [.init(name: "commitment", value: nil)],
            href: "https://tsp.example/invoice.pdf",
            checksum: .init(value: "Y2hlY2tzdW0", algorithmOid: "2.16.840.1.101.3.4.2.1"),
            oneTimePassword: "5678"
          )
        ]
      )
    )
  }

  func testToPresentationTransactionDataDomain_whenQesApproval_thenMapsEveryField() throws {
    // When
    let domain = try transaction(approvalJson).payload.toPresentationTransactionDataDomain()

    // Then
    XCTAssertEqual(domain, expectedApproval)
  }

  func testToPresentationTransactionDataDomain_whenQesRequest_thenMapsTheReferencedDocument() throws {
    // When
    let domain = try transaction(requestJson).payload.toPresentationTransactionDataDomain()

    // Then
    XCTAssertEqual(domain, expectedRequest)
  }

  func testToPresentationTransactionDataDomain_whenAnotherType_thenIsUnavailable() throws {
    // When
    let domain = try transaction(customJson).payload.toPresentationTransactionDataDomain()

    // Then
    XCTAssertEqual(domain, .unavailable)
  }

  func testTransactionDataDomains_whenTheSetCarriesTransactions_thenKeepsThemPerDocumentInOrder() throws {
    // Given
    let set = DisclosedDocumentSet(
      docElements: [],
      warnings: nil,
      transactionData: ["pid-document": [try transaction(approvalJson), try transaction(requestJson)]],
      requestName: "option-1"
    )

    // When
    let domains = set.transactionDataDomains()

    // Then
    XCTAssertEqual(domains, ["pid-document": [expectedApproval, expectedRequest]])
  }

  func testTransactionDataDomains_whenTheSetHasNoTransactions_thenIsEmpty() {
    // Given
    let set = DisclosedDocumentSet(docElements: [], warnings: nil)

    // When
    let domains = set.transactionDataDomains()

    // Then
    XCTAssertTrue(domains.isEmpty)
  }

  func testToPresentationTransactionDataDomains_whenTheTypesAreSupported_thenReadsEachRecordedTransaction() throws {
    // Given
    let malformedApproval = """
      { "type": "https://cloudsignatureconsortium.org/2025/qes-approval", "credential_ids": ["pid"] }
      """
    let recorded = try recordedData([approvalJson, malformedApproval, requestJson])

    // When
    let domains = recorded.toPresentationTransactionDataDomains(supportedTypes: [.qesApprovalRequest, .qesRequest])

    // Then
    XCTAssertEqual(domains, [expectedApproval, .unavailable, expectedRequest])
  }

  func testToPresentationTransactionDataDomains_whenNoTypeIsSupported_thenEveryTransactionIsUnavailable() throws {
    // Given
    let recorded = try recordedData([approvalJson, requestJson])

    // When
    let domains = recorded.toPresentationTransactionDataDomains(supportedTypes: [])

    // Then
    XCTAssertEqual(domains, [.unavailable, .unavailable])
  }

  func testToTransactionLogDomain_whenThePresentationRecordsTransactionData_thenMapsIt() throws {
    // Given
    let entry = TransactionEntry.presentation(
      .init(
        transactionIdentifier: "tx-1",
        time: time,
        transactionResult: .completed,
        listOfClaimsRequested: [],
        listOfClaimsPresented: [],
        transactionalData: try recordedData([approvalJson])
      )
    )

    // When
    let domain = entry.toTransactionLogDomain(
      id: "row-1",
      parentPresentationId: nil,
      transactionDataTypes: [.qesApprovalRequest, .qesRequest]
    )

    // Then
    guard case .presentation(let presentation)? = domain else {
      return XCTFail("Expected a presentation")
    }
    XCTAssertEqual(presentation.transactionData, [expectedApproval])
  }

  func testToTransactionLogDomain_whenThePresentationRecordsNoTransactionData_thenHasNone() {
    // Given
    let entry = TransactionEntry.presentation(
      .init(
        transactionIdentifier: "tx-2",
        time: time,
        transactionResult: .completed,
        listOfClaimsRequested: [],
        listOfClaimsPresented: []
      )
    )

    // When
    let domain = entry.toTransactionLogDomain(
      id: "row-2",
      parentPresentationId: nil,
      transactionDataTypes: [.qesApprovalRequest, .qesRequest]
    )

    // Then
    guard case .presentation(let presentation)? = domain else {
      return XCTFail("Expected a presentation")
    }
    XCTAssertTrue(presentation.transactionData.isEmpty)
  }
}

private extension TestPresentationTransactionDataDomain {

  func transaction(_ json: String) throws -> PresentationTransactionData {
    try PresentationTransactionData(encodedValue: Data(json.utf8).base64URLEncodedString())
  }

  func recordedData(_ objects: [String]) throws -> TransactionalData {
    let array = "[" + objects.joined(separator: ",") + "]"
    return try JSONDecoder().decode(TransactionalData.self, from: Data(array.utf8))
  }
}
