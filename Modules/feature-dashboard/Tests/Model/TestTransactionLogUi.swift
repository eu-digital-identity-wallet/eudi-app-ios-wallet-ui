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
@testable import logic_business
@testable import logic_core
@testable import logic_resources
@testable import logic_ui
@testable import logic_test
@testable import feature_test
@testable import feature_dashboard

final class TestTransactionLogUi: EudiTest {
  private let time = Date(timeIntervalSince1970: 1_700_000_000)
  private let noParty = InteractingPartyDomain(name: nil, identifier: nil, contacts: [])

  private var allTransactionKinds: [TransactionLogDomain] {
    let issuance = IssuanceDetailsDomain(
      issuer: noParty, requestedCount: 1, issuedCount: 1, credentials: [], isUserTriggered: nil
    )
    return [
      .presentation(.init(id: "t1", time: time, result: .completed, party: noParty, intermediary: nil, registration: nil, claimsRequested: [], claimsPresented: [])),
      .credentialIssuance(.init(id: "t2", time: time, result: .completed, details: issuance)),
      .credentialReissuance(.init(id: "t3", time: time, result: .completed, details: issuance)),
      .credentialDeletion(.init(id: "t4", time: time, result: .completed, credential: .init(identifier: .mDocPid), issuer: noParty)),
      .signingSealing(.init(id: "t5", time: time, result: .completed, service: noParty, signingTransactionIdentifier: nil, certificateSerialNumber: nil, fileName: nil, fileSizeBytes: nil, dtbsr: nil)),
      .dataDeletionRequest(.init(id: "t6", time: time, result: .completed, parentPresentationId: "t1", party: noParty, claims: [])),
      .dpaReport(.init(id: "t7", time: time, result: .completed, parentPresentationId: "t1", dpaName: nil, dpaCountry: nil))
    ]
  }

  func testPrivacyPolicyFields_WhenALinkIsNotHttps_ThenItIsShownAsTextOnly() {
    // When
    let fields = TransactionDetailsFieldUi.privacyPolicyFields(
      .init(
        registrarUrl: nil,
        purpose: nil,
        privacyPolicyUrls: ["https://rp.example/privacy", "http://rp.example/privacy"],
        dpa: nil
      )
    )

    // Then
    XCTAssertEqual(fields.map(\.url), [URL(string: "https://rp.example/privacy"), nil])
  }

  func testTransformToTransactionUI_WhenPresentation_ThenUsesPartyNameAndType() {
    // When
    let ui = Constants.eudiRemoteVerifierMock.transformToTransactionUI()

    // Then
    XCTAssertEqual(ui?.id, "transactionId1")
    XCTAssertEqual(ui?.name, "EUDI Remote Verifier")
    XCTAssertEqual(ui?.status, .completed)
    XCTAssertEqual(ui?.transactionType, .presentation)
  }

  func testTransformToTransactionUI_WhenPresentationHasNoParty_ThenFallsBackToTypeLabel() {
    // Given
    let log = TransactionLogDomain.presentation(
      .init(id: "1", time: time, result: .notCompleted(reason: nil), party: noParty, intermediary: nil, registration: nil, claimsRequested: [], claimsPresented: [])
    )

    // When
    let ui = log.transformToTransactionUI()

    // Then
    XCTAssertEqual(ui?.name, TransactionType.presentation.typeTitle.toString)
    XCTAssertEqual(ui?.status, .notCompleted)
  }

  func testTransformToTransactionUI_WhenIssuanceHasNoIssuerName_ThenUsesCredentialIdentifier() {
    // Given
    let log = TransactionLogDomain.credentialIssuance(
      .init(id: "2", time: time, result: .completed, details: .init(issuer: noParty, requestedCount: 1, issuedCount: 1, credentials: [.init(identifier: .sdJwtPid)], isUserTriggered: nil))
    )

    // When
    let ui = log.transformToTransactionUI()

    // Then
    XCTAssertEqual(ui?.name, DocumentTypeIdentifier.sdJwtPid.rawValue)
    XCTAssertEqual(ui?.transactionType, .issuance)
  }

  func testTransformToTransactionUI_WhenReissuance_ThenTypeIsReissuance() {
    // Given
    let log = TransactionLogDomain.credentialReissuance(
      .init(id: "3", time: time, result: .completed, details: .init(issuer: .init(name: "Issuer", identifier: nil, contacts: []), requestedCount: 1, issuedCount: 1, credentials: [], isUserTriggered: false))
    )

    // When
    let ui = log.transformToTransactionUI()

    // Then
    XCTAssertEqual(ui?.name, "Issuer")
    XCTAssertEqual(ui?.transactionType, .reissuance)
  }

