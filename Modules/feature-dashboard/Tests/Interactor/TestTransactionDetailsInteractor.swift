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
import Cuckoo
@testable import logic_core
@testable import logic_test
@testable import feature_test
@testable import logic_business
@testable import feature_dashboard

final class TestTransactionDetailsInteractor: EudiTest {
  
  var interactor: TransactionDetailsInteractor!
  var walletKitController: MockWalletKitController!
  
  override func setUp() {
    self.walletKitController = MockWalletKitController()
    self.interactor = TransactionDetailsInteractorImpl(
      walletController: walletKitController
    )
  }
  
  override func tearDown() {
    self.interactor = nil
  }
  
  func testGetTransactionDetails_WhenWalletKitControllerReturnsTransactions_ThenReturnsExpectedUIModel() async {
    // Given
    let transactionId = Constants.eudiRemoteVerifierMock.id
    stubFetchTransaction()
    
    // When
    let result = await interactor.getTransactionDetails(
      transactionId: transactionId
    )
    
    // Then
    switch result {
    case .success(let uiModel):
      XCTAssertEqual(uiModel.id, transactionId)
    case .failure:
      XCTFail("Expected success, but got failure.")
    }
  }
  
  func testGetTransactionDetails_WhenWalletKitControllerReturnsTransactionsFailure_ThenReturnsExpectedError() async {
    // Given
    let transactionId = "nonexistentTransactionId"
    stubFetchTransactionFailure(for: transactionId)
    
    // When
    let result = await interactor.getTransactionDetails(
      transactionId: transactionId
    )
    
    // Then
    switch result {
    case .success:
      XCTFail("Expected failure, but got success.")
    case .failure(let error):
      XCTAssertEqual(error as! WalletCoreError, WalletCoreError.unableToFetchTransactionLog)
    }
  }
}

extension TestTransactionDetailsInteractor {
  func testGetTransactionDetails_WhenPresentationIsReturned_ThenBuildsCardAndSections() async {
    // Given
    let transactionId = Constants.eudiRemoteVerifierMock.id
    stubFetchTransaction()

    // When
    let result = await interactor.getTransactionDetails(transactionId: transactionId)

    // Then
    guard case .success(let uiModel) = result else {
      return XCTFail("Expected success, but got failure.")
    }
    XCTAssertEqual(uiModel.transactionDetailsCardData.partyName, .custom("EUDI Remote Verifier"))
    XCTAssertTrue(uiModel.transactionDetailsCardData.transactionIsCompleted)
    XCTAssertNil(uiModel.transactionDetailsCardData.nonCompletionReason)
    XCTAssertTrue(uiModel.showsPresentationActions)
    XCTAssertEqual(uiModel.sections.map(\.id), ["requested", "shared"])
    XCTAssertEqual(uiModel.sections[0].groups.first?.title, DocumentTypeIdentifier.mDocPid.rawValue)
    XCTAssertEqual(uiModel.sections[0].groups.first?.listItems.count, 1)
    XCTAssertEqual(uiModel.transactionDetailsCardData.transactionTypeLabel, TransactionType.presentation.typeTitle)
    XCTAssertTrue(uiModel.transactionDetailsCardData.details.isEmpty)
  }

  func testGetTransactionDetails_WhenTransactionIsNotCompleted_ThenCardCarriesTheReason() async {
    // Given
    stub(walletKitController) { stub in
      when(stub.fetchTransactionLog(with: equal(to: "transactionId2")))
        .thenReturn(Constants.otherRelPartyMock)
      when(stub.fetchPresentationActions(parentPresentationId: any())).thenReturn([])
    }

    // When
    let result = await interactor.getTransactionDetails(transactionId: "transactionId2")

    // Then
    guard case .success(let uiModel) = result else {
      return XCTFail("Expected success, but got failure.")
    }
    XCTAssertFalse(uiModel.transactionDetailsCardData.transactionIsCompleted)
    XCTAssertEqual(uiModel.transactionDetailsCardData.nonCompletionReason, .custom("Some Error"))
    XCTAssertTrue(uiModel.sections[0].isEmpty)
    XCTAssertTrue(uiModel.sections[1].isEmpty)
  }

