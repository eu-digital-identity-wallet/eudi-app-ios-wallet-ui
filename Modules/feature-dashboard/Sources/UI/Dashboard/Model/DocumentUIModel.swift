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
import SwiftUI
import logic_core
import logic_resources
import logic_business
import logic_ui

public struct DocumentUIModel: Identifiable, Equatable, FilterableItemPayload {

  @EquatableNoop
  public var id: String
  public let value: Value
  public let listItem: ListItemData

  public init(
    id: String,
    value: Value,
    listItem: ListItemData
  ) {
    self.id = id
    self.value = value
    self.listItem = listItem
  }
}

public extension DocumentUIModel {

  struct Value: Equatable, Sendable {

    public struct RemoteImage: Equatable, Sendable {
      public static func == (lhs: RemoteImage, rhs: RemoteImage) -> Bool {
        return lhs.url == rhs.url
      }
      public let url: URL?
      public let placeholder: Image?
    }

    @EquatableNoop
    public var id: String

    public let heading: String
    public let title: String
    public let createdAt: Date
    public let expiresAt: String?
    public let hasExpired: Bool
    public let state: State
    public let image: RemoteImage?
    public let documentCategory: DocumentCategory
  }

  static func mocks() -> [DocumentCategory: [DocumentUIModel]] {
    [
      DocumentCategory.Other:
        [
          .init(
            id: UUID().uuidString,
            value: .init(
              id: UUID().uuidString,
              heading: "Issuer Name",
              title: "Digital ID",
              createdAt: Date(),
              expiresAt: "22/01/2025",
              hasExpired: false,
              state: .issued,
              image: .init(
                url: URL(string: "https://www.example.com"),
                placeholder: Theme.shared.image.logo
              ),
              documentCategory: .Other
            ),
            listItem: ListItemData(
              mainText: .custom("Digital ID"),
              overlineText: .custom("Issuer Name")
            )
          ),
          .init(
            id: UUID().uuidString,
            value: .init(
              id: UUID().uuidString,
              heading: "Issuer Name",
              title: "EUDI Conference",
              createdAt: Date(),
              expiresAt: "22/01/2025",
              hasExpired: false,
              state: .issued,
              image: .init(
                url: URL(string: "https://www.example.com"),
                placeholder: Theme.shared.image.logo
              ),
              documentCategory: .Other
            ),
            listItem: ListItemData(
              mainText: .custom("EUDI Conference"),
              overlineText: .custom("Issuer Name")
            )
          ),
          .init(
            id: UUID().uuidString,
            value: .init(
              id: UUID().uuidString,
              heading: "Issuer Name",
              title: "Passport",
              createdAt: Date(),
              expiresAt: "22/01/2025",
              hasExpired: false,
              state: .issued,
              image: .init(
                url: URL(string: "https://www.example.com"),
                placeholder: Theme.shared.image.logo
              ),
              documentCategory: .Other
            ),
            listItem: ListItemData(
              mainText: .custom("Passport"),
              overlineText: .custom("Issuer Name")
            )
          ),
          .init(
            id: UUID().uuidString,
            value: .init(
              id: UUID().uuidString,
              heading: "Issuer Name",
              title: "Document 1",
              createdAt: Date(),
              expiresAt: "22/01/2025",
              hasExpired: false,
              state: .issued,
              image: .init(
                url: URL(string: "https://www.example.com"),
                placeholder: Theme.shared.image.logo
              ),
              documentCategory: .Other
            ),
            listItem: ListItemData(
              mainText: .custom("Document 1"),
              overlineText: .custom("Issuer Name")
            )
          ),
          .init(
            id: UUID().uuidString,
            value: .init(
              id: UUID().uuidString,
              heading: "Issuer Name",
              title: "Document 2",
              createdAt: Date(),
              expiresAt: "22/01/2025",
              hasExpired: false,
              state: .issued,
              image: .init(
                url: URL(string: "https://www.example.com"),
                placeholder: Theme.shared.image.logo
              ),
              documentCategory: .Other
            ),
            listItem: ListItemData(
              mainText: .custom("Document 2"),
              overlineText: .custom("Issuer Name")
            )
          ),
          .init(
            id: UUID().uuidString,
            value: .init(
              id: UUID().uuidString,
              heading: "Issuer Name",
              title: "Document 3",
              createdAt: Date(),
              expiresAt: "22/01/2025",
              hasExpired: false,
              state: .issued,
              image: .init(
                url: URL(string: "https://www.example.com"),
                placeholder: Theme.shared.image.logo
              ),
              documentCategory: .Other
            ),
            listItem: ListItemData(
              mainText: .custom("Document 3"),
              overlineText: .custom("Issuer Name")
            )
          ),
          .init(
            id: UUID().uuidString,
            value: .init(
              id: UUID().uuidString,
              heading: "Issuer Name",
              title: "Document 4",
              createdAt: Date(),
              expiresAt: "22/01/2025",
              hasExpired: false,
              state: .issued,
              image: .init(
                url: URL(string: "https://www.example.com"),
                placeholder: Theme.shared.image.logo
              ),
              documentCategory: .Other
            ),
            listItem: ListItemData(
              mainText: .custom("Document 4"),
              overlineText: .custom("Issuer Name")
            )
          ),
          .init(
            id: UUID().uuidString,
            value: .init(
              id: UUID().uuidString,
              heading: "Issuer Name",
              title: "Document 5",
              createdAt: Date(),
              expiresAt: "22/01/2025",
              hasExpired: false,
              state: .issued,
              image: .init(
                url: URL(string: "https://www.example.com"),
                placeholder: Theme.shared.image.logo
              ),
              documentCategory: .Other
            ),
            listItem: ListItemData(
              mainText: .custom("Document 5"),
              overlineText: .custom("Issuer Name")
            )
          ),
          .init(
            id: UUID().uuidString,
            value: .init(
              id: UUID().uuidString,
              heading: "Issuer Name",
              title: "Document 6",
              createdAt: Date(),
              expiresAt: "22/01/2025",
              hasExpired: false,
              state: .issued,
              image: .init(
                url: URL(string: "https://www.example.com"),
                placeholder: Theme.shared.image.logo
              ),
              documentCategory: .Other
            ),
            listItem: ListItemData(
              mainText: .custom("Document 6"),
              overlineText: .custom("Issuer Name")
            )
          ),
          .init(
            id: UUID().uuidString,
            value: .init(
              id: UUID().uuidString,
              heading: "Issuer Name",
              title: "Passport",
              createdAt: Date(),
              expiresAt: "22/01/2025",
              hasExpired: false,
              state: .issued,
              image: .init(
                url: URL(string: "https://www.example.com"),
                placeholder: Theme.shared.image.logo
              ),
              documentCategory: .Other
            ),
            listItem: ListItemData(
              mainText: .custom("Passport"),
              overlineText: .custom("Issuer Name")
            )
          )
        ]
    ]
  }
}

