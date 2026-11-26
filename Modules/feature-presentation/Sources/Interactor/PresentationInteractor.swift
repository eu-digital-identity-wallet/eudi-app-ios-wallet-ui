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
  var requestDataCombinations: [RequestCombinationUiModel]
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
  func onResponsePrepare(combinationIndex: Int, chosenDocumentIds: Set<String>) async -> Result<RequestItemConvertible, Error>
  func onRequestReceived() async -> PresentationRequestPartialState
  func onSendResponse() async -> RemoteSentResponsePartialState
  func onDeclineRequest() async
  func storeDynamicIssuancePendingUrl(with url: URL) async
  func stopPresentation() async
  func registrationForFailedRequest() async -> RelyingPartyRegistration?
}

/// A combination as the consent screen shows it: the response is built from `elements`, so it holds only the
/// documents shown in `uiModels`, never one the screen left out.
private struct RequestCombination {
  let elements: [DocElements]
  let uiModels: [RequestDataUiModel]
  let transactionData: RequestTransactionDataUiModel?
  let requestName: String?
  /// `PresentationInteractorImpl.canShowTransactionData` for this option's own transaction data.
  let showsTransactionData: Bool
  /// The option's DCQL queries.
  let credentialQueries: PresentationCredentialQueriesDomain
  /// The documents the user picks among two or more matches of a `multiple: true` query; every other document of
  /// `elements` is sent with the option.
  let choosableDocumentIds: Set<String>
}