  func testTransformToTransactionUI_WhenDeletion_ThenTitleIsTheIssuer() {
    // Given
    let log = TransactionLogDomain.credentialDeletion(
      .init(id: "4", time: time, result: .completed, credential: .init(identifier: .mDocPid), issuer: .init(name: "Issuer", identifier: nil, contacts: []))
    )

    // When
    let ui = log.transformToTransactionUI()

    // Then
    XCTAssertEqual(ui?.name, "Issuer")
    XCTAssertEqual(ui?.transactionType, .deletion)
  }

  func testTransformToTransactionUI_WhenDeletionHasNoIssuerName_ThenUsesTheCredential() {
    // Given
    let log = TransactionLogDomain.credentialDeletion(
      .init(id: "4", time: time, result: .completed, credential: .init(identifier: .mDocPid), issuer: noParty)
    )

    // When
    let ui = log.transformToTransactionUI()

    // Then
    XCTAssertEqual(ui?.name, DocumentTypeIdentifier.mDocPid.rawValue)
    XCTAssertEqual(ui?.transactionType, .deletion)
  }

  func testTransformToTransactionUI_WhenSigningHasNoServiceName_ThenUsesFileName() {
    // Given
    let log = TransactionLogDomain.signingSealing(
      .init(id: "5", time: time, result: .completed, service: noParty, signingTransactionIdentifier: nil, certificateSerialNumber: nil, fileName: "contract.pdf", fileSizeBytes: nil, dtbsr: nil)
    )

    // When
    let ui = log.transformToTransactionUI()

    // Then
    XCTAssertEqual(ui?.name, "contract.pdf")
    XCTAssertEqual(ui?.transactionType, .signing)
  }

  func testTransformToTransactionUI_WhenPresentationAction_ThenHiddenFromList() {
    // Given
    let request = TransactionLogDomain.dataDeletionRequest(
      .init(id: "6", time: time, result: .completed, parentPresentationId: "1", party: noParty, claims: [])
    )
    let report = TransactionLogDomain.dpaReport(
      .init(id: "7", time: time, result: .completed, parentPresentationId: "1", dpaName: "DPA", dpaCountry: nil)
    )

    // When
    let requestUi = request.transformToTransactionUI()
    let reportUi = report.transformToTransactionUI()

    // Then
    XCTAssertNil(requestUi)
    XCTAssertNil(reportUi)
  }

  func testTransformToTransactionUI_WhenVisibleType_ThenCarriesTheExactInstant() {
    // Then
    for log in allTransactionKinds where log.isVisibleInTransactionList {
      XCTAssertEqual(log.transformToTransactionUI()?.transactionDate, log.time)
    }
  }

  func testCategory_WhenAnyHourOfToday_ThenGroupsUnderToday() {
    // Given
    let calendar = Calendar.current
    let startOfToday = calendar.startOfDay(for: Date())
    let startOfTomorrow = calendar.date(byAdding: .day, value: 1, to: startOfToday)!
    let lastSecondOfToday = calendar.date(byAdding: .second, value: -1, to: startOfTomorrow)!

    // Then
    for instant in [startOfToday, Date(), lastSecondOfToday] {
      XCTAssertEqual(
        TransactionCategory.category(for: instant),
        .month(dateTime: LocalizableStringKey.today.toString)
      )
    }
  }

  func testCategory_WhenMonthsAgo_ThenLabelIsThatMonthWithoutAnyShift() {
    // Given
    let old = Calendar.current.date(byAdding: .month, value: -3, to: Date())!

    // When
    let category = TransactionCategory.category(for: old)

    // Then
    XCTAssertEqual(
      category,
      .month(dateTime: Date.monthYearFormatter.string(from: old).uppercased())
    )
  }

  func testToCardData_WhenPartyHasAType_ThenItIsShownUnderTheName() {
    // Given
    let log = TransactionLogDomain.presentation(
      .init(
        id: "1", time: time, result: .completed,
        party: .init(name: "Verifier", identifier: nil, contacts: [], type: "ServiceProvider"),
        intermediary: nil, registration: nil, claimsRequested: [], claimsPresented: []
      )
    )

    // When
    let card = log.toUiModel().transactionDetailsCardData

    // Then
    XCTAssertEqual(card.partyName, .custom("Verifier"))
    XCTAssertEqual(card.partyType, .custom("ServiceProvider"))
  }

