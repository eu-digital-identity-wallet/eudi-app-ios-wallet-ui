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
import SwiftUI
import logic_core
import logic_ui
import logic_resources

public struct RequestTransactionDataUiModel: Equatable, Sendable {
  public let details: PresentationListItemSection
  public let documentUrlsByItemId: [String: URL]

  public init(details: PresentationListItemSection, documentUrlsByItemId: [String: URL]) {
    self.details = details
    self.documentUrlsByItemId = documentUrlsByItemId
  }
}

public extension Array where Element == PresentationTransactionDataDomain {

  func toRequestTransactionDataUiModel(sectionId: String) -> RequestTransactionDataUiModel? {
    guard !isEmpty else { return nil }
    var builder = TransactionDataRowsBuilder<DocumentElementClaim>(sectionId: sectionId, isRecorded: false)
    builder.addTransactions(self)
    return .init(
      details: .init(
        id: sectionId,
        title: LocalizableStringKey.requestTransactionDataSignatureDetails.toString,
        listItems: builder.rows
      ),
      documentUrlsByItemId: builder.documentUrlsByItemId
    )
  }

  func toRecordedTransactionDataItems<T: Sendable>(sectionId: String) -> [ExpandableListItem<T>] {
    guard !isEmpty else { return [] }
    var builder = TransactionDataRowsBuilder<T>(sectionId: sectionId, isRecorded: true)
    builder.addTransactions(self)
    return builder.rows
  }
}

private struct TransactionDataRowsBuilder<T: Sendable> {

  let sectionId: String
  let isRecorded: Bool

  private(set) var rows: [ExpandableListItem<T>] = []
  private(set) var documentUrlsByItemId: [String: URL] = [:]

  init(sectionId: String, isRecorded: Bool) {
    self.sectionId = sectionId
    self.isRecorded = isRecorded
  }

  mutating func addTransactions(_ transactions: [PresentationTransactionDataDomain]) {
    addField(
      itemId: "\(sectionId)/framework",
      label: .requestTransactionDataTrustFramework,
      value: LocalizableStringKey.requestTransactionDataTrustFrameworkValue.toString
    )
    for (index, transaction) in transactions.enumerated() {
      let transactionId = "\(sectionId)/transaction-\(index)"
      if transactions.count > 1 {
        addField(
          itemId: "\(transactionId)/title",
          label: nil,
          value: LocalizableStringKey.requestTransactionDataNumbered([String(index + 1)]).toString
        )
      }
      switch transaction {
      case .qesApproval(let approval):
        addApproval(approval, itemId: transactionId)
      case .qes(let request):
        addRequest(request, itemId: transactionId)
      case .unavailable:
        addField(
          itemId: "\(transactionId)/unavailable",
          label: nil,
          value: LocalizableStringKey.requestTransactionDataUnavailable.toString
        )
      }
    }
  }

  private mutating func addApproval(_ approval: QesApprovalTransactionDomain, itemId: String) {
    addType(itemId: itemId, value: .requestTransactionDataTypeQes)
    addField(
      itemId: "\(itemId)/signature-type",
      label: .requestTransactionDataSignatureType,
      value: approval.signatureQualifier.map { $0.signatureTypeDisplayValue }
    )
    addCredentialReferences(itemId: itemId, credentialIds: approval.credentialIds)
    addField(itemId: "\(itemId)/credential", label: .requestTransactionDataSigningCredentialId, value: approval.credentialId)
    addField(itemId: "\(itemId)/count", label: .requestTransactionDataNumberOfSignatures, value: String(approval.numSignatures))
    addFields(itemId: "\(itemId)/location", label: .requestTransactionDataLocation, values: approval.locations)
    addFields(
      itemId: "\(itemId)/data-hash-algorithm",
      label: .requestTransactionDataHashAlgorithms,
      values: approval.transactionDataHashAlgorithms
    )

    for (documentIndex, document) in approval.documentDigests.enumerated() {
      let documentId = "\(itemId)/document-\(documentIndex)"
      let representation = document.hashType.hashRepresentationDisplayValue
      addDocumentName(itemId: documentId, label: document.label, index: documentIndex)
      addDocumentReference(itemId: documentId, href: document.href, checksum: document.checksum)
      addField(itemId: "\(documentId)/representation", label: .requestTransactionDataHashRepresentation, value: representation)
      addField(itemId: "\(documentId)/hash", label: .requestTransactionDataTypedHash([representation]), value: document.hash)
      addField(
        itemId: "\(documentId)/hash-algorithm",
        label: .requestTransactionDataTypedHashAlgorithm([representation]),
        value: approval.hashAlgorithmOid.hashAlgorithmDisplayValue
      )
      addSignedAttributes(itemId: documentId, attributes: document.signedProperties)
      addField(
        itemId: "\(documentId)/circumstantial-data",
        label: .requestTransactionDataCircumstantialData,
        value: document.circumstantialData
      )
      addDocumentAccess(itemId: documentId, accessMode: document.accessMode, oneTimePassword: document.oneTimePassword)
    }
  }

