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

private enum WalletKitKeyChainIdentifier: String, KeychainWrapper {
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
  func fetchAllDocuments() -> [MdocDecodable]
  func fetchDeferredDocuments() -> [WalletStorage.Document]
  func fetchIssuedDocuments() -> [MdocDecodable]
  func fetchIssuedDocuments(with type: DocumentTypeIdentifier) -> [MdocDecodable]
  func fetchIssuedDocuments(excluded: [DocumentTypeIdentifier]) -> [MdocDecodable]
  func fetchMainPidDocument() -> MdocDecodable?
  func fetchDocument(with id: String) -> MdocDecodable?
  func loadSampleData(dataFiles: [String]) async throws
  func clearAllDocuments() async
  func clearDocuments(status: DocumentStatus) async throws
  func deleteDocument(with id: String, status: DocumentStatus) async throws
  func loadDocuments() async throws
  func issueDocument(docType: String, format: DataFormat) async throws -> WalletStorage.Document
  func requestDeferredIssuance(with doc: WalletStorage.Document) async throws -> MdocDecodable
  func resolveOfferUrlDocTypes(uriOffer: String) async throws -> OfferedIssuanceModel
  func issueDocumentsByOfferUrl(
    offerUri: String,
    docTypes: [OfferedDocModel],
    format: DataFormat,
    txCodeValue: String?
  ) async throws -> [WalletStorage.Document]
  func valueForElementIdentifier(
    for documentType: DocumentTypeIdentifier,
    with documentId: String,
    elementIdentifier: String,
    parser: (String) -> String
  ) -> MdocValue
  func mandatoryFields(for documentType: DocumentTypeIdentifier) -> [String]
  func retrieveLogFileUrl() -> URL?
  func resumePendingIssuance(pendingDoc: WalletStorage.Document, webUrl: URL?) async throws -> WalletStorage.Document
  func storeDynamicIssuancePendingUrl(with url: URL)
  func getDynamicIssuancePendingData() async -> DynamicIssuancePendingData?
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
    format: DataFormat,
    txCodeValue: String?
  ) async throws -> [WalletStorage.Document] {
    return try await wallet.issueDocumentsByOfferUrl(
      offerUri: offerUri,
      docTypes: docTypes,
      txCodeValue: txCodeValue,
      format: format
    )
  }

  public func loadSampleData(dataFiles: [String]) async throws {
    return try await wallet.loadSampleData(sampleDataFiles: dataFiles)
  }

  public func clearAllDocuments() async {
    try? await wallet.deleteAllDocuments()
  }

  public func clearDocuments(status: DocumentStatus) async throws {
    return try await wallet.deleteDocuments(status: status)
  }

  public func deleteDocument(with id: String, status: DocumentStatus) async throws {
    return try await wallet.deleteDocument(id: id, status: status)
  }

  public func loadDocuments() async throws {
    _ = try await wallet.loadAllDocuments()
  }

  public func startProximityPresentation() async -> ProximitySessionCoordinator {
    self.stopPresentation()
    let session = await wallet.beginPresentation(flow: .ble)
    let proximitySessionCoordinator = DIGraph.resolver.force(
      ProximitySessionCoordinator.self,
      argument: session
    )
    self.sessionCoordinatorHolder.setActiveProximityCoordinator(proximitySessionCoordinator)
    return proximitySessionCoordinator
  }

  public func startSameDevicePresentation(deepLink: URLComponents) async -> RemoteSessionCoordinator {
    await self.startRemotePresentation(
      urlString: decodeDeeplink(
        link: deepLink
      ) ?? ""
    )
  }

  public func startCrossDevicePresentation(urlString: String) async -> RemoteSessionCoordinator {
    await self.startRemotePresentation(urlString: urlString)
  }

  private func startRemotePresentation(urlString: String) async -> RemoteSessionCoordinator {
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

  public func stopPresentation() {
    self.sessionCoordinatorHolder.clear()
  }

  func fetchAllDocuments() -> [MdocDecodable] {
    return fetchIssuedDocuments() + fetchDeferredDocuments().transformToMdocDecodable()
  }

  func fetchDeferredDocuments() -> [WalletStorage.Document] {
    return wallet.storage.deferredDocuments
  }

  public func fetchIssuedDocuments() -> [MdocDecodable] {
    return wallet.storage.mdocModels
  }

  public func fetchIssuedDocuments(with type: DocumentTypeIdentifier) -> [MdocDecodable] {
    return wallet.storage.mdocModels
      .filter({ $0.docType == type.rawValue })
  }

  func fetchMainPidDocument() -> MdocDecodable? {
    return fetchIssuedDocuments(with: DocumentTypeIdentifier.PID)
      .sorted { $0.createdAt > $1.createdAt }.last
  }

  func fetchIssuedDocuments(excluded: [DocumentTypeIdentifier]) -> [MdocDecodable] {
    let excludedRawValues = excluded.map { $0.rawValue }
    return fetchIssuedDocuments().filter { !excludedRawValues.contains($0.docType) }
  }

  public func fetchDocument(with id: String) -> MdocDecodable? {
    wallet.storage.getDocumentModel(id: id)
  }

  public func issueDocument(docType: String, format: DataFormat) async throws -> WalletStorage.Document {
    return try await wallet.issueDocument(docType: docType, format: format)
  }

  func requestDeferredIssuance(with doc: WalletStorage.Document) async throws -> MdocDecodable {
    let result = try await wallet.requestDeferredIssuance(deferredDoc: doc)
    if result.isDeferred {
      return result.transformToMdocDecodable()
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
      key: WalletKitKeyChainIdentifier.dynamicIssuancePendingUrl,
      value: url.absoluteString
    )
  }

  func getDynamicIssuancePendingData() async -> DynamicIssuancePendingData? {

    guard
      let urlString = keyChainController.getValue(key: WalletKitKeyChainIdentifier.dynamicIssuancePendingUrl),
      let url = urlString.toCompatibleUrl()
    else {
      return nil
    }

    keyChainController.removeObject(
      key: WalletKitKeyChainIdentifier.dynamicIssuancePendingUrl
    )

    guard let pendingDoc = wallet.storage.pendingDocuments.last else {
      return nil
    }

    return .init(pendingDoc: pendingDoc, url: url)
  }

  private func decodeDeeplink(link: URLComponents) -> String? {
    // Handling requests of the form
    //    mdoc-openid4vp://https://eudi.netcompany-intrasoft.com?client_id=Verifier&request_uri=https://eudi.netcompany-intrasoft.com/wallet/request.jwt/OWB1_xVU7ndoHmirBn7S2JpcC5fFPzAXGCY1fTLxDjczVATjzQvre_w4yEcMB4FO5KwuyYXXw-JottarKgEvRQ
    // so we need to drop scheme and forward slashes and keep the rest of the url in order to
    // pass to wallet

    return link.removeSchemeFromComponents()?.string
  }
}

