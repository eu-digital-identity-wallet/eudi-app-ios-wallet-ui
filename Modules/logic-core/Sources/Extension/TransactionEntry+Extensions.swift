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
import logic_business
import logic_storage

extension TransactionEntry {
  func toTransactionLogDomain(
    id: String,
    parentPresentationId: String?,
    actionChannel: TransactionActionChannel? = nil
  ) -> TransactionLogDomain? {
    switch self {
    case .presentation(let entry):
      return .presentation(
        .init(
          id: id,
          time: entry.time,
          result: entry.transactionResult.toDomain(reason: entry.reasonOfNoncompletion),
          party: .init(
            name: entry.interactingPartyName?.content,
            identifier: entry.interactingPartyIdentifier?.toDomain(),
            contacts: entry.interactingPartyContact ?? [],
            type: entry.interactingPartyType.nonBlankValue
          ),
          intermediary: entry.intermediaryDomain,
          registration: entry.registrationDomain,
          claimsRequested: entry.listOfClaimsRequested.toDomain(),
          claimsPresented: entry.listOfClaimsPresented.toDomain()
        )
      )
    case .credentialIssuance(let entry):
      return .credentialIssuance(
        .init(
          id: id,
          time: entry.time,
          result: entry.transactionResult.toDomain(reason: entry.reasonOfNoncompletion),
          details: entry.details.toDomain()
        )
      )
    case .credentialReissuance(let entry):
      return .credentialReissuance(
        .init(
          id: id,
          time: entry.time,
          result: entry.transactionResult.toDomain(reason: entry.reasonOfNoncompletion),
          details: entry.details.toDomain()
        )
      )
    case .credentialDeletion(let entry):
      return .credentialDeletion(
        .init(
          id: id,
          time: entry.time,
          result: entry.transactionResult.toDomain(reason: entry.reasonOfNoncompletion),
          credential: .init(identifier: .init(rawValue: entry.credentialIdentifier)),
          issuer: .init(
            name: entry.credentialIssuerName?.content,
            identifier: entry.credentialIssuerIdentifier?.toDomain(),
            contacts: []
          )
        )
      )
    case .signingSealing(let entry):
      return .signingSealing(
        .init(
          id: id,
          time: entry.time,
          result: entry.transactionResult.toDomain(reason: entry.reasonOfNoncompletion),
          service: .init(
            name: entry.interactingPartyName?.content,
            identifier: entry.interactingPartyIdentifier?.toDomain(),
            contacts: entry.interactingPartyContact ?? [],
            type: entry.interactingPartyType.nonBlankValue
          ),
          signingTransactionIdentifier: entry.signingTransactionIdentifier?.nonBlankValue,
          certificateSerialNumber: entry.certificateIdentifier,
          fileName: entry.fileName,
          fileSizeBytes: entry.fileSize.flatMap { Int($0) },
          dtbsr: entry.dtbsr
        )
      )
    case .dataDeletionRequest(let entry):
      guard let parentId = Self.validParent(parentPresentationId, ownId: id) else { return nil }
      return .dataDeletionRequest(
        .init(
          id: id,
          time: entry.time,
          result: entry.transactionResult.toDomain(reason: entry.reasonOfNoncompletion),
          parentPresentationId: parentId,
          party: .init(
            name: entry.interactingPartyName?.content,
            identifier: entry.interactingPartyIdentifier?.toDomain(),
            contacts: []
          ),
          claims: entry.listOfClaims.toDomain(),
          channel: actionChannel
        )
      )
    case .dpaReport(let entry):
      guard let parentId = Self.validParent(parentPresentationId, ownId: id) else { return nil }
      return .dpaReport(
        .init(
          id: id,
          time: entry.time,
          result: entry.transactionResult.toDomain(reason: entry.reasonOfNoncompletion),
          parentPresentationId: parentId,
          dpaName: entry.dpaName?.content,
          dpaCountry: entry.dpaCountry?.content,
          channel: actionChannel
        )
      )
    default:
      return nil
    }
  }

  func toTransactionLogStorage(
    parentPresentationId: String?,
    actionChannel: TransactionActionChannel? = nil
  ) throws -> logic_storage.TransactionLog {
    let data = try JSONEncoder().encode(self)
    return .init(
      identifier: transactionIdentifier,
      value: try data.toJSONString(),
      parentPresentationId: parentPresentationId,
      actionChannel: actionChannel?.rawValue
    )
  }

