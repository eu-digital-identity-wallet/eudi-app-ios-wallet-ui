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
import SwiftUI
import logic_resources
import logic_core

public struct IssuerDocumentDetailsCardUIModel: Equatable, Sendable {

  public let issuerName: LocalizableStringKey
  public let issuerLogo: URL?
  public let documentState: DocumentState

  public init(
    issuerName: LocalizableStringKey,
    issuerLogo: URL?,
    documentState: DocumentState,
  ) {
    self.issuerName = issuerName
    self.issuerLogo = issuerLogo
    self.documentState = documentState
  }

  var expandedMessageText: LocalizableStringKey {
    switch documentState {
    case .issued:
      return .documentDetailsIssuerCardIssuedMessageText
    case .revoked:
      return .documentDetailsIssuerCardRevokedMessageText
    case .expired:
      return .documentDetailsIssuerCardExpiredMessageText
    }
  }

  var expandedActionButtonText: LocalizableStringKey? {
    switch documentState {
    case .issued, .expired:
      return .documentDetailsIssuerCardIssuedActionButtonText
    case .revoked:
      return nil
    }
  }

  var dateText: LocalizableStringKey? {
    switch documentState {
    case .issued(_, let expirationDate):
      guard let date = expirationDate else { return nil }
      return .documentDetailsExpiresOn([date])
    case .revoked:
      return .documentDetailsRevokedDocument
    case .expired(_, let expirationDate):
      guard let date = expirationDate else { return nil }
      return .documentDetailsExpiredOn([date])
    }
  }

  var dateTextColor: Color {
    switch documentState {
    case .issued:
      return Theme.shared.color.secondaryLabel
    case .revoked, .expired:
      return Theme.shared.color.red
    }
  }

  var expandedDateText: LocalizableStringKey? {
    switch documentState {
    case .issued(let issuanceDate, _), .expired(let issuanceDate, _):
      guard let date = issuanceDate else { return nil }
      return .documentDetailsIssuedOn([date])
    case .revoked:
      return nil
    }
  }

  public enum DocumentState: Equatable, Sendable {
    case issued(issuanceDate: String?, expirationDate: String?)
    case revoked
    case expired(issuanceDate: String?, expirationDate: String?)
  }
}

public extension DocClaimsDecodable {
  func transformToIssuerDetailsCardDataUi(
    isRevoked: Bool
  ) -> IssuerDocumentDetailsCardUIModel {
    let documentState: IssuerDocumentDetailsCardUIModel.DocumentState
    let issuanceDate = self.createdAt.formattedForDocumentDetails()
    let expirationDate = self.getExpiryDate(parser: {
      Locale.current.localizedDateTime(date: $0, uiFormatter: "dd MMM yyyy")
    }) ?? ""
    if isRevoked {
      documentState = .revoked
    } else if self.hasExpired {
      documentState = .expired(
        issuanceDate: issuanceDate,
        expirationDate: expirationDate
      )
    } else {
      documentState = .issued(
        issuanceDate: issuanceDate,
        expirationDate: expirationDate
      )
    }

    return .init(
      issuerName: .custom(self.issuerName),
      issuerLogo: self.issuerLogo,
      documentState: documentState
    )
  }
}
