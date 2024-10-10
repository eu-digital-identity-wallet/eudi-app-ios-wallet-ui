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
import UIKit

public protocol RemoteSessionCoordinator: Sendable {

  var sendableCurrentValueSubject: SendableCurrentValueSubject<PresentationState> { get }

  init(session: PresentationSession)

  func initialize() async
  func requestReceived() async throws -> PresentationRequest
  func sendResponse(response: RequestItemConvertible) async

  func getState() async -> PresentationState
  func getStream() -> AsyncStream<PresentationState>
  func setState(presentationState: PresentationState)
  func stopPresentation()

}

final class RemoteSessionCoordinatorImpl: RemoteSessionCoordinator {

  let sendableCurrentValueSubject: SendableCurrentValueSubject<PresentationState> = .init(.loading)

  private let sendableAnyCancellable: SendableAnyCancellable = .init()

  private let session: PresentationSession

  init(session: PresentationSession) {
    self.session = session
    self.session.$status
      .sink { [weak self] status in
        guard let self else { return }
        switch status {
        case .error:
          if let error = session.uiError?.errorDescription {
            self.sendableCurrentValueSubject.setValue(.error(RuntimeError.customError(error)))
          } else {
            self.sendableCurrentValueSubject.setValue(.error(WalletCoreError.unableToPresentAndShare))
          }
        case .requestReceived:
          self.sendableCurrentValueSubject.setValue(.requestReceived(self.createRequest()))
        default:
          ()
        }
      }
      .store(in: &sendableAnyCancellable.cancellables)
  }

  deinit {
    stopPresentation()
  }

  public func initialize() async {
    _ = await session.receiveRequest()
  }

  public func requestReceived() async throws -> PresentationRequest {
    guard session.disclosedDocuments.isEmpty == false else {
      throw session.uiError ?? .init(description: "Failed to Find known documents to send")
    }
    return createRequest()
  }

  public func sendResponse(response: RequestItemConvertible) async {
    await session.sendResponse(userAccepted: true, itemsToSend: response.asRequestItems(), onCancel: nil) { url in
      self.sendableCurrentValueSubject.setValue(.responseSent(url))
    }
  }

  public func getState() async -> PresentationState {
    self.sendableCurrentValueSubject.getValue()
  }

  public func setState(presentationState: PresentationState) {
    self.sendableCurrentValueSubject.setValue(presentationState)
  }

  public func getStream() -> AsyncStream<PresentationState> {
    self.sendableCurrentValueSubject.getSubject().toAsyncStream()
  }

  public func stopPresentation() {
    self.sendableCurrentValueSubject.getSubject().send(completion: .finished)
    sendableAnyCancellable.cancel()
  }

  private func createRequest() -> PresentationRequest {
    PresentationRequest(
      items: session.disclosedDocuments,
      relyingParty: session.readerCertIssuer ?? LocalizableString.shared.get(with: .unknownVerifier),
      dataRequestInfo: session.readerCertValidationMessage ?? LocalizableString.shared.get(with: .requestDataInfoNotice),
      isTrusted: session.readerCertIssuerValid == true
    )
  }
}
