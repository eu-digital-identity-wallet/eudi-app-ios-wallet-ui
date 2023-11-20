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
import CoreImage.CIFilterBuiltins
import UIKit
import EudiWalletKit
import feature_common

public enum ProximityPartialState {
  case success
  case failure(Error)
}

public enum ProximityResponsePreparationPartialState {
  case success(RequestItems)
  case failure(Error)
}

public enum ProximityRequestPartialState {
  case success([RequestDataCell])
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
  var presentationSession: PresentationSession { get }
  func doWork() async -> ProximityPartialState
  func onDeviceEngagement() async -> ProximityInitialisationPartialState
  func onQRGeneration() async -> ProximityQrCodePartialState
  func onRequestReceived() async -> ProximityRequestPartialState
  func onResponsePrepare(requestItems: [RequestDataCell]) async -> ProximityResponsePreparationPartialState
  func onSendResponse(requestItems: RequestItems) async -> ProximityPartialState
  func stopPresentation() async

}

public final actor ProximityInteractor: ProximityInteractorType {

  public let presentationSession: PresentationSession

  public init(presentationSession: PresentationSession) {
    self.presentationSession = presentationSession
  }

  public func onDeviceEngagement() async -> ProximityInitialisationPartialState {
    do {
      try await presentationSession.startQrEngagement()
      try await presentationSession.receiveRequest()
      return .success
    } catch {
      return .failure(error)
    }
  }

  public func onQRGeneration() async -> ProximityQrCodePartialState {

    guard let data = presentationSession.deviceEngagement else {
      return .failure(RuntimeError.genericError)
    }

    guard let qrImage = UIImage(data: data) else {
      return .failure(RuntimeError.genericError)
    }

    return .success(qrImage)
  }

  public func onRequestReceived() -> ProximityRequestPartialState {
    return .success(RequestDataUiModel.mock())
    var requestDataCell = [RequestDataCell]()

    for document in presentationSession.disclosedDocuments {
      // Section Header
      requestDataCell.append(documentSectionHeader(for: document))

      // Filter fields for Selectable Disclosed Fields
      requestDataCell.append(contentsOf: documentSelectiveDisclosableFields(for: document))

      // Filter fields for mandatory keys for verification
      if let verificationFields = documentMandatoryVerificationFields(for: document) {
        requestDataCell.append(verificationFields)
      }
    }

    guard requestDataCell.count > 1 else {
      return .failure(presentationSession.uiError ?? .init(description: LocalizableString.shared.get(with: .genericErrorTitle)))
    }

    return .success(requestDataCell)
  }

  public func onResponsePrepare(requestItems: [RequestDataCell]) async -> ProximityResponsePreparationPartialState {
    .success(
      requestItems
        .reduce(into: [RequestDataRow]()) { partialResult, cell in
          if let item = cell.isDataRow, item.isSelected {
            partialResult.append(item)
          }

          if let items = cell.isDataVerification?.items.filter({$0.isSelected}) {
            partialResult.append(contentsOf: items)
          }
        }
        .reduce(into: RequestItems()) {  partialResult, row in
          var nameSpaceDict = partialResult[row.docType, default: [row.namespace: [row.elementKey]]]
          nameSpaceDict[row.namespace, default: [row.elementKey]].append(row.elementKey)
          partialResult[row.docType] = nameSpaceDict
        })
  }

  public func onSendResponse(requestItems: RequestItems) async -> ProximityPartialState {
    do {
      try await Task.sleep(nanoseconds: 2 * 1_000_000_000)
      try await presentationSession.sendResponse(userAccepted: true, itemsToSend: requestItems) {
      }
      return .success
    } catch {
      return .failure(error)
    }
  }

  public func doWork() async -> ProximityPartialState {
    do {
      try await Task.sleep(nanoseconds: 2 * 1_000_000_000)
      return .success
    } catch {
      return .failure(error)
    }
  }

  public func stopPresentation() async {
    WalletKitController.shared.stopPresentation()
  }
}

extension ProximityInteractor {
  fileprivate func documentSectionHeader(for document: DocElementsViewModel) -> RequestDataCell {
    .requestDataSection(.init(id: document.docType, type: .init(docType: document.docType), title: document.docType))
  }

  fileprivate func documentSelectiveDisclosableFields(for document: DocElementsViewModel) -> [RequestDataCell] {
    document.elements
      .filter { element in
        let mandatoryKeys = WalletKitController.shared.mandatoryFields(for: .init(rawValue: document.docType))
        return !mandatoryKeys.contains(element.elementIdentifier)
      }
      .map {
        RequestDataCell.requestDataRow(
          RequestDataRow(
            id: $0.id,
            isSelected: true,
            isVisible: false,
            title: LocalizableString.shared.get(with: .dynamic(key: $0.elementIdentifier)),
            value: "",
            elementKey: $0.elementIdentifier,
            namespace: $0.nameSpace,
            docType: document.docType))

      }
  }

  fileprivate func documentMandatoryVerificationFields(for document: DocElementsViewModel) -> RequestDataCell? {
    let mandatoryFields = document.elements
      .filter { element in
        let mandatoryKeys = WalletKitController.shared.mandatoryFields(for: .init(rawValue: document.docType))
        return mandatoryKeys.contains(element.elementIdentifier)
      }
      .map {
        RequestDataRow(
          id: $0.id,
          isSelected: true,
          isVisible: false,
          title: LocalizableString.shared.get(with: .dynamic(key: $0.elementIdentifier)),
          value: "",
          elementKey: $0.elementIdentifier,
          namespace: $0.nameSpace,
          docType: document.docType)
      }

    guard mandatoryFields.count > 0 else {
      return nil
    }

    return .requestDataVerification(
      .init(title: LocalizableString.shared.get(with: .verification),
            items: mandatoryFields)
    )
  }
}
