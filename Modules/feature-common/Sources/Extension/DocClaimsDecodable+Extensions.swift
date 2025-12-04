/*
 * Copyright (c) 2025 European Commission
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
import logic_ui
import logic_core

public extension DocClaimsDecodable {
  func transformToDocumentUi(
    isSensitive: Bool = true
  ) -> DocumentUIModel {

    var issuer: DocumentUIModel.IssuerField? {
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
}

public extension DocClaimsDecodable {

  func parseClaim(
    documentId: String,
    isSensitive: Bool,
    input: [DocClaim]
  ) -> [GenericExpandableItem] {

    func shouldGroup(_ title: String, _ children: [DocClaim]) -> Bool {
      children.count > 1 && !title.isEmpty && children.allSatisfy { $0.children != nil }
    }

    return input.reduce(into: []) { result, claim in

      let title = claim.displayName.ifNilOrEmpty { claim.name }

      if let nested = claim.children {

        if shouldGroup(title, nested) {

          let grouped = nested.enumerated().map { index, entry in

            let expanded = parseClaim(
              documentId: documentId,
              isSensitive: isSensitive,
              input: entry.children ?? []
            ).sortByName()

            return GenericExpandableItem.nested(
              .init(
                collapsed: .init(mainContent: .text(.custom("\(title) \(index + 1)"))),
                expanded: expanded,
                isExpanded: false
              )
            )
          }

          result.append(
            .nested(
              .init(
                collapsed: .init(mainContent: .text(.custom(title))),
                expanded: grouped.sortByName(),
                isExpanded: false
              )
            )
          )

        } else {

          let children = parseClaim(
            documentId: documentId,
            isSensitive: isSensitive,
            input: nested
          ).sortByName()

          if title.isEmpty {
            result.append(contentsOf: children)
          } else {
            result.append(
              .nested(
                .init(
                  collapsed: .init(mainContent: .text(.custom(title))),
                  expanded: children,
                  isExpanded: false
                )
              )
            )
          }
        }

      } else if let uiImage = claim.dataValue.image {

        let collapsed: ListItemData

        if claim.name == DocumentJsonKeys.SIGNATURE {
          collapsed = .init(
            mainContent: .image(Image(uiImage: uiImage)),
            overlineText: .custom(title),
            isBlur: isSensitive
          )
        } else {
          collapsed = .init(
            mainContent: .text(.custom(title)),
            leadingIcon: .init(image: Image(uiImage: uiImage)),
            isBlur: isSensitive
          )
        }

        result.append(.single(.init(collapsed: collapsed, domainModel: nil)))

      } else {

        let parsed = claim
          .parseDate {
            Locale.current.localizedDateTime(
              date: $0,
              uiFormatter: "dd MMM yyyy"
            )
          }
          .parseUserPseudonym()

        let collapsed = ListItemData(
          mainContent: .text(.custom(parsed.stringValue)),
          overlineText: .custom(title),
          isBlur: isSensitive
        )

        result.append(.single(.init(collapsed: collapsed, domainModel: nil)))
      }
    }
    .sortByName()
  }
}
