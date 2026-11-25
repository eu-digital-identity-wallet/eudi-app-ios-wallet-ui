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

  func testToTransactionLogDomain_WhenPresentationIsCompleted_ThenMapsPartyRegistrationAndClaims() throws {
    // Given
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

    // When
    let domain = entry.toTransactionLogDomain(id: "row-1", parentPresentationId: nil)

    // Then
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

  func testToTransactionLogDomain_WhenPresentationHasNoRegistration_ThenRegistrationAndIntermediaryAreNil() throws {
    // Given
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

    // When
    let domain = entry.toTransactionLogDomain(id: "row-2", parentPresentationId: nil)

    // Then
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

  func testToTransactionLogDomain_WhenPurposeHasNoDeviceLanguage_ThenFallsBackToTheFirst() throws {
    // Given
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

    // When
    let result = entry.toTransactionLogDomain(id: "row-3", parentPresentationId: nil)

    // Then
    guard case .presentation(let presentation)? = result else {
      return XCTFail("Expected a presentation")
    }
    XCTAssertEqual(presentation.registration?.purpose, "First written")
  }

  func testToTransactionLogDomain_WhenCredentialIssuance_ThenMapsDetails() throws {
    // Given
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

    // When
    let actual = entry.toTransactionLogDomain(id: "row-4", parentPresentationId: nil)

    // Then
    guard case .credentialIssuance(let issuance)? = actual else {
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

  func testToTransactionLogDomain_WhenCredentialReissuance_ThenMapsToReissuance() throws {
    // Given
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

    // When
    let actual = entry.toTransactionLogDomain(id: "row-5", parentPresentationId: nil)

    // Then
    guard case .credentialReissuance(let reissuance)? = actual else {
      return XCTFail("Expected a credential reissuance")
    }
    XCTAssertEqual(reissuance.result, .completed)
    XCTAssertEqual(reissuance.details.isUserTriggered, false)
    XCTAssertEqual(reissuance.details.credentials, [.init(identifier: .other(formatType: "org.iso.18013.5.1.mDL"))])
    XCTAssertEqual(reissuance.details.issuer, .init(name: nil, identifier: nil, contacts: []))
    XCTAssertNil(reissuance.details.issuer.type)
  }

  func testToTransactionLogDomain_WhenCredentialDeletion_ThenMapsCredentialAndIssuer() throws {
    // Given
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

    // When
    let result = entry.toTransactionLogDomain(id: "row-6", parentPresentationId: nil)

    // Then
    guard case .credentialDeletion(let deletion)? = result else {
      return XCTFail("Expected a credential deletion")
    }
    XCTAssertEqual(deletion.credential, .init(identifier: .sdJwtPid))
    XCTAssertEqual(
      deletion.issuer,
      .init(name: "Issuer", identifier: .init(schemeUri: QualifiedIdentifier.lei, value: "111"), contacts: [])
    )
  }

  func testToTransactionLogDomain_WhenSigningSealing_ThenMapsServiceAndDocument() throws {
    // Given
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

    // When
    let result = entry.toTransactionLogDomain(id: "row-7", parentPresentationId: nil)

    // Then
    guard case .signingSealing(let signing)? = result else {
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

  func testToTransactionLogDomain_WhenSigningFileSizeIsNotNumeric_ThenFileSizeIsNil() throws {
    // Given
    let entry = TransactionEntry.signingSealing(
      .init(
        transactionIdentifier: "sign-2:0",
        time: time,
        transactionResult: .notCompleted,
        reasonOfNoncompletion: "Signing failed",
        fileSize: "large"
      )
    )

    // When
    let actual = entry.toTransactionLogDomain(id: "row-8", parentPresentationId: nil)

    // Then
    guard case .signingSealing(let signing)? = actual else {
      return XCTFail("Expected a signing transaction")
    }
    XCTAssertNil(signing.fileSizeBytes)
    XCTAssertEqual(signing.result, .notCompleted(reason: "Signing failed"))
  }

  func testToTransactionLogDomain_WhenDataDeletionRequestHasParent_ThenMapsWithParent() throws {
    // Given
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

    // When
    let result = entry.toTransactionLogDomain(id: "ddr-1", parentPresentationId: "tx-1")

    // Then
    guard case .dataDeletionRequest(let request)? = result else {
      return XCTFail("Expected a data deletion request")
    }
    XCTAssertEqual(request.parentPresentationId, "tx-1")
    XCTAssertEqual(request.party.name, "Verifier")
    XCTAssertEqual(request.claims.first?.claims, [.init(segments: [.key(name: "family_name")])])
    XCTAssertEqual(entry.toTransactionLogDomain(id: "ddr-1", parentPresentationId: "tx-1")?.parentPresentationId, "tx-1")
  }

  func testToTransactionLogDomain_WhenActionParentIsMissingBlankOrSelf_ThenReturnsNil() throws {
    // Given
    let entry = TransactionEntry.dpaReport(
      .init(transactionIdentifier: "dpar-1", time: time, transactionResult: .completed, dpaName: .init(content: "DPA"))
    )

    // Then
    XCTAssertNil(entry.toTransactionLogDomain(id: "dpar-1", parentPresentationId: nil))
    XCTAssertNil(entry.toTransactionLogDomain(id: "dpar-1", parentPresentationId: ""))
    XCTAssertNil(entry.toTransactionLogDomain(id: "dpar-1", parentPresentationId: "dpar-1"))
    XCTAssertNotNil(entry.toTransactionLogDomain(id: "dpar-1", parentPresentationId: "tx-1"))
  }

  func testToTransactionLogDomain_WhenKindIsUnsupported_ThenReturnsNil() throws {
    // Given
    let entry = TransactionEntry.pseudonymGeneration(
      .init(transactionIdentifier: "pseudo-1", time: time, transactionResult: .completed, pseudonym: .init(value: "abc"))
    )

    // When
    let result = entry.toTransactionLogDomain(id: "pseudo-1", parentPresentationId: nil)

    // Then
    XCTAssertNil(result)
  }

  func testStorageRoundTrip_WhenEntryIsStoredAndReadBack_ThenDomainIsPreserved() throws {
    // Given
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

    // When
    let stored = try entry.toTransactionLogStorage(parentPresentationId: nil)

    // Then
    XCTAssertEqual(stored.identifier, "tx-9")
    XCTAssertNil(stored.parentPresentationId)
    XCTAssertFalse(stored.value.contains("rawResponse"))
    XCTAssertEqual(
      stored.toTransactionLogDomain(),
      entry.toTransactionLogDomain(id: "tx-9", parentPresentationId: nil)
    )
  }

  func testStorageRoundTrip_WhenActionIsStoredWithParent_ThenParentIsReadBack() throws {
    // Given
    let entry = TransactionEntry.dpaReport(
      .init(transactionIdentifier: "dpar-2", time: time, transactionResult: .completed)
    )

    // When
    let stored = try entry.toTransactionLogStorage(parentPresentationId: "tx-9")

    // Then
    XCTAssertEqual(stored.parentPresentationId, "tx-9")
    XCTAssertEqual(stored.toTransactionLogDomain()?.parentPresentationId, "tx-9")
  }

  func testToTransactionEntry_WhenStoredValueUsesTheLegacyModel_ThenReturnsNil() {
    // Given
    let legacy = logic_storage.TransactionLog(
      identifier: "legacy",
      value: #"{"timestamp":1700000000,"status":"completed","type":"presentation","dataFormat":"cbor"}"#
    )

    // Then
    XCTAssertNil(legacy.toTransactionEntry())
    XCTAssertNil(legacy.toTransactionLogDomain())
  }
}