  func testToCardData_WhenPartyHasNoType_ThenTheLineIsOmitted() {
    // Given
    let log = TransactionLogDomain.credentialDeletion(
      .init(id: "4", time: time, result: .completed, credential: .init(identifier: .mDocPid), issuer: noParty)
    )

    // When
    let partyType = log.toUiModel().transactionDetailsCardData.partyType

    // Then
    XCTAssertNil(partyType)
  }

  func testSearchTags_WhenPresentationHasIntermediary_ThenBothNamesAreSearchable() {
    // Given
    let log = TransactionLogDomain.presentation(
      .init(
        id: "1", time: time, result: .completed,
        party: .init(name: " Verifier ", identifier: nil, contacts: []),
        intermediary: .init(name: "Broker", identifier: nil, contacts: []),
        registration: nil, claimsRequested: [], claimsPresented: []
      )
    )

    // When
    let tags = log.searchTags

    // Then
    XCTAssertEqual(tags, ["Verifier", "Broker"])
  }

  func testSearchTags_WhenSigning_ThenServiceAndFileNameAreSearchable() {
    // Given
    let log = TransactionLogDomain.signingSealing(
      .init(id: "5", time: time, result: .completed, service: .init(name: "QTSP", identifier: nil, contacts: []), signingTransactionIdentifier: nil, certificateSerialNumber: nil, fileName: "contract.pdf", fileSizeBytes: nil, dtbsr: nil)
    )

    // When
    let tags = log.searchTags

    // Then
    XCTAssertEqual(tags, ["QTSP", "contract.pdf"])
  }

  func testSearchTags_WhenDeletion_ThenIssuerAndAttestationTypeAreSearchable() {
    // Given
    let log = TransactionLogDomain.credentialDeletion(
      .init(
        id: "6", time: time, result: .completed,
        credential: .init(identifier: .mDocPid),
        issuer: .init(name: "PID Issuer", identifier: nil, contacts: [])
      )
    )

    // When
    let tags = log.searchTags

    // Then
    XCTAssertEqual(tags, ["PID Issuer", DocumentTypeIdentifier.mDocPid.rawValue])
  }

  func testSearchTags_WhenDeletionHasNoIssuerName_ThenAttestationTypeIsSearchable() {
    // Given
    let log = TransactionLogDomain.credentialDeletion(
      .init(
        id: "7", time: time, result: .completed,
        credential: .init(identifier: .mDocPid),
        issuer: .init(name: nil, identifier: nil, contacts: [])
      )
    )

    // When
    let tags = log.searchTags

    // Then
    XCTAssertEqual(tags, [DocumentTypeIdentifier.mDocPid.rawValue])
  }