/// Works on the session its route carries, never on another one started later.
final actor PresentationInteractorImpl: PresentationInteractor {

  private let presentationCoordinator: RemoteSessionCoordinator
  private let walletKitController: WalletKitController
  private let configUiLogic: ConfigUiLogic

  private var requestedItemSets: [[DocElements]] = []
  private var requestedRequestNames: [String?] = []
  private var requestedCredentialQueries: [PresentationCredentialQueriesDomain] = []
  private var requestedChoosableDocumentIds: [Set<String>] = []

  init(
    with presentationCoordinator: RemoteSessionCoordinator,
    and walletKitController: WalletKitController,
    configUiLogic: ConfigUiLogic
  ) {
    self.presentationCoordinator = presentationCoordinator
    self.walletKitController = walletKitController
    self.configUiLogic = configUiLogic
  }

  public func getSessionStatePublisher() async -> RemotePublisherPartialState {
    .success(presentationCoordinator.getStream())
  }

  public func getCoordinator() async -> PresentationCoordinatorPartialState {
    .success(presentationCoordinator)
  }

  public func onDeviceEngagement() async -> PresentationRequestPartialState {
    await presentationCoordinator.initialize()
    return await onRequestReceived()
  }

  /// Offers only the options whose documents are all unblocked, each as WalletKit built it. An option that holds a
  /// revoked, suspended or unrecognised document is left out whole, not offered without that document. So is an
  /// option that gives a query accepting one document two of them, which WalletKit would refuse to send. Where a
  /// `multiple: true` query has two or more matches in an option, the user chooses which to share (none at first),
  /// except a document that carries transaction data, which is always sent.
  public func onRequestReceived() async -> PresentationRequestPartialState {
    do {
      let coordinator = presentationCoordinator
      let response = try await coordinator.requestReceived()
      let blockedDocuments = try await walletKitController.fetchRevokedDocumentStatuses()
      let registrationPolicy = coordinator.relyingPartyRegistration
      let overaskedClaims = response.overaskedClaims
      let transactionDataSets = response.transactionDataSets
      let requestNames = response.requestNames
      let credentialQuerySets = response.credentialQueries
      let presentable = response.itemSets
        .enumerated()
        .filter { _, documentSet in
          documentSet.allSatisfy { item in blockedDocuments[item.docId] == nil }
        }
        .map { index, documentSet in
          let uiModels = documentSet.toUiModels(
            with: self.walletKitController,
            claimsAreSelectable: false,
            userImageClaimKeys: self.configUiLogic.userImageClaimKeys,
            overaskedPaths: documentSet.overaskedPaths(from: overaskedClaims)
          )
          let transactionData = transactionDataSets.indices.contains(index) ? transactionDataSets[index] : [:]
          let transactions = uiModels.flatMap { transactionData[$0.section.id] ?? [] }
          let shownDocumentIds = Set(uiModels.map(\.section.id))
          let shownDocuments = documentSet.filter { shownDocumentIds.contains($0.docId) }
          let credentialQueries = credentialQuerySets.indices.contains(index) ? credentialQuerySets[index] : .init()
          let choosableDocumentIds = credentialQueries.choosableDocumentIds(
            among: shownDocuments.map(\.docId),
            excluding: Set(transactionData.filter { !$0.value.isEmpty }.keys)
          )
          return RequestCombination(
            elements: shownDocuments,
            uiModels: uiModels.map { model in
              model.withCredentialChoice(
                queryIds: credentialQueries.queryIds(of: model.section.id),
                isChosen: choosableDocumentIds.contains(model.section.id) ? false : nil
              )
            },
            transactionData: transactions.toRequestTransactionDataUiModel(sectionId: "transaction-data:\(index)"),
            requestName: requestNames.indices.contains(index) ? requestNames[index] : nil,
            showsTransactionData: Self.canShowTransactionData(transactionData, shownDocuments: shownDocuments),
            credentialQueries: credentialQueries,
            choosableDocumentIds: choosableDocumentIds
          )
        }
        .filter { !$0.uiModels.isEmpty }
        .filter { !$0.credentialQueries.givesASingleQueryManyDocuments($0.elements.map(\.docId)) }

      guard presentable.allSatisfy(\.showsTransactionData) else {
        return .failure(WalletCoreError.transactionDataNotShown)
      }

      self.requestedItemSets = presentable.map(\.elements)
      self.requestedRequestNames = presentable.map(\.requestName)
      self.requestedCredentialQueries = presentable.map(\.credentialQueries)
      self.requestedChoosableDocumentIds = presentable.map(\.choosableDocumentIds)
      let combinations = presentable.map {
        RequestCombinationUiModel(documents: $0.uiModels, transactionData: $0.transactionData)
      }

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
            verifierIsTrusted: response.isTrusted,
            isNotBoundToRequester: coordinator.isRelyingPartyNotBoundToRequester,
            transactionIdentifier: coordinator.transactionIdentifier
          )
        )
      )
    } catch {
      return error.isTrustBlocked ? .notSecuredRequest : .failure(error)
    }
  }

  /// True when every transaction-data entry can be shown as it will be signed: readable, and bound to a document on
  /// the consent screen. Otherwise the request is declined rather than shown in part.
  static func canShowTransactionData(
    _ transactionData: [String: [PresentationTransactionDataDomain]],
    shownDocuments: [DocElements]
  ) -> Bool {
    transactionData.allSatisfy { documentId, entries in
      guard !entries.isEmpty else { return true }
      guard shownDocuments.contains(where: { $0.docId == documentId }) else { return false }
      return !entries.contains(.unavailable)
    }
  }

  /// Prepares the response of the option at `combinationIndex`: every document of the option except the ones the user
  /// could choose and left out of `chosenDocumentIds`. It fails when a DCQL query of the option would be left without a
  /// document.
  public func onResponsePrepare(
    combinationIndex: Int,
    chosenDocumentIds: Set<String>
  ) async -> Result<RequestItemConvertible, Error> {

    guard requestedItemSets.indices.contains(combinationIndex) else {
      return .failure(PresentationSessionError.conversionToRequestItemModel)
    }

    let optionDocuments = requestedItemSets[combinationIndex]
    let choosableDocumentIds = requestedChoosableDocumentIds.indices.contains(combinationIndex)
      ? requestedChoosableDocumentIds[combinationIndex]
      : []
    let sharedDocuments = optionDocuments.filter {
      !choosableDocumentIds.contains($0.docId) || chosenDocumentIds.contains($0.docId)
    }
    let credentialQueries = requestedCredentialQueries.indices.contains(combinationIndex)
      ? requestedCredentialQueries[combinationIndex]
      : .init()

    guard credentialQueries.keepsEveryQuery(
      of: optionDocuments.map(\.docId),
      sharing: Set(sharedDocuments.map(\.docId))
    ) else {
      return .failure(PresentationSessionError.conversionToRequestItemModel)
    }

    let requestConvertible = RequestItemsWrapper(
      dictionary: sharedDocuments.items,
      requestName: requestedRequestNames.indices.contains(combinationIndex)
        ? requestedRequestNames[combinationIndex]
        : nil
    )

    guard requestConvertible.items.isEmpty == false else {
      return .failure(PresentationSessionError.conversionToRequestItemModel)
    }

    presentationCoordinator.setState(presentationState: .responseToSend(requestConvertible))

    return .success(requestConvertible)
  }

  public func onSendResponse() async -> RemoteSentResponsePartialState {

    guard
      case PresentationState.responseToSend(let responseItem) = await presentationCoordinator.getState()
    else {
      return .failure(PresentationSessionError.invalidState)
    }

    do {
      try await presentationCoordinator.sendResponse(response: responseItem)
      return .sent
    } catch {
      return .failure(error)
    }
  }

  public func onDeclineRequest() async {
    try? await presentationCoordinator.declineResponse()
    await stopPresentation()
  }

  public func storeDynamicIssuancePendingUrl(with url: URL) async {
    await walletKitController.storeDynamicIssuancePendingUrl(with: url)
  }

  public func registrationForFailedRequest() async -> RelyingPartyRegistration? {
    await walletKitController.getVerifierRegistrationForFailedRequest()
  }

  public func stopPresentation() async {
    await walletKitController.stopRemotePresentation(presentationCoordinator)
    presentationCoordinator.stopPresentation()
  }
}
