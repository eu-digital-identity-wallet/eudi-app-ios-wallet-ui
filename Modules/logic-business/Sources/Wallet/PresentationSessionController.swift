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

public protocol RequestItemConvertible {
  func asRequestItems() -> RequestItems
}

public final class PresentationSessionCoordinator {

  public enum PresentationState {
    case loading
    case prepareQr
    case qrReady(imageData: Data)
    case requestReceived(requestedFields: [DocElementsViewModel])
    case response(RequestItemConvertible)
    case success
    case error(WalletError)

  }

  let session: PresentationSession

  @Published public var presentationState: PresentationState

  private var cancellables = Set<AnyCancellable>()

  init(session: PresentationSession) {
    self.session = session
    self.presentationState = .loading

    self.session.$status.sink { status in
      switch status {
      case .qrEngagementReady:
        self.presentationState = .prepareQr
      case .requestReceived:
        self.presentationState = .requestReceived(requestedFields: [])
      case .error:
        if let error = session.uiError {
          self.presentationState = .error(error)
        }

      default:
        ()
      }
    }
    .store(in: &cancellables)
  }

  public func initialize() async throws {
    try await session.startQrEngagement()
    try await session.receiveRequest()
  }

  public func startQrEngagement() async throws -> Data {
    guard let deviceEngagement = session.deviceEngagement else {
      self.presentationState = .error(session.uiError ?? .init(description: "Failed To Generate QR Code"))
      throw session.uiError ?? .init(description: "Failed To Generate QR Code")
    }
    self.presentationState = .qrReady(imageData: deviceEngagement)
    return deviceEngagement
  }

  public func requestReceived() async throws -> [DocElementsViewModel] {
    guard session.disclosedDocuments.isEmpty == false else {
      self.presentationState = .error(session.uiError ?? .init(description: "Failed to Find knonw documents to send"))
      throw session.uiError ?? .init(description: "Failed to Find knonw documents to send")
    }

    self.presentationState = .requestReceived(requestedFields: session.disclosedDocuments)
    return session.disclosedDocuments
  }

  public func sendResponse(response: RequestItemConvertible) async throws {
    do {
      try await session.sendResponse(userAccepted: true, itemsToSend: response.asRequestItems()) {

      }
    } catch {
      self.presentationState = .error(session.uiError ?? .init(description: "Failed to Find send response"))
    }

    self.presentationState = .success
  }

  public func getState() async -> PresentationState {
    self.presentationState
  }
}

public struct RequestItemsWrapper: RequestItemConvertible {
  public func asRequestItems() -> EudiWalletKit.RequestItems {
    requestItems
  }

  public var requestItems: RequestItems

  public init() {
    requestItems = RequestItems()
  }

  public init(dictionary: [String: [String: [String]]]) {
    self.requestItems = dictionary
  }
}

extension RequestItems: RequestItemConvertible {
  public func asRequestItems() -> RequestItems {
    return self
  }
}
