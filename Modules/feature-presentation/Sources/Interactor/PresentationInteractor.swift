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
import logic_core
import feature_common

public struct OnlineAuthenticationRequestSuccessModel: Sendable {
  var requestDataCombinations: [[RequestDataUiModel]]
  var relyingParty: String
  var dataRequestInfo: String
  var isTrusted: Bool
  var relyingPartyRegistration: RelyingPartyRegistration
}

public enum PresentationCoordinatorPartialState: Sendable {
  case success(RemoteSessionCoordinator)
  case failure(Error)
}

public enum RemotePublisherPartialState: Sendable {
  case success(AsyncStream<PresentationState>)
  case failure(Error)
}

public enum RemoteSentResponsePartialState: Sendable {
  case sent
  case failure(Error)
}

public enum PresentationRequestPartialState: Sendable {
  case success(OnlineAuthenticationRequestSuccessModel)
  case notSecuredRequest
  case failure(Error)
}

public protocol PresentationInteractor: Sendable {
  func getSessionStatePublisher() async -> RemotePublisherPartialState
  func getCoordinator() async -> PresentationCoordinatorPartialState
  func onDeviceEngagement() async -> PresentationRequestPartialState
  func onResponsePrepare(combinationIndex: Int) async -> Result<RequestItemConvertible, Error>
  func onRequestReceived() async -> PresentationRequestPartialState
  func onSendResponse() async -> RemoteSentResponsePartialState
  func onDeclineRequest() async
  func updatePresentationCoordinator(with coordinator: RemoteSessionCoordinator) async
  func storeDynamicIssuancePendingUrl(with url: URL) async
  func stopPresentation() async
  func registrationForFailedRequest() async -> RelyingPartyRegistration?
}

private struct RequestCombination {
  let elements: [DocElements]
  let uiModels: [RequestDataUiModel]
}

final actor PresentationInteractorImpl: PresentationInteractor {

  private let sessionCoordinatorHolder: SessionCoordinatorHolder
  private let walletKitController: WalletKitController

  private var requestedItemSets: [[DocElements]] = []

  init(
    with presentationCoordinator: RemoteSessionCoordinator,
    and walletKitController: WalletKitController,
    also sessionCoordinatorHolder: SessionCoordinatorHolder
  ) {
    self.walletKitController = walletKitController
    self.sessionCoordinatorHolder = sessionCoordinatorHolder
    Task { await self.sessionCoordinatorHolder.setActiveRemoteCoordinator(presentationCoordinator) }
  }

  public func getSessionStatePublisher() async -> RemotePublisherPartialState {
    do {
      return .success(try await self.sessionCoordinatorHolder.getActiveRemoteCoordinator().getStream())
    } catch {
      return .failure(error)
    }
  }

  public func getCoordinator() async -> PresentationCoordinatorPartialState {
    do {
      return .success(try await self.sessionCoordinatorHolder.getActiveRemoteCoordinator())
    } catch {
      return .failure(error)
    }
  }

  public func updatePresentationCoordinator(with coordinator: RemoteSessionCoordinator) async {
    await self.sessionCoordinatorHolder.setActiveRemoteCoordinator(coordinator)
  }

  public func onDeviceEngagement() async -> PresentationRequestPartialState {
    try? await sessionCoordinatorHolder.getActiveRemoteCoordinator().initialize()
    return await onRequestReceived()
  }

  public func onRequestReceived() async -> PresentationRequestPartialState {
    do {
      let coordinator = try await sessionCoordinatorHolder.getActiveRemoteCoordinator()
      let response = try await coordinator.requestReceived()
      let revokedDocuments = (try? await walletKitController.fetchRevokedDocuments()) ?? []
      let registrationPolicy = coordinator.relyingPartyRegistration
      let overaskedClaims = response.overaskedClaims
      let transactionDataSets = response.transactionDataSets
      let presentable = response.itemSets
        .enumerated()
        .map { index, documentSet in
          let documentSet = documentSet.filter { item in !revokedDocuments.contains(where: { $0 == item.docId }) }
          let transactionData = transactionDataSets.indices.contains(index) ? transactionDataSets[index] : [:]
          return RequestCombination(
            elements: documentSet,
            uiModels: documentSet.toUiModels(
              with: self.walletKitController,
              claimsAreSelectable: false,
              overaskedPaths: documentSet.overaskedPaths(from: overaskedClaims),
              transactionData: transactionData
            )
          )
        }
        .filter { !$0.uiModels.isEmpty }

      self.requestedItemSets = presentable.map(\.elements)
      let combinations = presentable.map(\.uiModels)

      return .success(
        .init(
          requestDataCombinations: combinations,
          relyingParty: response.relyingParty,
          dataRequestInfo: response.dataRequestInfo,
          isTrusted: response.isTrusted,
          relyingPartyRegistration: await walletKitController.getVerifierRegistration(
            policy: registrationPolicy,
            trustViolations: coordinator.relyingPartyWarningViolations,
            overaskedClaims: overaskedClaims,
            verifierName: response.relyingParty,
            verifierIsTrusted: response.isTrusted
          )
        )
      )
    } catch {
      return error.isTrustBlocked ? .notSecuredRequest : .failure(error)
    }
  }

  public func onResponsePrepare(combinationIndex: Int) async -> Result<RequestItemConvertible, Error> {

    guard requestedItemSets.indices.contains(combinationIndex) else {
      return .failure(PresentationSessionError.conversionToRequestItemModel)
    }

    let requestConvertible = requestedItemSets[combinationIndex].items

    guard requestConvertible.isEmpty == false else {
      return .failure(PresentationSessionError.conversionToRequestItemModel)
    }

    do {

      try await self.sessionCoordinatorHolder
        .getActiveRemoteCoordinator()
        .setState(presentationState: .responseToSend(requestConvertible))

    } catch {
      return .failure(error)
    }

    return .success(requestConvertible.items)
  }

  public func onSendResponse() async -> RemoteSentResponsePartialState {

    guard
      let state = try? await sessionCoordinatorHolder.getActiveRemoteCoordinator().getState(),
      case PresentationState.responseToSend(let responseItem) = state
    else {
      return .failure(PresentationSessionError.invalidState)
    }

    do {
      try await self.sessionCoordinatorHolder.getActiveRemoteCoordinator().sendResponse(response: responseItem)
      return .sent
    } catch {
      return .failure(error)
    }
  }

  public func onDeclineRequest() async {
    try? await sessionCoordinatorHolder.getActiveRemoteCoordinator().declineResponse()
    await stopPresentation()
  }

  public func storeDynamicIssuancePendingUrl(with url: URL) async {
    await walletKitController.storeDynamicIssuancePendingUrl(with: url)
  }

  public func registrationForFailedRequest() async -> RelyingPartyRegistration? {
    await walletKitController.getVerifierRegistrationForFailedRequest()
  }

  public func stopPresentation() async {
    await walletKitController.stopPresentation()
    try? await sessionCoordinatorHolder.getActiveRemoteCoordinator().stopPresentation()
  }
}
