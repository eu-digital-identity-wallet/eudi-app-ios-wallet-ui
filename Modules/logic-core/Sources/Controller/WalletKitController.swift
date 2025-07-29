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
import logic_business
import SwiftUI
import logic_storage

private enum KeyIdentifier: String, KeyChainWrapper {
  public var value: String {
    self.rawValue
  }
  case dynamicIssuancePendingUrl
}

public protocol WalletKitController: Sendable {

  var wallet: EudiWallet { get }

  func startProximityPresentation() async -> ProximitySessionCoordinator
  func startSameDevicePresentation(deepLink: URLComponents) async -> RemoteSessionCoordinator
  func startCrossDevicePresentation(urlString: String) async -> RemoteSessionCoordinator
  func stopPresentation()

  func fetchAllDocuments() -> [DocClaimsDecodable]
  func fetchDeferredDocuments() -> [WalletStorage.Document]
  func fetchIssuedDocuments() -> [DocClaimsDecodable]
  func fetchIssuedDocuments(with types: [DocumentTypeIdentifier]) -> [DocClaimsDecodable]
  func fetchIssuedDocuments(excluded: [DocumentTypeIdentifier]) -> [DocClaimsDecodable]
  func fetchMainPidDocument() -> DocClaimsDecodable?
  func fetchDocument(with id: String) -> DocClaimsDecodable?
  func fetchDocuments(with ids: [String]) -> [DocClaimsDecodable]

  func clearAllDocuments() async
  func deleteDocument(with id: String, status: DocumentStatus) async throws
  func loadDocuments() async throws

  func issueDocument(identifier: String, docTypeIdentifier: DocumentTypeIdentifier) async throws -> WalletStorage.Document
  func requestDeferredIssuance(with doc: WalletStorage.Document) async throws -> DocClaimsDecodable
  func resolveOfferUrlDocTypes(uriOffer: String) async throws -> OfferedIssuanceModel
  func issueDocumentsByOfferUrl(
    offerUri: String,
    docTypes: [OfferedDocModel],
    txCodeValue: String?
  ) async throws -> [WalletStorage.Document]
  func parseDocClaim(
    docId: String,
    groupId: String,
    docClaim: DocClaim,
    type: DocumentElementType,
    parser: (String) -> String
  ) -> [DocumentElementClaim]
  func retrieveLogFileUrl() -> URL?
  func resumePendingIssuance(pendingDoc: WalletStorage.Document, webUrl: URL?) async throws -> WalletStorage.Document
  func storeDynamicIssuancePendingUrl(with url: URL)
  func getDynamicIssuancePendingData() async -> DynamicIssuancePendingData?
  func getScopedDocuments() async throws -> [ScopedDocument]
  func getDocumentCategories() -> DocumentCategories

  func isDocumentBookmarked(with id: String) async -> Bool
  func storeBookmarkedDocument(with id: String) async throws
  func removeBookmarkedDocument(with id: String) async throws

  func fetchTransactionLog(with id: String) async throws -> TransactionLogItem
  func fetchTransactionLogs() async throws -> [TransactionLogItem]

  func isDocumentRevoked(with id: String) async -> Bool
  func fetchRevokedDocuments() async throws -> [String]
  func storeRevokedDocuments(with ids: [String]) async throws
  func removeRevokedDocument(with id: String) async throws

  func getDocumentStatus(for statusIdentifier: StatusIdentifier) async throws -> CredentialStatus
  func isDocumentLowOnCredentials(document: DocClaimsDecodable?) -> Bool
}

final class WalletKitControllerImpl: WalletKitController {

  let wallet: EudiWallet
  private let sessionCoordinatorHolder: SessionCoordinatorHolder

  private let configLogic: WalletKitConfig
  private let keyChainController: KeyChainController
  private let bookmarkStorageController: any BookmarkStorageController
  private let transactionLogStorageController: any TransactionLogStorageController
  private let revokedDocumentStorageController: any RevokedDocumentStorageController

