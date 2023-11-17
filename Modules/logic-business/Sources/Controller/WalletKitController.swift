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

  public enum DocumentIdentifiers: String {
    case EuPidDocType = "eu.europa.ec.eudiw.pid.1"
    case IsoMdlModel = "org.iso.18013.5.1.mDL"
  }

  public let wallet = EudiWallet.standard

  public private(set) var activeSession: PresentationSession? {
    didSet {
      self.setupStatusSubscription()
    }
  }
  private var cancellables = Set<AnyCancellable>()

  private init() {
    try? wallet.loadSampleData()
    wallet.userAuthenticationRequired = false
    wallet.trustedReaderCertificates = [Data(name: "scytales_root_ca", ext: "der")!]

  }

  private func setupStatusSubscription() {
    self.activeSession?.$status
      .sink { status in
        print("---> received value \(status)")
        switch status {
        case .initializing:
          print(status)
        case .initialized:
          print(status)
        case .qrEngagementReady:
          print(status)
        case .connected:
          print(status)
        case .started:
          print(status)
        case .requestReceived:
          print(status)
        case .userSelected:
          print(status)
        case .disconnected, .error, .responseSent:
          self.stopPresentation()
        }
      }
      .store(in: &cancellables)
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

  public func mandatoryFields(for documentType: String) -> [String] {
    if documentType == IsoMdlModel.isoDocType {
      return IsoMdlModel.mandatoryKeys
    } else if documentType == EuPidModel.EuPidDocType {
      return []
    }

    return []
  }

  public func valueForElementIdentifier(for documentType: String) -> String {

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
