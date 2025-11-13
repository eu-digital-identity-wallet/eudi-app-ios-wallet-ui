/*
 * Copyright (c) 2025 European Commission
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
import logic_resources
import UIKit
import logic_business

public protocol ProximitySessionCoordinator: Sendable {

  var sendableCurrentValueSubject: SendableCurrentValueSubject<PresentationState> { get }

  init(session: PresentationSession)

  func initialize() async throws
  func startQrEngagement() async throws -> UIImage
  func requestReceived() async throws -> PresentationRequest
  func sendResponse(response: RequestItemConvertible) async
  func getState() async -> PresentationState

  func setState(presentationState: PresentationState)
  func getStream() -> AsyncStream<PresentationState>
  func stopPresentation()
}

final class ProximitySessionCoordinatorImpl: ProximitySessionCoordinator {

  let sendableCurrentValueSubject: SendableCurrentValueSubject<PresentationState> = .init(.loading)

  private let session: PresentationSession
  private let sendableAnyCancellable: SendableAnyCancellable = .init()

  init(session: PresentationSession) {
    self.session = session
    self.session.$status
      .sink { [weak self] status in
        guard let self else { return }
        switch status {
        case .qrEngagementReady:
          self.sendableCurrentValueSubject.setValue(.prepareQr)
        case .requestReceived:
          self.sendableCurrentValueSubject.setValue(.requestReceived(self.createRequest()))
        case .responseSent:
          self.sendableCurrentValueSubject.setValue(.responseSent(nil))
        case .error:
          if let error = session.uiError?.errorDescription {
            self.sendableCurrentValueSubject.setValue(.error(RuntimeError.customError(error)))
          } else {
            self.sendableCurrentValueSubject.setValue(.error(WalletCoreError.unableToPresentAndShare))
          }

        default:
          ()
        }
      }
      .store(in: &sendableAnyCancellable.cancellables)
  }

  deinit {
    stopPresentation()
  }

  public func initialize() async throws {
    try await session.startQrEngagement()
    _ = await session.receiveRequest()
  }

  public func startQrEngagement() async throws -> UIImage {
    guard
      let deviceEngagement = session.deviceEngagement,
      let qrImage = DeviceEngagement.getQrCodeImage(qrCode: deviceEngagement),
      let qrImageData = qrImage.pngData()
    else {
      throw session.uiError ?? .init(description: "Failed To Generate QR Code")
    }
    self.sendableCurrentValueSubject.setValue(.qrReady(imageData: qrImageData))
    return qrImage
  }

  public func requestReceived() async throws -> PresentationRequest {
    guard session.disclosedDocuments.isEmpty == false else {
      throw session.uiError ?? .init(description: "Failed to Find knonw documents to send")
    }
    return createRequest()
  }

  public func sendResponse(response: RequestItemConvertible) async {
    await session.sendResponse(userAccepted: true, itemsToSend: response.items)
  }

  public func getState() async -> PresentationState {
    self.sendableCurrentValueSubject.getValue()
  }

  public func setState(presentationState: PresentationState) {
    self.sendableCurrentValueSubject.setValue(presentationState)
  }

  func getStream() -> AsyncStream<PresentationState> {
    self.sendableCurrentValueSubject.getAsyncStream()
  }

  public func stopPresentation() {
    self.sendableCurrentValueSubject.complete()
    self.sendableAnyCancellable.cancel()
  }

  private func createRequest() -> PresentationRequest {
    PresentationRequest(
      items: session.disclosedDocuments,
      relyingParty: session.readerCertIssuer ?? LocalizableStringKey.unknownVerifier.toString,
      dataRequestInfo: session.readerCertValidationMessage ?? LocalizableStringKey.requestDataInfoNotice.toString,
      isTrusted: session.readerCertIssuerValid == true
    )
  }
}