  private mutating func addRequest(_ request: QesTransactionDomain, itemId: String) {
    addType(itemId: itemId, value: .requestTransactionDataTypeQesRequest)
    addCredentialReferences(itemId: itemId, credentialIds: request.credentialIds)
    addFields(
      itemId: "\(itemId)/data-hash-algorithm",
      label: .requestTransactionDataHashAlgorithms,
      values: request.transactionDataHashAlgorithms
    )

    for (documentIndex, signatureRequest) in request.signatureRequests.enumerated() {
      let documentId = "\(itemId)/document-\(documentIndex)"
      addDocumentName(itemId: documentId, label: signatureRequest.label, index: documentIndex)
      addDocumentReference(itemId: documentId, href: signatureRequest.href, checksum: signatureRequest.checksum)
      addInlineDocument(itemId: documentId, document: signatureRequest.inlineDocument)
      addField(
        itemId: "\(documentId)/signature-type",
        label: .requestTransactionDataSignatureType,
        value: signatureRequest.signatureQualifier.signatureTypeDisplayValue
      )
      addField(
        itemId: "\(documentId)/format",
        label: .requestTransactionDataSignatureFormat,
        value: signatureRequest.signatureFormat.map { $0.signatureFormatDisplayValue }
      )
      addField(itemId: "\(documentId)/conformance", label: .requestTransactionDataConformanceLevel, value: signatureRequest.conformanceLevel)
      addField(
        itemId: "\(documentId)/signed-envelope-property",
        label: .requestTransactionDataSignedEnvelopeProperty,
        value: signatureRequest.signedEnvelopeProperty
      )
      addField(itemId: "\(documentId)/reference-uri", label: .requestTransactionDataReferenceUri, value: signatureRequest.referenceUri)
      addField(
        itemId: "\(documentId)/circumstantial-data",
        label: .requestTransactionDataCircumstantialData,
        value: signatureRequest.circumstantialData
      )
      addField(
        itemId: "\(documentId)/signature-algorithm",
        label: .requestTransactionDataSignatureAlgorithm,
        value: signatureRequest.signatureAlgorithm?.signatureAlgorithmDisplayValue
      )
      addField(
        itemId: "\(documentId)/signature-algorithm-parameters",
        label: .requestTransactionDataSignatureAlgorithmParameters,
        value: signatureRequest.signatureAlgorithmParameters
      )
      addSignedAttributes(itemId: documentId, attributes: signatureRequest.signedProperties)
      addDocumentAccess(
        itemId: documentId,
        accessMode: signatureRequest.accessMode,
        oneTimePassword: signatureRequest.oneTimePassword
      )
      addField(itemId: "\(documentId)/response-uri", label: .requestTransactionDataResponseUri, value: signatureRequest.responseUri)
    }
  }

  private mutating func addType(itemId: String, value: LocalizableStringKey) {
    guard !isRecorded else { return }
    addField(itemId: "\(itemId)/type", label: .requestTransactionDataType, value: value.toString)
  }

