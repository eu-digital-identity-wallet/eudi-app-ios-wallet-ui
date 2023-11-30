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

  func getSessionStatePublisher() async -> AnyPublisher<PresentationState, Never>

  func onDeviceEngagement() async -> ProximityInitialisationPartialState
  func onQRGeneration() async -> ProximityQrCodePartialState
  func onRequestReceived() async -> ProximityRequestPartialState
  func onResponsePrepare(requestItems: [RequestDataCell]) async -> ProximityResponsePreparationPartialState
  func onSendResponse() async -> ProximityResponsePartialState
  func stopPresentation() async

}

public final actor ProximityInteractor: ProximityInteractorType {

  private lazy var walletKitController: WalletKitControllerType = WalletKitController.shared
  public let presentationSessionCoordinator: PresentationSessionCoordinatorType

  public init(with presentationSessionCoordinator: PresentationSessionCoordinatorType) {
    self.presentationSessionCoordinator = presentationSessionCoordinator
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
        relyingParty: getVerifierName(response: response),
        dataRequestInfo: response.dataRequestInfo,
        isTrusted: response.isTrusted
      )
    } catch {
      return .failure(error)
    }
  }

  public func onResponsePrepare(requestItems: [RequestDataCell]) async -> ProximityResponsePreparationPartialState {
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

    self.presentationSessionCoordinator.setState(presentationState: .responseToSend(requestConvertible))

    return .success(requestConvertible.asRequestItems())
  }

  public func onSendResponse() async -> ProximityResponsePartialState {

    guard case PresentationState.responseToSend(let responseItem) = await presentationSessionCoordinator.getState() else {
      return .failure(PresentationSessionError.invalidState)
    }

    do {
      try await presentationSessionCoordinator.sendResponse(response: responseItem)
      return .success
    } catch {
      return .failure(error)
    }
  }

  public func stopPresentation() {
    walletKitController.stopPresentation()
  }
}

extension ProximityInteractor {
  fileprivate func getVerifierName(response: PresentationRequest) -> String {
    // TODO: Make a more concrete approach in how we handle extracting the CN value of verifier message

      func extractKeyValuePairs(from input: String) -> [String: String] {
          var result = [String: String]()
          // Find Keys, separated  by a = unti we find the next comma e.g. CN = Test Verifier, CU = Test
          // will produce a dictionary of result[CN] = "Test Verifier", result[CU] = "Test"
          let regexPattern = #"(\w+)=([^,]+)"#

          do {
              let regex = try NSRegularExpression(pattern: regexPattern)
              let matches = regex.matches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count))

              for match in matches {
                  if let keyRange = Range(match.range(at: 1), in: input),
                    let valueRange = Range(match.range(at: 2), in: input) {
                      let key = String(input[keyRange])
                      let value = String(input[valueRange])

                      result[key] = value
                  }
              }

          } catch let error {
              print("Invalid regex: \(error.localizedDescription)")
          }

          return result
      }

    let extractedKeys = extractKeyValuePairs(from: response.relyingParty)
    let issuerMessage = extractedKeys["CN"]
    return issuerMessage ?? LocalizableString.shared.get(with: .unknownVerifier)
  }
}
