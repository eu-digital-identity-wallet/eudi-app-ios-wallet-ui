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

  func startDeviceEngagement() async -> ProximityInitialisationPartialState
  func generateQRCode() async -> ProximityQrCodePartialState
  func onRequestReceived() async -> ProximityRequestPartialState
  func onRequestSent(requestItems: [RequestDataCell]) async throws
  func stopPresentation() async

}

public final actor ProximityInteractor: ProximityInteractorType {

  public let presentationSession: PresentationSession

  public init() {
    guard WalletKitController.shared.activeSession.status != .initializing else {
      presentationSession = WalletKitController.shared.startPresentation(flow: .ble)
      return
    }
    presentationSession = WalletKitController.shared.activeSession
  }

  public func startDeviceEngagement() async -> ProximityInitialisationPartialState {
    do {
      try await presentationSession.startQrEngagement()
      try await presentationSession.receiveRequest()
      return .success
    } catch {
      return .failure(error)
    }
  }

  public func generateQRCode() async -> ProximityQrCodePartialState {

    guard let data = presentationSession.deviceEngagement else {
      return .failure(RuntimeError.genericError)
    }

    guard let qrImage = UIImage(data: data) else {
      return .failure(RuntimeError.genericError)
    }

    return .success(qrImage)
  }

  public func onRequestSent(requestItems: [RequestDataCell]) async throws {
    // Dictionary of Dictionaries of Array of Strings
    var itemsToSend = RequestItems()
    for item in requestItems {
      if let section = item.isDataSection {
        itemsToSend[section.id] = Dictionary()
      }
    }

    let flattenedRows = requestItems.reduce(into: [RequestDataRow]()) { partialResult, cell in
      if let item = cell.isDataRow, item.isSelected {
        partialResult.append(item)
      }

      if let items = cell.isDataVerification?.items.filter({$0.isSelected}) {
        partialResult.append(contentsOf: items)
      }
    }

    let flatRowsDictionary = Dictionary(grouping: flattenedRows, by: \.namespace)
      .mapValues { row in
        row.map({$0.title})
      }

    //    for row in flattenedRows {
    //      print(itemsToSend[row.docType]?.count)
    //
    //      itemsToSend[row.docType] = flattenedRows.reduce(into: [String: [String]](), { partialResult, row in
    //        if let exists = partialResult[row.namespace] {
    //          partialResult[row.namespace] = []
    //          partialResult[row.namespace]?.append(row.title)
    //        } else {
    //          partialResult[row.namespace]?.append(row.title)
    //        }
    //
    //      })
    //    }

    for item in itemsToSend {
      itemsToSend[item.key] = [item.key: flatRowsDictionary[item.key] ?? []]
    }

    print(itemsToSend)

    try await presentationSession.sendResponse(userAccepted: true, itemsToSend: itemsToSend) {

    }
  }

  public func onRequestReceived() -> ProximityRequestPartialState {
    var requestDataCell = [RequestDataCell]()

    for document in presentationSession.disclosedDocuments {
      // Section Header
      requestDataCell.append(documentSectionHeader(for: document))

      // Filter fields for Selectable Disclosed Fields
      requestDataCell.append(contentsOf: documentSelectiveDisclosableFields(for: document))

      // Filter fields for mandatory keys for verification
      requestDataCell.append(documentMandatoryVerificationFields(for: document))
    }

    return .success(requestDataCell)
  }

  private func documentSectionHeader(for document: DocElementsViewModel) -> RequestDataCell {
    .requestDataSection(.init(id: document.id, type: .init(docType: document.docType), title: document.docType))
  }

  private func documentSelectiveDisclosableFields(for document: DocElementsViewModel) -> [RequestDataCell] {
    document.elements
      .filter { element in
        let mandatoryKeys = WalletKitController.shared.mandatoryFields(for: document.docType)
        return !mandatoryKeys.contains(element.elementIdentifier)
      }
      .map {
        RequestDataCell.requestDataRow(.init(id: $0.id,
                                             isSelected: true,
                                             isVisible: false,
                                             title: $0.elementIdentifier,
                                             value: "",
                                             namespace: $0.nameSpace,
                                             docType: document.docType))

      }
  }

  private func documentMandatoryVerificationFields(for document: DocElementsViewModel) -> RequestDataCell {
    let mandatoryFields = document.elements
      .filter { element in
        let mandatoryKeys = WalletKitController.shared.mandatoryFields(for: document.docType)
        return mandatoryKeys.contains(element.elementIdentifier)
      }
      .map {
        RequestDataRow(id: $0.id,
                       isSelected: true,
                       isVisible: false,
                       title: $0.elementIdentifier,
                       value: "",
                       namespace: $0.nameSpace,
                       docType: document.docType)

      }

    return .requestDataVerification(.init(title: document.docType + "verification", items: mandatoryFields))
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
