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

public struct DocumentDetailsUIModel: Sendable, Equatable, Identifiable {

  public let id: String
  public let type: DocumentTypeIdentifier
  public let documentName: String
  public let issuer: IssuerField?
  public let holdersName: String
  public let createdAt: Date
  public let hasExpired: Bool
  public let documentFields: [DocumentField]
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

  struct DocumentField: Identifiable, Sendable, Equatable {

    public indirect enum Value: Sendable, Equatable {
      case string(String)
      case image(Image)
    }

    public let id: String
    public let title: String
    public let value: Value
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
      holdersName: "Jane Doe",
      createdAt: Date(),
      hasExpired: false,
      documentFields:
        [
          .init(
            id: UUID().uuidString,
            title: "ID no",
            value: .string("AB12356")),
          .init(
            id: UUID().uuidString,
            title: "Nationality",
            value: .string("Hellenic")),
          .init(
            id: UUID().uuidString,
            title: "Place of birth",
            value: .string("21 Oct 1994")),
          .init(
            id: UUID().uuidString,
            title: "Height",
            value: .string("1,82"))
        ]
      +
      Array(
        count: 6,
        createElement: DocumentField(
          id: UUID().uuidString,
          title: "Placeholder Field Title".padded(padLength: 5),
          value: .string("Placeholder Field Value".padded(padLength: 10))
        )
      )
    )
  }
}

extension DocClaimsDecodable {
  func transformToDocumentDetailsUi() -> DocumentDetailsUIModel {

    var issuer: DocumentDetailsUIModel.IssuerField? {
      guard let name = self.issuerDisplay?.first?.name else {
        return nil
      }
      let logo = self.issuerDisplay?.first?.logo?.uri
      return .init(
        issuersName: name,
        logoUrl: logo,
        isVerified: true
      )
    }

    let documentFields: [DocumentDetailsUIModel.DocumentField] =
    flattenValues(
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
    .sorted(by: { $0.title.lowercased() < $1.title.lowercased() })

    var bearerName: String {
      guard let fullName = getBearersName() else {
        return ""
      }
      return "\(fullName.first) \(fullName.last)"
    }

    let identifier = DocumentTypeIdentifier(rawValue: docType.orEmpty)

    return .init(
      id: id,
      type: identifier,
      documentName: displayName.orEmpty,
      issuer: issuer,
      holdersName: bearerName,
      createdAt: createdAt,
      hasExpired: hasExpired(
        parser: {
          Locale.current.parseDate(
            date: $0
          )
        }
      ),
      documentFields: documentFields
    )
  }

  private func flattenValues(input: [DocClaim]) -> [DocumentDetailsUIModel.DocumentField] {
    input.reduce(into: []) { partialResult, docClaim in

      let uuid = UUID().uuidString
      let title = docClaim.displayName.ifNilOrEmpty { docClaim.name }

      if let uiImage = docClaim.dataValue.image {

        partialResult.append(
          .init(
            id: uuid,
            title: title,
            value: .image(Image(uiImage: uiImage))
          )
        )

      } else if let nested = docClaim.children {
        partialResult.append(
          .init(
            id: uuid,
            title: title,
            value: .string(docClaim.flattenNested(nested: nested).stringValue)
          )
        )
      } else {
        partialResult.append(
          .init(
            id: uuid,
            title: title,
            value: .string(docClaim.stringValue)
          )
        )
      }
    }
  }
}
