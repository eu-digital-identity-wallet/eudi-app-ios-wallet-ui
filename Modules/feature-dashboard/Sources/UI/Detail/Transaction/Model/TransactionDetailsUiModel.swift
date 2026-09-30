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
import Foundation
import logic_ui
import logic_core
import logic_business
import logic_resources

public struct TransactionDetailsUiModel: Equatable, Identifiable, Sendable {

  public let id: String
  public let transactionDetailsCardData: TransactionDetailsCardData
  public let sections: [TransactionDetailsSectionUi]
  public let presentationActions: TransactionPresentationActionsUi?

  public var showsPresentationActions: Bool {
    presentationActions != nil
  }
}

public struct TransactionDetailsSectionUi: Equatable, Identifiable, Sendable {
  public let id: String
  public let title: LocalizableStringKey
  public let fields: [TransactionDetailsFieldUi]
  public let groups: [GenericListItemSection]
  public let emptyText: LocalizableStringKey

  public var isEmpty: Bool {
    fields.isEmpty && groups.isEmpty
  }
}

public struct TransactionDetailsFieldUi: Equatable, Identifiable, Sendable {
  public let id: String
  public let listItem: ListItemData
  public let url: URL?
}

extension TransactionDetailsUiModel {
  static func mock() -> TransactionDetailsUiModel {
    TransactionDetailsUiModel(
      id: "id",
      transactionDetailsCardData: TransactionDetailsCardData.mock(),
      sections: [
        .init(
          id: "requested",
          title: .transactionDetailsDataRequested,
          fields: [],
          groups: [.init(id: "pid", title: "PID", listItems: [])],
          emptyText: .transactionDetailsNoDataRequested
        )
      ],
      presentationActions: .init(deletionContacts: [], reportContacts: [], dataDeletionRequests: 0, dpaReports: 0)
    )
  }
}

private struct CardParty {
  let type: String?
  let details: [[TransactionDetailsFieldUi]]
}

extension TransactionLogDomain {
  func toUiModel(actions: [TransactionLogDomain] = []) -> TransactionDetailsUiModel {
    .init(
      id: id,
      transactionDetailsCardData: toCardData(),
      sections: toSections(),
      presentationActions: {
        guard case .presentation(let presentation) = self else { return nil }
        return .init(
          deletionContacts: presentation.contacts(for: .requestDataDeletion),
          reportContacts: presentation.contacts(for: .reportSuspiciousTransaction),
          dataDeletionRequests: actions.filter { if case .dataDeletionRequest = $0 { true } else { false } }.count,
          dpaReports: actions.filter { if case .dpaReport = $0 { true } else { false } }.count
        )
      }()
    )
  }

  private func toCardData() -> TransactionDetailsCardData {
    let status = transactionStatus
    let reason: String? = if case .notCompleted(let reason) = result { reason } else { nil }
    let party = cardParty
    return .init(
      transactionTypeLabel: transactionType.typeTitle,
      transactionStatusLabel: status.statusTitle,
      transactionIsCompleted: status == .completed,
      transactionDate: .custom(time.formattedTimestamp().toString),
      partyName: partyName.map { .custom($0) },
      partyType: party.type.map { .custom($0) },
      nonCompletionReason: reason?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false
        ? .custom(reason!)
        : nil,
      details: party.details
    )
  }