public extension DocumentUIModel.Value {
  enum State: Equatable, Sendable {
    case issued
    case pending
    case failed
    case revoked
  }
}

extension Array where Element == DocClaimsDecodable {
  func transformToDocumentUi(
    with failedDocuments: [String] = [],
    categories: DocumentCategories,
    isRevoked: Bool
  ) -> [DocumentUIModel] {
    self.map { item in
      item.transformToDocumentUi(
        with: failedDocuments,
        categories: categories,
        isRevoked: isRevoked
      )
    }
  }
}

extension DocClaimsDecodable {
  func transformToDocumentUi(
    with failedDocuments: [String] = [],
    categories: DocumentCategories,
    isRevoked: Bool
  ) -> DocumentUIModel {
    let state: DocumentUIModel.Value.State = failedDocuments.contains(where: { $0 == self.id })
    ? .failed
    : (self is DeferrredDocument)
    ? .pending
    : isRevoked
    ? .revoked
    : .issued

    let expiresAt = self.getExpiryDate(
      parser: {
        Locale.current.localizedDateTime(
          date: $0,
          uiFormatter: "dd MMM yyyy"
        )
      }
    )
    return .init(
      id: UUID().uuidString,
      value: .init(
        id: self.id,
        heading: self.issuerName,
        title: self.displayName.orEmpty,
        createdAt: self.createdAt,
        expiresAt: expiresAt,
        hasExpired: self.hasExpired,
        state: state,
        image: .init(
          url: self.issuerLogo,
          placeholder: Theme.shared.image.id
        ),
        documentCategory: categories.first(where: { $1.contains(self.documentTypeIdentifier) })?.key ?? .Other
      ),
      listItem: .init(
        mainText: .custom(displayName.orEmpty),
        overlineText: .custom(issuerName),
        supportingText: supportingText(state, expiresAt),
        supportingTextColor: supportingColor(state),
        leadingIcon: .init(
          imageUrl: issuerLogo,
          image: Theme.shared.image.id
        ),
        trailingContent: .icon(indicatorImage(state), supportingColor(state))
      )
    )
  }

  func supportingText(
    _ state: DocumentUIModel.Value.State,
    _ expiresAt: String?
  ) -> LocalizableStringKey {
    if hasExpired {
      return .expired
    } else {
      switch state {
      case .issued:
        return .custom(expiry(expiresAt: expiresAt).orEmpty)
      case .pending:
        return .pending
      case .failed:
        return .issuanceFailed
      case .revoked:
        return .revoked
      }
    }
  }

  func expiry(expiresAt: String?) -> String? {
    guard let expires = expiresAt else {
      return nil
    }
    return LocalizableStringKey.validUntil([expires]).toString.replacingOccurrences(of: "\n", with: "")
  }

  func supportingColor(
    _ state: DocumentUIModel.Value.State
  ) -> Color {
    if hasExpired {
      return Theme.shared.color.error
    } else {
      switch state {
      case .issued:
        return Theme.shared.color.onSurfaceVariant
      case .pending:
        return Theme.shared.color.warning
      case .failed:
        return Theme.shared.color.error
      case .revoked:
        return Theme.shared.color.error
      }
    }
  }

  func indicatorImage(
    _ state: DocumentUIModel.Value.State
  ) -> Image {
    switch state {
    case .issued:
      return Theme.shared.image.chevronRight
    case .pending:
      return Theme.shared.image.clockIndicator
    case .failed:
      return Theme.shared.image.errorIndicator
    case .revoked:
      return Theme.shared.image.errorIndicator
    }
  }
}
