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
import Foundation
import EudiWalletKit
import MdocDataModel18013
import struct OpenID4VP.ClaimPath

public extension Array where Element == PresentationPolicyViolation {

  func toOveraskedClaims() -> [OveraskedClaim] {
    var seen = Set<OveraskedClaim>()

    return self.reduce(into: [OveraskedClaim]()) { result, violation in

      guard case .overAskedClaims(let docType, let claims) = violation.reason else { return }

      let overasked: [OveraskedClaim] = if let claims, !claims.isEmpty {
        claims.map { OveraskedClaim(attestationType: docType, path: $0) }
      } else {
        [OveraskedClaim(attestationType: docType, path: nil)]
      }

      result.append(contentsOf: overasked.filter { seen.insert($0).inserted })
    }
  }
}

public extension Array where Element == DocElements {

  /// The paths of the rows that show an over-asked claim, by document id. A row is marked when its path and an
  /// over-asked path share a prefix in either direction, as the Android wallet does: an over-asked object marks the
  /// rows below it, and an over-asked member or array element marks the row that shows its object or array whole.
  func overaskedPaths(from overaskedClaims: [OveraskedClaim]) -> [String: Set<[String]>] {

    guard !overaskedClaims.isEmpty else { return [:] }

    return self.reduce(into: [String: Set<[String]>]()) { result, element in

      let attestationType: String
      let claims: [DocClaim]

      switch element {
      case .msoMdoc(let doc):
        attestationType = doc.docType
        claims = doc.nameSpacedElements.flatMap(\.elements).compactMap(\.docClaim)
      case .sdJwt(let doc):
        attestationType = doc.vct
        claims = doc.sdJwtElements.compactMap(\.docClaim)
      }

      let applicable = overaskedClaims.filter { $0.appliesTo(attestationType: attestationType) }
      guard !applicable.isEmpty else { return }

      let leafPaths = claims.flatMap { $0.leafPaths() }

      let overasked: Set<[String]> = if applicable.contains(where: { $0.path == nil }) {
        Set(leafPaths)
      } else {
        Set(
          leafPaths.filter { leafPath in
            let claimPath = ClaimPath(rowPath: leafPath)
            return applicable.contains { overasked in
              guard let path = overasked.path else { return false }
              return path.contains2(claimPath) || claimPath.contains2(path)
            }
          }
        )
      }

      if !overasked.isEmpty { result[element.docId] = overasked }
    }
  }
}

private extension DocClaim {
  func leafPaths() -> [[String]] {
    guard let children, !children.isEmpty else { return [path] }
    return children.flatMap { $0.leafPaths() }
  }
}

private extension ClaimPath {
  /// A row's path read as WalletKit writes it (`RequestItem.claimPath`): an empty component selects every element
  /// of an array, a number selects one element, and any other component names a claim.
  init(rowPath: [String]) {
    self.init(
      rowPath.map { component in
        if let index = Int(component) {
          .arrayElement(index: index)
        } else if component.isEmpty {
          .allArrayElements
        } else {
          .claim(name: component)
        }
      }
    )
  }
}