  private var cardParty: CardParty {
    switch self {
    case .presentation(let log):
      let purpose = TransactionDetailsFieldUi.purposeFields(log.registration)
      let policies = TransactionDetailsFieldUi.privacyPolicyFields(log.registration)
      let contacts = TransactionDetailsFieldUi.contactFields(log.party, prefix: "party")
      let intermediary = log.intermediary.map { TransactionDetailsFieldUi.intermediaryFields($0) } ?? []
      let groups = [purpose, policies, contacts, intermediary].filter { !$0.isEmpty }
      return .init(type: log.party.type, details: groups)
    case .credentialIssuance(let log):
      let counts = TransactionDetailsFieldUi.countFields(log.details)
      let contacts = TransactionDetailsFieldUi.contactFields(log.details.issuer, prefix: "issuer")
      return .init(type: log.details.issuer.type, details: [counts, contacts].filter { !$0.isEmpty })
    case .credentialReissuance(let log):
      let counts = TransactionDetailsFieldUi.countFields(log.details)
      let trigger = TransactionDetailsFieldUi.triggerFields(log.details.isUserTriggered)
      let contacts = TransactionDetailsFieldUi.contactFields(log.details.issuer, prefix: "issuer")
      return .init(type: log.details.issuer.type, details: [counts, trigger, contacts].filter { !$0.isEmpty })
    case .credentialDeletion(let log):
      return .init(type: log.issuer.type, details: [])
    case .signingSealing(let log):
      let identifier = TransactionDetailsFieldUi.signingIdentifierFields(log.signingTransactionIdentifier)
      return .init(type: log.service.type, details: [identifier].filter { !$0.isEmpty })
    case .dataDeletionRequest:
      return .init(type: nil, details: [])
    case .dpaReport:
      return .init(type: nil, details: [])
    }
  }

  private func toSections() -> [TransactionDetailsSectionUi] {
    switch self {
    case .presentation(let log):
      return [
        .claims(id: "requested", title: .transactionDetailsDataRequested, claims: log.claimsRequested, emptyText: .transactionDetailsNoDataRequested),
        .claims(id: "shared", title: .transactionDetailsDataShare, claims: log.claimsPresented, emptyText: .transactionDetailsNoDataShared)
      ]
    case .credentialIssuance(let log):
      return TransactionDetailsSectionUi.credentialList(log.details.credentials, title: .transactionDetailsCredentialsIssuedSection)
    case .credentialReissuance(let log):
      return TransactionDetailsSectionUi.credentialList(log.details.credentials, title: .transactionDetailsCredentialsIssuedSection)
    case .credentialDeletion(let log):
      return TransactionDetailsSectionUi.credentialList([log.credential], title: .transactionDetailsCredentialsSection)
    case .signingSealing(let log):
      return TransactionDetailsSectionUi.signing(log)
    case .dataDeletionRequest(let log):
      return [
        .claims(id: "deletion", title: .transactionDetailsDataDeletionSection, claims: log.claims, emptyText: .transactionDetailsNoDataRequested)
      ]
    case .dpaReport:
      return []
    }
  }
}

extension TransactionDetailsSectionUi {
  static func credentialList(
    _ credentials: [CredentialRefDomain],
    title: LocalizableStringKey
  ) -> [TransactionDetailsSectionUi] {
    let rows = credentials.filter { !$0.identifier.rawValue.isBlankValue }
    guard !rows.isEmpty else { return [] }
    return [
      .init(
        id: "credentials",
        title: title,
        fields: rows.enumerated().map { index, credential in
          .field(id: "credentials:\(index)", label: nil, value: credential.identifier.rawValue)
        },
        groups: [],
        emptyText: .transactionDetailsNoInformation
      )
    ]
  }

  static func claims(
    id: String,
    title: LocalizableStringKey,
    claims: [CredentialClaimsDomain],
    emptyText: LocalizableStringKey
  ) -> TransactionDetailsSectionUi {
    .init(
      id: id,
      title: title,
      fields: [],
      groups: claims.enumerated().map { index, credentialClaims in
        let groupId = "\(id):\(index)"
        let items: [ListItemData] = credentialClaims.claims.isEmpty
          ? [.init(id: "\(groupId):empty", mainContent: .text(.transactionDetailsNoClaims))]
          : credentialClaims.claims.enumerated().map { claimIndex, claim in
            .init(id: "\(groupId):\(claimIndex)", mainContent: .text(claim.identifierPath))
          }
        return .init(
          id: groupId,
          title: credentialClaims.credential.identifier.rawValue,
          listItems: items.map { .single(.init(collapsed: $0, domainModel: nil)) }
        )
      },
      emptyText: emptyText
    )
  }

