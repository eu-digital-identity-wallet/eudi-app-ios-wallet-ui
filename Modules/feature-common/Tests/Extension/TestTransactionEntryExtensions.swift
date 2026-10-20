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
@testable import logic_business
@testable import logic_core
@testable import logic_storage
@testable import logic_test

final class TestTransactionEntryExtensions: EudiTest {
  private let time = Date(timeIntervalSince1970: 1_700_000_000)

  private var deviceLanguage: String {
    Locale.current.systemLanguageCode ?? "en"
  }

  func testToTransactionLogDomain_whenPresentationIsCompleted_thenMapsPartyRegistrationAndClaims() throws {
    let entry = TransactionEntry.presentation(
      .init(
        transactionIdentifier: "tx-1",
        time: time,
        transactionResult: .completed,
        listOfClaimsRequested: [
          .init(credentialIdentifier: "eu.europa.ec.eudi.pid.1", claims: [
            .init([.claim(name: "eu.europa.ec.eudi.pid.1"), .claim(name: "family_name")]),
            .init([.claim(name: "eu.europa.ec.eudi.pid.1"), .claim(name: "age_over_18")])
          ])
        ],
        listOfClaimsPresented: [
          .init(credentialIdentifier: "urn:eudi:pid:1", claims: [
            .init([.claim(name: "addresses"), .allArrayElements, .claim(name: "street")]),
            .init([.claim(name: "nationalities"), .arrayElement(index: 0)])
          ])
        ],
        interactingPartyName: .init(lang: "en", content: "Verifier"),
        interactingPartyIdentifier: .init(type: QualifiedIdentifier.lei, value: "123"),
        interactingPartyContact: ["GR", "https://verifier.example/support"],
        isIntermediary: true,
        intermediaryIdentifier: .init(type: QualifiedIdentifier.vatin, value: "456"),
        intermediaryName: .init(lang: "en", content: "Broker"),
        intermediaryContact: ["https://broker.example"],
        registrarURL: "https://registry.example",
        purpose: [
          .init(lang: "zz", content: "Wrong language"),
          .init(lang: deviceLanguage, content: "Age check")
        ],
        privacyPolicy: [.init(type: Policy.privacyPolicy, policyURI: "https://verifier.example/privacy")],
        dpaName: .init(lang: "en", content: "DPA"),
        dpaCountry: .init(lang: "en", content: "GR"),
        dpaContact: ["dpa@example.org"]
      )
    )

    let domain = entry.toTransactionLogDomain(id: "row-1", parentPresentationId: nil)

    guard case .presentation(let presentation)? = domain else {
      return XCTFail("Expected a presentation, got \(String(describing: domain))")
    }
    XCTAssertEqual(presentation.id, "row-1")
    XCTAssertEqual(presentation.time, time)
    XCTAssertEqual(presentation.result, .completed)
    XCTAssertEqual(
      presentation.party,
      .init(
        name: "Verifier",
        identifier: .init(schemeUri: QualifiedIdentifier.lei, value: "123"),
        contacts: ["GR", "https://verifier.example/support"],
        type: TransactionEntry.Presentation.interactingPartyTypeDefault
      )
    )
    XCTAssertEqual(
      presentation.intermediary,
      .init(
        name: "Broker",
        identifier: .init(schemeUri: QualifiedIdentifier.vatin, value: "456"),
        contacts: ["https://broker.example"]
      )
    )
    XCTAssertEqual(
      presentation.registration,
      .init(
        registrarUrl: "https://registry.example",
        purpose: "Age check",
        privacyPolicyUrls: ["https://verifier.example/privacy"],
        dpa: .init(name: "DPA", country: "GR", contacts: ["dpa@example.org"])
      )
    )
    XCTAssertEqual(
      presentation.claimsRequested,
      [
        .init(
          credential: .init(identifier: .mDocPid),
          claims: [
            .init(segments: [.key(name: "eu.europa.ec.eudi.pid.1"), .key(name: "family_name")]),
            .init(segments: [.key(name: "eu.europa.ec.eudi.pid.1"), .key(name: "age_over_18")])
          ]
        )
      ]
    )
    XCTAssertEqual(
      presentation.claimsPresented,
      [
        .init(
          credential: .init(identifier: .sdJwtPid),
          claims: [
            .init(segments: [.key(name: "addresses"), .allElements, .key(name: "street")]),
            .init(segments: [.key(name: "nationalities"), .index(0)])
          ]
        )
      ]
    )
  }

