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
import logic_core
import logic_resources
import logic_ui

public struct TransactionActionUiModel: Equatable, Sendable {
  public let transactionId: String
  public let action: TransactionDataProtectionAction
  public let title: LocalizableStringKey
  public let content: Content
  public let contacts: [TransactionActionContactUi]

  public enum Content: Equatable, Sendable {
    case confirmation(ConfirmationUi)
    case contactList(ContactListUi)
  }

  public struct ConfirmationUi: Equatable, Sendable {
    public let intro: LocalizableStringKey?
    public let noticeBold: LocalizableStringKey
    public let notice: LocalizableStringKey?
    public let legal: LocalizableStringKey?
    public let buttonTitle: LocalizableStringKey
    public let contact: TransactionActionContactUi?
  }

  public struct ContactListUi: Equatable, Sendable {
    public let partyLabel: LocalizableStringKey
    public let partyName: LocalizableStringKey?
    public let messageBold: LocalizableStringKey
    public let message: LocalizableStringKey
    public let followUp: LocalizableStringKey
  }
}

public struct TransactionActionContactUi: Identifiable, Equatable, Sendable {
  public let channel: TransactionActionChannel
  public let label: String
  public let url: URL

  public var id: String { url.absoluteString }
}

extension TransactionActionChannel {

  var icon: Image {
    switch self {
    case .phone: Theme.shared.image.phone
    case .email: Theme.shared.image.envelope
    case .website: Theme.shared.image.link
    }
  }

  var actionTitle: LocalizableStringKey {
    switch self {
    case .phone: .transactionActionCall
    case .email: .transactionActionOpenEmail
    case .website: .transactionActionVisitWebsite
    }
  }

  var historyTitle: LocalizableStringKey {
    switch self {
    case .phone: .transactionHistoryChannelPhone
    case .email: .transactionHistoryChannelEmail
    case .website: .transactionHistoryChannelWebsite
    }
  }

  func continueTitle(party: String?) -> LocalizableStringKey {
    switch self {
    case .phone: party.map { .transactionActionContinuePhone([$0]) } ?? .continueButton
    case .email: .transactionActionContinueEmail
    case .website: party.map { .transactionActionContinueWebsite([$0]) } ?? .continueButton
    }
  }

  func deletionIntro(party: String) -> LocalizableStringKey {
    switch self {
    case .phone: .transactionActionDeletionIntroPhone([party])
    case .email: .transactionActionDeletionIntroEmail([party])
    case .website: .transactionActionDeletionIntroWebsite([party])
    }
  }

  var deletionNotice: LocalizableStringKey {
    switch self {
    case .phone: .transactionActionDeletionNoticePhone
    case .email: .transactionActionDeletionNoticeEmail
    case .website: .transactionActionDeletionNoticeWebsite
    }
  }
}

extension TransactionActionUiModel {
  static func mock() -> TransactionActionUiModel {
    .init(
      transactionId: "id",
      action: .reportSuspiciousTransaction,
      title: .transactionActionReportTitle,
      content: .contactList(
        .init(
          partyLabel: .transactionActionAuthorityLabel,
          partyName: .custom("Data protection authority"),
          messageBold: .transactionActionReportMessageBold,
          message: .transactionActionReportMessage(["the authority"]),
          followUp: .transactionActionReportFollowUp(["the authority"])
        )
      ),
      contacts: []
    )
  }
}

extension TransactionLogDomain.Presentation {

  func toActionUiModel(transactionId: String, action: TransactionDataProtectionAction) -> TransactionActionUiModel {
    let contacts = contacts(for: action).compactMap { contact in
      TransactionActionChannel(url: contact.url).map {
        TransactionActionContactUi(channel: $0, label: contact.label, url: contact.url)
      }
    }
    switch action {
    case .requestDataDeletion:
      let name = party.name?.nonBlankValue
      let preferred = contacts.first
      let intro: LocalizableStringKey? = if let preferred {
        name.map { preferred.channel.deletionIntro(party: $0) }
      } else {
        .transactionDetailsActionUnavailable
      }
      return .init(
        transactionId: transactionId,
        action: action,
        title: .transactionActionDeletionScreenTitle,
        content: .confirmation(
          .init(
            intro: intro,
            noticeBold: .transactionActionDeletionNoticeBold,
            notice: preferred?.channel.deletionNotice,
            legal: name.map { .transactionActionDeletionLegal([$0, $0]) },
            buttonTitle: preferred.map { $0.channel.continueTitle(party: name) } ?? .continueButton,
            contact: preferred
          )
        ),
        contacts: contacts
      )
    case .reportSuspiciousTransaction:
      let name = registration?.dpa?.name?.nonBlankValue
      return .init(
        transactionId: transactionId,
        action: action,
        title: .transactionActionReportTitle,
        content: .contactList(
          .init(
            partyLabel: .transactionActionAuthorityLabel,
            partyName: name.map { .custom($0) },
            messageBold: .transactionActionReportMessageBold,
            message: name.map { .transactionActionReportMessage([$0]) } ?? .transactionActionReportMessageNoAuthority,
            followUp: name.map { .transactionActionReportFollowUp([$0]) } ?? .transactionActionReportFollowUpNoAuthority
          )
        ),
        contacts: contacts
      )
    }
  }
}