  private mutating func addCredentialReferences(itemId: String, credentialIds: [String]) {
    for (index, queryId) in credentialIds.enumerated() {
      addField(itemId: "\(itemId)/query-\(index)", label: .requestTransactionDataRequestedCredentials, value: queryId)
    }
  }

  private mutating func addDocumentName(itemId: String, label: String?, index: Int) {
    addField(
      itemId: "\(itemId)/name",
      label: .requestTransactionDataDocument,
      value: label ?? LocalizableStringKey.requestTransactionDataDocumentNumbered([String(index + 1)]).toString
    )
  }

  private mutating func addDocumentReference(itemId: String, href: String?, checksum: DocumentChecksumDomain?) {
    addField(itemId: "\(itemId)/location", label: .requestTransactionDataDocumentLocation, value: href)
    if !isRecorded, let url = href.flatMap({ $0.documentUrl }) {
      let actionId = "\(itemId)/open"
      documentUrlsByItemId[actionId] = url
      rows.append(
        .single(
          .init(
            collapsed: .init(
              id: actionId,
              mainContent: .text(.requestTransactionDataOpenDocument),
              mainTextColor: Theme.shared.color.accent,
              trailingContent: .icon(Theme.shared.image.arrowUpRightSquare)
            ),
            domainModel: nil
          )
        )
      )
    }
    addField(itemId: "\(itemId)/checksum", label: .requestTransactionDataExpectedChecksum, value: checksum?.value)
    addField(
      itemId: "\(itemId)/checksum-algorithm",
      label: .requestTransactionDataChecksumAlgorithm,
      value: checksum?.algorithmOid.hashAlgorithmDisplayValue
    )
  }

  /// One row for each value, all under `label`, with the index in each row's identifier.
  private mutating func addFields(itemId: String, label: LocalizableStringKey, values: [String]) {
    for (index, value) in values.enumerated() {
      addField(itemId: "\(itemId)-\(index)", label: label, value: value)
    }
  }

  /// How the document is fetched and, on the request only, its one-time password: history does not show the
  /// password again, as on Android.
  private mutating func addDocumentAccess(itemId: String, accessMode: String?, oneTimePassword: String?) {
    addField(
      itemId: "\(itemId)/access",
      label: .requestTransactionDataDocumentAccess,
      value: accessMode?.documentAccessDisplayValue
    )
    guard !isRecorded else { return }
    addField(itemId: "\(itemId)/otp", label: .requestTransactionDataOneTimePassword, value: oneTimePassword)
  }

  /// A document the request carries itself: that it is included, its type and its size, never its content.
  private mutating func addInlineDocument(itemId: String, document: QesInlineDocumentDomain?) {
    guard let document else { return }
    addField(
      itemId: "\(itemId)/content",
      label: .requestTransactionDataDocumentContent,
      value: LocalizableStringKey.requestTransactionDataDocumentContentInline.toString
    )
    addField(
      itemId: "\(itemId)/document-type",
      label: .requestTransactionDataDocumentType,
      value: document.documentType?.documentTypeDisplayValue
    )
    addField(
      itemId: "\(itemId)/size",
      label: .requestTransactionDataDocumentSize,
      value: document.sizeInBytes.map { ByteCountFormatter.string(fromByteCount: Int64($0), countStyle: .file) }
    )
  }

  private mutating func addSignedAttributes(itemId: String, attributes: [SigningAttributeDomain]?) {
    guard let attributes, !attributes.isEmpty else { return }
    addField(
      itemId: "\(itemId)/attributes",
      label: nil,
      value: LocalizableStringKey.requestTransactionDataSignedAttributes.toString,
      supportingText: .requestTransactionDataChosenByRelyingPartyWarning
    )
    for (index, attribute) in attributes.enumerated() {
      addField(
        itemId: "\(itemId)/attribute-\(index)",
        label: attribute.value.map { _ in LocalizableStringKey.custom(attribute.name) },
        value: attribute.value ?? attribute.name
      )
    }
  }

