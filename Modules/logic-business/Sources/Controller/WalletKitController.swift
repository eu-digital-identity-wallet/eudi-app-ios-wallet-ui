/*
 * Copyright (c) 2023 European Commission
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Foundation
import EudiWalletKit
import MdocDataModel18013
import Combine
import logic_resources

public final class WalletKitController {

  public static let shared = WalletKitController()

  public enum DocumentIdentifier: RawRepresentable {

    case EuPidDocType
    case IsoMdlModel
    case genericDocument(docType: String)

    public var rawValue: String {
      switch self {
      case .EuPidDocType:
        return MdocDataModel18013.EuPidModel.EuPidDocType
      case .IsoMdlModel:
        return MdocDataModel18013.IsoMdlModel.isoDocType
      case .genericDocument(let docType):
        return docType
      }
    }

    public init(rawValue: String) {
      switch rawValue {
      case MdocDataModel18013.EuPidModel.EuPidDocType:
        self = .EuPidDocType
      case MdocDataModel18013.IsoMdlModel.isoDocType:
        self = .IsoMdlModel
      default:
        self = .genericDocument(docType: rawValue)
      }
    }
  }

  public let wallet = EudiWallet.standard

  public private(set) var activeSession: PresentationSession?
  private var cancellables = Set<AnyCancellable>()

  private init() {
    try? wallet.loadSampleData()
    wallet.userAuthenticationRequired = false
    wallet.trustedReaderCertificates = [Data(name: "scytales_root_ca", ext: "der")!]

  }

  public func statusPublisher() -> AnyPublisher<TransferStatus, Never>? {
    activeSession?.$status.eraseToAnyPublisher()
  }

  public func startPresentation(flow: FlowType) -> PresentationSession {
    self.stopPresentation()
    let session = wallet.beginPresentation(flow: flow)
    self.activeSession = session
    return session
  }

  public func stopPresentation() {
    self.cancellables.forEach {$0.cancel()}
    self.activeSession = nil
  }

  public func mandatoryFields(for documentType: DocumentIdentifier) -> [String] {
    switch documentType {
    case .EuPidDocType:
      return []
    case .IsoMdlModel:
      return IsoMdlModel.mandatoryKeys
    case .genericDocument(docType: let docType):
      return []
    }
  }

  public func valueForElementIdentifier(for documentType: DocumentIdentifier) -> String {

    return ""
  }
}

@MainActor
public final class PresentationSessionCoordinator {

  let session: PresentationSession

  init(session: PresentationSession) {
    self.session = session
  }

  private func startQrEngagement() async throws {
    try await session.startQrEngagement()
  }

  private func awaitForRequest() async throws {
    try await session.receiveRequest()
  }

}
