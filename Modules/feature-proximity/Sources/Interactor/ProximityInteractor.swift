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
import logic_core
import logic_business
import feature_common

public enum ProximityResponsePartialState: ThreadSafePartialState {
  case sent
  case failure(Error)
}

public enum ProximityResponsePreparationPartialState: ThreadSafePartialState {
  case success(RequestItemConvertible)
  case failure(Error)
}

public enum ProximityRequestPartialState: ThreadSafePartialState {
  case success([RequestDataUIModel], relyingParty: String, dataRequestInfo: String, isTrusted: Bool)
  case failure(Error)
}

public enum ProximityQrCodePartialState: ThreadSafePartialState {
  case success(UIImage)
  case failure(Error)
}

public enum ProximityPublisherPartialState: ThreadSafePartialState {
  case success(AsyncStream<PresentationState>)
  case failure(Error)
}

public enum ProximityCoordinatorPartialState: ThreadSafePartialState {
  case success(ProximitySessionCoordinator)
  case failure(Error)
}

public protocol ProximityInteractor: ThreadSafeInteractor {

  func getSessionStatePublisher() -> ProximityPublisherPartialState
  func getCoordinator() -> ProximityCoordinatorPartialState

  func onDeviceEngagement() async
  func onQRGeneration() async -> ProximityQrCodePartialState
  func onRequestReceived() async -> ProximityRequestPartialState
  func onResponsePrepare(requestItems: [RequestDataUIModel]) async -> ProximityResponsePreparationPartialState
  func onSendResponse() async -> ProximityResponsePartialState
  func stopPresentation()

}

final class ProximityInteractorImpl: ProximityInteractor {

  private let walletKitController: WalletKitController
  private let sessionCoordinatorHolder: SessionCoordinatorHolder

  init(
    with presentationSessionCoordinator: ProximitySessionCoordinator,
    and walletKitController: WalletKitController,
    also sessionCoordinatorHolder: SessionCoordinatorHolder
  ) {
    self.walletKitController = walletKitController
    self.sessionCoordinatorHolder = sessionCoordinatorHolder
    self.sessionCoordinatorHolder.setActiveProximityCoordinator(presentationSessionCoordinator)
  }

  func getCoordinator() -> ProximityCoordinatorPartialState {
    do {
      return .success(try sessionCoordinatorHolder.getActiveProximityCoordinator())
    } catch {
      return .failure(error)
    }
  }

  public func getSessionStatePublisher() -> ProximityPublisherPartialState {
    do {
      return .success(try sessionCoordinatorHolder.getActiveProximityCoordinator().getStream())
    } catch {
      return .failure(error)
    }
  }

  public func onDeviceEngagement() async {
    try? await sessionCoordinatorHolder.getActiveProximityCoordinator().initialize()
  }

  public func onQRGeneration() async -> ProximityQrCodePartialState {
    do {
      let qrImage = try await self.sessionCoordinatorHolder.getActiveProximityCoordinator().startQrEngagement()
      return .success(qrImage)
    } catch {
      return .failure(error)
    }

  }

  public func onRequestReceived() async -> ProximityRequestPartialState {
    do {
      let response = try await sessionCoordinatorHolder.getActiveProximityCoordinator().requestReceived()
      return .success(
        RequestDataUiModel.items(
          for: response.items,
          walletKitController: self.walletKitController
        ),
        relyingParty: response.relyingParty,
        dataRequestInfo: response.dataRequestInfo,
        isTrusted: response.isTrusted
      )
    } catch {
      return .failure(error)
    }
  }

  public func onResponsePrepare(requestItems: [RequestDataUIModel]) async -> ProximityResponsePreparationPartialState {
    let requestConvertible = requestItems
      .reduce(into: [RequestDataRow]()) { partialResult, cell in
        if let item = cell.isDataRow, item.isSelected {
          partialResult.append(item)
        }

        if let items = cell.isDataVerification?.items.filter({$0.isSelected}) {
          partialResult.append(contentsOf: items)
        }
      }
      .reduce(into: RequestItemsWrapper()) { partialResult, row in
        var nameSpaceDict = partialResult.requestItems[row.documentId, default: [row.namespace: [row.elementKey]]]
        nameSpaceDict[row.namespace, default: [row.elementKey]].append(row.elementKey)
        partialResult.requestItems[row.documentId] = nameSpaceDict
      }

    guard requestConvertible.requestItems.isEmpty == false else {
      return .failure(PresentationSessionError.conversionToRequestItemModel)
    }

    do {
      try self.sessionCoordinatorHolder.getActiveProximityCoordinator().setState(presentationState: .responseToSend(requestConvertible))
    } catch {
      return .failure(error)
    }

    return .success(requestConvertible.asRequestItems())
  }

  public func onSendResponse() async -> ProximityResponsePartialState {

    guard
      let state = try? await sessionCoordinatorHolder.getActiveProximityCoordinator().getState(),
      case PresentationState.responseToSend(let responseItem) = state
    else {
      return .failure(PresentationSessionError.invalidState)
    }

    do {
      try await sessionCoordinatorHolder.getActiveProximityCoordinator().sendResponse(response: responseItem)
      return .sent
    } catch {
      return .failure(error)
    }
  }

  public func stopPresentation() {
    walletKitController.stopPresentation()
    try? sessionCoordinatorHolder.getActiveProximityCoordinator().stopPresentation()
  }
}
