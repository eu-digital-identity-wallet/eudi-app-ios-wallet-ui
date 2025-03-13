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
import Copyable

@Copyable
public struct DocumentDetailsUIModel: Equatable, Identifiable, Routable {

  public let id: String
  public let type: DocumentTypeIdentifier
  public let documentName: String
  public let issuer: IssuerField?
  public let createdAt: Date
  public let hasExpired: Bool
  public let documentFields: [GenericExpandableItem]

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
          .single(
            .init(
              collapsed: .init(
                mainText: .custom("AB12356"),
                overlineText: .custom("ID no")
              ),
              domainModel: nil
            )
          ),
          .single(
            .init(
              collapsed: .init(
                mainText: .custom("Hellenic"),
                overlineText: .custom("Nationality")
              ),
              domainModel: nil
            )
          ),
          .single(
            .init(
              collapsed: .init(
                mainText: .custom("21 Oct 1994"),
                overlineText: .custom("Place of birth")
              ),
              domainModel: nil
            )
          ),
          .single(
            .init(
              collapsed: .init(
                mainText: .custom("1,82"),
                overlineText: .custom("Height")
              ),
              domainModel: nil
            )
          )
        ]
      +
      Array(
        count: 6,
        createElement: .single(
          .init(
            collapsed: .init(
              mainText: .custom("Placeholder Field Value".padded(padLength: 10)),
              overlineText: .custom("Placeholder Field Title".padded(padLength: 5))
            ),
            domainModel: nil
          )
        )
      )
    )
  }

  func toggleVisibility(isVisible: Bool) -> [GenericExpandableItem] {

    func toggleSelection(isVisible: Bool, fields: inout [GenericExpandableItem]) {
      for index in fields.indices {
        switch fields[index] {
        case .single(let item):
          fields[index] = .single(item.copy(collapsed: item.collapsed.copy(isBlur: isVisible)))
        case .nested(let item):
          var children = item.expanded
          toggleSelection(isVisible: isVisible, fields: &children)
          fields[index] = .nested(item.copy(expanded: children))
        }
      }
    }

    var documentFields = self.documentFields
    toggleSelection(isVisible: isVisible, fields: &documentFields)
    return documentFields

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

    let documentFields: [GenericExpandableItem] =
    parseClaim(
      documentId: self.id,
      isSensitive: isSensitive,
      input: docClaims
    )
    .sorted(by: {
      $0.title.localizedCompare($1.title) == .orderedAscending
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

  private func parseClaim(
    documentId: String,
    isSensitive: Bool,
    input: [DocClaim]
  ) -> [GenericExpandableItem] {
    input.reduce(into: []) { partialResult, docClaim in

      let title = docClaim.displayName.ifNilOrEmpty { docClaim.name }

      if let nested = docClaim.children {

        let children = parseClaim(
          documentId: documentId,
          isSensitive: isSensitive,
          input: nested
        )

        if title.isEmpty {
          partialResult.append(contentsOf: children)
        } else {
          partialResult.append(
            .nested(
              .init(
                collapsed: .init(mainText: .custom(title)),
                expanded: children,
                isExpanded: false
              )
            )
          )
        }
      } else if let uiImage = docClaim.dataValue.image {
        partialResult.append(
          .single(
            .init(
              collapsed: .init(
                mainText: .custom(title),
                leadingIcon: .init(image: Image(uiImage: uiImage)),
                isBlur: isSensitive
              ),
              domainModel: nil
            )
          )
        )
      } else {

        let claim = docClaim
          .parseDate(
            parser: {
              Locale.current.localizedDateTime(
                date: $0,
                uiFormatter: "dd MMM yyyy"
              )
            }
          )
          .parseUserPseudonym()

        partialResult.append(
          .single(
            .init(
              collapsed: .init(
                mainText: .custom(claim.stringValue),
                overlineText: .custom(title),
                isBlur: isSensitive
              ),
              domainModel: nil
            )
          )
        )
      }
    }
  }
}