  func testToTransactionLogDomain_whenPresentationHasNoRegistration_thenRegistrationAndIntermediaryAreNil() throws {
    let entry = TransactionEntry.presentation(
      .init(
        transactionIdentifier: "tx-2",
        time: time,
        transactionResult: .notCompleted,
        reasonOfNoncompletion: "User cancelled authentication",
        listOfClaimsRequested: [],
        listOfClaimsPresented: [],
        interactingPartyName: .init(lang: "en", content: "Certificate CN")
      )
    )

    let domain = entry.toTransactionLogDomain(id: "row-2", parentPresentationId: nil)

    guard case .presentation(let presentation)? = domain else {
      return XCTFail("Expected a presentation")
    }
    XCTAssertEqual(presentation.result, .notCompleted(reason: "User cancelled authentication"))
    XCTAssertEqual(
      presentation.party,
      .init(
        name: "Certificate CN", identifier: nil, contacts: [],
        type: TransactionEntry.Presentation.interactingPartyTypeDefault
      )
    )
    XCTAssertNil(presentation.intermediary)
    XCTAssertNil(presentation.registration)
    XCTAssertTrue(presentation.claimsRequested.isEmpty)
    XCTAssertTrue(presentation.claimsPresented.isEmpty)
  }

  func testToTransactionLogDomain_whenPurposeHasNoDeviceLanguage_thenFallsBackToTheFirst() throws {
    let entry = TransactionEntry.presentation(
      .init(
        transactionIdentifier: "tx-3",
        time: time,
        transactionResult: .completed,
        listOfClaimsRequested: [],
        listOfClaimsPresented: [],
        purpose: [.init(lang: "zz", content: "First written"), .init(lang: "yy", content: "Second written")]
      )
    )

    guard case .presentation(let presentation)? = entry.toTransactionLogDomain(id: "row-3", parentPresentationId: nil) else {
      return XCTFail("Expected a presentation")
    }
    XCTAssertEqual(presentation.registration?.purpose, "First written")
  }

  func testToTransactionLogDomain_whenCredentialIssuance_thenMapsDetails() throws {
    let entry = TransactionEntry.credentialIssuance(
      .init(
        transactionIdentifier: "issuance:doc-1",
        time: time,
        transactionResult: .notCompleted,
        reasonOfNoncompletion: "Not all requested credentials were issued",
        details: .init(
          credentialNumberRequested: 5,
          credentialNumberIssued: 3,
          credentialIdentifier: ["eu.europa.ec.eudi.pid.1"],
          isUserTriggered: true,
          interactingPartyName: .init(lang: "en", content: "PID Provider"),
          interactingPartyIdentifier: .init(type: QualifiedIdentifier.euid, value: "789"),
          interactingPartyType: "PIDProvider",
          interactingPartyContact: ["https://issuer.example"]
        )
      )
    )

    guard case .credentialIssuance(let issuance)? = entry.toTransactionLogDomain(id: "row-4", parentPresentationId: nil) else {
      return XCTFail("Expected a credential issuance")
    }
    XCTAssertEqual(issuance.id, "row-4")
    XCTAssertEqual(issuance.result, .notCompleted(reason: "Not all requested credentials were issued"))
    XCTAssertEqual(
      issuance.details,
      .init(
        issuer: .init(
          name: "PID Provider",
          identifier: .init(schemeUri: QualifiedIdentifier.euid, value: "789"),
          contacts: ["https://issuer.example"],
          type: "PIDProvider"
        ),
        requestedCount: 5,
        issuedCount: 3,
        credentials: [.init(identifier: .mDocPid)],
        isUserTriggered: true
      )
    )
  }

