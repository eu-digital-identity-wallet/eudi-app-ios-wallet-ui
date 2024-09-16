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
import logic_api
import logic_core
import logic_business
import feature_common

public enum ProximityResponsePartialState {
  case success
  case failure(Error)
}

public enum ProximityResponsePreparationPartialState {
  case success(RequestItemConvertible)
  case failure(Error)
}

public enum ProximityRequestPartialState {
  case success([RequestDataUIModel], relyingParty: String, dataRequestInfo: String, isTrusted: Bool)
  case failure(Error)
}

public enum ProximityInitialisationPartialState {
  case success
  case failure(Error)
}

public enum ProximityQrCodePartialState {
  case success(UIImage)
  case failure(Error)
}

public protocol ProximityInteractor {

  var presentationSessionCoordinator: PresentationSessionCoordinator { get }

  func getSessionStatePublisher() async -> AnyPublisher<PresentationState, Never>

  func onDeviceEngagement() async -> ProximityInitialisationPartialState
  func onQRGeneration() async -> ProximityQrCodePartialState
  func onRequestReceived() async -> ProximityRequestPartialState
  func onResponsePrepare(requestItems: [RequestDataUIModel]) async -> ProximityResponsePreparationPartialState
  func onSendResponse() async -> ProximityResponsePartialState
  func stopPresentation() async

}

final class ProximityInteractorImpl: ProximityInteractor {

  private let walletKitController: WalletKitController
  public let presentationSessionCoordinator: PresentationSessionCoordinator

  init(
    with presentationSessionCoordinator: PresentationSessionCoordinator,
    and walletKitController: WalletKitController
  ) {
    self.presentationSessionCoordinator = presentationSessionCoordinator
    self.walletKitController = walletKitController
  }

  public func getSessionStatePublisher() async -> AnyPublisher<PresentationState, Never> {
    presentationSessionCoordinator
      .presentationStateSubject
      .eraseToAnyPublisher()
  }

  public func onDeviceEngagement() async -> ProximityInitialisationPartialState {
    await presentationSessionCoordinator.initialize()
    return .success
  }

  public func onQRGeneration() async -> ProximityQrCodePartialState {
    do {
      let qrImage = try await self.presentationSessionCoordinator.startQrEngagement()
      return .success(qrImage)
    } catch {
      return .failure(error)
    }

  }

  public func onRequestReceived() async -> ProximityRequestPartialState {
    do {
      let response = try await presentationSessionCoordinator.requestReceived()
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

    self.presentationSessionCoordinator.setState(presentationState: .responseToSend(requestConvertible))

    return .success(requestConvertible.asRequestItems())
  }

  public func onSendResponse() async -> ProximityResponsePartialState {

    guard case PresentationState.responseToSend(let responseItem) = await presentationSessionCoordinator.getState() else {
      return .failure(PresentationSessionError.invalidState)
    }

    do {
      try await presentationSessionCoordinator.sendResponse(
        response: responseItem,
        onSuccess: nil,
        onCancel: nil
      )
      return .success
    } catch {
      return .failure(error)
    }
  }

  public func stopPresentation() {
    walletKitController.stopPresentation()
  }
}
