/*
 * Copyright (c) 2023 European Commission
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import Foundation
import logic_api
import logic_business
import UIKit
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
  case success([RequestDataCell], relyingParty: String, dataRequestInfo: String, isTrusted: Bool)
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

public protocol ProximityInteractorType {

  var presentationSessionCoordinator: PresentationSessionCoordinatorType { get }

  func getSessionStatePublisher() async -> any Publisher<PresentationState, Never>
  func onDeviceEngagement() async -> ProximityInitialisationPartialState
  func onQRGeneration() async -> ProximityQrCodePartialState
  func onRequestReceived() async -> ProximityRequestPartialState
  func onResponsePrepare(requestItems: [RequestDataCell]) -> ProximityResponsePreparationPartialState
  func onSendResponse() async -> ProximityResponsePartialState
  func stopPresentation() async

}

public final actor ProximityInteractor: ProximityInteractorType {

  public let presentationSessionCoordinator: PresentationSessionCoordinatorType

  public init(presentationSessionCoordinator: PresentationSessionCoordinatorType) {
    self.presentationSessionCoordinator = presentationSessionCoordinator
  }

  public func getSessionStatePublisher() async -> any Publisher<PresentationState, Never> {
    presentationSessionCoordinator.presentationStateSubject.eraseToAnyPublisher()
  }

  public func onDeviceEngagement() async -> ProximityInitialisationPartialState {
    await presentationSessionCoordinator.initialize()
    return .success
  }

  public func onQRGeneration() async -> ProximityQrCodePartialState {
    do {
      let data = try await self.presentationSessionCoordinator.startQrEngagement()

      guard let qrImage = UIImage(data: data) else {
        return .failure(PresentationSessionError.qrGeneration)
      }

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
          for: response.items
        ),
        relyingParty: response.relyingParty,
        dataRequestInfo: response.dataRequestInfo,
        isTrusted: response.isTrusted
      )
    } catch {
      return .failure(error)
    }
  }

  nonisolated public func onResponsePrepare(requestItems: [RequestDataCell]) -> ProximityResponsePreparationPartialState {
    let requestConvertible = requestItems
      .reduce(into: [RequestDataRow]()) { partialResult, cell in
        if let item = cell.isDataRow, item.isSelected {
          partialResult.append(item)
        }

        if let items = cell.isDataVerification?.items.filter({$0.isSelected}) {
          partialResult.append(contentsOf: items)
        }
      }
      .reduce(into: RequestItemsWrapper()) {  partialResult, row in
        var nameSpaceDict = partialResult.requestItems[row.docType, default: [row.namespace: [row.elementKey]]]
        nameSpaceDict[row.namespace, default: [row.elementKey]].append(row.elementKey)
        partialResult.requestItems[row.docType] = nameSpaceDict
      }

    guard requestConvertible.requestItems.isEmpty == false else {
      return .failure(PresentationSessionError.conversionToRequestItemModel)
    }

    self.presentationSessionCoordinator.setState(presentationState: .response(requestConvertible))

    return .success(requestConvertible.asRequestItems())
  }

  public func onSendResponse() async -> ProximityResponsePartialState {

    guard case PresentationState.response(let responseItem) = presentationSessionCoordinator.presentationStateSubject.value else {
      return .failure(PresentationSessionError.invalidState)
    }

    do {
      try await Task.sleep(nanoseconds: 2.nanoseconds)
      try await presentationSessionCoordinator.sendResponse(response: responseItem)
      return .success
    } catch {
      return .failure(error)
    }
  }

  public func stopPresentation() {
    WalletKitController.shared.stopPresentation()
  }
}