  /// `supportingText` shows in the warning colour, as the marker on the signed attributes, which the relying party
  /// chooses freely, does on Android.
  private mutating func addField(
    itemId: String,
    label: LocalizableStringKey?,
    value: String?,
    supportingText: LocalizableStringKey? = nil
  ) {
    guard let value else { return }
    rows.append(
      .single(
        .init(
          collapsed: .init(
            id: itemId,
            mainContent: .text(.custom(value)),
            overlineText: label,
            supportingText: supportingText,
            supportingTextColor: Theme.shared.color.warning
          ),
          domainModel: nil
        )
      )
    )
  }
}

private extension String {

  var signatureTypeDisplayValue: String {
    switch self {
    case "eu_eidas_qes": LocalizableStringKey.requestTransactionDataSignatureQes.toString
    case "eu_eidas_qeseal": LocalizableStringKey.requestTransactionDataSignatureQeseal.toString
    case "eu_eidas_aes": LocalizableStringKey.requestTransactionDataSignatureAes.toString
    case "eu_eidas_aeseal": LocalizableStringKey.requestTransactionDataSignatureAeseal.toString
    case "eu_eidas_aesqc": LocalizableStringKey.requestTransactionDataSignatureAesqc.toString
    case "eu_eidas_aesealqc": LocalizableStringKey.requestTransactionDataSignatureAesealqc.toString
    default: self
    }
  }

  var signatureFormatDisplayValue: String {
    switch self {
    case "C": "CAdES"
    case "X": "XAdES"
    case "P": "PAdES"
    case "J": "JAdES"
    default: self
    }
  }

  var hashRepresentationDisplayValue: String {
    switch self {
    case "dtbsr": "DTBSR"
    case "sdr": "SDR"
    case "sodr": "SODR"
    default: self
    }
  }

  var signatureAlgorithmDisplayValue: String {
    switch self {
    case "1.2.840.113549.1.1.1": "RSA"
    case "1.2.840.113549.1.1.10": "RSASSA-PSS"
    case "1.2.840.113549.1.1.11": "RSA with SHA-256"
    case "1.2.840.113549.1.1.12": "RSA with SHA-384"
    case "1.2.840.113549.1.1.13": "RSA with SHA-512"
    case "1.2.840.10045.2.1": "ECDSA"
    case "1.2.840.10045.4.3.2": "ECDSA with SHA-256"
    case "1.2.840.10045.4.3.3": "ECDSA with SHA-384"
    case "1.2.840.10045.4.3.4": "ECDSA with SHA-512"
    default: self
    }
  }

  var documentAccessDisplayValue: String {
    switch self {
    case "public": LocalizableStringKey.requestTransactionDataDocumentAccessPublic.toString
    case "OTP": LocalizableStringKey.requestTransactionDataDocumentAccessOtp.toString
    case "Basic_Auth": LocalizableStringKey.requestTransactionDataDocumentAccessBasic.toString
    case "Digest_Auth": LocalizableStringKey.requestTransactionDataDocumentAccessDigest.toString
    case "OAuth_20": LocalizableStringKey.requestTransactionDataDocumentAccessOauth.toString
    default: self
    }
  }

  var documentTypeDisplayValue: String {
    switch self {
    case "sod": LocalizableStringKey.requestTransactionDataDocumentTypeOriginal.toString
    case "sfd": LocalizableStringKey.requestTransactionDataDocumentTypeFormatted.toString
    default: self
    }
  }

  var hashAlgorithmDisplayValue: String {
    switch self {
    case "2.16.840.1.101.3.4.2.1": "SHA-256"
    case "2.16.840.1.101.3.4.2.2": "SHA-384"
    case "2.16.840.1.101.3.4.2.3": "SHA-512"
    default: self
    }
  }

  var documentUrl: URL? {
    guard
      let components = URLComponents(string: self),
      let scheme = components.scheme?.lowercased(),
      scheme == "https" || scheme == "http",
      let host = components.host, !host.isEmpty,
      components.user == nil,
      components.password == nil,
      components.port.map({ (1...65535).contains($0) }) ?? true
    else {
      return nil
    }
    return URL(string: self)
  }
}
