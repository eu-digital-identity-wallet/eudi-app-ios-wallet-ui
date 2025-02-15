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
import SwiftUI
import logic_resources
import logic_business
import logic_core
import logic_ui

public struct DocumentDetailsUIModel: Equatable, Identifiable, Routable {

  public let id: String
  public let type: DocumentTypeIdentifier
  public let documentName: String
  public let issuer: IssuerField?
  public let createdAt: Date
  public let hasExpired: Bool
  public let documentFields: [ListItemData]

  public var log: String {
    "id: \(id), type: \(type.rawValue), name: \(documentName)"
  }
}

public extension DocumentDetailsUIModel {

  struct IssuerField: Identifiable, Sendable, Equatable {
    public let id: String
    public let name: String
    public let logoUrl: URL?
    public let isVerified: Bool

    public init(
      id: String = UUID().uuidString,
      issuersName: String,
      logoUrl: URL?,
      isVerified: Bool
    ) {
      self.id = id
      self.name = issuersName
      self.logoUrl = logoUrl
      self.isVerified = isVerified
    }
  }

  static func mock() -> DocumentDetailsUIModel {
    DocumentDetailsUIModel(
      id: UUID().uuidString,
      type: DocumentTypeIdentifier.mDocPid,
      documentName: "Digital ID",
      issuer: .init(
        id: UUID().uuidString,
        issuersName: "Digital Credential Service",
        logoUrl: URL(string: "https://www.example.com")!,
        isVerified: true
      ),
      createdAt: Date(),
      hasExpired: false,
      documentFields:
        [
          .init(
            mainText: .custom("AB12356"),
            overlineText: .custom("ID no")
          ),
          .init(
            mainText: .custom("Hellenic"),
            overlineText: .custom("Nationality")
          ),
          .init(
            mainText: .custom("21 Oct 1994"),
            overlineText: .custom("Place of birth")
          ),
          .init(
            mainText: .custom("1,82"),
            overlineText: .custom("Height")
          )
        ]
      +
      Array(
        count: 6,
        createElement: .init(
          mainText: .custom("Placeholder Field Value".padded(padLength: 10)),
          overlineText: .custom("Placeholder Field Title".padded(padLength: 5))
        )
      )
    )
  }
}

extension DocClaimsDecodable {
  func transformToDocumentDetailsUi(
    isSensitive: Bool = true
  ) -> DocumentDetailsUIModel {

    var issuer: DocumentDetailsUIModel.IssuerField? {
      guard !self.issuerName.isEmpty else {
        return nil
      }
      return .init(
        issuersName: self.issuerName,
        logoUrl: self.issuerLogo,
        isVerified: true
      )
    }

    let documentFields: [ListItemData] =
    flattenValues(
      isSensitive: isSensitive,
      input: docClaims
        .compactMap({$0})
        .parseDates(
          parser: {
            Locale.current.localizedDateTime(
              date: $0,
              uiFormatter: "dd MMM yyyy"
            )
          }
        )
        .parseUserPseudonym()
    )
    .sorted(by: {
      $0.mainText.toString.localizedCompare($1.mainText.toString) == .orderedAscending
    })

    var bearerName: String {
      guard let fullName = getBearersName() else {
        return ""
      }
      return "\(fullName.first) \(fullName.last)"
    }

    return .init(
      id: id,
      type: documentTypeIdentifier,
      documentName: displayName.orEmpty,
      issuer: issuer,
      createdAt: createdAt,
      hasExpired: hasExpired,
      documentFields: documentFields
    )
  }

  private func flattenValues(
    isSensitive: Bool = true,
    input: [DocClaim]
  ) -> [ListItemData] {
    input.reduce(into: []) { partialResult, docClaim in

      let uuid = UUID().uuidString
      let title = docClaim.displayName.ifNilOrEmpty { docClaim.name }

      if let uiImage = docClaim.dataValue.image {

        partialResult.append(
          .init(
            id: uuid,
            mainText: .custom(title),
            leadingIcon: .init(image: Image(uiImage: uiImage)),
            isBlur: isSensitive
          )
        )

      } else if let nested = docClaim.children {
        partialResult.append(
          .init(
            id: uuid,
            mainText: .custom(docClaim.flattenNested(nested: nested).stringValue),
            overlineText: .custom(title),
            isBlur: isSensitive
          )
        )
      } else {
        partialResult.append(
          .init(
            id: uuid,
            mainText: .custom(docClaim.stringValue),
            overlineText: .custom(title),
            isBlur: isSensitive
          )
        )
      }
    }
  }
}
