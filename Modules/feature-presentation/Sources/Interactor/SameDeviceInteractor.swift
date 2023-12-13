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
import logic_business
import feature_common

public protocol SameDeviceInteractorType {
  var presentationCoordinator: PresentationSessionCoordinatorType { get }

  func onDeviceEngagement() async -> Result<OnlineAuthenticationRequestSuccess, Error>
  func onResponsePrepare(requestItems: [RequestDataCell]) async -> Result<RequestItemConvertible, Error>
  func onSendResponse() async -> Result<Void, Error>
}

public final actor SameDeviceInteractor: SameDeviceInteractorType {

  public let presentationCoordinator: PresentationSessionCoordinatorType
  private lazy var walletKitController: WalletKitControllerType = WalletKitController.shared

  public init(with presentationCoordinator: PresentationSessionCoordinatorType) {
    self.presentationCoordinator = presentationCoordinator
  }

  public func onDeviceEngagement() async -> Result<OnlineAuthenticationRequestSuccess, Error> {
    await presentationCoordinator.initialize()
    return await onRequestReceived()
  }

  func onRequestReceived() async -> Result<OnlineAuthenticationRequestSuccess, Error> {
    do {
      let response = try await presentationCoordinator.requestReceived()
      return .success(
        .init(
          requestDataCells: RequestDataUiModel.items(
            for: response.items
          ),
          relyingParty: response.relyingParty,
          dataRequestInfo: response.dataRequestInfo,
          isTrusted: response.isTrusted
        )
      )
    } catch {
      return .failure(error)
    }
  }

  public func onResponsePrepare(requestItems: [RequestDataCell]) async -> Result<RequestItemConvertible, Error> {
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

    self.presentationCoordinator.setState(presentationState: .responseToSend(requestConvertible))

    return .success(requestConvertible.asRequestItems())
  }

  public func onSendResponse() async -> Result<Void, Error> {

    guard case PresentationState.responseToSend(let responseItem) = await presentationCoordinator.getState() else {
      return .failure(PresentationSessionError.invalidState)
    }

    do {
      try await presentationCoordinator.sendResponse(response: responseItem)
      return .success
    } catch {
      return .failure(error)
    }
  }
}
