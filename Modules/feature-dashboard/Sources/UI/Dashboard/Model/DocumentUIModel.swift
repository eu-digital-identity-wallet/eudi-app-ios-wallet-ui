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
import MdocDataModel18013
import logic_resources

public struct DocumentUIModel: Identifiable {
  public let id: String
  public let value: Value

  public init(id: String, value: Value) {
    self.id = id
    self.value = value
  }
}

public extension DocumentUIModel {

  struct Value {
    public let id: String
    public let title: String
    public let expiresAt: String?
  }

  static func mocks() -> [DocumentUIModel] {
    [
      .init(
        id: UUID().uuidString,
        value: .init(id: UUID().uuidString, title: "Digital ID", expiresAt: "22/01/2025")
      ),
      .init(
        id: UUID().uuidString,
        value: .init(id: UUID().uuidString, title: "EUDI Conference", expiresAt: "22/01/2025")
      ),
      .init(
        id: UUID().uuidString,
        value: .init(id: UUID().uuidString, title: "Passport", expiresAt: "22/01/2025")
      ),
      .init(
        id: UUID().uuidString,
        value: .init(id: UUID().uuidString, title: "Document 1", expiresAt: "22/01/2025")
      ),
      .init(
        id: UUID().uuidString,
        value: .init(id: UUID().uuidString, title: "Document 2", expiresAt: "22/01/2025")
      ),
      .init(
        id: UUID().uuidString,
        value: .init(id: UUID().uuidString, title: "Document 3", expiresAt: "22/01/2025")
      ),
      .init(
        id: UUID().uuidString,
        value: .init(id: UUID().uuidString, title: "Document 4", expiresAt: "22/01/2025")
      ),
      .init(
        id: UUID().uuidString,
        value: .init(id: UUID().uuidString, title: "Document 5", expiresAt: "22/01/2025")
      ),
      .init(
        id: UUID().uuidString,
        value: .init(id: UUID().uuidString, title: "Document 6", expiresAt: "22/01/2025")
      ),
      .init(
        id: UUID().uuidString,
        value: .init(id: UUID().uuidString, title: "Passport", expiresAt: "22/01/2025")
      )
    ]
  }
}

extension Array where Element == MdocDecodable {
  func transformToDocumentUi() -> [DocumentUIModel] {
    self.map { item in

      return .init(
        id: UUID().uuidString,
        value: .init(
          id: item.docType,
          title: LocalizableString.shared.get(with: .dynamic(key: item.title)),
          expiresAt: item.getExpiryDate()
        )
      )
    }
  }
}
