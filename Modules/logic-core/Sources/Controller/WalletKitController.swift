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
import logic_storage
import logic_api

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
  func stopPresentation() async

  func fetchAllDocuments() async -> [any DocClaimsDecodable]
  func fetchDeferredDocuments() async -> [WalletStorage.Document]
  func fetchIssuedDocuments() async -> [any DocClaimsDecodable]
  func fetchIssuedDocuments(with types: [DocumentTypeIdentifier]) async -> [any DocClaimsDecodable]
  func fetchIssuedDocuments(excluded: [DocumentTypeIdentifier]) async -> [any DocClaimsDecodable]
  func fetchMainPidDocument() async -> (any DocClaimsDecodable)?
  func fetchDocument(with id: String) async -> (any DocClaimsDecodable)?
  func fetchDocuments(with ids: [String]) async -> [any DocClaimsDecodable]
  func clearAllDocuments() async throws
  func deleteDocument(with id: String, status: DocumentStatus) async throws
  func loadDocuments() async throws
  func issueDocuments(
    issuerId: String,
    identifiers: [String],
    docTypeIdentifier: DocumentTypeIdentifier
  ) async throws -> IssuanceResult
  func reIssueDocument(
    identifier: String,
    isBackgroundOperation: Bool
  ) async throws -> WalletStorage.Document
  func getDocumentCredentialOptions(with id: String) async -> CredentialOptions?
  func requestDeferredIssuance(with doc: WalletStorage.Document) async throws -> any DocClaimsDecodable
  func resolveOfferUrlDocTypes(offerUri: String) async throws -> OfferedIssuanceModel
  func issueDocumentsByOfferUrl(
    offerUri: String,
    docTypes: [OfferedDocModel],
    txCodeValue: String?
  ) async throws -> IssuanceResult
  func parseDocClaim(
    docId: String,
    groupId: String,
    docClaim: DocClaim,
    type: DocumentElementType,
    parser: (String) -> String
  ) async -> [DocumentElementClaim]
  func retrieveLogFileUrl() async -> URL?
  func resumePendingIssuance(pendingDoc: WalletStorage.Document, webUrl: URL?) async throws -> WalletStorage.Document
  func storeDynamicIssuancePendingUrl(with url: URL) async
  func getDynamicIssuancePendingData() async -> DynamicIssuancePendingData?
  func getScopedDocuments() async -> ScopedDocumentsResult
  func getDocumentCategories() async -> DocumentCategories

  func isDocumentBookmarked(with id: String) async -> Bool
  func storeBookmarkedDocument(with id: String) async throws
  func removeBookmarkedDocument(with id: String) async throws

  func fetchTransactionLog(with id: String) async throws -> TransactionLogDomain
  func fetchTransactionLogs() async throws -> [TransactionLogDomain]
  func deleteTransactionLog(with id: String) async throws
  func fetchPresentationActions(parentPresentationId: String) async throws -> [TransactionLogDomain]
  func recordDataDeletionRequest(for presentation: TransactionLogDomain.Presentation, contactUrl: URL) async throws
  func recordDpaReport(for presentation: TransactionLogDomain.Presentation, contactUrl: URL) async throws

  func isDocumentRevoked(with id: String) async -> Bool
  func fetchRevokedDocuments() async throws -> [String]
  func storeRevokedDocuments(with ids: [String]) async throws
  func removeRevokedDocument(with id: String) async throws

  func getDocumentStatus(for statusList: MdocDataModel18013.StatusList) async throws -> CredentialStatus
  func isDocumentLowOnCredentials(document: (any DocClaimsDecodable)?) async -> Bool

  func storeFailedReIssuedDocuments(ids: [String]) async throws
  func removeAllFailedReIssuedDocuments() async throws

  func refreshUsageCounters() async throws
  func getIssuerRegistration(for offer: OfferedIssuanceModel) async -> IssuerRegistration?
  func getIssuerRegistration(issuerId: String, configIds: [String]) async -> IssuerRegistration?

  func getVerifierRegistration(
    policy: WrpRegistrationPolicy?,
    trustViolations: [String],
    overaskedClaims: [logic_core.OveraskedClaim],
    verifierName: String?,
    verifierIsTrusted: Bool
  ) async -> RelyingPartyRegistration

  func getVerifierRegistrationForFailedRequest() async -> RelyingPartyRegistration?
}