  func testToTransactionLogDomain_whenCredentialReissuance_thenMapsToReissuance() throws {
    let entry = TransactionEntry.credentialReissuance(
      .init(
        transactionIdentifier: "issuance:doc-2",
        time: time,
        transactionResult: .completed,
        details: .init(
          credentialNumberRequested: 1,
          credentialNumberIssued: 1,
          credentialIdentifier: ["org.iso.18013.5.1.mDL"],
          isUserTriggered: false
        )
      )
    )

    guard case .credentialReissuance(let reissuance)? = entry.toTransactionLogDomain(id: "row-5", parentPresentationId: nil) else {
      return XCTFail("Expected a credential reissuance")
    }
    XCTAssertEqual(reissuance.result, .completed)
    XCTAssertEqual(reissuance.details.isUserTriggered, false)
    XCTAssertEqual(reissuance.details.credentials, [.init(identifier: .other(formatType: "org.iso.18013.5.1.mDL"))])
    XCTAssertEqual(reissuance.details.issuer, .init(name: nil, identifier: nil, contacts: []))
    XCTAssertNil(reissuance.details.issuer.type)
  }

  func testToTransactionLogDomain_whenCredentialDeletion_thenMapsCredentialAndIssuer() throws {
    let entry = TransactionEntry.credentialDeletion(
      .init(
        transactionIdentifier: "tx-6",
        time: time,
        transactionResult: .completed,
        credentialIdentifier: "urn:eudi:pid:1",
        credentialIssuerIdentifier: .init(type: QualifiedIdentifier.lei, value: "111"),
        credentialIssuerName: .init(lang: "en", content: "Issuer")
      )
    )

    guard case .credentialDeletion(let deletion)? = entry.toTransactionLogDomain(id: "row-6", parentPresentationId: nil) else {
      return XCTFail("Expected a credential deletion")
    }
    XCTAssertEqual(deletion.credential, .init(identifier: .sdJwtPid))
    XCTAssertEqual(
      deletion.issuer,
      .init(name: "Issuer", identifier: .init(schemeUri: QualifiedIdentifier.lei, value: "111"), contacts: [])
    )
  }

  func testToTransactionLogDomain_whenSigningSealing_thenMapsServiceAndDocument() throws {
    let entry = TransactionEntry.signingSealing(
      .init(
        transactionIdentifier: "sign-1:0",
        time: time,
        transactionResult: .completed,
        signingTransactionIdentifier: "sign-1",
        certificateIdentifier: "serial-42",
        dtbsr: "ZGlnZXN0",
        fileIdentifier: "file-1",
        fileName: "contract.pdf",
        fileSize: "2048",
        interactingPartyName: .init(lang: "en", content: "Wallet-Centric")
      )
    )

    guard case .signingSealing(let signing)? = entry.toTransactionLogDomain(id: "row-7", parentPresentationId: nil) else {
      return XCTFail("Expected a signing transaction")
    }
    XCTAssertEqual(
      signing.service,
      .init(
        name: "Wallet-Centric", identifier: nil, contacts: [],
        type: TransactionEntry.SigningSealing.interactingPartyTypeDefault
      )
    )
    XCTAssertEqual(signing.signingTransactionIdentifier, "sign-1")
    XCTAssertEqual(signing.certificateSerialNumber, "serial-42")
    XCTAssertEqual(signing.fileName, "contract.pdf")
    XCTAssertEqual(signing.fileSizeBytes, 2048)
    XCTAssertEqual(signing.dtbsr, "ZGlnZXN0")
  }

  func testToTransactionLogDomain_whenSigningFileSizeIsNotNumeric_thenFileSizeIsNil() throws {
    let entry = TransactionEntry.signingSealing(
      .init(
        transactionIdentifier: "sign-2:0",
        time: time,
        transactionResult: .notCompleted,
        reasonOfNoncompletion: "Signing failed",
        fileSize: "large"
      )
    )

    guard case .signingSealing(let signing)? = entry.toTransactionLogDomain(id: "row-8", parentPresentationId: nil) else {
      return XCTFail("Expected a signing transaction")
    }
    XCTAssertNil(signing.fileSizeBytes)
    XCTAssertEqual(signing.result, .notCompleted(reason: "Signing failed"))
  }