  init(
    configLogic: WalletKitConfig,
    keyChainController: KeyChainController,
    sessionCoordinatorHolder: SessionCoordinatorHolder,
    bookmarkStorageController: any BookmarkStorageController,
    transactionLogStorageController: any TransactionLogStorageController,
    revokedDocumentStorageController: any RevokedDocumentStorageController
  ) {
    self.configLogic = configLogic
    self.keyChainController = keyChainController
    self.sessionCoordinatorHolder = sessionCoordinatorHolder
    self.bookmarkStorageController = bookmarkStorageController
    self.transactionLogStorageController = transactionLogStorageController
    self.revokedDocumentStorageController = revokedDocumentStorageController

    guard let walletKit = try? EudiWallet(serviceName: configLogic.documentStorageServiceName) else {
      fatalError("Unable to Initialize WalletKit")
    }

    wallet = walletKit
    wallet.uiCulture = Locale.current.systemLanguageCode
    wallet.userAuthenticationRequired = configLogic.userAuthenticationRequired
    wallet.openID4VciIssuerUrl = configLogic.vciConfig.issuerUrl
    wallet.openID4VciConfig = .init(
      client: .public(id: configLogic.vciConfig.clientId),
      authFlowRedirectionURI: configLogic.vciConfig.redirectUri,
      usePAR: configLogic.vciConfig.usePAR,
      useDPoP: configLogic.vciConfig.useDPoP
    )
    wallet.trustedReaderCertificates = configLogic.readerConfig.trustedCerts
    wallet.logFileName = configLogic.logFileName
    walletKit.transactionLogger = configLogic.transactionLogger
  }

  func resolveOfferUrlDocTypes(uriOffer: String) async throws -> OfferedIssuanceModel {
    return try await wallet.resolveOfferUrlDocTypes(uriOffer: uriOffer)
  }

  func issueDocumentsByOfferUrl(
    offerUri: String,
    docTypes: [OfferedDocModel],
    txCodeValue: String?
  ) async throws -> [WalletStorage.Document] {
    let docTypes = docTypes.map { docType in
      let identifier: DocumentTypeIdentifier? = docType.docType.map {
        DocumentTypeIdentifier(rawValue: $0)
      } ?? docType.vct.map { DocumentTypeIdentifier(rawValue: $0) }

      let rule = configLogic.documentIssuanceConfig.rule(for: identifier)
      let keyOptions = KeyOptions(credentialPolicy: rule.policy, batchSize: rule.numberOfCredentials)
      return docType.copy(keyOptions: keyOptions)
    }

    return try await wallet.issueDocumentsByOfferUrl(
      offerUri: offerUri,
      docTypes: docTypes,
      txCodeValue: txCodeValue
    )
  }

  func clearAllDocuments() async {
    try? await wallet.deleteAllDocuments()
  }

  func deleteDocument(with id: String, status: DocumentStatus) async throws {
    try await wallet.deleteDocument(id: id, status: status)
    try await revokedDocumentStorageController.delete(id)
  }

  func loadDocuments() async throws {
    _ = try await wallet.loadAllDocuments()
  }

  func startProximityPresentation() async -> ProximitySessionCoordinator {
    self.stopPresentation()
    let session = await wallet.beginPresentation(flow: .ble)
    let proximitySessionCoordinator = DIGraph.resolver.force(
      ProximitySessionCoordinator.self,
      argument: session
    )
    self.sessionCoordinatorHolder.setActiveProximityCoordinator(proximitySessionCoordinator)
    return proximitySessionCoordinator
  }

  func startSameDevicePresentation(deepLink: URLComponents) async -> RemoteSessionCoordinator {
    await self.startRemotePresentation(
      urlString: decodeDeeplink(
        link: deepLink
      ) ?? ""
    )
  }

  func startCrossDevicePresentation(urlString: String) async -> RemoteSessionCoordinator {
    await self.startRemotePresentation(urlString: urlString)
  }

  func stopPresentation() {
    self.sessionCoordinatorHolder.clear()
  }

  func fetchAllDocuments() -> [DocClaimsDecodable] {
    return fetchIssuedDocuments() + fetchDeferredDocuments().transformToDeferredDecodables()
  }

  func fetchDeferredDocuments() -> [WalletStorage.Document] {
    return wallet.storage.deferredDocuments
  }

  func fetchIssuedDocuments() -> [DocClaimsDecodable] {
    return wallet.storage.docModels
  }

  func fetchIssuedDocuments(with types: [DocumentTypeIdentifier]) -> [DocClaimsDecodable] {
    return wallet.storage.docModels
      .filter({ types.map { $0.rawValue }.contains($0.docType) })
  }

  func fetchMainPidDocument() -> DocClaimsDecodable? {
    return fetchIssuedDocuments(with: [DocumentTypeIdentifier.mDocPid, DocumentTypeIdentifier.sdJwtPid])
      .sorted { $0.createdAt > $1.createdAt }.last
  }

