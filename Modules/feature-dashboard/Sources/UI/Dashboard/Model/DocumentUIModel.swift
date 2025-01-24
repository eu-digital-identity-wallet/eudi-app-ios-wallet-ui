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

public struct DocumentUIModel: Identifiable, Equatable, Sendable {

  @EquatableNoop
  public var id: String

  public let value: Value

  public init(id: String, value: Value) {
    self.id = id
    self.value = value
  }

  public var listItem: ListItemData {
    .init(
      mainText: .custom(value.title),
      overlineText: .custom(value.heading),
      supportingText: .custom(supportingText()),
      supportingTextColor: supportingColor(),
      leadingIcon: (
        value.image?.url,
        value.image?.placeholder
      ),
      trailingContent: .icon(indicatorImage(), supportingColor())
    )
  }
}
private extension DocumentUIModel {
  func supportingText() -> String {
    if value.hasExpired {
      return LocalizableString.shared.get(with: .expired)
    } else {
      switch value.state {
      case .issued:
        return expiry.orEmpty
      case .pending:
        return LocalizableString.shared.get(with: .pending)
      case .failed:
        return LocalizableString.shared.get(with: .issuanceFailed)
      }
    }
  }

  func supportingColor() -> Color {
    if value.hasExpired {
      return Theme.shared.color.error
    } else {
      switch value.state {
      case .issued:
        return Theme.shared.color.onSurfaceVariant
      case .pending:
        return Theme.shared.color.warning
      case .failed:
        return Theme.shared.color.error
      }
    }
  }

  func indicatorImage() -> Image {
    switch value.state {
    case .issued:
      return Theme.shared.image.chevronRight
    case .pending:
      return Theme.shared.image.clockIndicator
    case .failed:
      return Theme.shared.image.errorIndicator
    }
  }

  var expiry: String? {
    guard let expiresAt = value.expiresAt else {
      return nil
    }
    return LocalizableString.shared.get(with: .validUntil([expiresAt])).replacingOccurrences(of: "\n", with: "")
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
    public var createdAt: Date
    public let expiresAt: String?
    public let hasExpired: Bool
    public let state: State
    public let image: RemoteImage?
  }

  static func mocks() -> [DocumentUIModel] {
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
          )
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
          )
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
          )
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
          )
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
          )
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
          )
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
          )
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
          )
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
          )
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
          )
        )
      )
    ]
  }
}

public extension DocumentUIModel.Value {
  enum State: Equatable, Sendable {
    case issued
    case pending
    case failed
  }
}

extension Array where Element == DocClaimsDecodable {
  func transformToDocumentUi(with failedDocuments: [String] = []) -> [DocumentUIModel] {
    self.map { item in
      item.transformToDocumentUi(with: failedDocuments)
    }
  }
}

extension DocClaimsDecodable {
  func transformToDocumentUi(with failedDocuments: [String] = []) -> DocumentUIModel {
    return .init(
      id: UUID().uuidString,
      value: .init(
        id: self.id,
        heading: issuerDisplay?.first?.name.orEmpty ?? "",
        title: self.displayName.orEmpty,
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
        state: failedDocuments.contains(
          where: { $0 == self.id }
        ) ? .failed : (self is DeferrredDocument) ? .pending : .issued,
        image: .init(
          url: self.issuerDisplay?.first?.logo?.uri,
          placeholder: Theme.shared.image.id
        )
      )
    )
  }
}
