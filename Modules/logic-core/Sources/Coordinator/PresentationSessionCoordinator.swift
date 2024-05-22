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
import UIKit

enum RegistrationName: String {
  case proximity
  case remote
}

public protocol PresentationSessionCoordinator {

  var presentationStateSubject: CurrentValueSubject<PresentationState, Never> { get }

  init(session: PresentationSession)

  func initialize() async
  func startQrEngagement() async throws -> UIImage
  func requestReceived() async throws -> PresentationRequest
  func sendResponse(response: RequestItemConvertible, onSuccess: ((URL?) -> Void)?, onCancel: (() -> Void)?) async throws
  func onSuccess(completion: () -> Void)

  func getState() async -> PresentationState
  func setState(presentationState: PresentationState)

}

public enum PresentationState {
  case loading
  case prepareQr
  case qrReady(imageData: Data)
  case requestReceived(PresentationRequest)
  case responseToSend(RequestItemConvertible)
  case success
  case error(WalletError)
}

public struct PresentationRequest {

  public let items: [DocElementsViewModel]

  public let relyingParty: String
  public let dataRequestInfo: String
  public let isTrusted: Bool
}

public enum PresentationSessionError: Error {
  case qrGeneration
  case noDocumentFoundForRequest
  case conversionToRequestItemModel
  case invalidState
  case failedToParseRemoteURL
}
