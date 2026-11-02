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
import logic_resources
import UIKit
import logic_business

/// A presentation service whose Bluetooth transfer the app can stop and watch. Wallet-kit's
/// `BlePresentationService` is one; the protocol lets tests do both without a Bluetooth session.
protocol ProximityTransferService: Sendable {
  func stop()
  /// True once the reader has ended the Bluetooth session. Wallet-kit announces a disconnect to the session only
  /// after a response, so the app reads the status itself, on the main actor, where wallet-kit's status handler
  /// records the disconnect.
  @MainActor var isReaderDisconnected: Bool { get }
}

public protocol ProximitySessionCoordinator: AnyObject, Sendable {

  var sendableCurrentValueSubject: SendableCurrentValueSubject<PresentationState> { get }
  var relyingPartyRegistration: WrpRegistrationPolicy? { get }
  var relyingPartyWarningViolations: [String] { get }
  /// True when wallet-kit found the registration certificate issued to another party than the one that asked.
  var isRelyingPartyNotBoundToRequester: Bool { get }
  /// The transaction identifier of the history entry wallet-kit writes for this presentation.
  var transactionIdentifier: String { get }

  init(session: PresentationSession)

  func initialize() async throws
  func startQrEngagement() async throws -> UIImage
  func requestReceived() async throws -> PresentationRequest
  func sendResponse(response: RequestItemConvertible) async throws
  func getState() async -> PresentationState

  func setState(presentationState: PresentationState)
  func getStream() -> AsyncStream<PresentationState>
  func stopPresentation()
  /// Returns true once the reader ends the Bluetooth session, checking every half second, and false when the
  /// session has no Bluetooth transfer or the waiting task is cancelled.
  func waitForReaderDisconnect() async -> Bool
}

final class ProximitySessionCoordinatorImpl: ProximitySessionCoordinator {

  let sendableCurrentValueSubject: SendableCurrentValueSubject<PresentationState> = .init(.loading)

  private let session: PresentationSession
  private let sendableAnyCancellable: SendableAnyCancellable = .init()

  var relyingPartyRegistration: WrpRegistrationPolicy? { session.wrpVerifierPolicy }
  var relyingPartyWarningViolations: [String] { (session.wrpVerifierWarnings?[""] ?? []).map(\.message) }
  var isRelyingPartyNotBoundToRequester: Bool {
    (session.wrpVerifierWarnings?[""] ?? []).contains { $0.reason == .notBoundToAccessCertificate }
  }
  var transactionIdentifier: String { session.presentationService.transactionLog.transactionIdentifier }

  private var overaskedClaims: [OveraskedClaim] {
    (session.wrpVerifierWarnings?.values.flatMap { $0 } ?? []).toOveraskedClaims()
  }

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

  /// Ends only the state stream. Stopping the Bluetooth transfer here would start the transfer library's
  /// key-deletion task just as the session is released, the crash `SessionCoordinatorHolderImpl` avoids by
  /// keeping a stopped coordinator until the next one starts.
  deinit {
    endStateStream()
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
      throw session.uiError ?? .init(description: "Failed To Generate QR Code", code: .internalError)
    }
    self.sendableCurrentValueSubject.setValue(.qrReady(imageData: qrImageData))
    return qrImage
  }

  public func requestReceived() async throws -> PresentationRequest {
    guard session.disclosedDocumentSets.contains(where: { !$0.docElements.isEmpty }) else {
      throw session.uiError ?? .init(description: "Failed to Find knonw documents to send", code: .noDocumentsAvailable)
    }
    return createRequest()
  }

  public func sendResponse(response: RequestItemConvertible) async throws {
    try await session.sendResponse(userAccepted: true, itemsToSend: response.items)
    await session.waitForDisconnect()
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

  /// Stops the Bluetooth transfer as well as the state stream, so that a session the user, a lock or a new
  /// link ends stops advertising, as the Android wallet's proximity screen does when it closes. The transfer
  /// stops on the main actor, where wallet-kit's own status handler changes the same state.
  public func stopPresentation() {
    if let transfer = session.presentationService as? ProximityTransferService {
      Task { @MainActor in transfer.stop() }
    }
    endStateStream()
  }

  public func waitForReaderDisconnect() async -> Bool {
    guard let transfer = session.presentationService as? ProximityTransferService else { return false }
    while !Task.isCancelled {
      if await transfer.isReaderDisconnected { return true }
      try? await Task.sleep(seconds: Constants.disconnectCheckInterval)
    }
    return false
  }

  private func endStateStream() {
    self.sendableCurrentValueSubject.complete()
    self.sendableAnyCancellable.cancel()
  }

  private func createRequest() -> PresentationRequest {
    let isTrusted = session.readerAuthenticationStatus == .authenticated
    return PresentationRequest(
      itemSets: session.disclosedDocumentSets.map(\.docElements),
      relyingParty: PresentationRequest.relyingPartyName(certificateName: session.readerCertIssuer, isTrusted: isTrusted),
      dataRequestInfo: session.readerCertValidationMessage ?? LocalizableStringKey.requestDataInfoNotice.toString,
      isTrusted: isTrusted,
      overaskedClaims: overaskedClaims,
      transactionDataSets: [],
      requestNames: session.disclosedDocumentSets.map(\.requestName)
    )
  }
}

private extension ProximitySessionCoordinatorImpl {
  enum Constants {
    /// How often `waitForReaderDisconnect()` reads the transfer's status, in seconds.
    static let disconnectCheckInterval: TimeInterval = 0.5
  }
}
