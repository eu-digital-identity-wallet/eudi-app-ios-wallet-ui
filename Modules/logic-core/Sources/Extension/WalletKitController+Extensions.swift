/*
 * Copyright (c) 2026 European Commission
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
import logic_business
import SwiftUI

public extension WalletKitController {
  /// Throws `WalletCoreError.documentBlocked` for a document the issuer has revoked or suspended, and the read's
  /// error when the revocation records cannot be read, so a re-issue fails closed, as the Android wallet does.
  func refuseReIssueIfBlocked(_ identifier: String) async throws {
    guard try await fetchRevokedDocumentStatuses()[identifier] == nil else {
      throw WalletCoreError.documentBlocked
    }
  }
}

extension WalletKitController {

  private func parseChildren(
    docId: String,
    groupId: String,
    docClaims: [DocClaim],
    type: DocumentElementType,
    parser: (String) -> String,
    claims: inout [DocumentElementClaim]
  ) {
    docClaims.forEach { claim in
      let docElementClaim = parseDocClaim(
        docId: docId,
        groupId: groupId,
        docClaim: claim,
        type: type,
        parser: parser
      )
      claims.append(contentsOf: docElementClaim)
    }
  }

  public func parseDocClaim(
    docId: String,
    groupId: String,
    docClaim: DocClaim,
    type: DocumentElementType,
    parser: (String) -> String
  ) -> [DocumentElementClaim] {

    func shouldGroup(_ title: String, _ children: [DocClaim]) -> Bool {
      children.count > 1 && !title.isEmpty && children.allSatisfy { $0.children != nil }
    }

    if let children = docClaim.children, !children.isEmpty {

      let title = docClaim.displayName.ifNilOrEmpty { docClaim.name }

      if shouldGroup(title, children) {

        let grouped = children.enumerated().flatMap { index, entry in
          let inner = entry.children ?? []

          return [
            DocumentElementClaim.group(
              id: UUID().uuidString,
              title: "\(title) \(index + 1)",
              items: inner.flatMap {
                parseDocClaim(
                  docId: docId,
                  groupId: groupId,
                  docClaim: $0,
                  type: type,
                  parser: parser
                )
              }.sortByName()
            )
          ]
        }

        return [
          .group(
            id: UUID().uuidString,
            title: title,
            items: grouped
          )
        ]

      } else {

        let childClaims = children.flatMap {
          parseDocClaim(
            docId: docId,
            groupId: groupId,
            docClaim: $0,
            type: type,
            parser: parser
          )
        }.sortByName()

        return title.isEmpty
        ? childClaims
        : [
          .group(
            id: UUID().uuidString,
            title: title,
            items: childClaims
          )
        ]
      }
    }

    var value: DocumentElementValue {
      if let image = docClaim.dataValue.boundedImage {
        return .image(Image(uiImage: image))
      } else {
        let claim = docClaim
          .parseDate(parser: parser)
          .parseUserPseudonym()
        return .string(claim.stringValue)
      }
    }

    let groupIdentifier: String = groupId
    return [
      .primitive(
        id: groupIdentifier,
        title: docClaim.displayName.ifNilOrEmpty { docClaim.name },
        documentId: docId,
        nameSpace: docClaim.namespace,
        path: docClaim.path,
        type: type,
        value: value,
        status: .available(isRequired: false)
      )
    ]
  }
}
