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

import Foundation
import Combine
import logic_resources
import logic_business
import SwiftUI

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
  func clearAllDocuments() async
  func clearDocuments(status: DocumentStatus) async throws
  func deleteDocument(with id: String, status: DocumentStatus) async throws
  func loadDocuments() async throws
  func issueDocument(identifier: String) async throws -> WalletStorage.Document
  func requestDeferredIssuance(with doc: WalletStorage.Document) async throws -> DocClaimsDecodable
  func resolveOfferUrlDocTypes(uriOffer: String) async throws -> OfferedIssuanceModel
  func issueDocumentsByOfferUrl(
    offerUri: String,
    docTypes: [OfferedDocModel],
    txCodeValue: String?
  ) async throws -> [WalletStorage.Document]
  func valueForElementIdentifier(
    with documentId: String,
    elementIdentifier: String,
    parser: (String) -> String
  ) -> DocValue
  func mandatoryFields(for documentType: DocumentTypeIdentifier) -> [String]
  func retrieveLogFileUrl() -> URL?
  func resumePendingIssuance(pendingDoc: WalletStorage.Document, webUrl: URL?) async throws -> WalletStorage.Document
  func storeDynamicIssuancePendingUrl(with url: URL)
  func getDynamicIssuancePendingData() async -> DynamicIssuancePendingData?
  func getScopedDocuments() async throws -> [ScopedDocument]
}

final class WalletKitControllerImpl: WalletKitController {

  let wallet: EudiWallet
  private let sessionCoordinatorHolder: SessionCoordinatorHolder

  private let configLogic: WalletKitConfig
  private let keyChainController: KeyChainController

  init(
    configLogic: WalletKitConfig,
    keyChainController: KeyChainController,
    sessionCoordinatorHolder: SessionCoordinatorHolder
  ) {
    self.configLogic = configLogic
    self.keyChainController = keyChainController
    self.sessionCoordinatorHolder = sessionCoordinatorHolder

    guard let walletKit = try? EudiWallet(serviceName: configLogic.documentStorageServiceName) else {
      fatalError("Unable to Initialize WalletKit")
    }

    wallet = walletKit
    wallet.uiCulture = Locale.current.systemLanguageCode
    wallet.userAuthenticationRequired = configLogic.userAuthenticationRequired
    wallet.openID4VciIssuerUrl = configLogic.vciConfig.issuerUrl
    wallet.openID4VciConfig = .init(
      clientId: configLogic.vciConfig.clientId,
      authFlowRedirectionURI: configLogic.vciConfig.redirectUri
    )
    wallet.trustedReaderCertificates = configLogic.readerConfig.trustedCerts
    wallet.logFileName = configLogic.logFileName
  }

  func resolveOfferUrlDocTypes(uriOffer: String) async throws -> OfferedIssuanceModel {
    return try await wallet.resolveOfferUrlDocTypes(uriOffer: uriOffer)
  }

  func issueDocumentsByOfferUrl(
    offerUri: String,
    docTypes: [OfferedDocModel],
    txCodeValue: String?
  ) async throws -> [WalletStorage.Document] {
    return try await wallet.issueDocumentsByOfferUrl(
      offerUri: offerUri,
      docTypes: docTypes,
      txCodeValue: txCodeValue
    )
  }

  func clearAllDocuments() async {
    try? await wallet.deleteAllDocuments()
  }

  func clearDocuments(status: DocumentStatus) async throws {
    return try await wallet.deleteDocuments(status: status)
  }

  func deleteDocument(with id: String, status: DocumentStatus) async throws {
    return try await wallet.deleteDocument(id: id, status: status)
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
    return fetchIssuedDocuments() + fetchDeferredDocuments().transformToDocsDecodable()
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

  func issueDocument(identifier: String) async throws -> WalletStorage.Document {
    return try await wallet.issueDocument(docType: nil, scope: nil, identifier: identifier)
  }

  func requestDeferredIssuance(with doc: WalletStorage.Document) async throws -> DocClaimsDecodable {
    let result = try await wallet.requestDeferredIssuance(deferredDoc: doc)
    if result.isDeferred {
      return result.transformToDocDecodable()
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
        return ScopedDocument(
          name: config.display.getName(fallback: credential.key.value),
          configId: credential.key.value,
          isPid: DocumentTypeIdentifier(rawValue: config.docType) == .mDocPid
        )
        // MARK: - TODO Re-activate isPid Check once SD-JWT PID Rule book is in place in ARF.
      case .sdJwtVc(let config):
        //        guard let vct = config.vct else {
        //          return nil
        //        }
        return ScopedDocument(
          name: config.display.getName(fallback: credential.key.value),
          configId: credential.key.value,
          //isPid: DocumentTypeIdentifier(rawValue: vct) == .sdJwtPid
          isPid: false
        )
      default: return nil
      }
    }
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

  public func mandatoryFields(for documentType: DocumentTypeIdentifier) -> [String] {
    switch documentType {
    case .mDocPid, .sdJwtPid:
      return [
        "issuance_date",
        DocumentJsonKeys.EXPIRY_DATE,
        "issuing_authority",
        "document_number",
        "administrative_number",
        "issuing_country",
        "issuing_jurisdiction",
        DocumentJsonKeys.PORTRAIT,
        "portrait_capture_date"
      ]
    case .mDocPseudonym:
      return [
        "issuance_date",
        "expiry_date",
        "issuing_country",
        "issuing_authority"
      ]
    default:
      return []
    }
  }

  public func valueForElementIdentifier(
    with documentId: String,
    elementIdentifier: String,
    parser: (String) -> String
  ) -> DocValue {

    guard let document = fetchDocument(with: documentId) else {
      return .unavailable(LocalizableString.shared.get(with: .errorUnableFetchDocument))
    }

    let claims = document.docClaims
      .parseDates(
        parser: {
          Locale.current.localizedDateTime(
            date: $0,
            uiFormatter: "dd MMM yyyy"
          )
        }
      )
      .parseUserPseudonym()

    guard let element = claims.first(where: { $0.name == elementIdentifier }) else {
      return .unavailable(LocalizableString.shared.get(with: .unavailableField))
    }

    if let image = element.dataValue.image {
      return .image(Image(uiImage: image))
    }

    if let nested = element.children {
      return .string(element.flattenNested(nested: nested).stringValue)
    }

    return .string(element.stringValue)
  }
}