  func testGetTransactionDetails_WhenPresentationHasActions_ThenCountsThem() async {
    // Given
    stubFetchTransaction()
    stub(walletKitController) { stub in
      when(stub.fetchPresentationActions(parentPresentationId: equal(to: "transactionId1")))
        .thenReturn([Self.deletionRequest, Self.deletionRequest, Self.dpaReport])
    }

    // When
    let result = await interactor.getTransactionDetails(transactionId: "transactionId1")

    // Then
    guard case .success(let uiModel) = result else {
      return XCTFail("Expected success, but got failure.")
    }
    XCTAssertEqual(uiModel.presentationActions?.dataDeletionRequests, 2)
    XCTAssertEqual(uiModel.presentationActions?.dpaReports, 1)
    XCTAssertTrue(uiModel.presentationActions?.deletionContacts.isEmpty == true)
  }

  func testGetDataProtectionAction_WhenReport_ThenShowsAuthorityAndTypedContacts() async {
    // Given
    stubFetchPresentationWithContacts()

    // When
    let result = await interactor.getDataProtectionAction(transactionId: "tx-contacts", action: .reportSuspiciousTransaction)

    // Then
    guard case .success(let ui) = result else {
      return XCTFail("Expected success, but got \(result).")
    }
    XCTAssertEqual(ui.title, .transactionActionReportTitle)
    guard case .contactList(let content) = ui.content else {
      return XCTFail("Expected the contact list layout for a report.")
    }
    XCTAssertEqual(content.partyLabel, .transactionActionAuthorityLabel)
    XCTAssertEqual(content.partyName, .custom("DPA"))
    XCTAssertEqual(content.message, .transactionActionReportMessage(["DPA"]))
    XCTAssertEqual(ui.contacts.map(\.channel), [.website])
    XCTAssertEqual(ui.contacts.first?.url, URL(string: "https://dpa.example/report"))
  }

  func testGetDataProtectionAction_WhenDeletion_ThenShowsRelyingPartyAndEmailContact() async {
    // Given
    stubFetchPresentationWithContacts()

    // When
    let result = await interactor.getDataProtectionAction(transactionId: "tx-contacts", action: .requestDataDeletion)

    // Then
    guard case .success(let ui) = result else {
      return XCTFail("Expected success, but got \(result).")
    }
    XCTAssertEqual(ui.title, .transactionActionDeletionScreenTitle)
    guard case .confirmation(let content) = ui.content else {
      return XCTFail("Expected the confirmation layout for a deletion request.")
    }
    XCTAssertEqual(content.intro, .transactionActionDeletionIntroEmail(["Verifier"]))
    XCTAssertEqual(content.notice, .transactionActionDeletionNoticeEmail)
    XCTAssertEqual(content.legal, .transactionActionDeletionLegal(["Verifier", "Verifier"]))
    XCTAssertEqual(content.buttonTitle, .transactionActionContinueEmail)
    XCTAssertEqual(content.contact?.channel, .email)
    XCTAssertEqual(ui.contacts.map(\.channel), [.email])
  }

  func testGetDataProtectionActionHistory_WhenReport_ThenTitleNamesThePartyAndCardNamesTheAuthority() async {
    // Given
    stubFetchPresentationWithContacts()
    stub(walletKitController) { stub in
      when(stub.fetchPresentationActions(parentPresentationId: any())).thenReturn([Self.websiteReport, Self.deletionRequest])
    }

    // When
    let result = await interactor.getDataProtectionActionHistory(transactionId: "tx-contacts", action: .reportSuspiciousTransaction)

    // Then
    guard case .success(let ui) = result else {
      return XCTFail("Expected success, but got \(result).")
    }
    XCTAssertEqual(ui.title, .transactionHistoryReportTitle(["Verifier"]))
    XCTAssertEqual(ui.disclaimer, .transactionHistoryReportDisclaimer)
    XCTAssertEqual(ui.authorityName, .custom("DPA"))
    XCTAssertEqual(ui.entries.map(\.method), [.transactionHistoryChannelWebsite])
  }

  func testGetDataProtectionActionHistory_WhenReportAndAuthorityHasNoName_ThenHasNoAuthorityCard() async {
    // Given
    stub(walletKitController) { stub in
      when(stub.fetchTransactionLog(with: equal(to: "tx-contacts")))
        .thenReturn(Self.presentationWithUnnamedDpa)
      when(stub.fetchPresentationActions(parentPresentationId: any())).thenReturn([Self.websiteReport])
    }

    // When
    let result = await interactor.getDataProtectionActionHistory(transactionId: "tx-contacts", action: .reportSuspiciousTransaction)

    // Then
    guard case .success(let ui) = result else {
      return XCTFail("Expected success, but got \(result).")
    }
    XCTAssertNil(ui.authorityLabel)
    XCTAssertNil(ui.authorityName)
    XCTAssertEqual(ui.entries.map(\.method), [.transactionHistoryChannelWebsite])
  }