  func testIdentifierPath_WhenSegmentsAreMixed_ThenRendersBracketedComponents() {
    // Given
    let claim = ClaimRefDomain(segments: [.key(name: "addresses"), .allElements, .key(name: "street"), .index(2)])

    // When
    let path = claim.identifierPath
    let emptyPath = ClaimRefDomain(segments: []).identifierPath

    // Then
    XCTAssertEqual(path, .custom(#"["addresses"][*]["street"][2]"#))
    XCTAssertEqual(emptyPath, .transactionDetailsUnknownClaim)
  }

  func testToUiModel_WhenIssuance_ThenShowsCountsContactsAndIssuedCredentials() {
    // Given
    let log = TransactionLogDomain.credentialIssuance(
      .init(
        id: "2", time: time, result: .notCompleted(reason: "Not all requested credentials were issued"),
        details: .init(
          issuer: .init(name: "PID Provider", identifier: .init(schemeUri: "http://data.europa.eu/eudi/id/LEI", value: "123"), contacts: ["https://issuer.example"]),
          requestedCount: 5, issuedCount: 3,
          credentials: [.init(identifier: .mDocPid)], isUserTriggered: true
        )
      )
    )

    // When
    let ui = log.toUiModel()

    // Then
    XCTAssertEqual(ui.sections.map(\.id), ["credentials"])
    XCTAssertEqual(ui.sections[0].title, .transactionDetailsCredentialsIssuedSection)
    XCTAssertEqual(ui.transactionDetailsCardData.partyName, .custom("PID Provider"))
    XCTAssertEqual(
      ui.transactionDetailsCardData.details.map { $0.map(\.id) },
      [["issuance:requested", "issuance:issued"], ["issuer:contact:0"]]
    )
    XCTAssertEqual(ui.transactionDetailsCardData.details[0][0].listItem.mainContent, .text(.custom("5")))
    XCTAssertEqual(ui.transactionDetailsCardData.details[0][1].listItem.mainContent, .text(.custom("3")))
    XCTAssertNotNil(ui.transactionDetailsCardData.details[1][0].url)
    XCTAssertEqual(ui.sections[0].fields.first?.listItem.mainContent, .text(.custom(DocumentTypeIdentifier.mDocPid.rawValue)))
    XCTAssertEqual(ui.transactionDetailsCardData.nonCompletionReason, .custom("Not all requested credentials were issued"))
    XCTAssertFalse(ui.showsPresentationActions)
  }

  func testToUiModel_WhenReissuance_ThenCountsComeBeforeTriggerAndContacts() {
    // Given
    let log = TransactionLogDomain.credentialReissuance(
      .init(
        id: "3", time: time, result: .completed,
        details: .init(
          issuer: .init(name: "Issuer", identifier: nil, contacts: ["https://issuer.example"]),
          requestedCount: 0, issuedCount: 0,
          credentials: [], isUserTriggered: false
        )
      )
    )

    // When
    let ui = log.toUiModel()

    // Then
    XCTAssertTrue(ui.sections.isEmpty)
    XCTAssertEqual(
      ui.transactionDetailsCardData.details.map { $0.map(\.id) },
      [["issuance:requested", "issuance:issued"], ["issuance:trigger"], ["issuer:contact:0"]]
    )
    XCTAssertEqual(ui.transactionDetailsCardData.details[0][1].listItem.mainContent, .text(.custom("0")))
    XCTAssertEqual(
      ui.transactionDetailsCardData.details[1][0].listItem.mainContent,
      .text(.custom(LocalizableStringKey.transactionDetailsRenewedByWallet.toString))
    )
  }

  func testToUiModel_WhenDeletion_ThenKeepsTheCredentialsHeading() {
    // Given
    let log = TransactionLogDomain.credentialDeletion(
      .init(id: "4", time: time, result: .completed, credential: .init(identifier: .mDocPid), issuer: noParty)
    )

    // When
    let ui = log.toUiModel()

    // Then
    XCTAssertEqual(ui.sections.map(\.title), [.transactionDetailsCredentialsSection])
    XCTAssertTrue(ui.transactionDetailsCardData.details.isEmpty)
  }

  func testToUiModel_WhenSigning_ThenOnlyTheFilenameAndSigningIdentifierRemain() {
    // Given
    let log = TransactionLogDomain.signingSealing(
      .init(
        id: "5", time: time, result: .completed,
        service: .init(name: "QTSP", identifier: nil, contacts: ["support@qtsp.example"]),
        signingTransactionIdentifier: "sign-42", certificateSerialNumber: "serial",
        fileName: "contract.pdf", fileSizeBytes: 2048, dtbsr: "ZGlnZXN0"
      )
    )

    // When
    let ui = log.toUiModel()

    // Then
    XCTAssertEqual(ui.sections.map(\.id), ["document"])
    XCTAssertEqual(ui.transactionDetailsCardData.details.map { $0.map(\.id) }, [["signing:identifier"]])
    XCTAssertEqual(ui.sections[0].fields.map(\.id), ["document:name"])
  }

  func testToUiModel_WhenPresentationRecordsTransactionData_ThenTheSigningRequestFollowsTheSharedData() {
    // Given
    let log = TransactionLogDomain.presentation(
      .init(
        id: "1", time: time, result: .completed, party: noParty, intermediary: nil, registration: nil,
        claimsRequested: [], claimsPresented: [],
        transactionData: [
          .qes(.init(credentialIds: ["pid"], signatureRequests: [])),
          .unavailable
        ]
      )
    )

    // When
    let ui = log.toUiModel()

    // Then
    XCTAssertEqual(ui.sections.map(\.id), ["requested", "shared", "transaction-data"])
    let signingRequest = ui.sections[2]
    XCTAssertEqual(signingRequest.title, .transactionDetailsSigningRequest)
    XCTAssertTrue(signingRequest.fields.isEmpty)
    XCTAssertEqual(signingRequest.groups.map(\.title), [LocalizableStringKey.requestTransactionDataSignatureDetails.toString])
    XCTAssertEqual(
      signingRequest.groups[0].listItems.map(\.id),
      [
        "transaction-data/framework",
        "transaction-data/transaction-0/title",
        "transaction-data/transaction-0/query-0",
        "transaction-data/transaction-1/title",
        "transaction-data/transaction-1/unavailable"
      ]
    )
  }

  func testToUiModel_WhenPresentationRecordsNoTransactionData_ThenThereIsNoSigningRequest() {
    // Given
    let log = TransactionLogDomain.presentation(
      .init(
        id: "1", time: time, result: .completed, party: noParty, intermediary: nil, registration: nil,
        claimsRequested: [], claimsPresented: []
      )
    )

    // When
    let ui = log.toUiModel()

    // Then
    XCTAssertEqual(ui.sections.map(\.id), ["requested", "shared"])
  }

  func testContacts_WhenTheRegistrationWasIssuedToAnotherParty_ThenOffersNoDeletionAndWarns() {
    // Given
    let presentation = sharedPresentation(registrationCheck: .notBoundToRequester)

    // When
    let deletionContacts = presentation.contacts(for: .requestDataDeletion)
    let reportContacts = presentation.contacts(for: .reportSuspiciousTransaction)
    let warning = presentation.registrationWarning

    // Then
    XCTAssertTrue(deletionContacts.isEmpty)
    XCTAssertFalse(reportContacts.isEmpty)
    XCTAssertEqual(warning, .transactionDetailsRegistrationNotBoundWarning)
  }

  func testRegistrationWarning_WhenTheRegistrationWasNotVerifiedOrNotRecorded_ThenWarns() {
    // Then
    for check in [RecordedRegistrationCheck.notVerified, .notEvaluated, nil] {
      let presentation = sharedPresentation(registrationCheck: check)

      XCTAssertEqual(presentation.registrationWarning, .transactionDetailsRegistrationNotVerifiedWarning)
      XCTAssertFalse(presentation.contacts(for: .requestDataDeletion).isEmpty)
    }
  }

  func testRegistrationWarning_WhenOnlyAPartyIdentifierOrAnIntermediaryWasRecorded_ThenWarns() {
    // Given
    let withIdentifier = TransactionLogDomain.Presentation(
      id: "1", time: time, result: .completed,
      party: .init(name: "Verifier", identifier: .init(schemeUri: "scheme", value: "rp"), contacts: []),
      intermediary: nil, registration: nil, claimsRequested: [], claimsPresented: [], registrationCheck: .notVerified
    )
    let withIntermediary = TransactionLogDomain.Presentation(
      id: "2", time: time, result: .completed,
      party: .init(name: "Verifier", identifier: nil, contacts: []),
      intermediary: .init(name: "Intermediary", identifier: nil, contacts: []),
      registration: nil, claimsRequested: [], claimsPresented: [], registrationCheck: nil
    )
    let withNothing = TransactionLogDomain.Presentation(
      id: "3", time: time, result: .completed,
      party: .init(name: "Verifier", identifier: nil, contacts: []),
      intermediary: nil, registration: nil, claimsRequested: [], claimsPresented: [], registrationCheck: nil
    )

    // When
    let identifierWarning = withIdentifier.registrationWarning
    let intermediaryWarning = withIntermediary.registrationWarning
    let nothingWarning = withNothing.registrationWarning

    // Then
    XCTAssertEqual(identifierWarning, LocalizableStringKey.transactionDetailsRegistrationNotVerifiedWarning)
    XCTAssertEqual(intermediaryWarning, LocalizableStringKey.transactionDetailsRegistrationNotVerifiedWarning)
    XCTAssertNil(nothingWarning)
  }

  func testRegistrationWarning_WhenTheRegistrationWasVerified_ThenDoesNotWarn() {
    // When
    let warning = sharedPresentation(registrationCheck: .verified).registrationWarning

    // Then
    XCTAssertNil(warning)
  }

  func testContacts_WhenNothingWasPresented_ThenDeletionCannotBeRequested() {
    // Given
    let presentation = TransactionLogDomain.Presentation(
      id: "1", time: time, result: .notCompleted(reason: nil),
      party: .init(name: "Verifier", identifier: nil, contacts: ["support@verifier.example", "not a contact"]),
      intermediary: nil,
      registration: .init(registrarUrl: nil, purpose: nil, privacyPolicyUrls: [], dpa: .init(name: "DPA", country: nil, contacts: ["+30 210 1234567", "https://dpa.example"])),
      claimsRequested: [], claimsPresented: []
    )

    // When
    let deletionContacts = presentation.contacts(for: .requestDataDeletion)
    let reportUrls = presentation.contacts(for: .reportSuspiciousTransaction).map(\.url)

    // Then
    XCTAssertTrue(deletionContacts.isEmpty)
    XCTAssertEqual(
      reportUrls,
      [URL(string: "https://dpa.example")!, URL(string: "tel:+302101234567")!]
    )
  }

  func testToActionUiModel_WhenContactsAreMixed_ThenKindsFollowTheUrlScheme() {
    // Given
    let presentation = TransactionLogDomain.Presentation(
      id: "1", time: time, result: .completed,
      party: .init(name: "Verifier", identifier: nil, contacts: []),
      intermediary: nil,
      registration: .init(registrarUrl: nil, purpose: nil, privacyPolicyUrls: [], dpa: .init(name: "APD-GBA", country: "BE", contacts: ["+32 2 274 48 00", "contact@apd-gba.be", "https://www.autoriteprotectiondonnees.be"])),
      claimsRequested: [], claimsPresented: []
    )

    // When
    let ui = presentation.toActionUiModel(transactionId: "1", action: .reportSuspiciousTransaction)

    // Then
    guard case .contactList(let content) = ui.content else {
      return XCTFail("Expected the contact list layout for a report.")
    }
    XCTAssertEqual(content.partyName, .custom("APD-GBA"))
    XCTAssertEqual(ui.contacts.map(\.channel), [.website, .email, .phone])
    XCTAssertEqual(ui.contacts.map(\.label), ["https://www.autoriteprotectiondonnees.be", "contact@apd-gba.be", "+32 2 274 48 00"])
    XCTAssertEqual(content.followUp, .transactionActionReportFollowUp(["APD-GBA"]))
  }

  func testReportScreen_WhenTheDpaHasNoName_ThenTheCardAndNamedTextsAreDropped() {
    // Given
    let presentation = TransactionLogDomain.Presentation(
      id: "1", time: time, result: .completed,
      party: .init(name: "Verifier", identifier: nil, contacts: []),
      intermediary: nil,
      registration: .init(registrarUrl: nil, purpose: nil, privacyPolicyUrls: [], dpa: .init(name: nil, country: "BE", contacts: ["https://dpa.example"])),
      claimsRequested: [], claimsPresented: []
    )

    // When
    let ui = presentation.toActionUiModel(transactionId: "1", action: .reportSuspiciousTransaction)

    // Then
    guard case .contactList(let content) = ui.content else {
      return XCTFail("Expected the contact list layout for a report.")
    }
    XCTAssertNil(content.partyName)
    XCTAssertEqual(content.message, .transactionActionReportMessageNoAuthority)
    XCTAssertEqual(content.followUp, .transactionActionReportFollowUpNoAuthority)
    XCTAssertEqual(content.messageBold, .transactionActionReportMessageBold)
  }

  func testReportScreen_WhenTheDpaNameIsBlank_ThenItCountsAsMissing() {
    // Given
    let presentation = TransactionLogDomain.Presentation(
      id: "1", time: time, result: .completed,
      party: .init(name: "Verifier", identifier: nil, contacts: []),
      intermediary: nil,
      registration: .init(registrarUrl: nil, purpose: nil, privacyPolicyUrls: [], dpa: .init(name: "   ", country: "BE", contacts: [])),
      claimsRequested: [], claimsPresented: []
    )

    // When
    let ui = presentation.toActionUiModel(transactionId: "1", action: .reportSuspiciousTransaction)

    // Then
    guard case .contactList(let content) = ui.content else {
      return XCTFail("Expected the contact list layout for a report.")
    }
    XCTAssertNil(content.partyName)
    XCTAssertEqual(content.message, .transactionActionReportMessageNoAuthority)
    XCTAssertEqual(content.followUp, .transactionActionReportFollowUpNoAuthority)
  }

  func testDeletionScreen_WhenThePartyHasNoName_ThenTheCardAndNamedTextsAreDropped() {
    // Given
    let presentation = TransactionLogDomain.Presentation(
      id: "1", time: time, result: .completed,
      party: .init(name: nil, identifier: nil, contacts: ["https://verifier.example/erasure"]),
      intermediary: nil, registration: nil,
      claimsRequested: [],
      claimsPresented: [.init(credential: .init(identifier: .mDocPid), claims: [])]
    )

    // When
    let ui = presentation.toActionUiModel(transactionId: "1", action: .requestDataDeletion)

    // Then
    guard case .confirmation(let content) = ui.content else {
      return XCTFail("Expected the confirmation layout for a deletion request.")
    }
    XCTAssertNil(content.intro)
    XCTAssertNil(content.legal)
    XCTAssertEqual(content.contact?.channel, .website)
    XCTAssertEqual(content.buttonTitle, .continueButton)
    XCTAssertEqual(content.noticeBold, .transactionActionDeletionNoticeBold)
  }

  func testDeletionScreen_WhenThePartyHasNoNameAndEmailIsUsed_ThenTheButtonKeepsItsTitle() {
    // Given
    let presentation = TransactionLogDomain.Presentation(
      id: "1", time: time, result: .completed,
      party: .init(name: nil, identifier: nil, contacts: ["support@verifier.example"]),
      intermediary: nil, registration: nil,
      claimsRequested: [],
      claimsPresented: [.init(credential: .init(identifier: .mDocPid), claims: [])]
    )

    // When
    let ui = presentation.toActionUiModel(transactionId: "1", action: .requestDataDeletion)

    // Then
    guard case .confirmation(let content) = ui.content else {
      return XCTFail("Expected the confirmation layout for a deletion request.")
    }
    XCTAssertNil(content.intro)
    XCTAssertEqual(content.buttonTitle, .transactionActionContinueEmail)
  }

  func testDeletionScreen_WhenThereIsNoNameAndNoContact_ThenTheUnavailableNoticeStays() {
    // Given
    let presentation = TransactionLogDomain.Presentation(
      id: "1", time: time, result: .completed,
      party: .init(name: nil, identifier: nil, contacts: []),
      intermediary: nil, registration: nil,
      claimsRequested: [],
      claimsPresented: [.init(credential: .init(identifier: .mDocPid), claims: [])]
    )

    // When
    let ui = presentation.toActionUiModel(transactionId: "1", action: .requestDataDeletion)

    // Then
    guard case .confirmation(let content) = ui.content else {
      return XCTFail("Expected the confirmation layout for a deletion request.")
    }
    XCTAssertEqual(content.intro, .transactionDetailsActionUnavailable)
    XCTAssertNil(content.legal)
    XCTAssertEqual(content.buttonTitle, .continueButton)
  }

  func testContacts_WhenSeveralMethodsExist_ThenWebsiteComesFirstAndPhoneLast() {
    // Given
    let presentation = TransactionLogDomain.Presentation(
      id: "1", time: time, result: .completed,
      party: .init(name: "Verifier", identifier: nil, contacts: ["+30 210 1234567", "support@verifier.example", "https://verifier.example/erasure"]),
      intermediary: nil, registration: nil,
      claimsRequested: [],
      claimsPresented: [.init(credential: .init(identifier: .mDocPid), claims: [])]
    )

    // When
    let ui = presentation.toActionUiModel(transactionId: "1", action: .requestDataDeletion)

    // Then
    XCTAssertEqual(ui.contacts.map(\.channel), [.website, .email, .phone])
    guard case .confirmation(let content) = ui.content else {
      return XCTFail("Expected the confirmation layout for a deletion request.")
    }
    XCTAssertEqual(content.intro, .transactionActionDeletionIntroWebsite(["Verifier"]))
    XCTAssertEqual(content.contact?.channel, .website)
    XCTAssertEqual(content.buttonTitle, .transactionActionContinueWebsite(["Verifier"]))
  }

  func testDeletionScreen_WhenThereIsNoWebsite_ThenEmailIsPreferredOverPhone() {
    // Given
    let presentation = TransactionLogDomain.Presentation(
      id: "1", time: time, result: .completed,
      party: .init(name: "Verifier", identifier: nil, contacts: ["+30 210 1234567", "support@verifier.example"]),
      intermediary: nil, registration: nil,
      claimsRequested: [],
      claimsPresented: [.init(credential: .init(identifier: .mDocPid), claims: [])]
    )

    // When
    let ui = presentation.toActionUiModel(transactionId: "1", action: .requestDataDeletion)

    // Then
    guard case .confirmation(let content) = ui.content else {
      return XCTFail("Expected the confirmation layout for a deletion request.")
    }
    XCTAssertEqual(content.contact?.channel, .email)
    XCTAssertEqual(content.buttonTitle, .transactionActionContinueEmail)
  }

  func testDeletionScreen_WhenOnlyAPhoneExists_ThenItIsUsed() {
    // Given
    let presentation = TransactionLogDomain.Presentation(
      id: "1", time: time, result: .completed,
      party: .init(name: "Verifier", identifier: nil, contacts: ["+30 210 1234567"]),
      intermediary: nil, registration: nil,
      claimsRequested: [],
      claimsPresented: [.init(credential: .init(identifier: .mDocPid), claims: [])]
    )

    // When
    let ui = presentation.toActionUiModel(transactionId: "1", action: .requestDataDeletion)

    // Then
    guard case .confirmation(let content) = ui.content else {
      return XCTFail("Expected the confirmation layout for a deletion request.")
    }
    XCTAssertEqual(content.contact?.channel, .phone)
    XCTAssertEqual(content.buttonTitle, .transactionActionContinuePhone(["Verifier"]))
    XCTAssertEqual(content.intro, .transactionActionDeletionIntroPhone(["Verifier"]))
  }

  func testDeletionScreen_WhenNoContactIsRecorded_ThenTheButtonIsDisabled() {
    // Given
    let presentation = TransactionLogDomain.Presentation(
      id: "1", time: time, result: .completed,
      party: .init(name: "Verifier", identifier: nil, contacts: []),
      intermediary: nil, registration: nil,
      claimsRequested: [],
      claimsPresented: [.init(credential: .init(identifier: .mDocPid), claims: [])]
    )

    // When
    let ui = presentation.toActionUiModel(transactionId: "1", action: .requestDataDeletion)

    // Then
    guard case .confirmation(let content) = ui.content else {
      return XCTFail("Expected the confirmation layout for a deletion request.")
    }
    XCTAssertNil(content.contact)
    XCTAssertNil(content.notice)
    XCTAssertEqual(content.intro, .transactionDetailsActionUnavailable)
    XCTAssertEqual(content.buttonTitle, .continueButton)
  }

  func testWithMailContent_WhenMailto_ThenSubjectAndBodyAreEncoded() {
    // When
    let url = URL(string: "mailto:support@verifier.example")!.withMailContent(subject: "Request — A+B", body: "Line 1\nLine 2")
    let unchanged = URL(string: "https://dpa.example")!.withMailContent(subject: "s", body: "b")

    // Then
    XCTAssertEqual(url.scheme, "mailto")
    XCTAssertTrue(url.absoluteString.hasPrefix("mailto:support@verifier.example?subject="))
    XCTAssertTrue(url.absoluteString.contains("A%2BB"))
    XCTAssertTrue(url.absoluteString.contains("Line%201%0ALine%202"))
    XCTAssertEqual(unchanged, URL(string: "https://dpa.example"))
  }

  func testToUiModel_WhenPresentationHasRegistration_ThenRelyingPartyAndAuthoritySectionsAreFilled() {
    // Given
    let log = TransactionLogDomain.presentation(
      .init(
        id: "1", time: time, result: .completed,
        party: .init(name: "Verifier", identifier: .init(schemeUri: "scheme", value: "123"), contacts: ["support@verifier.example", "+30 210 1234567"]),
        intermediary: .init(name: "Broker", identifier: nil, contacts: []),
        registration: .init(registrarUrl: "https://registry.example", purpose: "Age check", privacyPolicyUrls: ["https://verifier.example/privacy"], dpa: .init(name: "DPA", country: "GR", contacts: ["dpa@example.org"])),
        claimsRequested: [.init(credential: .init(identifier: .mDocPid), claims: [])],
        claimsPresented: [],
        registrationCheck: .verified
      )
    )

    // When
    let ui = log.toUiModel()

    // Then
    XCTAssertEqual(ui.sections.map(\.id), ["requested", "shared"])
    let groups = ui.transactionDetailsCardData.details
    XCTAssertEqual(
      groups.map { $0.map(\.id) },
      [
        ["party:purpose"],
        ["party:privacy:0"],
        ["party:contact:0", "party:contact:1"],
        ["intermediary:name"]
      ]
    )
    XCTAssertEqual(groups[1][0].url, URL(string: "https://verifier.example/privacy"))
    XCTAssertEqual(groups[2][0].url, URL(string: "mailto:support@verifier.example"))
    XCTAssertEqual(groups[2][1].url, URL(string: "tel:+302101234567"))
    XCTAssertEqual(groups[3][0].listItem.overlineText, .transactionDetailsIntermediaryNameLabel)
    XCTAssertEqual(ui.sections[0].groups.first?.listItems.first?.title, LocalizableStringKey.transactionDetailsNoClaims.toString)
    XCTAssertTrue(ui.sections[1].isEmpty)
  }
}

private extension TestTransactionLogUi {
  func sharedPresentation(registrationCheck: RecordedRegistrationCheck?) -> TransactionLogDomain.Presentation {
    TransactionLogDomain.Presentation(
      id: "1", time: time, result: .completed,
      party: .init(name: "Verifier", identifier: nil, contacts: ["support@verifier.example"]),
      intermediary: nil,
      registration: .init(registrarUrl: nil, purpose: nil, privacyPolicyUrls: [], dpa: .init(name: "DPA", country: nil, contacts: ["https://dpa.example"])),
      claimsRequested: [],
      claimsPresented: [.init(credential: .init(identifier: .mDocPid), claims: [])],
      registrationCheck: registrationCheck
    )
  }
}
