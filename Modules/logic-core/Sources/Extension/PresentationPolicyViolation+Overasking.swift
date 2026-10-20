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
            let claimPath = ClaimPath(leafPath.map { .claim(name: $0) })
            return applicable.contains { $0.path?.contains2(claimPath) == true }
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