  func testGetDataProtectionActionHistory_WhenReportHasNoAttempts_ThenHasNoAuthorityCard() async {
    // Given
    stubFetchPresentationWithContacts()

    // When
    let result = await interactor.getDataProtectionActionHistory(transactionId: "tx-contacts", action: .reportSuspiciousTransaction)

    // Then
    guard case .success(let ui) = result else {
      return XCTFail("Expected success, but got \(result).")
    }
    XCTAssertNil(ui.authorityLabel)
    XCTAssertNil(ui.authorityName)
    XCTAssertTrue(ui.entries.isEmpty)
  }

  func testGetDataProtectionActionHistory_WhenDeletion_ThenHasNoAuthorityCard() async {
    // Given
    stubFetchPresentationWithContacts()

    // When
    let result = await interactor.getDataProtectionActionHistory(transactionId: "tx-contacts", action: .requestDataDeletion)

    // Then
    guard case .success(let ui) = result else {
      return XCTFail("Expected success, but got \(result).")
    }
    XCTAssertEqual(ui.title, .transactionHistoryDeletionTitle(["Verifier"]))
    XCTAssertNil(ui.authorityLabel)
    XCTAssertNil(ui.authorityName)
  }

  func testGetDataProtectionAction_WhenTransactionIsNotAPresentation_ThenReturnsFailure() async {
    // Given
    stub(walletKitController) { stub in
      when(stub.fetchTransactionLog(with: equal(to: "deletion")))
        .thenReturn(.credentialDeletion(.init(id: "deletion", time: Date(), result: .completed, credential: .init(identifier: .mDocPid), issuer: .init(name: nil, identifier: nil, contacts: []))))
    }

    // When
    let result = await interactor.getDataProtectionAction(transactionId: "deletion", action: .reportSuspiciousTransaction)

    // Then
    guard case .failure = result else {
      return XCTFail("Expected failure, but got success.")
    }
  }

  func testPerformDataProtectionAction_WhenDeletionContactIsRecorded_ThenRecordsAndReturnsMailUrl() async {
    // Given
    stubFetchPresentationWithContacts()
    stub(walletKitController) { stub in
      when(stub.recordDataDeletionRequest(for: any(), contactUrl: any())).thenDoNothing()
    }

    // When
    let result = await interactor.performDataProtectionAction(
      transactionId: "tx-contacts",
      action: .requestDataDeletion,
      contactUrl: URL(string: "mailto:support@verifier.example")!
    )

    // Then
    guard case .success(let url) = result else {
      return XCTFail("Expected success, but got \(result).")
    }
    XCTAssertEqual(url.scheme, "mailto")
    XCTAssertTrue(url.absoluteString.hasPrefix("mailto:support@verifier.example?subject="))
    XCTAssertTrue(url.absoluteString.contains("body="))
    verify(walletKitController).recordDataDeletionRequest(for: any(), contactUrl: equal(to: URL(string: "mailto:support@verifier.example")!))
  }

  func testPerformDataProtectionAction_WhenReportContactIsRecorded_ThenRecordsReportAndKeepsWebUrl() async {
    // Given
    stubFetchPresentationWithContacts()
    stub(walletKitController) { stub in
      when(stub.recordDpaReport(for: any(), contactUrl: any())).thenDoNothing()
    }

    // When
    let result = await interactor.performDataProtectionAction(
      transactionId: "tx-contacts",
      action: .reportSuspiciousTransaction,
      contactUrl: URL(string: "https://dpa.example/report")!
    )

    // Then
    guard case .success(let url) = result else {
      return XCTFail("Expected success, but got \(result).")
    }
    XCTAssertEqual(url, URL(string: "https://dpa.example/report"))
    verify(walletKitController).recordDpaReport(for: any(), contactUrl: any())
  }

  func testPerformDataProtectionAction_WhenContactIsNotRecorded_ThenReturnsUnavailableWithoutRecording() async {
    // Given
    stubFetchPresentationWithContacts()

    // When
    let result = await interactor.performDataProtectionAction(
      transactionId: "tx-contacts",
      action: .requestDataDeletion,
      contactUrl: URL(string: "mailto:someone@else.example")!
    )

    // Then
    guard case .unavailable = result else {
      return XCTFail("Expected unavailable, but got \(result).")
    }
    verify(walletKitController, never()).recordDataDeletionRequest(for: any(), contactUrl: any())
  }