  private static func validParent(_ parentPresentationId: String?, ownId: String) -> String? {
    guard
      let parentPresentationId,
      !parentPresentationId.isEmpty,
      parentPresentationId != ownId
    else {
      return nil
    }
    return parentPresentationId
  }
}

extension logic_storage.TransactionLog {
  func toTransactionEntry() -> TransactionEntry? {
    guard let data = value.data(using: .utf8) else { return nil }
    return try? JSONDecoder().decode(TransactionEntry.self, from: data)
  }

  func toTransactionLogDomain() -> TransactionLogDomain? {
    toTransactionEntry()?.toTransactionLogDomain(
      id: identifier,
      parentPresentationId: parentPresentationId,
      actionChannel: actionChannel.flatMap { TransactionActionChannel(rawValue: $0) }
    )
  }
}

private extension TransactionEntry.Presentation {
  var intermediaryDomain: InteractingPartyDomain? {
    let name = intermediaryName?.content
    let identifier = intermediaryIdentifier?.toDomain()
    let contacts = intermediaryContact ?? []
    guard isIntermediary == true || name != nil || identifier != nil || !contacts.isEmpty else {
      return nil
    }
    return .init(name: name, identifier: identifier, contacts: contacts)
  }

  var registrationDomain: PresentationRegistrationDomain? {
    let localizedPurpose = purpose?.localizedContent
    let policyUrls = privacyPolicy?.map(\.policyURI) ?? []
    let dpa = dpaDomain
    guard registrarURL != nil || localizedPurpose != nil || !policyUrls.isEmpty || dpa != nil else {
      return nil
    }
    return .init(
      registrarUrl: registrarURL,
      purpose: localizedPurpose,
      privacyPolicyUrls: policyUrls,
      dpa: dpa
    )
  }

  var dpaDomain: DpaContactDomain? {
    let name = dpaName?.content
    let country = dpaCountry?.content
    let contacts = dpaContact ?? []
    guard name != nil || country != nil || !contacts.isEmpty else { return nil }
    return .init(name: name, country: country, contacts: contacts)
  }
}

private extension TransactionEntry.CredentialIssuanceDetails {
  func toDomain() -> IssuanceDetailsDomain {
    .init(
      issuer: .init(
        name: interactingPartyName?.content,
        identifier: interactingPartyIdentifier?.toDomain(),
        contacts: interactingPartyContact ?? [],
        type: interactingPartyType?.nonBlankValue
      ),
      requestedCount: credentialNumberRequested,
      issuedCount: credentialNumberIssued,
      credentials: credentialIdentifier.map { .init(identifier: .init(rawValue: $0)) },
      isUserTriggered: isUserTriggered
    )
  }
}

private extension TransactionResult {
  func toDomain(reason: String?) -> TransactionResultDomain {
    switch self {
    case .completed: .completed
    case .notCompleted: .notCompleted(reason: reason)
    }
  }
}

private extension QualifiedIdentifier {
  func toDomain() -> QualifiedIdentifierDomain {
    .init(schemeUri: type, value: value)
  }
}

private extension Array where Element == ClaimInfo {
  func toDomain() -> [CredentialClaimsDomain] {
    map { info in
      .init(
        credential: .init(identifier: .init(rawValue: info.credentialIdentifier)),
        claims: info.claims.map { .init(segments: $0.value.map(\.toDomain)) }
      )
    }
  }
}

private extension ClaimPathElement {
  var toDomain: ClaimPathSegment {
    switch self {
    case .claim(let name): .key(name: name)
    case .arrayElement(let index): .index(index)
    case .allArrayElements: .allElements
    }
  }
}

extension Array where Element == MultiLangString {
  var localizedContent: String? {
    let language = Locale.current.systemLanguageCode?.lowercased()
    return first { $0.lang.languageSubtag == language }?.content ?? first?.content
  }
}

private extension String {
  var nonBlankValue: String? {
    let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
    return trimmed.isEmpty ? nil : self
  }

  var languageSubtag: String {
    components(separatedBy: "-").first?.lowercased() ?? lowercased()
  }
}
