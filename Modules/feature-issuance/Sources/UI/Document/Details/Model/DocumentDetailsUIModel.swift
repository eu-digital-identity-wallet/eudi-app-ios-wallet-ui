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

public struct DocumentDetailsUIModel: Sendable {

  public let id: String
  public let type: DocumentTypeIdentifier
  public let documentName: String
  public let holdersName: String
  public let holdersImage: Image
  public let createdAt: Date
  public let hasExpired: Bool
  public let documentFields: [DocumentField]
}

public extension DocumentDetailsUIModel {

  struct DocumentField: Identifiable, Sendable {

    public indirect enum Value: Sendable {
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
      holdersName: "Jane Doe",
      holdersImage: Theme.shared.image.user,
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

    let documentFields: [DocumentDetailsUIModel.DocumentField] =
    flattenValues(
      input: docClaims
        .compactMap({$0})
        .sorted(by: {$0.order < $1.order})
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
      holdersName: bearerName,
      holdersImage: getPortrait() ?? Theme.shared.image.user,
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

        guard docClaim.name != DocumentJsonKeys.PORTRAIT else {
          partialResult.append(
            .init(
              id: uuid,
              title: title,
              value: .string(LocalizableString.shared.get(with: .shownAbove))
            )
          )
          return
        }

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
