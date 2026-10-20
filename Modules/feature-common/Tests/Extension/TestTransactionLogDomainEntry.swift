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

final class TestTransactionLogDomainEntry: EudiTest {
  private let time = Date(timeIntervalSince1970: 1_700_000_000)

  private var presentation: TransactionLogDomain.Presentation {
    .init(
      id: "tx-1",
      time: time,
      result: .completed,
      party: .init(name: "Verifier", identifier: .init(schemeUri: QualifiedIdentifier.lei, value: "123"), contacts: ["support@verifier.example"]),
      intermediary: nil,
      registration: .init(registrarUrl: nil, purpose: nil, privacyPolicyUrls: [], dpa: .init(name: "DPA", country: "GR", contacts: [])),
      claimsRequested: [.init(credential: .init(identifier: .mDocPid), claims: [.init(segments: [.key(name: "ns"), .key(name: "family_name")]), .init(segments: [.key(name: "ns"), .key(name: "age_over_18")])])],
      claimsPresented: [.init(credential: .init(identifier: .mDocPid), claims: [.init(segments: [.key(name: "ns"), .key(name: "family_name")])])]
    )
  }

  func testToDataDeletionRequestEntry_WhenBuilt_ThenListsOnlyPresentedClaimsAndParty() throws {
    let entry = presentation.toDataDeletionRequestEntry(id: "ddr-1", time: time)

    guard case .dataDeletionRequest(let request) = entry else {
      return XCTFail("Expected a data deletion request")
    }
    XCTAssertEqual(request.transactionIdentifier, "ddr-1")
    XCTAssertEqual(request.time, time)
    XCTAssertEqual(request.transactionResult, .completed)
    XCTAssertEqual(request.listOfClaims, [
      .init(credentialIdentifier: DocumentTypeIdentifier.mDocPid.rawValue, claims: [.init([.claim(name: "ns"), .claim(name: "family_name")])])
    ])
    XCTAssertEqual(request.interactingPartyIdentifier, .init(type: QualifiedIdentifier.lei, value: "123"))
    XCTAssertEqual(request.interactingPartyName, .init(lang: "und", content: "Verifier"))
  }

  func testToDpaReportEntry_WhenBuilt_ThenCarriesTheAuthority() throws {
    let entry = presentation.toDpaReportEntry(id: "dpar-1", time: time)

    guard case .dpaReport(let report) = entry else {
      return XCTFail("Expected a DPA report")
    }
    XCTAssertEqual(report.transactionIdentifier, "dpar-1")
    XCTAssertEqual(report.dpaName?.content, "DPA")
    XCTAssertEqual(report.dpaCountry?.content, "GR")
  }

  func testActionEntries_WhenStoredWithAChannel_ThenTheChannelIsReadBack() throws {
    let entry = presentation.toDataDeletionRequestEntry(id: "ddr-3", time: time)

    let stored = try entry.toTransactionLogStorage(parentPresentationId: "tx-1", actionChannel: .email)

    XCTAssertEqual(stored.actionChannel, "email")
    guard case .dataDeletionRequest(let request)? = stored.toTransactionLogDomain() else {
      return XCTFail("Expected a data deletion request")
    }
    XCTAssertEqual(request.channel, .email)
    XCTAssertFalse(stored.value.contains("email"), "The channel is our own metadata and must stay out of the TS10 payload")
  }

  func testActionEntries_WhenStoredWithoutAChannel_ThenTheChannelIsNil() throws {
    let stored = try presentation.toDpaReportEntry(id: "dpar-3", time: time).toTransactionLogStorage(parentPresentationId: "tx-1")

    guard case .dpaReport(let report)? = stored.toTransactionLogDomain() else {
      return XCTFail("Expected a DPA report")
    }
    XCTAssertNil(stored.actionChannel)
    XCTAssertNil(report.channel)
  }

  func testChannel_WhenBuiltFromAContactUrl_ThenFollowsTheScheme() throws {
    XCTAssertEqual(TransactionActionChannel(url: URL(string: "tel:+302101234567")!), .phone)
    XCTAssertEqual(TransactionActionChannel(url: URL(string: "mailto:a@b.com")!), .email)
    XCTAssertEqual(TransactionActionChannel(url: URL(string: "https://dpa.example")!), .website)
    XCTAssertNil(TransactionActionChannel(url: URL(string: "ftp://dpa.example")!))
  }

  func testActionEntries_WhenStoredUnderTheParent_ThenReadBackAsActions() throws {
    let stored = try presentation.toDataDeletionRequestEntry(id: "ddr-2", time: time).toTransactionLogStorage(parentPresentationId: "tx-1")

    guard case .dataDeletionRequest(let request)? = stored.toTransactionLogDomain() else {
      return XCTFail("Expected a data deletion request")
    }
    XCTAssertEqual(request.parentPresentationId, "tx-1")
    XCTAssertEqual(request.party.name, "Verifier")
    XCTAssertEqual(request.claims.first?.claims, [.init(segments: [.key(name: "ns"), .key(name: "family_name")])])
  }
}