final actor WalletKitControllerImpl: WalletKitController {

  let wallet: EudiWallet
  private let sessionCoordinatorHolder: SessionCoordinatorHolder

  private let walletKitConfig: WalletKitConfig
  private let configLogic: ConfigLogic
  private let keyChainController: KeyChainController
  private let bookmarkStorageController: any BookmarkStorageController
  private let transactionLogStorageController: any TransactionLogStorageController
  private let revokedDocumentStorageController: any RevokedDocumentStorageController
  private let failedReIssuedDocStorageController: any FailedReIssuedDocStorageController
  private let documentRegistrationManager: DocumentRegistrationManager

  init(
    walletKitConfig: WalletKitConfig,
    configLogic: ConfigLogic,
    keyChainController: KeyChainController,
    sessionCoordinatorHolder: SessionCoordinatorHolder,
    bookmarkStorageController: any BookmarkStorageController,
    transactionLogStorageController: any TransactionLogStorageController,
    revokedDocumentStorageController: any RevokedDocumentStorageController,
    failedReIssuedDocStorageController: any FailedReIssuedDocStorageController,
    networkSessionProvider: NetworkSessionProvider,
    documentRegistrationManager: DocumentRegistrationManager
  ) {
    self.walletKitConfig = walletKitConfig
    self.configLogic = configLogic
    self.keyChainController = keyChainController
    self.sessionCoordinatorHolder = sessionCoordinatorHolder
    self.bookmarkStorageController = bookmarkStorageController
    self.transactionLogStorageController = transactionLogStorageController
    self.revokedDocumentStorageController = revokedDocumentStorageController
    self.failedReIssuedDocStorageController = failedReIssuedDocStorageController
    self.documentRegistrationManager = documentRegistrationManager

    guard let walletKit = try? EudiWallet(
      eudiWalletConfig: EudiWalletConfiguration(
        serviceName: configLogic.keyChainConfig.documentStorageServiceName,
        accessGroup: configLogic.keyChainConfig.keychainAccessGroup,
        userAuthenticationRequired: walletKitConfig.userAuthenticationRequired,
        deviceAuthMethod: .deviceSignature,
        uiCulture: Locale.current.systemLanguageCode,
        logFileName: walletKitConfig.logFileName
      ),
      trustConfig: walletKitConfig.trustConfiguration,
      openID4VpConfig: walletKitConfig.vpConfig,
      openID4VciConfigurations: walletKitConfig.issuersConfig.mapValues { $0.config },
      networking: networkSessionProvider.urlSession,
      transactionLogger: walletKitConfig.transactionLogger,
      trustMarkSource: walletKitConfig.trustMarkSource
    ) else {
      fatalError("Unable to Initialize WalletKit")
    }

    wallet = walletKit
  }

  func resolveOfferUrlDocTypes(offerUri: String) async throws -> OfferedIssuanceModel {
    return try await wallet.resolveOfferUrlDocTypes(
      offerUri: offerUri,
      authFlowRedirectionURI: nil
    )
  }

  private func resolveCredentialOptions(
    documentId: String,
    documentTypeIdentifier: DocumentTypeIdentifier?
  ) async -> CredentialOptions {
    if let persisted = await getDocumentCredentialOptions(with: documentId) {
      return persisted
    }
    return walletKitConfig.documentIssuanceConfig.credentialOptions(for: documentTypeIdentifier)
  }

  func getDocumentCredentialOptions(with id: String) async -> CredentialOptions? {
    return try? await wallet.getDocumentCredentialOptions(documentId: id)
  }

  func issueDocumentsByOfferUrl(
    offerUri: String,
    docTypes: [OfferedDocModel],
    txCodeValue: String?
  ) async throws -> IssuanceResult {
    let docTypes = docTypes.map { docType in
      let credentialOptions = walletKitConfig.documentIssuanceConfig.credentialOptions(for: docType.documentTypeIdentifier)
      return docType.copy(
        credentialOptions: credentialOptions,
        keyOptions: walletKitConfig.keyOptions
      )
    }

    let response = try await wallet.issueDocumentsByOfferUrl(
      offerUri: offerUri,
      docTypes: docTypes,
      txCodeValue: txCodeValue
    )
    await reconcileRegistrations()
    return IssuanceResult(
      documents: response.documents,
      issuerRegistration: makeIssuerRegistration(
        policy: response.wrpIssuerPolicy,
        warnings: response.wrpIssuerWarnings
      )
    )
  }

  func clearAllDocuments() async throws {
    try await wallet.deleteAllDocuments()
    await reconcileRegistrations()
  }

  func deleteDocument(with id: String, status: DocumentStatus) async throws {
    try await wallet.deleteDocument(id: id, status: status)
    try await revokedDocumentStorageController.delete(id)
    await reconcileRegistrations()
  }

  func loadDocuments() async throws {
    _ = try await wallet.loadAllDocuments()
    await reconcileRegistrations()
  }

  func startProximityPresentation() async -> ProximitySessionCoordinator {
    await self.stopPresentation()
    let session = await wallet.beginPresentation(flow: .ble)
    let proximitySessionCoordinator = DIGraph.shared.resolver.force(
      ProximitySessionCoordinator.self,
      argument: session
    )
    await self.sessionCoordinatorHolder.setActiveProximityCoordinator(proximitySessionCoordinator)
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

  func stopPresentation() async {
    await self.sessionCoordinatorHolder.clear()
  }

  func fetchAllDocuments() async -> [any DocClaimsDecodable] {
    return fetchIssuedDocuments() + fetchDeferredDocuments().transformToDeferredDecodables()
  }

  func fetchDeferredDocuments() -> [WalletStorage.Document] {
    return wallet.storage.deferredDocuments
  }

  func fetchIssuedDocuments() -> [any DocClaimsDecodable] {
    return wallet.storage.docModels
  }

  func fetchIssuedDocuments(with types: [DocumentTypeIdentifier]) -> [any DocClaimsDecodable] {
    return wallet.storage.docModels
      .filter({ types.map { $0.rawValue }.contains($0.docType) })
  }

  func fetchMainPidDocument() -> (any DocClaimsDecodable)? {
    return fetchIssuedDocuments(with: [DocumentTypeIdentifier.mDocPid, DocumentTypeIdentifier.sdJwtPid])
      .sorted { $0.createdAt > $1.createdAt }.last
  }

  func fetchIssuedDocuments(excluded: [DocumentTypeIdentifier]) -> [any DocClaimsDecodable] {
    let excludedRawValues = excluded.map { $0.rawValue }
    return fetchIssuedDocuments().filter { !excludedRawValues.contains($0.docType) }
  }

  func fetchDocument(with id: String) -> (any DocClaimsDecodable)? {
    wallet.storage.getDocumentModel(id: id)
  }

  func fetchDocuments(with ids: [String]) async -> [any DocClaimsDecodable] {
    let documents = fetchIssuedDocuments().filter { ids.contains($0.id) }
    await reconcileRegistrations()
    return documents
  }

  func issueDocuments(
    issuerId: String,
    identifiers: [String],
    docTypeIdentifier: DocumentTypeIdentifier
  ) async throws -> IssuanceResult {
    let credentialOptions = walletKitConfig.documentIssuanceConfig.credentialOptions(for: docTypeIdentifier)

    let response = try await wallet.issueDocuments(
      issuerName: issuerId,
      docTypeIdentifiers: identifiers.map { .identifier($0) },
      credentialOptions: credentialOptions,
      keyOptions: walletKitConfig.keyOptions
    )
    await reconcileRegistrations()
    return IssuanceResult(
      documents: response.documents,
      issuerRegistration: makeIssuerRegistration(
        policy: response.wrpIssuerPolicy,
        warnings: response.wrpIssuerWarnings
      )
    )
  }

  private var isIssuerRegistrationEnforced: Bool {
    guard walletKitConfig.validateIssuerRegistrationCertificate else { return false }
    if case .enforce = walletKitConfig.trustConfiguration.wrprcVciTrustPolicy { return true }
    return false
  }

  private func makeIssuerRegistration(
    policy: WrpRegistrationPolicy?,
    warnings: [String: [RegistrationPolicyViolation]]?
  ) -> IssuerRegistration? {

    guard let policy else {
      return isIssuerRegistrationEnforced ? .blocked(reason: .notRegisteredAsProvider) : nil
    }

    let raised = (warnings ?? [:]).values.flatMap { $0 }

    if raised.contains(where: { if case .credentialNotCovered = $0.reason { true } else { false } }) {
      return .blocked(reason: .attestationNotRegistered)
    }

    guard raised.isEmpty else { return .blocked(reason: .notRegisteredAsProvider) }

    return .verified(
      details: RegistrationDetails(
        tradeName: policy.name ?? policy.sub,
        uniqueId: policy.sub,
        logoUrl: nil,
        intendedUse: policy.purpose?.localizedValue,
        privacyPolicyUrl: policy.privacyPolicy.flatMap { URL(string: $0) },
        serviceDescription: policy.srvDescription?.localizedValue
      )
    )
  }

  func reIssueDocument(identifier: String, isBackgroundOperation: Bool) async throws -> WalletStorage.Document {
    let document = fetchDocument(with: identifier)

    if let issuerId = document?.credentialIssuerIdentifier,
       let configId = document?.configurationIdentifier,
       case .blocked = await getIssuerRegistration(issuerId: issuerId, configIds: [configId]) {
      throw RegistrationRefusedError()
    }

    let credentialOptions = await resolveCredentialOptions(
      documentId: identifier,
      documentTypeIdentifier: document?.documentTypeIdentifier
    )
    let response = try await wallet.reissueDocument(
      documentId: identifier,
      credentialOptions: credentialOptions,
      keyOptions: walletKitConfig.keyOptions,
      backgroundOnly: isBackgroundOperation
    )
    guard let document = response.documents.first else {
      throw WalletCoreError.unableToIssueAndStore
    }
    await reconcileRegistrations()
    return document
  }

  func requestDeferredIssuance(with doc: WalletStorage.Document) async throws -> any DocClaimsDecodable {
    guard
      let metadata = DocMetadata(from: doc.metadata)
    else {
      throw WalletCoreError.missingMetadata
    }
    let credentialOptions = await resolveCredentialOptions(
      documentId: doc.id,
      documentTypeIdentifier: doc.documentTypeIdentifier
    )
    let result = try await wallet.requestDeferredIssuance(
      issuerName: metadata.credentialIssuerIdentifier,
      deferredDoc: doc,
      credentialOptions: credentialOptions,
      keyOptions: walletKitConfig.keyOptions
    )
    if result.isDeferred {
      return result.transformToDeferredDecodable()
    } else if let doc = fetchDocument(with: result.id) {
      await reconcileRegistrations()
      return doc
    } else {
      throw WalletCoreError.unableFetchDocument
    }
  }

  func retrieveLogFileUrl() -> URL? {
    guard
      let url = try? EudiWallet.getLogFileURL(walletKitConfig.logFileName)
    else {
      return nil
    }
    if url.isFileURL {
      let directoryUrl = url.deletingLastPathComponent()
      if !FileManager.default.fileExists(atPath: directoryUrl.path) {
        try? FileManager.default.createDirectory(
          at: directoryUrl,
          withIntermediateDirectories: true
        )
      }
      if !FileManager.default.fileExists(atPath: url.path) {
        FileManager.default.createFile(atPath: url.path, contents: Data())
      }
    }
    return url
  }

  func resumePendingIssuance(pendingDoc: WalletStorage.Document, webUrl: URL?) async throws -> WalletStorage.Document {
    guard
      let metadata = DocMetadata(from: pendingDoc.metadata)
    else {
      throw WalletCoreError.missingMetadata
    }
    let credentialOptions = await resolveCredentialOptions(
      documentId: pendingDoc.id,
      documentTypeIdentifier: pendingDoc.documentTypeIdentifier
    )
    let document = try await wallet.resumePendingIssuance(
      issuerName: metadata.credentialIssuerIdentifier,
      pendingDoc: pendingDoc,
      webUrl: webUrl,
      credentialOptions: credentialOptions,
      keyOptions: walletKitConfig.keyOptions
    )
    await reconcileRegistrations()
    return document
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

  func getScopedDocuments() async -> ScopedDocumentsResult {

    let issuersConfig = walletKitConfig.issuersConfig

    return await withTaskGroup(of: Result<[ScopedDocument], Error>.self) { group in
      for (issuerName, orderedVciConfig) in issuersConfig {
        group.addTask {
          do {
            let metadata = try await self.wallet.getIssuerMetadata(issuerName: issuerName)
            return .success(
              metadata.credentialsSupported.compactMap { credential in
                switch credential.value {
                case .msoMdoc(let config):
                  let id = DocumentTypeIdentifier(rawValue: config.docType)
                  return ScopedDocument(
                    name: config.credentialMetadata?.display.getName(fallback: credential.key.value) ?? credential.key.value,
                    issuer: metadata.credentialIssuerIdentifier.url.host.ifNilOrEmpty { issuerName },
                    order: orderedVciConfig.order,
                    configId: credential.key.value,
                    isPid: id == .mDocPid,
                    docTypeIdentifier: id
                  )

                case .sdJwtVc(let config):
                  guard let vct = config.vct else { return nil }
                  let id = DocumentTypeIdentifier(rawValue: vct)
                  return ScopedDocument(
                    name: config.credentialMetadata?.display.getName(fallback: credential.key.value) ?? credential.key.value,
                    issuer: metadata.credentialIssuerIdentifier.url.host.ifNilOrEmpty { issuerName },
                    order: orderedVciConfig.order,
                    configId: credential.key.value,
                    isPid: id == .sdJwtPid,
                    docTypeIdentifier: id
                  )

                default:
                  return nil
                }
              }
            )
          } catch {
            return .failure(error)
          }
        }
      }

      var documents: [ScopedDocument] = []
      var errors: [Error] = []
      for await result in group {
        switch result {
        case .success(let docs): documents.append(contentsOf: docs)
        case .failure(let error): errors.append(error)
        }
      }
      return ScopedDocumentsResult(
        documents: documents,
        errors: errors,
        totalIssuers: issuersConfig.count
      )
    }
  }

  func isDocumentLowOnCredentials(document: (any DocClaimsDecodable)?) -> Bool {
    if let document, let documentRemainingCredentials = document.credentialsUsageCounts?.remaining {
      return document.credentialPolicy == CredentialPolicy.oneTimeUse && documentRemainingCredentials <= 1
    } else {
      return false
    }
  }
  func getIssuerRegistration(for offer: OfferedIssuanceModel) async -> IssuerRegistration? {
    makeIssuerRegistration(
      policy: offer.wrpVciRegistrationPolicy,
      warnings: offer.wrpVciWarnings
    )
  }

  func getIssuerRegistration(issuerId: String, configIds: [String]) async -> IssuerRegistration? {
    guard let response = try? await wallet.resolveIssuerRegistration(
      issuerName: issuerId,
      credentialConfigurationIds: configIds
    ) else {
      return nil
    }
    return makeIssuerRegistration(
      policy: response.wrpIssuerPolicy,
      warnings: response.wrpIssuerWarnings
    )
  }

  func getVerifierRegistrationForFailedRequest() async -> RelyingPartyRegistration? {

    guard let policy = await wallet.wrpRegistrationValidator.wrpVpRegistrationPolicy else {
      return nil
    }

    return await getVerifierRegistration(
      policy: policy,
      trustViolations: [],
      overaskedClaims: [],
      verifierName: nil,
      verifierIsTrusted: false
    )
  }

  func getDocumentCategories() -> DocumentCategories {
    let sorted = walletKitConfig.documentsCategories.sorted { $0.key.order < $1.key.order }
    return DocumentCategories(uniqueKeysWithValues: sorted)
  }

  func getVerifierRegistration(
    policy: WrpRegistrationPolicy?,
    trustViolations: [String],
    overaskedClaims: [OveraskedClaim],
    verifierName: String?,
    verifierIsTrusted: Bool
  ) async -> RelyingPartyRegistration {

    let unregistered = RelyingPartyRegistration(
      name: verifierName,
      uniqueId: nil,
      isVerified: verifierIsTrusted,
      logoUrl: nil,
      registration: .notSupported
    )

    guard walletKitConfig.validateIssuerRegistrationCertificate else { return unregistered }

    guard let policy else {
      return trustViolations.isEmpty ? unregistered : RelyingPartyRegistration(
        name: verifierName,
        uniqueId: nil,
        isVerified: verifierIsTrusted,
        logoUrl: nil,
        registration: .notVerified(details: nil)
      )
    }

    let privacyPolicyUrl = policy.privacyPolicy.flatMap { URL(string: $0) }

    let subjectDetails = RegistrationDetails(
      tradeName: policy.name ?? policy.sub,
      uniqueId: policy.sub,
      logoUrl: nil,
      intendedUse: policy.purpose?.localizedValue,
      privacyPolicyUrl: privacyPolicyUrl,
      serviceDescription: policy.srvDescription?.localizedValue
    )

    let status: RegistrationStatus = trustViolations.isEmpty
    ? .verified(details: subjectDetails, overaskedClaims: overaskedClaims)
    : .notVerified(details: subjectDetails)

    return RelyingPartyRegistration(
      name: status.resolveRequesterName(
        registrationName: policy.name,
        accessCertificateName: verifierName
      ),
      uniqueId: policy.sub,
      isVerified: verifierIsTrusted,
      logoUrl: nil,
      registration: status
    )
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

  func fetchTransactionLog(with id: String) async throws -> TransactionLogDomain {
    guard
      let storedLog = try? await self.transactionLogStorageController.retrieve(id),
      let log = storedLog.toTransactionLogDomain()
    else {
      throw WalletCoreError.unableToFetchTransactionLog
    }
    return log
  }

  func fetchTransactionLogs() async throws -> [TransactionLogDomain] {
    guard
      let storedLogs = try? await self.transactionLogStorageController.retrieveAll()
    else {
      throw WalletCoreError.unableToFetchTransactionLog
    }
    var logs: [TransactionLogDomain] = []
    for storedLog in storedLogs {
      guard let entry = storedLog.toTransactionEntry() else {
        try? await self.transactionLogStorageController.delete(storedLog.identifier)
        continue
      }
      guard
        let log = entry.toTransactionLogDomain(
          id: storedLog.identifier,
          parentPresentationId: storedLog.parentPresentationId
        )
      else {
        continue
      }
      logs.append(log)
    }
    return logs
  }

  func deleteTransactionLog(with id: String) async throws {
    let actions = (try? await self.transactionLogStorageController.retrieve(parentPresentationId: id)) ?? []
    for action in actions {
      try await self.transactionLogStorageController.delete(action.identifier)
    }
    try await self.transactionLogStorageController.delete(id)
  }

  func fetchPresentationActions(parentPresentationId: String) async throws -> [TransactionLogDomain] {
    let storedActions = try await self.transactionLogStorageController.retrieve(parentPresentationId: parentPresentationId)
    return storedActions
      .compactMap { $0.toTransactionLogDomain() }
      .filter { $0.parentPresentationId == parentPresentationId }
      .sorted { $0.time > $1.time }
  }

  func recordDataDeletionRequest(for presentation: TransactionLogDomain.Presentation, contactUrl: URL) async throws {
    try await recordPresentationAction(
      parentPresentationId: presentation.id,
      entry: presentation.toDataDeletionRequestEntry(id: UUID().uuidString, time: Date()),
      channel: TransactionActionChannel(url: contactUrl)
    )
  }

  func recordDpaReport(for presentation: TransactionLogDomain.Presentation, contactUrl: URL) async throws {
    try await recordPresentationAction(
      parentPresentationId: presentation.id,
      entry: presentation.toDpaReportEntry(id: UUID().uuidString, time: Date()),
      channel: TransactionActionChannel(url: contactUrl)
    )
  }

  private func recordPresentationAction(
    parentPresentationId: String,
    entry: TransactionEntry,
    channel: TransactionActionChannel?
  ) async throws {
    guard
      !parentPresentationId.isEmpty,
      parentPresentationId != entry.transactionIdentifier,
      let parent = try? await self.transactionLogStorageController.retrieve(parentPresentationId),
      parent.parentPresentationId == nil,
      case .presentation? = parent.toTransactionEntry()
    else {
      throw WalletCoreError.unableToRecordTransactionAction
    }
    try await self.transactionLogStorageController.store(
      entry.toTransactionLogStorage(parentPresentationId: parentPresentationId, actionChannel: channel)
    )
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

  func getDocumentStatus(for statusList: MdocDataModel18013.StatusList) async throws -> CredentialStatus {
    return try await wallet.getDocumentStatus(for: statusList)
  }

  func storeFailedReIssuedDocuments(ids: [String]) async throws {
    try await self.failedReIssuedDocStorageController.store(ids.map { .init(identifier: $0) })
  }

  func removeAllFailedReIssuedDocuments() async throws {
    try await failedReIssuedDocStorageController.deleteAll()
  }

  func refreshUsageCounters() async throws {
    try await wallet.refreshUsageCounters()
  }
}

private extension WalletKitControllerImpl {

  func reconcileRegistrations() async {
    await documentRegistrationManager.reconcile(
      desired: fetchIssuedDocuments()
        .filter { $0.docDataFormat == .cbor }
        .map {
          RegistrationDescriptor(
            documentIdentifier: $0.id,
            mobileDocumentType: $0.docType,
            invalidationDate: $0.validUntil
          )
        }
    )
  }

  func decodeDeeplink(link: URLComponents) -> String? {
    link.removeSchemeFromComponents()?.string
  }

  func startRemotePresentation(urlString: String) async -> RemoteSessionCoordinator {
    await self.stopPresentation()

    let data = urlString.data(using: .utf8) ?? Data()

    wallet.openID4VpConfig = walletKitConfig.vpConfig

    let session = await wallet.beginPresentation(flow: .openid4vp(qrCode: data))
    let remoteSessionCoordinator = DIGraph.shared.resolver.force(
      RemoteSessionCoordinator.self,
      argument: session
    )
    await self.sessionCoordinatorHolder.setActiveRemoteCoordinator(remoteSessionCoordinator)
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
      if let image = docClaim.dataValue.image {
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