  func fetchIssuedDocuments(excluded: [DocumentTypeIdentifier]) -> [DocClaimsDecodable] {
    let excludedRawValues = excluded.map { $0.rawValue }
    return fetchIssuedDocuments().filter { !excludedRawValues.contains($0.docType.orEmpty) }
  }

  func fetchDocument(with id: String) -> DocClaimsDecodable? {
    wallet.storage.getDocumentModel(id: id)
  }

  func fetchDocuments(with ids: [String]) -> [DocClaimsDecodable] {
    fetchIssuedDocuments().filter { ids.contains($0.id) }
  }

  func issueDocument(identifier: String, docTypeIdentifier: DocumentTypeIdentifier) async throws -> WalletStorage.Document {
    let rule = configLogic.documentIssuanceConfig.rule(for: docTypeIdentifier)
    let keyOptions = KeyOptions(credentialPolicy: rule.policy, batchSize: rule.numberOfCredentials)

    return try await wallet.issueDocument(docTypeIdentifier: .identifier(identifier), keyOptions: keyOptions)
  }

  func requestDeferredIssuance(with doc: WalletStorage.Document) async throws -> DocClaimsDecodable {
    let result = try await wallet.requestDeferredIssuance(deferredDoc: doc)
    if result.isDeferred {
      return result.transformToDeferredDecodable()
    } else if let doc = fetchDocument(with: result.id) {
      return doc
    } else {
      throw WalletCoreError.unableFetchDocument
    }
  }

  func retrieveLogFileUrl() -> URL? {
    guard
      let url = try? EudiWallet.getLogFileURL(configLogic.logFileName)
    else {
      return nil
    }
    return url
  }

  func resumePendingIssuance(pendingDoc: WalletStorage.Document, webUrl: URL?) async throws -> WalletStorage.Document {
    return try await wallet.resumePendingIssuance(pendingDoc: pendingDoc, webUrl: webUrl)
  }

  func storeDynamicIssuancePendingUrl(with url: URL) {
    keyChainController.storeValue(
      key: KeyIdentifier.dynamicIssuancePendingUrl,
      value: url.absoluteString
    )
  }

  func getDynamicIssuancePendingData() async -> DynamicIssuancePendingData? {

    guard
      let urlString = keyChainController.getValue(key: KeyIdentifier.dynamicIssuancePendingUrl),
      let url = urlString.toCompatibleUrl()
    else {
      return nil
    }

    keyChainController.removeObject(
      key: KeyIdentifier.dynamicIssuancePendingUrl
    )

    guard let pendingDoc = wallet.storage.pendingDocuments.last else {
      return nil
    }

    return .init(pendingDoc: pendingDoc, url: url)
  }

  func getScopedDocuments() async throws -> [ScopedDocument] {
    let metadata = try await wallet.getIssuerMetadata()
    return metadata.credentialsSupported.compactMap { credential in
      switch credential.value {
      case .msoMdoc(let config):
        let identifier = DocumentTypeIdentifier(rawValue: config.docType)
        return ScopedDocument(
          name: config.display.getName(fallback: credential.key.value),
          issuer: metadata.display.getName(fallback: ""),
          configId: credential.key.value,
          isPid: identifier == .mDocPid,
          docTypeIdentifier: identifier
        )
      case .sdJwtVc(let config):
        guard let vct = config.vct else {
          return nil
        }
        let identifier = DocumentTypeIdentifier(rawValue: vct)
        return ScopedDocument(
          name: config.display.getName(fallback: credential.key.value),
          issuer: metadata.display.getName(fallback: ""),
          configId: credential.key.value,
          isPid: identifier == .sdJwtPid,
          docTypeIdentifier: identifier
        )
      default: return nil
      }
    }
  }

  func isDocumentLowOnCredentials(document: DocClaimsDecodable?) -> Bool {
    if let document, let documentRemainingCredentials = document.credentialsUsageCounts?.remaining {
      return document.credentialPolicy == CredentialPolicy.oneTimeUse && documentRemainingCredentials <= 1
    } else {
      return false
    }
  }

  func getDocumentCategories() -> DocumentCategories {
    let sorted = configLogic.documentsCategories.sorted { $0.key.order < $1.key.order }
    return DocumentCategories(uniqueKeysWithValues: sorted)
  }

