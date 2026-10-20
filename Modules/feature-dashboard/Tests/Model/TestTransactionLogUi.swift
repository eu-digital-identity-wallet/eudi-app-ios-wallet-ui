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

  func testTransformToTransactionUI_WhenPresentation_ThenUsesPartyNameAndType() {
    let ui = Constants.eudiRemoteVerifierMock.transformToTransactionUI()

    XCTAssertEqual(ui?.id, "transactionId1")
    XCTAssertEqual(ui?.name, "EUDI Remote Verifier")
    XCTAssertEqual(ui?.status, .completed)
    XCTAssertEqual(ui?.transactionType, .presentation)
  }

  func testTransformToTransactionUI_WhenPresentationHasNoParty_ThenFallsBackToTypeLabel() {
    let log = TransactionLogDomain.presentation(
      .init(id: "1", time: time, result: .notCompleted(reason: nil), party: noParty, intermediary: nil, registration: nil, claimsRequested: [], claimsPresented: [])
    )

    let ui = log.transformToTransactionUI()

    XCTAssertEqual(ui?.name, TransactionType.presentation.typeTitle.toString)
    XCTAssertEqual(ui?.status, .notCompleted)
  }

  func testTransformToTransactionUI_WhenIssuanceHasNoIssuerName_ThenUsesCredentialIdentifier() {
    let log = TransactionLogDomain.credentialIssuance(
      .init(id: "2", time: time, result: .completed, details: .init(issuer: noParty, requestedCount: 1, issuedCount: 1, credentials: [.init(identifier: .sdJwtPid)], isUserTriggered: nil))
    )

    XCTAssertEqual(log.transformToTransactionUI()?.name, DocumentTypeIdentifier.sdJwtPid.rawValue)
    XCTAssertEqual(log.transformToTransactionUI()?.transactionType, .issuance)
  }

  func testTransformToTransactionUI_WhenReissuance_ThenTypeIsReissuance() {
    let log = TransactionLogDomain.credentialReissuance(
      .init(id: "3", time: time, result: .completed, details: .init(issuer: .init(name: "Issuer", identifier: nil, contacts: []), requestedCount: 1, issuedCount: 1, credentials: [], isUserTriggered: false))
    )

    XCTAssertEqual(log.transformToTransactionUI()?.name, "Issuer")
    XCTAssertEqual(log.transformToTransactionUI()?.transactionType, .reissuance)
  }

  func testTransformToTransactionUI_WhenDeletion_ThenTitleIsTheIssuer() {
    let log = TransactionLogDomain.credentialDeletion(
      .init(id: "4", time: time, result: .completed, credential: .init(identifier: .mDocPid), issuer: .init(name: "Issuer", identifier: nil, contacts: []))
    )

    XCTAssertEqual(log.transformToTransactionUI()?.name, "Issuer")
    XCTAssertEqual(log.transformToTransactionUI()?.transactionType, .deletion)
  }

  func testTransformToTransactionUI_WhenDeletionHasNoIssuerName_ThenUsesTheCredential() {
    let log = TransactionLogDomain.credentialDeletion(
      .init(id: "4", time: time, result: .completed, credential: .init(identifier: .mDocPid), issuer: noParty)
    )

    XCTAssertEqual(log.transformToTransactionUI()?.name, DocumentTypeIdentifier.mDocPid.rawValue)
    XCTAssertEqual(log.transformToTransactionUI()?.transactionType, .deletion)
  }

  func testTransformToTransactionUI_WhenSigningHasNoServiceName_ThenUsesFileName() {
    let log = TransactionLogDomain.signingSealing(
      .init(id: "5", time: time, result: .completed, service: noParty, signingTransactionIdentifier: nil, certificateSerialNumber: nil, fileName: "contract.pdf", fileSizeBytes: nil, dtbsr: nil)
    )

    XCTAssertEqual(log.transformToTransactionUI()?.name, "contract.pdf")
    XCTAssertEqual(log.transformToTransactionUI()?.transactionType, .signing)
  }

  func testTransformToTransactionUI_WhenPresentationAction_ThenHiddenFromList() {
    let request = TransactionLogDomain.dataDeletionRequest(
      .init(id: "6", time: time, result: .completed, parentPresentationId: "1", party: noParty, claims: [])
    )
    let report = TransactionLogDomain.dpaReport(
      .init(id: "7", time: time, result: .completed, parentPresentationId: "1", dpaName: "DPA", dpaCountry: nil)
    )

    XCTAssertNil(request.transformToTransactionUI())
    XCTAssertNil(report.transformToTransactionUI())
  }

  func testTransformToTransactionUI_WhenVisibleType_ThenCarriesTheExactInstant() {
    for log in allTransactionKinds where log.isVisibleInTransactionList {
      XCTAssertEqual(log.transformToTransactionUI()?.transactionDate, log.time)
    }
  }

  func testCategory_WhenAnyHourOfToday_ThenGroupsUnderToday() {
    let calendar = Calendar.current
    let startOfToday = calendar.startOfDay(for: Date())
    let startOfTomorrow = calendar.date(byAdding: .day, value: 1, to: startOfToday)!
    let lastSecondOfToday = calendar.date(byAdding: .second, value: -1, to: startOfTomorrow)!

    for instant in [startOfToday, Date(), lastSecondOfToday] {
      XCTAssertEqual(
        TransactionCategory.category(for: instant),
        .month(dateTime: LocalizableStringKey.today.toString)
      )
    }
  }

  func testCategory_WhenMonthsAgo_ThenLabelIsThatMonthWithoutAnyShift() {
    let old = Calendar.current.date(byAdding: .month, value: -3, to: Date())!

    XCTAssertEqual(
      TransactionCategory.category(for: old),
      .month(dateTime: Date.monthYearFormatter.string(from: old).uppercased())
    )
  }

  func testToCardData_WhenPartyHasAType_ThenItIsShownUnderTheName() {
    let log = TransactionLogDomain.presentation(
      .init(
        id: "1", time: time, result: .completed,
        party: .init(name: "Verifier", identifier: nil, contacts: [], type: "ServiceProvider"),
        intermediary: nil, registration: nil, claimsRequested: [], claimsPresented: []
      )
    )

    let card = log.toUiModel().transactionDetailsCardData

    XCTAssertEqual(card.partyName, .custom("Verifier"))
    XCTAssertEqual(card.partyType, .custom("ServiceProvider"))
  }

  func testToCardData_WhenPartyHasNoType_ThenTheLineIsOmitted() {
    let log = TransactionLogDomain.credentialDeletion(
      .init(id: "4", time: time, result: .completed, credential: .init(identifier: .mDocPid), issuer: noParty)
    )

    XCTAssertNil(log.toUiModel().transactionDetailsCardData.partyType)
  }

  func testSearchTags_WhenPresentationHasIntermediary_ThenBothNamesAreSearchable() {
    let log = TransactionLogDomain.presentation(
      .init(
        id: "1", time: time, result: .completed,
        party: .init(name: " Verifier ", identifier: nil, contacts: []),
        intermediary: .init(name: "Broker", identifier: nil, contacts: []),
        registration: nil, claimsRequested: [], claimsPresented: []
      )
    )

    XCTAssertEqual(log.searchTags, ["Verifier", "Broker"])
  }

  func testSearchTags_WhenSigning_ThenServiceAndFileNameAreSearchable() {
    let log = TransactionLogDomain.signingSealing(
      .init(id: "5", time: time, result: .completed, service: .init(name: "QTSP", identifier: nil, contacts: []), signingTransactionIdentifier: nil, certificateSerialNumber: nil, fileName: "contract.pdf", fileSizeBytes: nil, dtbsr: nil)
    )

    XCTAssertEqual(log.searchTags, ["QTSP", "contract.pdf"])
  }

  func testSearchTags_WhenDeletion_ThenIssuerAndAttestationTypeAreSearchable() {
    let log = TransactionLogDomain.credentialDeletion(
      .init(
        id: "6", time: time, result: .completed,
        credential: .init(identifier: .mDocPid),
        issuer: .init(name: "PID Issuer", identifier: nil, contacts: [])
      )
    )

    XCTAssertEqual(log.searchTags, ["PID Issuer", DocumentTypeIdentifier.mDocPid.rawValue])
  }

  func testSearchTags_WhenDeletionHasNoIssuerName_ThenAttestationTypeIsSearchable() {
    let log = TransactionLogDomain.credentialDeletion(
      .init(
        id: "7", time: time, result: .completed,
        credential: .init(identifier: .mDocPid),
        issuer: .init(name: nil, identifier: nil, contacts: [])
      )
    )

    XCTAssertEqual(log.searchTags, [DocumentTypeIdentifier.mDocPid.rawValue])
  }

  func testIdentifierPath_WhenSegmentsAreMixed_ThenRendersBracketedComponents() {
    let claim = ClaimRefDomain(segments: [.key(name: "addresses"), .allElements, .key(name: "street"), .index(2)])

    XCTAssertEqual(claim.identifierPath, .custom(#"["addresses"][*]["street"][2]"#))
    XCTAssertEqual(ClaimRefDomain(segments: []).identifierPath, .transactionDetailsUnknownClaim)
  }

  func testToUiModel_WhenIssuance_ThenShowsCountsContactsAndIssuedCredentials() {
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

    let ui = log.toUiModel()

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

    let ui = log.toUiModel()

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
    let log = TransactionLogDomain.credentialDeletion(
      .init(id: "4", time: time, result: .completed, credential: .init(identifier: .mDocPid), issuer: noParty)
    )

    let ui = log.toUiModel()

    XCTAssertEqual(ui.sections.map(\.title), [.transactionDetailsCredentialsSection])
    XCTAssertTrue(ui.transactionDetailsCardData.details.isEmpty)
  }

  func testToUiModel_WhenSigning_ThenOnlyTheFilenameAndSigningIdentifierRemain() {
    let log = TransactionLogDomain.signingSealing(
      .init(
        id: "5", time: time, result: .completed,
        service: .init(name: "QTSP", identifier: nil, contacts: ["support@qtsp.example"]),
        signingTransactionIdentifier: "sign-42", certificateSerialNumber: "serial",
        fileName: "contract.pdf", fileSizeBytes: 2048, dtbsr: "ZGlnZXN0"
      )
    )

    let ui = log.toUiModel()

    XCTAssertEqual(ui.sections.map(\.id), ["document"])
    XCTAssertEqual(ui.transactionDetailsCardData.details.map { $0.map(\.id) }, [["signing:identifier"]])
    XCTAssertEqual(ui.sections[0].fields.map(\.id), ["document:name"])
  }

  func testContacts_WhenNothingWasPresented_ThenDeletionCannotBeRequested() {
    let presentation = TransactionLogDomain.Presentation(
      id: "1", time: time, result: .notCompleted(reason: nil),
      party: .init(name: "Verifier", identifier: nil, contacts: ["support@verifier.example", "not a contact"]),
      intermediary: nil,
      registration: .init(registrarUrl: nil, purpose: nil, privacyPolicyUrls: [], dpa: .init(name: "DPA", country: nil, contacts: ["+30 210 1234567", "https://dpa.example"])),
      claimsRequested: [], claimsPresented: []
    )

    XCTAssertTrue(presentation.contacts(for: .requestDataDeletion).isEmpty)
    XCTAssertEqual(
      presentation.contacts(for: .reportSuspiciousTransaction).map(\.url),
      [URL(string: "https://dpa.example")!, URL(string: "tel:+302101234567")!]
    )
  }

  func testToActionUiModel_WhenContactsAreMixed_ThenKindsFollowTheUrlScheme() {
    let presentation = TransactionLogDomain.Presentation(
      id: "1", time: time, result: .completed,
      party: .init(name: "Verifier", identifier: nil, contacts: []),
      intermediary: nil,
      registration: .init(registrarUrl: nil, purpose: nil, privacyPolicyUrls: [], dpa: .init(name: "APD-GBA", country: "BE", contacts: ["+32 2 274 48 00", "contact@apd-gba.be", "https://www.autoriteprotectiondonnees.be"])),
      claimsRequested: [], claimsPresented: []
    )

    let ui = presentation.toActionUiModel(transactionId: "1", action: .reportSuspiciousTransaction)

    guard case .contactList(let content) = ui.content else {
      return XCTFail("Expected the contact list layout for a report.")
    }
    XCTAssertEqual(content.partyName, .custom("APD-GBA"))
    XCTAssertEqual(ui.contacts.map(\.channel), [.website, .email, .phone])
    XCTAssertEqual(ui.contacts.map(\.label), ["https://www.autoriteprotectiondonnees.be", "contact@apd-gba.be", "+32 2 274 48 00"])
    XCTAssertEqual(content.followUp, .transactionActionReportFollowUp(["APD-GBA"]))
  }

  func testReportScreen_WhenTheDpaHasNoName_ThenTheCardAndNamedTextsAreDropped() {
    let presentation = TransactionLogDomain.Presentation(
      id: "1", time: time, result: .completed,
      party: .init(name: "Verifier", identifier: nil, contacts: []),
      intermediary: nil,
      registration: .init(registrarUrl: nil, purpose: nil, privacyPolicyUrls: [], dpa: .init(name: nil, country: "BE", contacts: ["https://dpa.example"])),
      claimsRequested: [], claimsPresented: []
    )

    guard case .contactList(let content) = presentation.toActionUiModel(transactionId: "1", action: .reportSuspiciousTransaction).content else {
      return XCTFail("Expected the contact list layout for a report.")
    }
    XCTAssertNil(content.partyName)
    XCTAssertEqual(content.message, .transactionActionReportMessageNoAuthority)
    XCTAssertEqual(content.followUp, .transactionActionReportFollowUpNoAuthority)
    XCTAssertEqual(content.messageBold, .transactionActionReportMessageBold)
  }

  func testReportScreen_WhenTheDpaNameIsBlank_ThenItCountsAsMissing() {
    let presentation = TransactionLogDomain.Presentation(
      id: "1", time: time, result: .completed,
      party: .init(name: "Verifier", identifier: nil, contacts: []),
      intermediary: nil,
      registration: .init(registrarUrl: nil, purpose: nil, privacyPolicyUrls: [], dpa: .init(name: "   ", country: "BE", contacts: [])),
      claimsRequested: [], claimsPresented: []
    )

    guard case .contactList(let content) = presentation.toActionUiModel(transactionId: "1", action: .reportSuspiciousTransaction).content else {
      return XCTFail("Expected the contact list layout for a report.")
    }
    XCTAssertNil(content.partyName)
    XCTAssertEqual(content.message, .transactionActionReportMessageNoAuthority)
    XCTAssertEqual(content.followUp, .transactionActionReportFollowUpNoAuthority)
  }

  func testDeletionScreen_WhenThePartyHasNoName_ThenTheCardAndNamedTextsAreDropped() {
    let presentation = TransactionLogDomain.Presentation(
      id: "1", time: time, result: .completed,
      party: .init(name: nil, identifier: nil, contacts: ["https://verifier.example/erasure"]),
      intermediary: nil, registration: nil,
      claimsRequested: [],
      claimsPresented: [.init(credential: .init(identifier: .mDocPid), claims: [])]
    )

    guard case .confirmation(let content) = presentation.toActionUiModel(transactionId: "1", action: .requestDataDeletion).content else {
      return XCTFail("Expected the confirmation layout for a deletion request.")
    }
    XCTAssertNil(content.intro)
    XCTAssertNil(content.legal)
    XCTAssertEqual(content.contact?.channel, .website)
    XCTAssertEqual(content.buttonTitle, .continueButton)
    XCTAssertEqual(content.noticeBold, .transactionActionDeletionNoticeBold)
  }

  func testDeletionScreen_WhenThePartyHasNoNameAndEmailIsUsed_ThenTheButtonKeepsItsTitle() {
    let presentation = TransactionLogDomain.Presentation(
      id: "1", time: time, result: .completed,
      party: .init(name: nil, identifier: nil, contacts: ["support@verifier.example"]),
      intermediary: nil, registration: nil,
      claimsRequested: [],
      claimsPresented: [.init(credential: .init(identifier: .mDocPid), claims: [])]
    )

    guard case .confirmation(let content) = presentation.toActionUiModel(transactionId: "1", action: .requestDataDeletion).content else {
      return XCTFail("Expected the confirmation layout for a deletion request.")
    }
    XCTAssertNil(content.intro)
    XCTAssertEqual(content.buttonTitle, .transactionActionContinueEmail)
  }

  func testDeletionScreen_WhenThereIsNoNameAndNoContact_ThenTheUnavailableNoticeStays() {
    let presentation = TransactionLogDomain.Presentation(
      id: "1", time: time, result: .completed,
      party: .init(name: nil, identifier: nil, contacts: []),
      intermediary: nil, registration: nil,
      claimsRequested: [],
      claimsPresented: [.init(credential: .init(identifier: .mDocPid), claims: [])]
    )

    guard case .confirmation(let content) = presentation.toActionUiModel(transactionId: "1", action: .requestDataDeletion).content else {
      return XCTFail("Expected the confirmation layout for a deletion request.")
    }
    XCTAssertEqual(content.intro, .transactionDetailsActionUnavailable)
    XCTAssertNil(content.legal)
    XCTAssertEqual(content.buttonTitle, .continueButton)
  }

  func testContacts_WhenSeveralMethodsExist_ThenWebsiteComesFirstAndPhoneLast() {
    let presentation = TransactionLogDomain.Presentation(
      id: "1", time: time, result: .completed,
      party: .init(name: "Verifier", identifier: nil, contacts: ["+30 210 1234567", "support@verifier.example", "https://verifier.example/erasure"]),
      intermediary: nil, registration: nil,
      claimsRequested: [],
      claimsPresented: [.init(credential: .init(identifier: .mDocPid), claims: [])]
    )

    let ui = presentation.toActionUiModel(transactionId: "1", action: .requestDataDeletion)

    XCTAssertEqual(ui.contacts.map(\.channel), [.website, .email, .phone])
    guard case .confirmation(let content) = ui.content else {
      return XCTFail("Expected the confirmation layout for a deletion request.")
    }
    XCTAssertEqual(content.intro, .transactionActionDeletionIntroWebsite(["Verifier"]))
    XCTAssertEqual(content.contact?.channel, .website)
    XCTAssertEqual(content.buttonTitle, .transactionActionContinueWebsite(["Verifier"]))
  }

  func testDeletionScreen_WhenThereIsNoWebsite_ThenEmailIsPreferredOverPhone() {
    let presentation = TransactionLogDomain.Presentation(
      id: "1", time: time, result: .completed,
      party: .init(name: "Verifier", identifier: nil, contacts: ["+30 210 1234567", "support@verifier.example"]),
      intermediary: nil, registration: nil,
      claimsRequested: [],
      claimsPresented: [.init(credential: .init(identifier: .mDocPid), claims: [])]
    )

    guard case .confirmation(let content) = presentation.toActionUiModel(transactionId: "1", action: .requestDataDeletion).content else {
      return XCTFail("Expected the confirmation layout for a deletion request.")
    }
    XCTAssertEqual(content.contact?.channel, .email)
    XCTAssertEqual(content.buttonTitle, .transactionActionContinueEmail)
  }

  func testDeletionScreen_WhenOnlyAPhoneExists_ThenItIsUsed() {
    let presentation = TransactionLogDomain.Presentation(
      id: "1", time: time, result: .completed,
      party: .init(name: "Verifier", identifier: nil, contacts: ["+30 210 1234567"]),
      intermediary: nil, registration: nil,
      claimsRequested: [],
      claimsPresented: [.init(credential: .init(identifier: .mDocPid), claims: [])]
    )

    guard case .confirmation(let content) = presentation.toActionUiModel(transactionId: "1", action: .requestDataDeletion).content else {
      return XCTFail("Expected the confirmation layout for a deletion request.")
    }
    XCTAssertEqual(content.contact?.channel, .phone)
    XCTAssertEqual(content.buttonTitle, .transactionActionContinuePhone(["Verifier"]))
    XCTAssertEqual(content.intro, .transactionActionDeletionIntroPhone(["Verifier"]))
  }

  func testDeletionScreen_WhenNoContactIsRecorded_ThenTheButtonIsDisabled() {
    let presentation = TransactionLogDomain.Presentation(
      id: "1", time: time, result: .completed,
      party: .init(name: "Verifier", identifier: nil, contacts: []),
      intermediary: nil, registration: nil,
      claimsRequested: [],
      claimsPresented: [.init(credential: .init(identifier: .mDocPid), claims: [])]
    )

    guard case .confirmation(let content) = presentation.toActionUiModel(transactionId: "1", action: .requestDataDeletion).content else {
      return XCTFail("Expected the confirmation layout for a deletion request.")
    }
    XCTAssertNil(content.contact)
    XCTAssertNil(content.notice)
    XCTAssertEqual(content.intro, .transactionDetailsActionUnavailable)
    XCTAssertEqual(content.buttonTitle, .continueButton)
  }

  func testWithMailContent_WhenMailto_ThenSubjectAndBodyAreEncoded() {
    let url = URL(string: "mailto:support@verifier.example")!.withMailContent(subject: "Request — A+B", body: "Line 1\nLine 2")

    XCTAssertEqual(url.scheme, "mailto")
    XCTAssertTrue(url.absoluteString.hasPrefix("mailto:support@verifier.example?subject="))
    XCTAssertTrue(url.absoluteString.contains("A%2BB"))
    XCTAssertTrue(url.absoluteString.contains("Line%201%0ALine%202"))
    XCTAssertEqual(URL(string: "https://dpa.example")!.withMailContent(subject: "s", body: "b"), URL(string: "https://dpa.example"))
  }

  func testToUiModel_WhenPresentationHasRegistration_ThenRelyingPartyAndAuthoritySectionsAreFilled() {
    let log = TransactionLogDomain.presentation(
      .init(
        id: "1", time: time, result: .completed,
        party: .init(name: "Verifier", identifier: .init(schemeUri: "scheme", value: "123"), contacts: ["support@verifier.example", "+30 210 1234567"]),
        intermediary: .init(name: "Broker", identifier: nil, contacts: []),
        registration: .init(registrarUrl: "https://registry.example", purpose: "Age check", privacyPolicyUrls: ["https://verifier.example/privacy"], dpa: .init(name: "DPA", country: "GR", contacts: ["dpa@example.org"])),
        claimsRequested: [.init(credential: .init(identifier: .mDocPid), claims: [])],
        claimsPresented: []
      )
    )

    let ui = log.toUiModel()

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
