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

public protocol RequestItemConvertible {
  func asRequestItems() -> RequestItems
}

public protocol PresentationSessionCoordinatorType {
  
  var presentationState: PresentationState { get set }
  var presentationStatePublished: Published<PresentationState> { get }
  var presentationStatePublisher: Published<PresentationState>.Publisher { get }
  
  init(session: PresentationSession)
  
  func initialize() async
  func startQrEngagement() async throws -> Data
  func requestReceived() async throws -> PresentationRequest
  func sendResponse(response: RequestItemConvertible) async throws
  
  func setState(presentationState: PresentationState)
  
}

public enum PresentationState {
  case loading
  case prepareQr
  case qrReady(imageData: Data)
  case requestReceived(PresentationRequest)
  case response(RequestItemConvertible)
  case success
  case error(WalletError)
}

public final class PresentationSessionCoordinator: PresentationSessionCoordinatorType {
  
  private let session: PresentationSession
  
  @Published public var presentationState: PresentationState
  public var presentationStatePublisher: Published<PresentationState>.Publisher { $presentationState }
  public var presentationStatePublished: Published<PresentationState> { _presentationState }
  
  private var cancellables = Set<AnyCancellable>()
  
  public init(session: PresentationSession) {
    self.session = session
    self.presentationState = .loading
    
    self.session.$status
      .sink { status in
        switch status {
        case .qrEngagementReady:
          self.presentationState = .prepareQr
        case .responseSent:
          self.presentationState = .response(session.disclosedDocuments.items)
        case .error:
          if let error = session.uiError {
            self.presentationState = .error(error)
          } else {
            self.presentationState = .error(.init(description: LocalizableString.shared.get(with: .genericErrorDesc)))
          }
        default:
          ()
        }
      }
      .store(in: &cancellables)
  }
  
  public func initialize() async {
    await session.startQrEngagement()
    let dict = await session.receiveRequest()
  }
  
  public func startQrEngagement() async throws -> Data {
    guard let deviceEngagement = session.deviceEngagement else {
      throw session.uiError ?? .init(description: "Failed To Generate QR Code")
    }
    self.presentationState = .qrReady(imageData: deviceEngagement)
    return deviceEngagement
  }
  
  public func requestReceived() async throws -> PresentationRequest {
    guard session.disclosedDocuments.isEmpty == false else {
      throw session.uiError ?? .init(description: "Failed to Find knonw documents to send")
    }
    
    
    let presentationRequest = PresentationRequest(
      items: session.disclosedDocuments,
      relyingParty: session.readerCertIssuer ?? LocalizableString.shared.get(with: .custom("Wallet_Title")),
      dataRequestInfo: session.readerCertValidationMessage ?? LocalizableString.shared.get(with: .requestDataInfoNotice),
      isTrusted: true
    )
    self.presentationState = .requestReceived(presentationRequest)
    return presentationRequest
  }
  
  public func sendResponse(response: RequestItemConvertible) async {
    await session.sendResponse(userAccepted: true, itemsToSend: response.asRequestItems()) {
      
    }
    self.presentationState = .success
  }
  
  public func getState() async -> PresentationState {
    self.presentationState
  }
  
  public func setState(presentationState: PresentationState) {
    self.presentationState = presentationState
  }
  
  deinit {
    print(session)
  }
}

public struct PresentationRequest {
  
  public let items: [DocElementsViewModel]
  
  public let relyingParty: String
  public let dataRequestInfo: String
  public let isTrusted: Bool
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
