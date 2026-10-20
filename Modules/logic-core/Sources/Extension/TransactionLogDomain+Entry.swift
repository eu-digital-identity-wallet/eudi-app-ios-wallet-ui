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
import MdocDataModel18013

extension TransactionLogDomain.Presentation {
  func toDataDeletionRequestEntry(id: String, time: Date) -> TransactionEntry {
    .dataDeletionRequest(
      .init(
        transactionIdentifier: id,
        time: time,
        transactionResult: .completed,
        listOfClaims: claimsPresented.map { $0.toClaimInfo() },
        interactingPartyIdentifier: party.identifier?.toQualifiedIdentifier(),
        interactingPartyName: party.name?.toMultiLangString()
      )
    )
  }

  func toDpaReportEntry(id: String, time: Date) -> TransactionEntry {
    let dpa = registration?.dpa
    return .dpaReport(
      .init(
        transactionIdentifier: id,
        time: time,
        transactionResult: .completed,
        dpaName: dpa?.name?.toMultiLangString(),
        dpaCountry: dpa?.country?.toMultiLangString()
      )
    )
  }
}

private extension CredentialClaimsDomain {
  func toClaimInfo() -> ClaimInfo {
    .init(
      credentialIdentifier: credential.identifier.rawValue,
      claims: claims.map { claim in
        MdocDataModel18013.ClaimPath(
          claim.segments.map { segment in
            switch segment {
            case .key(let name): .claim(name: name)
            case .index(let index): .arrayElement(index: index)
            case .allElements: .allArrayElements
            }
          }
        )
      }
    )
  }
}

private extension QualifiedIdentifierDomain {
  func toQualifiedIdentifier() -> QualifiedIdentifier {
    .init(type: schemeUri, value: value)
  }
}

private extension String {
  func toMultiLangString() -> MultiLangString {
    .init(lang: "und", content: self)
  }
}