  func testPerformDataProtectionAction_WhenRecordingFails_ThenReturnsFailure() async {
    // Given
    stubFetchPresentationWithContacts()
    stub(walletKitController) { stub in
      when(stub.recordDataDeletionRequest(for: any(), contactUrl: any())).thenThrow(WalletCoreError.unableToRecordTransactionAction)
    }

    // When
    let result = await interactor.performDataProtectionAction(
      transactionId: "tx-contacts",
      action: .requestDataDeletion,
      contactUrl: URL(string: "mailto:support@verifier.example")!
    )

    // Then
    guard case .failure(let error) = result else {
      return XCTFail("Expected failure, but got success.")
    }
    XCTAssertEqual(error as? WalletCoreError, WalletCoreError.unableToRecordTransactionAction)
  }

  func testDeleteTransaction_WhenWalletKitControllerSucceeds_ThenReturnsSuccess() async {
    // Given
    stub(walletKitController) { stub in
      when(stub.deleteTransactionLog(with: equal(to: "transactionId1"))).thenDoNothing()
    }

    // When
    let result = await interactor.deleteTransaction(transactionId: "transactionId1")

    // Then
    guard case .success = result else {
      return XCTFail("Expected success, but got \(result).")
    }
    verify(walletKitController).deleteTransactionLog(with: equal(to: "transactionId1"))
  }

  func testDeleteTransaction_WhenWalletKitControllerThrows_ThenReturnsFailure() async {
    // Given
    stub(walletKitController) { stub in
      when(stub.deleteTransactionLog(with: equal(to: "transactionId1")))
        .thenThrow(WalletCoreError.unableToFetchTransactionLog)
    }

    // When
    let result = await interactor.deleteTransaction(transactionId: "transactionId1")

    // Then
    guard case .failure(let error) = result else {
      return XCTFail("Expected failure, but got success.")
    }
    XCTAssertEqual(error as? WalletCoreError, WalletCoreError.unableToFetchTransactionLog)
  }

  static let presentationWithContacts: TransactionLogDomain = .presentation(
    .init(
      id: "tx-contacts",
      time: Date(),
      result: .completed,
      party: .init(name: "Verifier", identifier: .init(schemeUri: "scheme", value: "123"), contacts: ["support@verifier.example"]),
      intermediary: nil,
      registration: .init(registrarUrl: nil, purpose: nil, privacyPolicyUrls: [], dpa: .init(name: "DPA", country: "GR", contacts: ["https://dpa.example/report"])),
      claimsRequested: [],
      claimsPresented: [.init(credential: .init(identifier: .mDocPid), claims: [.init(segments: [.key(name: "ns"), .key(name: "family_name")])])]
    )
  )

  static let presentationWithUnnamedDpa: TransactionLogDomain = .presentation(
    .init(
      id: "tx-contacts",
      time: Date(),
      result: .completed,
      party: .init(name: "Verifier", identifier: nil, contacts: []),
      intermediary: nil,
      registration: .init(registrarUrl: nil, purpose: nil, privacyPolicyUrls: [], dpa: .init(name: "  ", country: nil, contacts: ["https://dpa.example/report"])),
      claimsRequested: [],
      claimsPresented: []
    )
  )

  static let deletionRequest: TransactionLogDomain = .dataDeletionRequest(
    .init(id: "ddr", time: Date(), result: .completed, parentPresentationId: "transactionId1", party: .init(name: nil, identifier: nil, contacts: []), claims: [])
  )

  static let websiteReport: TransactionLogDomain = .dpaReport(
    .init(id: "dpar-web", time: Date(), result: .completed, parentPresentationId: "tx-contacts", dpaName: nil, dpaCountry: nil, channel: .website)
  )

  static let dpaReport: TransactionLogDomain = .dpaReport(
    .init(id: "dpar", time: Date(), result: .completed, parentPresentationId: "transactionId1", dpaName: nil, dpaCountry: nil)
  )

  func stubFetchPresentationWithContacts() {
    stub(walletKitController) { stub in
      when(stub.fetchTransactionLog(with: equal(to: "tx-contacts")))
        .thenReturn(Self.presentationWithContacts)
      when(stub.fetchPresentationActions(parentPresentationId: any())).thenReturn([])
    }
  }

  func stubFetchTransaction() {
    stub(walletKitController) { stub in
      when(stub.fetchTransactionLog(with: equal(to: "transactionId1")))
        .thenReturn(Constants.eudiRemoteVerifierMock)
      when(stub.fetchPresentationActions(parentPresentationId: any())).thenReturn([])
    }
  }
  
  func stubFetchTransactionFailure(for id: String) {
    stub(walletKitController) { stub in
      when(stub.fetchTransactionLog(with: equal(to: id)))
        .thenThrow(WalletCoreError.unableToFetchTransactionLog)
    }
  }
}
