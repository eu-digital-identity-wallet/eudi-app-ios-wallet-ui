/*
 * Copyright (c) 2025 European Commission
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
  public let credentialIssuerIdentifier: String
  public let documentState: DocumentState

  public init(
    issuerName: LocalizableStringKey,
    issuerLogo: URL?,
    credentialIssuerIdentifier: String,
    documentState: DocumentState,
  ) {
    self.issuerName = issuerName
    self.issuerLogo = issuerLogo
    self.credentialIssuerIdentifier = credentialIssuerIdentifier
    self.documentState = documentState
  }

  var expandedMessageText: LocalizableStringKey {
    switch documentState {
    case .issued:
      return .documentDetailsIssuerCardIssuedMessageText
    case .revoked:
      return .documentDetailsIssuerCardRevokedMessageText
    }
  }

  var expandedActionButtonText: LocalizableStringKey? {
    switch documentState {
    case .issued:
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
    }
  }

  var dateTextColor: Color {
    switch documentState {
    case .issued:
      return Theme.shared.color.onSurfaceVariant
    case .revoked:
      return Theme.shared.color.error
    }
  }

  var expandedDateText: LocalizableStringKey? {
    switch documentState {
    case .issued(let issuanceDate, _):
      guard let date = issuanceDate else { return nil }
      return .documentDetailsIssuedOn([date])
    case .revoked:
      return nil
    }
  }

  public enum DocumentState: Equatable, Sendable {
    case issued(issuanceDate: String?, expirationDate: String?)
    case revoked
  }
}

public extension DocClaimsDecodable {
  func transformToIssuerDetailsCardDataUi(
    isRevoked: Bool
  ) -> IssuerDocumentDetailsCardUIModel {
    let documentState: IssuerDocumentDetailsCardUIModel.DocumentState
    if isRevoked {
      documentState = .revoked
    } else {
      documentState = .issued(
        issuanceDate: self.createdAt.formattedForDocumentDetails(),
        expirationDate: self.getExpiryDate(parser: {
          Locale.current.localizedDateTime(date: $0, uiFormatter: "dd MMM yyyy")
        }) ?? ""
      )
    }

    return .init(
      issuerName: .custom(self.issuerName),
      issuerLogo: self.issuerLogo,
      credentialIssuerIdentifier: self.credentialIssuerIdentifier.orEmpty,
      documentState: documentState
    )
  }
}
