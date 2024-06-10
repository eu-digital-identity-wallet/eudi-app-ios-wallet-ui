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
import logic_resources
import logic_business

public struct DocumentUIModel: Identifiable, Equatable {

  @EquatableNoop
  public var id: String

  public let value: Value

  public init(id: String, value: Value) {
    self.id = id
    self.value = value
  }
}

public extension DocumentUIModel {

  struct Value: Equatable {

    @EquatableNoop
    public var id: String

    public let type: String
    public let title: String
    public var createdAt: Date
    public let expiresAt: String?
    public let hasExpired: Bool
  }

  static func mocks() -> [DocumentUIModel] {
    [
      .init(
        id: UUID().uuidString,
        value: .init(
          id: UUID().uuidString,
          type: UUID().uuidString,
          title: "Digital ID",
          createdAt: Date(),
          expiresAt: "22/01/2025",
          hasExpired: false
        )
      ),
      .init(
        id: UUID().uuidString,
        value: .init(
          id: UUID().uuidString,
          type: UUID().uuidString,
          title: "EUDI Conference",
          createdAt: Date(),
          expiresAt: "22/01/2025",
          hasExpired: false
        )
      ),
      .init(
        id: UUID().uuidString,
        value: .init(
          id: UUID().uuidString,
          type: UUID().uuidString,
          title: "Passport",
          createdAt: Date(),
          expiresAt: "22/01/2025",
          hasExpired: false
        )
      ),
      .init(
        id: UUID().uuidString,
        value: .init(
          id: UUID().uuidString,
          type: UUID().uuidString,
          title: "Document 1",
          createdAt: Date(),
          expiresAt: "22/01/2025",
          hasExpired: false
        )
      ),
      .init(
        id: UUID().uuidString,
        value: .init(
          id: UUID().uuidString,
          type: UUID().uuidString,
          title: "Document 2",
          createdAt: Date(),
          expiresAt: "22/01/2025",
          hasExpired: false
        )
      ),
      .init(
        id: UUID().uuidString,
        value: .init(
          id: UUID().uuidString,
          type: UUID().uuidString,
          title: "Document 3",
          createdAt: Date(),
          expiresAt: "22/01/2025",
          hasExpired: false
        )
      ),
      .init(
        id: UUID().uuidString,
        value: .init(
          id: UUID().uuidString,
          type: UUID().uuidString,
          title: "Document 4",
          createdAt: Date(),
          expiresAt: "22/01/2025",
          hasExpired: false
        )
      ),
      .init(
        id: UUID().uuidString,
        value: .init(
          id: UUID().uuidString,
          type: UUID().uuidString,
          title: "Document 5",
          createdAt: Date(),
          expiresAt: "22/01/2025",
          hasExpired: false
        )
      ),
      .init(
        id: UUID().uuidString,
        value: .init(
          id: UUID().uuidString,
          type: UUID().uuidString,
          title: "Document 6",
          createdAt: Date(),
          expiresAt: "22/01/2025",
          hasExpired: false
        )
      ),
      .init(
        id: UUID().uuidString,
        value: .init(
          id: UUID().uuidString,
          type: UUID().uuidString,
          title: "Passport",
          createdAt: Date(),
          expiresAt: "22/01/2025",
          hasExpired: false
        )
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
          id: item.id,
          type: item.docType,
          title: DocumentTypeIdentifier(rawValue: item.docType).localizedTitle,
          createdAt: item.createdAt,
          expiresAt: item.getExpiryDate(
            parser: {
              Locale.current.localizedDateTime(
                date: $0,
                uiFormatter: "dd MMM yyyy"
              )
            }
          ),
          hasExpired: item.hasExpired(
            parser: { Locale.current.parseDate(date: $0) }
          )
        )
      )
    }
  }
}
