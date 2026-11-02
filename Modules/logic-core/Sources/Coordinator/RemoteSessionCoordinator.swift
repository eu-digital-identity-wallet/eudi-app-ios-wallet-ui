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
import logic_business
import UIKit
import os

public protocol RemoteSessionCoordinator: AnyObject, Sendable {

  var sendableCurrentValueSubject: SendableCurrentValueSubject<PresentationState> { get }
  var relyingPartyRegistration: WrpRegistrationPolicy? { get }
  var relyingPartyWarningViolations: [String] { get }
  /// True when wallet-kit found the registration certificate issued to another party than the one that asked.
  var isRelyingPartyNotBoundToRequester: Bool { get }
  /// The transaction identifier of the history entry wallet-kit writes for this presentation.
  var transactionIdentifier: String { get }

  init(session: PresentationSession)

  func initialize() async
  func requestReceived() async throws -> PresentationRequest
  func sendResponse(response: RequestItemConvertible) async throws
  /// Declines the request, unless the wallet has already answered it: after a response, sent or failed, or an earlier
  /// decline, it sends nothing, so that the verifier gets no second answer from Back and the history keeps its result.
  func declineResponse() async throws
  func getState() async -> PresentationState

  func getStream() -> AsyncStream<PresentationState>
  func setState(presentationState: PresentationState)
  func stopPresentation()
}

final class RemoteSessionCoordinatorImpl: RemoteSessionCoordinator {

  let sendableCurrentValueSubject: SendableCurrentValueSubject<PresentationState> = .init(.loading)

  private let sendableAnyCancellable: SendableAnyCancellable = .init()
  private let session: PresentationSession
  /// Set once the wallet has tried to answer the request. A failed response may already have reached the verifier,
  /// or WalletKit may have reported the failure to it.
  private let hasAnswered = OSAllocatedUnfairLock(initialState: false)

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
    guard session.disclosedDocumentSets.contains(where: { !$0.docElements.isEmpty }) else {
      throw session.uiError ?? .init(description: "Failed to Find known documents to send", code: .noDocumentsAvailable)
    }
    return createRequest()
  }

  public func sendResponse(response: RequestItemConvertible) async throws {
    hasAnswered.withLock { $0 = true }
    try await session.sendResponse(
      userAccepted: true,
      itemsToSend: response.items,
      requestName: response.requestName,
      onCancel: nil
    ) { url in
      self.sendableCurrentValueSubject.setValue(.responseSent(url))
    }
  }

  public func declineResponse() async throws {
    let isFirstAnswer = hasAnswered.withLock { hasAnswered in
      defer { hasAnswered = true }
      return !hasAnswered
    }
    guard isFirstAnswer else { return }
    try await session.sendResponse(userAccepted: false, itemsToSend: [:], onCancel: nil)
  }

  public func getState() async -> PresentationState {
    self.sendableCurrentValueSubject.getValue()
  }

  public func setState(presentationState: PresentationState) {
    self.sendableCurrentValueSubject.setValue(presentationState)
  }

  public func getStream() -> AsyncStream<PresentationState> {
    self.sendableCurrentValueSubject.getAsyncStream()
  }

  public func stopPresentation() {
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
      transactionDataSets: session.disclosedDocumentSets.map { $0.transactionDataDomains() },
      requestNames: session.disclosedDocumentSets.map(\.requestName)
    )
  }
}