  func isDocumentBookmarked(with id: String) async -> Bool {
    return await (try? bookmarkStorageController.retrieve(id)) != nil
  }

  func storeBookmarkedDocument(with id: String) async throws {
    try await bookmarkStorageController.store(.init(identifier: id))
  }

  func removeBookmarkedDocument(with id: String) async throws {
    try await bookmarkStorageController.delete(id)
  }

  func fetchTransactionLog(with id: String) async throws -> TransactionLogItem {
    guard
      let storedLog = try? await self.transactionLogStorageController.retrieve(id),
      let item = try? storedLog.toTransactionLogItem(
        id: storedLog.identifier,
        parse: { self.wallet.parseTransactionLog($0) }
      )
    else {
      throw WalletCoreError.unableToFetchTransactionLog
    }
    return item
  }

  func fetchTransactionLogs() async throws -> [TransactionLogItem] {
    guard
      let storedLogs = try? await self.transactionLogStorageController.retrieveAll()
    else {
      throw WalletCoreError.unableToFetchTransactionLog
    }
    return storedLogs.compactMap {
      guard
        let item = try? $0.toTransactionLogItem(
          id: $0.identifier,
          parse: { self.wallet.parseTransactionLog($0) }
        )
      else {
        return nil
      }
      return item
    }
  }

  func fetchRevokedDocuments() async throws -> [String] {
    return try await self.revokedDocumentStorageController.retrieveAll().map {
      return $0.identifier
    }
  }

  func storeRevokedDocuments(with ids: [String]) async throws {
    try await revokedDocumentStorageController.store(ids.map { .init(identifier: $0) })
  }

  func removeRevokedDocument(with id: String) async throws {
    try await revokedDocumentStorageController.delete(id)
  }

  func isDocumentRevoked(with id: String) async -> Bool {
    return (try? await revokedDocumentStorageController.retrieve(id)) != nil
  }

  func getDocumentStatus(for statusIdentifier: StatusIdentifier) async throws -> CredentialStatus {
    return try await wallet.getDocumentStatus(for: statusIdentifier)
  }
}

private extension WalletKitControllerImpl {

  func decodeDeeplink(link: URLComponents) -> String? {
    // Handling requests of the form
    //    mdoc-openid4vp://https://eudi.netcompany-intrasoft.com?client_id=Verifier&request_uri=https://eudi.netcompany-intrasoft.com/wallet/request.jwt/OWB1_xVU7ndoHmirBn7S2JpcC5fFPzAXGCY1fTLxDjczVATjzQvre_w4yEcMB4FO5KwuyYXXw-JottarKgEvRQ
    // so we need to drop scheme and forward slashes and keep the rest of the url in order to
    // pass to wallet

    return link.removeSchemeFromComponents()?.string
  }

  func startRemotePresentation(urlString: String) async -> RemoteSessionCoordinator {
    self.stopPresentation()

    let data = urlString.data(using: .utf8) ?? Data()

    let session = await wallet.beginPresentation(flow: .openid4vp(qrCode: data))
    let remoteSessionCoordinator = DIGraph.resolver.force(
      RemoteSessionCoordinator.self,
      argument: session
    )
    self.sessionCoordinatorHolder.setActiveRemoteCoordinator(remoteSessionCoordinator)
    return remoteSessionCoordinator
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

    if let children = docClaim.children, !children.isEmpty {

      let title = docClaim.displayName.ifNilOrEmpty { docClaim.name }
      var childClaims: [DocumentElementClaim] = []

      parseChildren(
        docId: docId,
        groupId: groupId,
        docClaims: children,
        type: type,
        parser: parser,
        claims: &childClaims
      )

      return if title.isEmpty {
        childClaims.sortByName()
      } else {
        [
          .group(
            id: UUID().uuidString,
            title: docClaim.displayName.ifNilOrEmpty { docClaim.name },
            items: childClaims.sortByName()
          )
        ]
      }
    }

    var value: DocumentElementValue {
      if let image = docClaim.dataValue.image {
        return .image(Image(uiImage: image))
      } else {

        let claim = docClaim
          .parseDate(parser: parser)
          .parseUserPseudonym()

        return .string(claim.stringValue)
      }
    }

    var groupIdentifier: String {
      return switch type {
      case .mdoc:
        groupId
      case .sdjwt:
        if docClaim.path.last?.isEmpty == true {
          groupId
        } else {
          UUID().uuidString
        }
      }
    }

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
