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

public struct TransactionContactUi: Identifiable, Equatable, Sendable {
  public let label: String
  public let url: URL

  public var id: String { url.absoluteString }
}

public struct TransactionPresentationActionsUi: Equatable, Sendable {
  public let deletionContacts: [TransactionContactUi]
  public let reportContacts: [TransactionContactUi]
  public let dataDeletionRequests: Int
  public let dpaReports: Int

  func contacts(for action: TransactionDataProtectionAction) -> [TransactionContactUi] {
    switch action {
    case .requestDataDeletion: deletionContacts
    case .reportSuspiciousTransaction: reportContacts
    }
  }
}

extension TransactionLogDomain.Presentation {
  func contacts(for action: TransactionDataProtectionAction) -> [TransactionContactUi] {
    let sources: [String] = switch action {
    case .requestDataDeletion:
      claimsPresented.isEmpty ? [] : party.contacts
    case .reportSuspiciousTransaction:
      registration?.dpa?.contacts ?? []
    }
    return sources.reduce(into: [TransactionContactUi]()) { unique, contact in
      guard let url = contact.contactUrl, !unique.contains(where: { $0.url == url }) else { return }
      unique.append(.init(label: contact.trimmingCharacters(in: .whitespacesAndNewlines), url: url))
    }.sorted { $0.url.channelOrder < $1.url.channelOrder }
  }

  var partyIdentity: String {
    [party.name, party.identifier?.value, party.identifier?.schemeUri]
      .compactMap { $0 }
      .joined(separator: "\n")
  }
}

extension String {
  var isBlankValue: Bool {
    trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
  }

  var nonBlankValue: String? {
    isBlankValue ? nil : self
  }

  var webUrl: URL? {
    guard
      let url = URL(string: self),
      let scheme = url.scheme?.lowercased(),
      ["http", "https"].contains(scheme),
      url.host != nil
    else {
      return nil
    }
    return url
  }

  var contactUrl: URL? {
    if let webUrl { return webUrl }
    let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
    if trimmed.range(of: #"^[^@\s]+@[^@\s]+\.[^@\s]+$"#, options: .regularExpression) != nil {
      return URL(string: "mailto:\(trimmed)")
    }
    if trimmed.range(of: #"^\+?[0-9 ()./-]{6,}$"#, options: .regularExpression) != nil {
      let digits = trimmed.filter { $0.isNumber || $0 == "+" }
      return URL(string: "tel:\(digits)")
    }
    return nil
  }
}

extension URL {
  func withMailContent(subject: String, body: String) -> URL {
    guard scheme?.lowercased() == "mailto" else { return self }
    var components = URLComponents()
    components.scheme = "mailto"
    components.path = absoluteString.dropFirst("mailto:".count).description
    components.queryItems = [
      .init(name: "subject", value: subject),
      .init(name: "body", value: body)
    ]
    components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
    return components.url ?? self
  }
}

private extension URL {
  var channelOrder: Int {
    switch TransactionActionChannel(url: self) {
    case .website: 0
    case .email: 1
    case .phone: 2
    case nil: 3
    }
  }
}
