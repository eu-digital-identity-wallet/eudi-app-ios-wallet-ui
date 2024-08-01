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
    public let state: State
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
          hasExpired: false,
          state: .issued
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
          hasExpired: false,
          state: .issued
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
          hasExpired: false,
          state: .issued
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
          hasExpired: false,
          state: .issued
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
          hasExpired: false,
          state: .issued
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
          hasExpired: false,
          state: .issued
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
          hasExpired: false,
          state: .issued
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
          hasExpired: false,
          state: .issued
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
          hasExpired: false,
          state: .issued
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
          hasExpired: false,
          state: .issued
        )
      )
    ]
  }
}

public extension DocumentUIModel.Value {
  enum State: Equatable {
    case issued
    case pending
    case failed
  }
}

extension Array where Element == MdocDecodable {
  func transformToDocumentUi(with failedDocuments: [String] = []) -> [DocumentUIModel] {
    self.map { item in
      item.transformToDocumentUi(with: failedDocuments)
    }
  }
}

extension MdocDecodable {
  func transformToDocumentUi(with failedDocuments: [String] = []) -> DocumentUIModel {
    let identifier = DocumentTypeIdentifier(rawValue: self.docType)
    return .init(
      id: UUID().uuidString,
      value: .init(
        id: self.id,
        type: self.docType,
        title: identifier.isSupported
        ? identifier.localizedTitle
        : self.displayName ?? identifier.localizedTitle,
        createdAt: self.createdAt,
        expiresAt: self.getExpiryDate(
          parser: {
            Locale.current.localizedDateTime(
              date: $0,
              uiFormatter: "dd MMM yyyy"
            )
          }
        ),
        hasExpired: self.hasExpired(
          parser: { Locale.current.parseDate(date: $0) }
        ),
        state: failedDocuments.contains(where: { $0 == self.id })
        ? .failed
        : (self is DeferrredDocument) ? .pending : .issued
      )
    )
  }
}