  func testToTransactionLogDomain_whenDataDeletionRequestHasParent_thenMapsWithParent() throws {
    let entry = TransactionEntry.dataDeletionRequest(
      .init(
        transactionIdentifier: "ddr-1",
        time: time,
        transactionResult: .completed,
        listOfClaims: [.init(credentialIdentifier: "eu.europa.ec.eudi.pid.1", claims: [.claim("family_name")])],
        interactingPartyIdentifier: .init(type: QualifiedIdentifier.lei, value: "123"),
        interactingPartyName: .init(lang: "en", content: "Verifier")
      )
    )

    guard case .dataDeletionRequest(let request)? = entry.toTransactionLogDomain(id: "ddr-1", parentPresentationId: "tx-1") else {
      return XCTFail("Expected a data deletion request")
    }
    XCTAssertEqual(request.parentPresentationId, "tx-1")
    XCTAssertEqual(request.party.name, "Verifier")
    XCTAssertEqual(request.claims.first?.claims, [.init(segments: [.key(name: "family_name")])])
    XCTAssertEqual(entry.toTransactionLogDomain(id: "ddr-1", parentPresentationId: "tx-1")?.parentPresentationId, "tx-1")
  }

  func testToTransactionLogDomain_whenActionParentIsMissingBlankOrSelf_thenReturnsNil() throws {
    let entry = TransactionEntry.dpaReport(
      .init(transactionIdentifier: "dpar-1", time: time, transactionResult: .completed, dpaName: .init(content: "DPA"))
    )

    XCTAssertNil(entry.toTransactionLogDomain(id: "dpar-1", parentPresentationId: nil))
    XCTAssertNil(entry.toTransactionLogDomain(id: "dpar-1", parentPresentationId: ""))
    XCTAssertNil(entry.toTransactionLogDomain(id: "dpar-1", parentPresentationId: "dpar-1"))
    XCTAssertNotNil(entry.toTransactionLogDomain(id: "dpar-1", parentPresentationId: "tx-1"))
  }

  func testToTransactionLogDomain_whenKindIsUnsupported_thenReturnsNil() throws {
    let entry = TransactionEntry.pseudonymGeneration(
      .init(transactionIdentifier: "pseudo-1", time: time, transactionResult: .completed, pseudonym: .init(value: "abc"))
    )

    XCTAssertNil(entry.toTransactionLogDomain(id: "pseudo-1", parentPresentationId: nil))
  }

  func testStorageRoundTrip_whenEntryIsStoredAndReadBack_thenDomainIsPreserved() throws {
    let entry = TransactionEntry.presentation(
      .init(
        transactionIdentifier: "tx-9",
        time: time,
        transactionResult: .completed,
        listOfClaimsRequested: [.init(credentialIdentifier: "eu.europa.ec.eudi.pid.1", claims: [.claim("family_name")])],
        listOfClaimsPresented: [.init(credentialIdentifier: "eu.europa.ec.eudi.pid.1", claims: [.claim("family_name")])],
        interactingPartyName: .init(lang: "en", content: "Verifier")
      )
    )

    let stored = try entry.toTransactionLogStorage(parentPresentationId: nil)

    XCTAssertEqual(stored.identifier, "tx-9")
    XCTAssertNil(stored.parentPresentationId)
    XCTAssertFalse(stored.value.contains("rawResponse"))
    XCTAssertEqual(
      stored.toTransactionLogDomain(),
      entry.toTransactionLogDomain(id: "tx-9", parentPresentationId: nil)
    )
  }

  func testStorageRoundTrip_whenActionIsStoredWithParent_thenParentIsReadBack() throws {
    let entry = TransactionEntry.dpaReport(
      .init(transactionIdentifier: "dpar-2", time: time, transactionResult: .completed)
    )

    let stored = try entry.toTransactionLogStorage(parentPresentationId: "tx-9")

    XCTAssertEqual(stored.parentPresentationId, "tx-9")
    XCTAssertEqual(stored.toTransactionLogDomain()?.parentPresentationId, "tx-9")
  }

  func testToTransactionEntry_whenStoredValueUsesTheLegacyModel_thenReturnsNil() {
    let legacy = logic_storage.TransactionLog(
      identifier: "legacy",
      value: #"{"timestamp":1700000000,"status":"completed","type":"presentation","dataFormat":"cbor"}"#
    )

    XCTAssertNil(legacy.toTransactionEntry())
    XCTAssertNil(legacy.toTransactionLogDomain())
  }
}
