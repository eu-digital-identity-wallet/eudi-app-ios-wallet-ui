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
import EudiWalletKit
import MdocDataModel18013
import Combine
import logic_resources
import WalletStorage

public protocol WalletKitControllerType {

  var wallet: EudiWallet { get }
  var activeCoordinator: PresentationSessionCoordinatorType? { get }

  func startProximityPresentation() -> PresentationSessionCoordinatorType
  func startSameDevicePresentation(deepLink: URLComponents) -> PresentationSessionCoordinatorType
  func startCrossDevicePresentation(urlString: String) -> PresentationSessionCoordinatorType
  func stopPresentation()
  func fetchDocuments() -> [MdocDecodable]
  func fetchDocument(with id: String) -> MdocDecodable?
  func loadSampleData(dataFiles: [String]) async throws
  func clearDocuments() async throws
  func deleteDocument(with type: String) async throws
  func loadDocuments() async throws
  func issueDocument(docType: String, format: DataFormat) async throws -> WalletStorage.Document
}

public final class WalletKitController: WalletKitControllerType {

  public static let shared: WalletKitControllerType = WalletKitController()
  public let wallet = EudiWallet.standard

  public private(set) var activeCoordinator: PresentationSessionCoordinatorType?

  private let configLogic: ConfigLogic
  private var cancellables = Set<AnyCancellable>()

  internal init(configLogic: ConfigLogic = ConfigProvider.shared.getConfigLogic()) {
    self.configLogic = configLogic
    wallet.userAuthenticationRequired = false
    wallet.trustedReaderCertificates = [Data(name: "scytales_root_ca", ext: "der")!]
    wallet.verifierApiUri = configLogic.verifierConfig.apiUri
    wallet.vciIssuerUrl = configLogic.vciConfig.issuerUrl
    wallet.vciClientId = configLogic.vciConfig.clientId
    wallet.vciRedirectUri = configLogic.vciConfig.redirectUri
  }

  public func loadSampleData(dataFiles: [String]) async throws {
    return try await wallet.loadSampleData(sampleDataFiles: dataFiles)
  }

  public func clearDocuments() async throws {
    return try await wallet.storage.deleteDocuments()
  }

  public func deleteDocument(with type: String) async throws {
    return try await wallet.storage.deleteDocument(docType: type)
  }

  public func loadDocuments() async throws {
    _ = try await wallet.loadDocuments()
  }

  public func startProximityPresentation() -> PresentationSessionCoordinatorType {
    self.stopPresentation()
    let session = wallet.beginPresentation(flow: .ble)
    let presentationSessionCoordinator = ProximityPresentationSessionCoordinator(session: session)
    self.activeCoordinator = presentationSessionCoordinator
    presentationSessionCoordinator.onSuccess {
      stopPresentation()
    }
    return presentationSessionCoordinator
  }

  public func startSameDevicePresentation(deepLink: URLComponents) -> PresentationSessionCoordinatorType {
    self.startRemotePresentation(
      urlString: decodeDeeplink(
        link: deepLink
      ) ?? ""
    )
  }

  public func startCrossDevicePresentation(urlString: String) -> PresentationSessionCoordinatorType {
    self.startRemotePresentation(urlString: urlString)
  }

  private func startRemotePresentation(urlString: String) -> PresentationSessionCoordinatorType {
    self.stopPresentation()

    let data = urlString.data(using: .utf8) ?? Data()

    let session = wallet.beginPresentation(flow: .openid4vp(qrCode: data))
    let presentationSessionCoordinator = RemoteSessionCoordinator(session: session)
    self.activeCoordinator = presentationSessionCoordinator
    presentationSessionCoordinator.onSuccess {
      stopPresentation()
    }
    return presentationSessionCoordinator
  }

  public func stopPresentation() {
    self.cancellables.forEach {$0.cancel()}
    self.activeCoordinator = nil
  }

  public func fetchDocuments() -> [MdocDecodable] {
    return wallet.storage.mdocModels.compactMap({ $0 })
  }

  public func fetchDocument(with id: String) -> MdocDecodable? {
    wallet.storage.getDocumentModel(docType: id)
  }

  public func issueDocument(docType: String, format: DataFormat) async throws -> WalletStorage.Document {
    return try await wallet.issueDocument(docType: docType, format: format)
  }

  private func decodeDeeplink(link: URLComponents) -> String? {
    // Handling requests of the form
    //    mdoc-openid4vp://https://eudi.netcompany-intrasoft.com?client_id=Verifier&request_uri=https://eudi.netcompany-intrasoft.com/wallet/request.jwt/OWB1_xVU7ndoHmirBn7S2JpcC5fFPzAXGCY1fTLxDjczVATjzQvre_w4yEcMB4FO5KwuyYXXw-JottarKgEvRQ
    // so we need to drop scheme and forward slashes and keep the rest of the url in order to
    // pass to wallet

    return link.removeSchemeFromComponents()?.string
  }
}

extension WalletKitControllerType {

  // TODO: Mandatory fields should be returned in a generic model
  public func mandatoryFields(for documentType: DocumentIdentifier) -> [String] {
    switch documentType {
    case .EuPidDocType:
      return EuPidModel.pidMandatoryElementKeys
    case .IsoMdlModel:
      return IsoMdlModel.isoMandatoryElementKeys
    case .genericDocument:
      return []
    }
  }

  // TODO: This needs to be made in a more generic way
  /// A more concrete aproach would be:
  ///    wallet.storage.mdocModels
  ///      .compactMap({ $0 })
  ///      .first(where: { $0.docType == documentType.rawValue })?.displayStrings
  ///      .first(where: { $0.name == elementIdentifier })?.value ?? LocalizableString.shared.get(with: .unavailableField)
  ///
  public func valueForElementIdentifier(for documentType: DocumentIdentifier, elementIdentifier: String) -> MdocValue {

    // Check if we have image data and early return them

    if let imageName = wallet.storage.mdocModels
      .first(where: {$0?.docType == documentType.rawValue})??.displayImages
      .first(where: {$0.name == elementIdentifier}) {
      return .image(imageName.image)
    }

    // Convert the Stored models to their [Key: Value] array
    let displayStrings = wallet.storage.mdocModels
      .compactMap({ $0 })
      .first(where: { $0.docType == documentType.rawValue })?.displayStrings
      .decodeGender()
      .parseDates()
      .mapTrueFalseToLocalizable()

    // Check if document type matches one of known models (pid or mdl)

    guard var displayStrings = displayStrings else {
      return .string(LocalizableString.shared.get(with: .unavailableField))
    }

    if documentType == .IsoMdlModel,
       let mdl = wallet.storage.mdlModel {

      // Flatten properties in order to be made in a Key: Value structure
      if let drivingPrivileges = mdl.getDrivingPrivileges() {
        displayStrings.append(drivingPrivileges)
      }

      displayStrings.append(
        contentsOf: decodeAgeOver(ageOverDictionary: mdl.ageOverXX)
      )
    } else if documentType == .EuPidDocType,
              let pid = wallet.storage.pidModel {
      displayStrings.append(
        contentsOf: decodeAgeOver(ageOverDictionary: pid.ageOverXX)
      )
    }
    // Find the first Value that Matches given Key for document

    let value = displayStrings
      .first(where: { element in
        element.name == elementIdentifier
      })?.value
    // Return the value if found, or a static string that field was not found
    return  .string(value ?? LocalizableString.shared.get(with: .unavailableField))
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