extension WalletKitController {

  public func mandatoryFields(for documentType: DocumentTypeIdentifier) -> [String] {
    switch documentType {
    case .PID:
      return [
        "issuance_date",
        "expiry_date",
        "issuing_authority",
        "document_number",
        "administrative_number",
        "issuing_country",
        "issuing_jurisdiction",
        "portrait",
        "portrait_capture_date"
      ]
    case .AGE:
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
    for documentType: DocumentTypeIdentifier,
    with documentId: String,
    elementIdentifier: String,
    parser: (String) -> String
  ) -> MdocValue {

    // Check if we have image data and early return them
    if let imageName = wallet.storage.mdocModels
      .first(where: { $0.id == documentId })?.displayImages
      .first(where: { $0.name == elementIdentifier }) {
      return .image(imageName.image)
    }

    guard let document = fetchDocument(with: documentId) else {
      return .unavailable(LocalizableString.shared.get(with: .errorUnableFetchDocument))
    }

    // Convert the Stored models to their [Key: Value] array
    var displayStrings = document.displayStrings
      .decodeGender()
      .decodeUserPseudonym()
      .parseDates(parser: parser)
      .mapTrueFalseToLocalizable()

    if documentType == .MDL {

      // Flatten properties in order to be made in a Key: Value structure
      if let drivingPrivileges = document.getDrivingPrivileges(parser: parser) {
        displayStrings.appendOrReplace(drivingPrivileges)
      }

      displayStrings.appendOrReplace(
        contentsOf: decodeAgeOver(ageOverDictionary: document.ageOverXX)
      )
    } else if documentType == .PID {
      displayStrings.appendOrReplace(
        contentsOf: decodeAgeOver(ageOverDictionary: document.ageOverXX)
      )
    }
    // Find the first Value that Matches given Key for document

    displayStrings.forEach { print($0.name) }

    let value = displayStrings
      .first(where: { element in
        element.name == elementIdentifier
      })?.value
    // Return the value if found, or a static string that field was not found

    guard let isAvailable = value else {
      return .unavailable(LocalizableString.shared.get(with: .unavailableField))
    }

    return .string(isAvailable)
  }

  private func decodeAgeOver(ageOverDictionary: [Int: Bool]) -> [NameValue] {
    var nameValue: [NameValue] = []
    ageOverDictionary.sorted(by: {$0.key < $1.key}).forEach { key, value in
      nameValue.append(
        .init(
          name: "age_over_\(key)",
          value: value ? LocalizableString.shared.get(with: .yes) : LocalizableString.shared.get(with: .no)
        )
      )
    }
    return nameValue
  }
}
