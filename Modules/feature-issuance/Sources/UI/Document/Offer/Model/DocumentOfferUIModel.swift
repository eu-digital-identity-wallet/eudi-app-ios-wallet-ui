/*
 * Copyright (c) 2023 European Commission
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
import logic_business
import logic_resources

public struct DocumentOfferUIModel: Identifiable {

  @EquatableNoop
  public var id: String

  public let issuerName: String
  public let uiOffers: [UIOffer]
  public let docOffers: [OfferedDocModel]

  public init(
    id: String = UUID().uuidString,
    issuerName: String,
    uiOffers: [UIOffer],
    docOffers: [OfferedDocModel]
  ) {
    self.id = id
    self.issuerName = issuerName
    self.uiOffers = uiOffers
    self.docOffers = docOffers
  }
}

public extension DocumentOfferUIModel {
  struct UIOffer: Identifiable {

    @EquatableNoop
    public var id: String

    public let documentName: String
    public let documentType: DocumentTypeIdentifier

    var title: String {
      if documentType.isSupported {
        return documentType.localizedTitle
      }
      return documentName
    }

    public init(
      id: String = UUID().uuidString,
      documentName: String,
      documentType: DocumentTypeIdentifier
    ) {
      self.id = id
      self.documentName = documentName
      self.documentType = documentType
    }
  }
}

public extension DocumentOfferUIModel {
  static func mock() -> DocumentOfferUIModel {
    return .init(
      id: UUID().uuidString,
      issuerName: LocalizableString.shared.get(with: .unknownIssuer),
      uiOffers: [
        .init(
          id: UUID().uuidString,
          documentName: "Document Name",
          documentType: .GENERIC(docType: "")
        ),
        .init(
          id: UUID().uuidString,
          documentName: "Document Name",
          documentType: .GENERIC(docType: "")
        ),
        .init(
          id: UUID().uuidString,
          documentName: "Document Name",
          documentType: .GENERIC(docType: "")
        ),
        .init(
          id: UUID().uuidString,
          documentName: "Document Name",
          documentType: .GENERIC(docType: "")
        ),
        .init(
          id: UUID().uuidString,
          documentName: "Document Name",
          documentType: .GENERIC(docType: "")
        )
      ],
      docOffers: []
    )
  }
}

extension Array where Element == OfferedDocModel {
  func transformToDocumentOfferUi() -> DocumentOfferUIModel {

    var issuer: String = LocalizableString.shared.get(with: .unknownIssuer)
    var offers: [DocumentOfferUIModel.UIOffer] = []

    self.forEach { doc in
      issuer = doc.issuerName
      offers.append(
        .init(
          documentName: doc.displayName,
          documentType: DocumentTypeIdentifier(rawValue: doc.docType)
        )
      )
    }

    return .init(
      issuerName: issuer,
      uiOffers: offers,
      docOffers: self
    )
  }
}