  static func signing(_ log: TransactionLogDomain.SigningSealing) -> [TransactionDetailsSectionUi] {
    guard let fileName = log.fileName, !fileName.isBlankValue else { return [] }
    return [
      .init(
        id: "document",
        title: .transactionDetailsDataSigned,
        fields: [.field(id: "document:name", label: .transactionDetailsFilenameLabel, value: fileName)],
        groups: [],
        emptyText: .transactionDetailsNoInformation
      )
    ]
  }
}

extension TransactionDetailsFieldUi {

  static func contactFields(
    _ party: InteractingPartyDomain,
    prefix: String,
    label: LocalizableStringKey = .transactionDetailsContactLabel
  ) -> [TransactionDetailsFieldUi] {
    party.contacts.enumerated().compactMap { index, contact in
      guard !contact.isBlankValue else { return nil }
      return .field(id: "\(prefix):contact:\(index)", label: label, value: contact, url: contact.contactUrl)
    }
  }

  static func intermediaryFields(_ party: InteractingPartyDomain) -> [TransactionDetailsFieldUi] {
    var fields: [TransactionDetailsFieldUi] = []
    if let name = party.name, !name.isBlankValue {
      fields.append(.field(id: "intermediary:name", label: .transactionDetailsIntermediaryNameLabel, value: name))
    }
    fields.append(
      contentsOf: contactFields(party, prefix: "intermediary", label: .transactionDetailsIntermediaryContactLabel)
    )
    return fields
  }

  static func purposeFields(_ registration: PresentationRegistrationDomain?) -> [TransactionDetailsFieldUi] {
    guard let purpose = registration?.purpose, !purpose.isBlankValue else { return [] }
    return [.field(id: "party:purpose", label: .transactionDetailsPurposeLabel, value: purpose)]
  }

  static func privacyPolicyFields(_ registration: PresentationRegistrationDomain?) -> [TransactionDetailsFieldUi] {
    (registration?.privacyPolicyUrls ?? []).enumerated().compactMap { index, policy in
      guard !policy.isBlankValue else { return nil }
      return .field(id: "party:privacy:\(index)", label: .transactionDetailsPrivacyPolicyLabel, value: policy, url: policy.webUrl)
    }
  }

  static func countFields(_ details: IssuanceDetailsDomain) -> [TransactionDetailsFieldUi] {
    [
      .field(id: "issuance:requested", label: .transactionDetailsRequestedCountLabel, value: String(details.requestedCount)),
      .field(id: "issuance:issued", label: .transactionDetailsIssuedCountLabel, value: String(details.issuedCount))
    ]
  }

  static func triggerFields(_ isUserTriggered: Bool?) -> [TransactionDetailsFieldUi] {
    guard let isUserTriggered else { return [] }
    let value: LocalizableStringKey = isUserTriggered ? .transactionDetailsRequestedByYou : .transactionDetailsRenewedByWallet
    return [.field(id: "issuance:trigger", label: .transactionDetailsTriggerLabel, value: value.toString)]
  }

  static func signingIdentifierFields(_ identifier: String?) -> [TransactionDetailsFieldUi] {
    guard let identifier, !identifier.isBlankValue else { return [] }
    return [.field(id: "signing:identifier", label: .transactionDetailsSigningIdentifierLabel, value: identifier)]
  }

  static func field(id: String, label: LocalizableStringKey?, value: String, url: URL? = nil) -> TransactionDetailsFieldUi {
    .init(
      id: id,
      listItem: .init(
        id: id,
        mainContent: .text(.custom(value)),
        overlineText: label,
        mainTextColor: url != nil ? Theme.shared.color.accent : Theme.shared.color.primaryLabel,
        trailingContent: url != nil ? .icon(Theme.shared.image.arrowUpRightSquare) : nil
      ),
      url: url
    )
  }
}

extension ClaimRefDomain {
  var identifierPath: LocalizableStringKey {
    guard !segments.isEmpty else { return .transactionDetailsUnknownClaim }
    let path = segments.map { segment in
      switch segment {
      case .key(let name):
        "[\"\(name.replacingOccurrences(of: "\\", with: "\\\\").replacingOccurrences(of: "\"", with: "\\\""))\"]"
      case .index(let index):
        "[\(index)]"
      case .allElements:
        "[*]"
      }
    }.joined()
    return .custom(path)
  }
}
