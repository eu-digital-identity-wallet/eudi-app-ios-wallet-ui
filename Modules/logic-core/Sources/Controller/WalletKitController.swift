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
  func stopRemotePresentation(_ coordinator: RemoteSessionCoordinator) async
  func stopProximityPresentation(_ coordinator: ProximitySessionCoordinator) async

  func fetchAllDocuments() async -> [any DocClaimsDecodable]
  func fetchDeferredDocuments() async -> [WalletStorage.Document]
  func fetchIssuedDocuments() async -> [any DocClaimsDecodable]
  func fetchIssuedDocuments(with types: [DocumentTypeIdentifier]) async -> [any DocClaimsDecodable]
  func fetchMainPidDocument() async -> (any DocClaimsDecodable)?
  func fetchDocument(with id: String) async -> (any DocClaimsDecodable)?
  func fetchDocuments(with ids: [String]) async -> [any DocClaimsDecodable]
  func clearAllDocuments() async throws
  func deleteDocument(with id: String, status: DocumentStatus) async throws
  /// Loads the documents into WalletKit. It leaves the Digital Credential API registrations to the caller's
  /// `reconcileRegistrations()`, so that a slow registration store does not hold up the documents.
  func loadDocuments() async throws
  /// Whether the wallet holds any document, read from the Keychain without loading one: the query asks
  /// for no attributes and no data. A read error throws `KeyChainError.readFailed`.
  func hasStoredDocuments() async throws -> Bool
  func issueDocuments(
    issuerId: String,
    identifiers: [String],
    docTypeIdentifier: DocumentTypeIdentifier
  ) async throws -> IssuanceResult
  /// Throws `WalletCoreError.documentBlocked` for a document the issuer has revoked or suspended, checked just
  /// before the issuer is asked, so a background re-issuance that chose the document earlier refuses it too.
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
  /// Deletes the wallet's own records for the factory reset: the transaction history first, then the bookmarks,
  /// the revocation records, the re-issuance failures and the status refresh failures; then erases the store, so
  /// no deleted row stays readable on disk.
  func deleteAllRecords() async throws
  /// Changes whenever the transaction history is written or deleted, so a reader can tell whether it changed.
  func fetchTransactionLogRevision() async -> String
  func deleteTransactionLog(with id: String) async throws
  func fetchPresentationActions(parentPresentationId: String) async throws -> [TransactionLogDomain]
  func recordDataDeletionRequest(for presentation: TransactionLogDomain.Presentation, contactUrl: URL) async throws
  func recordDpaReport(for presentation: TransactionLogDomain.Presentation, contactUrl: URL) async throws

  /// The revocation record of every document that has one. A record without a status, or with one this
  /// build does not know, counts as unrecognised. An empty store gives an empty result; a failed read throws.
  func fetchRevokedDocumentStatuses() async throws -> [String: DocumentRevocationStatus]
  /// Stores or replaces the revocation record of each document, and takes the documents out of the Digital
  /// Credential API registrations.
  func storeRevokedDocuments(with statuses: [String: DocumentRevocationStatus]) async throws
  /// Removes a document's revocation record, and offers it through the Digital Credential API again.
  func removeRevokedDocument(with id: String) async throws
  /// The revocation record of one document, or `nil` if it has none.
  func getDocumentRevocationStatus(with id: String) async -> DocumentRevocationStatus?

  /// The documents whose status could not be refreshed at the last revocation check. An empty store
  /// gives an empty set; a failed read throws.
  func fetchStatusRefreshFailures() async throws -> Set<String>
  /// Records that the status of each document could not be refreshed.
  func storeStatusRefreshFailures(ids: [String]) async throws
  /// Removes the refresh-failure record of each document, after a check has read its status again.
  func removeStatusRefreshFailures(ids: [String]) async throws
  /// Whether the last revocation check could not refresh the document's status.
  func hasStatusRefreshFailure(with id: String) async -> Bool

  func getDocumentStatus(for statusList: MdocDataModel18013.StatusList) async throws -> CredentialStatus
  func isDocumentLowOnCredentials(document: (any DocClaimsDecodable)?) async -> Bool

  func storeFailedReIssuedDocuments(ids: [String]) async throws
  func removeAllFailedReIssuedDocuments() async throws
  /// Whether the last background re-issuance could not renew the document.
  func hasReIssuanceFailure(with id: String) async -> Bool

  func refreshUsageCounters() async throws
  func getIssuerRegistration(for offer: OfferedIssuanceModel) async -> IssuerRegistration?
  /// Registers the documents for the Digital Credential API, or withdraws every registration while the user has
  /// turned the offering off (`Prefs.Key.offerDocumentsToApps`).
  func reconcileRegistrations() async
  /// Where each issuer's logo may load from: its own origin and its `VciConfig.logoOrigins`.
  func issuerLogoOrigins() async -> IssuerLogoOrigins
  /// The issuer's registration for the issuer-list flow and re-issuance, resolved before the issuer is contacted. A
  /// lookup that fails refuses for a trust failure and throws any other error, so a failure never reads as "no
  /// registration"; with the check off nothing is looked up.
  func getIssuerRegistration(issuerId: String, configIds: [String]) async throws -> IssuerRegistration?

  func getVerifierRegistration(
    policy: WrpRegistrationPolicy?,
    trustViolations: [String],
    overaskedClaims: [logic_core.OveraskedClaim],
    verifierName: String?,
    verifierIsTrusted: Bool,
    isNotBoundToRequester: Bool,
    transactionIdentifier: String
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
  private let statusRefreshFailureStorageController: any StatusRefreshFailureStorageController
  private let storageEraseController: StorageEraseController
  private let documentRegistrationManager: DocumentRegistrationManager
  private let prefsController: PrefsController
  private let registrationCheckProvider: RegistrationCheckProvider
  private let registrationRunner = SerialCheckRunner()
  /// "Check Registration Certificates" as WalletKit was configured with it at launch; the setting applies after a
  /// restart, so the app's own decisions follow the same value.
  private let isRegistrationChecked: Bool
  /// The OpenID4VP configuration built at launch, so every remote presentation applies the registration-check setting
  /// read then, as the app's own decisions do (`isRegistrationChecked`), until the app restarts.
  private let openID4VpConfig: OpenId4VpConfiguration

  init(
    walletKitConfig: WalletKitConfig,
    configLogic: ConfigLogic,
    keyChainController: KeyChainController,
    sessionCoordinatorHolder: SessionCoordinatorHolder,
    bookmarkStorageController: any BookmarkStorageController,
    transactionLogStorageController: any TransactionLogStorageController,
    revokedDocumentStorageController: any RevokedDocumentStorageController,
    failedReIssuedDocStorageController: any FailedReIssuedDocStorageController,
    statusRefreshFailureStorageController: any StatusRefreshFailureStorageController,
    storageEraseController: StorageEraseController,
    networkSessionProvider: NetworkSessionProvider,
    documentRegistrationManager: DocumentRegistrationManager,
    prefsController: PrefsController,
    registrationCheckProvider: RegistrationCheckProvider
  ) {
    self.walletKitConfig = walletKitConfig
    self.configLogic = configLogic
    self.keyChainController = keyChainController
    self.sessionCoordinatorHolder = sessionCoordinatorHolder
    self.bookmarkStorageController = bookmarkStorageController
    self.transactionLogStorageController = transactionLogStorageController
    self.revokedDocumentStorageController = revokedDocumentStorageController
    self.failedReIssuedDocStorageController = failedReIssuedDocStorageController
    self.statusRefreshFailureStorageController = statusRefreshFailureStorageController
    self.storageEraseController = storageEraseController
    self.documentRegistrationManager = documentRegistrationManager
    self.prefsController = prefsController
    self.registrationCheckProvider = registrationCheckProvider
    if walletKitConfig.logFileName == nil {
      Self.removeLogFileOfAnEarlierBuild()
    }
    self.isRegistrationChecked = walletKitConfig.validateIssuerRegistrationCertificate
    let openID4VpConfig = walletKitConfig.vpConfig
    self.openID4VpConfig = openID4VpConfig

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
      openID4VpConfig: openID4VpConfig,
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
    try requireConfiguredIssuer(of: offerUri)
    return try await wallet.resolveOfferUrlDocTypes(
      offerUri: offerUri,
      authFlowRedirectionURI: nil
    )
  }

  /// Refuses an offer whose issuer is not configured before anything is fetched (`OfferIssuer`): wallet-kit would
  /// otherwise give it the first configured issuer's client settings.
  private func requireConfiguredIssuer(of offerUri: String) throws {
    try OfferIssuer.requireConfigured(
      offerUri: offerUri,
      configuredIssuers: walletKitConfig.issuersConfig.values.compactMap(\.config.credentialIssuerURL)
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
    try requireConfiguredIssuer(of: offerUri)
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

  /// Deletes every document and updates the Digital Credential API registrations, also when the deletion fails
  /// part way, so a document that is gone is no longer offered.
  /// With the documents go every document's records (`deleteRecords(of:)`); the history stays.
  func clearAllDocuments() async throws {
    do {
      try await wallet.deleteAllDocuments()
    } catch {
      await reconcileRegistrations()
      throw error
    }
    try? await revokedDocumentStorageController.deleteAll()
    try? await statusRefreshFailureStorageController.deleteAll()
    try? await bookmarkStorageController.deleteAll()
    try? await failedReIssuedDocStorageController.deleteAll()
    await reconcileRegistrations()
  }

  func deleteDocument(with id: String, status: DocumentStatus) async throws {
    try await wallet.deleteDocument(id: id, status: status)
    do {
      try await deleteRecords(of: id)
    } catch {
      await reconcileRegistrations()
      throw error
    }
    await reconcileRegistrations()
  }

  func loadDocuments() async throws {
    _ = try await wallet.loadAllDocuments()
  }

  func hasStoredDocuments() throws -> Bool {
    try StoredDocumentPresence(
      serviceName: configLogic.keyChainConfig.documentStorageServiceName,
      accessGroup: configLogic.keyChainConfig.keychainAccessGroup
    ).hasDocuments()
  }

  /// The registration validator is shared with remote presentations, and wallet-kit clears it for a Bluetooth request
  /// only once a registration certificate is validated, so it is cleared here first: a request that fails before
  /// that does not show the previous party's registration.
  func startProximityPresentation() async -> ProximitySessionCoordinator {
    await self.stopPresentation()
    await wallet.wrpRegistrationValidator.resetValidations()
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

  func stopRemotePresentation(_ coordinator: RemoteSessionCoordinator) async {
    await self.sessionCoordinatorHolder.clearRemoteCoordinator(coordinator)
  }

  func stopProximityPresentation(_ coordinator: ProximitySessionCoordinator) async {
    await self.sessionCoordinatorHolder.clearProximityCoordinator(coordinator)
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

  private func makeIssuerRegistration(
    policy: WrpRegistrationPolicy?,
    warnings: [String: [RegistrationPolicyViolation]]?
  ) -> IssuerRegistration? {
    Self.makeIssuerRegistration(policy: policy, warnings: warnings, isRegistrationChecked: isRegistrationChecked)
  }

  /// The one rule deciding whether an issuer's registration lets an issuance through, as the Android wallet's
  /// `isBlockedForIssuance`: with the registration check on, anything short of a verified registration refuses,
  /// whatever `wrprcVciTrustPolicy` says, a registration that was never established included (a certificate that
  /// cannot be decoded under `.warning`). With the check off nothing is evaluated and nothing refuses.
  static func makeIssuerRegistration(
    policy: WrpRegistrationPolicy?,
    warnings: [String: [RegistrationPolicyViolation]]?,
    isRegistrationChecked: Bool
  ) -> IssuerRegistration? {

    guard isRegistrationChecked else { return nil }

    guard let policy else { return .blocked(reason: .notRegisteredAsProvider) }

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

  /// A renewed document keeps the original's bookmark, as on Android. A bookmark that cannot be copied
  /// does not fail the renewal.
  func reIssueDocument(identifier: String, isBackgroundOperation: Bool) async throws -> WalletStorage.Document {
    try await refuseReIssueIfBlocked(identifier)
    let document = fetchDocument(with: identifier)
    let isBookmarked = await isDocumentBookmarked(with: identifier)

    if isRegistrationChecked {
      guard
        let issuerId = document?.credentialIssuerIdentifier,
        let configId = document?.configurationIdentifier
      else {
        throw RegistrationRefusedError()
      }
      if case .blocked = try await getIssuerRegistration(issuerId: issuerId, configIds: [configId]) {
        throw RegistrationRefusedError()
      }
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
    await bookmarkStorageController.carryBookmark(wasBookmarked: isBookmarked, to: response.documents.map(\.id))
    if !response.documents.contains(where: { $0.id == identifier }) {
      try? await deleteRecords(of: identifier, keepingRevocationRecord: true)
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
    } else if let issued = fetchDocument(with: result.id) {
      if result.id != doc.id {
        try? await deleteRecords(of: doc.id)
      }
      await reconcileRegistrations()
      return issued
    } else {
      throw WalletCoreError.unableFetchDocument
    }
  }

  /// Deletes the records the wallet keeps for a document: its revocation record, refresh failure, bookmark and failed
  /// re-issue, as Android's `deleteDocumentRecords`; its history stays, a legal record. After a re-issue the
  /// original's revocation record stays until the check after the re-issue has read it.
  private func deleteRecords(of id: String, keepingRevocationRecord: Bool = false) async throws {
    if !keepingRevocationRecord {
      try await revokedDocumentStorageController.delete(id)
    }
    try await statusRefreshFailureStorageController.delete(id)
    try await bookmarkStorageController.delete(id)
    try await failedReIssuedDocStorageController.delete(id)
  }

  /// Nil in builds that write no log file, so Settings offers no "Retrieve logs".
  func retrieveLogFileUrl() -> URL? {
    guard
      let logFileName = walletKitConfig.logFileName,
      let url = try? EudiWallet.getLogFileURL(logFileName)
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

  func getIssuerRegistration(issuerId: String, configIds: [String]) async throws -> IssuerRegistration? {
    guard isRegistrationChecked else { return nil }
    do {
      let response = try await wallet.resolveIssuerRegistration(
        issuerName: issuerId,
        credentialConfigurationIds: configIds
      )
      return makeIssuerRegistration(
        policy: response.wrpIssuerPolicy,
        warnings: response.wrpIssuerWarnings
      )
    } catch {
      if error.isTrustBlocked { return .blocked(reason: .notRegisteredAsProvider) }
      throw error
    }
  }

  func getVerifierRegistrationForFailedRequest() async -> RelyingPartyRegistration? {

    guard let policy = await wallet.wrpRegistrationValidator.wrpVpRegistrationPolicy else {
      return nil
    }

    return makeVerifierRegistration(
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
    verifierIsTrusted: Bool,
    isNotBoundToRequester: Bool,
    transactionIdentifier: String
  ) async -> RelyingPartyRegistration {
    let registration = makeVerifierRegistration(
      policy: policy,
      trustViolations: trustViolations,
      overaskedClaims: overaskedClaims,
      verifierName: verifierName,
      verifierIsTrusted: verifierIsTrusted
    )
    await registrationCheckProvider.record(
      RecordedRegistrationCheck(
        status: registration.registration,
        isNotBoundToRequester: isNotBoundToRequester,
        isRequesterAuthenticated: verifierIsTrusted
      ),
      for: transactionIdentifier
    )
    return registration
  }

  /// The outcome is recorded for the history entry wallet-kit writes when the presentation ends, as on Android.
  private func makeVerifierRegistration(
    policy: WrpRegistrationPolicy?,
    trustViolations: [String],
    overaskedClaims: [OveraskedClaim],
    verifierName: String?,
    verifierIsTrusted: Bool
  ) -> RelyingPartyRegistration {

    let unregistered = RelyingPartyRegistration(
      name: verifierName,
      uniqueId: nil,
      isVerified: verifierIsTrusted,
      logoUrl: nil,
      registration: .notSupported
    )

    guard isRegistrationChecked else { return unregistered }

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
      let log = storedLog.toTransactionLogDomain(
        transactionDataTypes: walletKitConfig.supportedTransactionDataTypes
      )
    else {
      throw WalletCoreError.unableToFetchTransactionLog
    }
    return log
  }

  func deleteAllRecords() async throws {
    try await transactionLogStorageController.deleteAll()
    try await bookmarkStorageController.deleteAll()
    try await revokedDocumentStorageController.deleteAll()
    try await failedReIssuedDocStorageController.deleteAll()
    try await statusRefreshFailureStorageController.deleteAll()
    try await storageEraseController.eraseStore()
  }

  func fetchTransactionLogRevision() async -> String {
    await transactionLogStorageController.retrieveRevision()
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
          parentPresentationId: storedLog.parentPresentationId,
          transactionDataTypes: walletKitConfig.supportedTransactionDataTypes
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

  func fetchRevokedDocumentStatuses() async throws -> [String: DocumentRevocationStatus] {
    try await revokedDocumentStorageController.retrieveRevocationStatuses()
  }

  func storeRevokedDocuments(with statuses: [String: DocumentRevocationStatus]) async throws {
    try await revokedDocumentStorageController.store(
      statuses.map { .init(identifier: $0.key, status: $0.value.rawValue) }
    )
    await reconcileRegistrations()
  }

  func removeRevokedDocument(with id: String) async throws {
    try await revokedDocumentStorageController.delete(id)
    await reconcileRegistrations()
  }

  func fetchStatusRefreshFailures() async throws -> Set<String> {
    try await statusRefreshFailureStorageController.retrieveIdentifiers()
  }

  func storeStatusRefreshFailures(ids: [String]) async throws {
    try await statusRefreshFailureStorageController.store(ids.map { StatusRefreshFailure(identifier: $0) })
  }

  func removeStatusRefreshFailures(ids: [String]) async throws {
    for id in ids {
      try await statusRefreshFailureStorageController.delete(id)
    }
  }

  func hasStatusRefreshFailure(with id: String) async -> Bool {
    (try? await statusRefreshFailureStorageController.retrieve(id)) != nil
  }

  func getDocumentRevocationStatus(with id: String) async -> DocumentRevocationStatus? {
    guard let record = try? await revokedDocumentStorageController.retrieve(id) else { return nil }
    return record.revocationStatus
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

  func hasReIssuanceFailure(with id: String) async -> Bool {
    (try? await failedReIssuedDocStorageController.retrieve(id)) != nil
  }

  func refreshUsageCounters() async throws {
    try await wallet.refreshUsageCounters()
  }
}

extension WalletKitControllerImpl {

  func issuerLogoOrigins() -> IssuerLogoOrigins {
    IssuerLogoOrigins(
      logoOriginsByIssuer: Dictionary(
        walletKitConfig.issuersConfig.values.compactMap { vciConfig in
          vciConfig.config.credentialIssuerURL.map { ($0, vciConfig.logoOrigins) }
        },
        uniquingKeysWith: +
      )
    )
  }

  /// Deletes the log file a debug build or an earlier build left, as the Android wallet does.
  static func removeLogFileOfAnEarlierBuild() {
    guard let url = try? EudiWallet.getLogFileURL(WalletKitConfigImpl.debugLogFileName) else { return }
    try? FileManager.default.removeItem(at: url)
  }

  /// Registers the issued CBOR documents for the Digital Credential API, leaving out every document with a
  /// revocation record (revoked, suspended or unrecognised), as the Android wallet does. When the records cannot be
  /// read, or the user has turned the offering off, nothing is registered.
  /// Passes run one at a time (`SerialCheckRunner`): a call during a pass makes it run once more, and the call
  /// returns when no pass is left, so an earlier pass cannot register documents after the one that withdrew them.
  func reconcileRegistrations() async {
    await registrationRunner.run { await self.reconcileRegistrationsOnce() }
    await registrationRunner.waitUntilIdle()
  }

  private func reconcileRegistrationsOnce() async {
    let blocked = try? await fetchRevokedDocumentStatuses()
    let candidates = fetchIssuedDocuments()
      .filter { $0.docDataFormat == .cbor }
      .map {
        RegistrationDescriptor(
          documentIdentifier: $0.id,
          mobileDocumentType: $0.docType,
          invalidationDate: $0.validUntil
        )
      }
    await documentRegistrationManager.reconcile(
      desired: Self.registrationDescriptors(
        candidates: candidates,
        blockedDocumentIds: blocked.map { Set($0.keys) },
        isOffering: prefsController.getBool(forKey: .offerDocumentsToApps)
      )
    )
  }

  /// The candidates without a revocation record; none while the offering is off or when the records could not be
  /// read (`blockedDocumentIds` is nil).
  static func registrationDescriptors(
    candidates: [RegistrationDescriptor],
    blockedDocumentIds: Set<String>?,
    isOffering: Bool
  ) -> [RegistrationDescriptor] {
    guard isOffering, let blockedDocumentIds else { return [] }
    return candidates.filter { !blockedDocumentIds.contains($0.documentIdentifier) }
  }
}

private extension WalletKitControllerImpl {

  func decodeDeeplink(link: URLComponents) -> String? {
    link.removeSchemeFromComponents()?.string
  }

  func startRemotePresentation(urlString: String) async -> RemoteSessionCoordinator {
    await self.stopPresentation()

    let data = urlString.data(using: .utf8) ?? Data()

    wallet.openID4VpConfig = openID4VpConfig

    let session = await wallet.beginPresentation(flow: .openid4vp(qrCode: data))
    let remoteSessionCoordinator = DIGraph.shared.resolver.force(
      RemoteSessionCoordinator.self,
      argument: session
    )
    await self.sessionCoordinatorHolder.setActiveRemoteCoordinator(remoteSessionCoordinator)
    return remoteSessionCoordinator
  }
}
