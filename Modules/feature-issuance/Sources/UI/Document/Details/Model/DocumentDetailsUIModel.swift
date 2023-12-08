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
import MdocDataModel18013

public struct DocumentDetailsUIModel {

  public let documentName: String
  public let holdersName: String
  public let holdersImage: Image
  public let documentFields: [DocumentField]
}

public extension DocumentDetailsUIModel {

  struct DocumentField: Identifiable {
    public let id: String
    public let title: String
    public let value: String
  }

  static func mock() -> DocumentDetailsUIModel {
    DocumentDetailsUIModel(
      documentName: "Digital ID",
      holdersName: "Jane Doe",
      holdersImage: Theme.shared.image.user,
      documentFields:
        [
          .init(
            id: UUID().uuidString,
            title: "ID no",
            value: "AB12356"),
          .init(
            id: UUID().uuidString,
            title: "Nationality",
            value: "Hellenic"),
          .init(
            id: UUID().uuidString,
            title: "Place of birth",
            value: "21 Oct 1994"),
          .init(
            id: UUID().uuidString,
            title: "Height",
            value: "1,82")
        ]
      +
      Array(
        count: 6,
        createElement: DocumentField(
          id: UUID().uuidString,
          title: "Placeholder Field Title".padded(padLength: 5),
          value: "Placeholder Field Value".padded(padLength: 10)
        )
      )
    )
  }
}

extension MdocDecodable {
  func transformToDocumentDetailsUi() -> DocumentDetailsUIModel {
    var nameValues = displayStrings + [getDrivingPrivileges()]

    let documentFields: [DocumentDetailsUIModel.DocumentField] =
    nameValues
      .compactMap({$0})
      .sorted(by: {$0.order < $1.order})
      .map {
        .init(
          id: UUID().uuidString,
          title: LocalizableString.shared.get(with: .dynamic(key: $0.name)),
          value: tryParseDate(dateString: $0.value)
        )
      }
    +
    ageOverXX
      .map { key, value in
          .init(
            id: UUID().uuidString,
            title: LocalizableString.shared.get(with: .dynamic(key: "age_over_\(key)")),
            value: LocalizableString.shared.get(with: value ? .yes : .no)
          )
      }

    var bearerName: String {
      guard let fullName = getBearersName() else {
        return ""
      }
      return "\(fullName.first) \(fullName.last)"
    }

    return .init(
      documentName: LocalizableString.shared.get(with: .dynamic(key: title)),
      holdersName: bearerName,
      holdersImage: getPortrait() ?? Theme.shared.image.user,
      documentFields: documentFields
    )
  }
}
