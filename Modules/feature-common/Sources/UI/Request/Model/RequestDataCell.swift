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
import SwiftUI
import logic_business
import EudiWalletKit

public enum RequestDataCell: Equatable {
  case requestDataRow(RequestDataRow)
  case requestDataSection(RequestDataSection)
  case requestDataVerification(RequestDataVerification)

  public var isDataRow: RequestDataRow? {
    switch self {
    case .requestDataRow(let row):
      return row
    default:
      return nil
    }
  }

  public var isDataSection: RequestDataSection? {
    switch self {
    case .requestDataSection(let section):
      return section
    default:
      return nil
    }
  }

  public var isDataVerification: RequestDataVerification? {
    switch self {
    case .requestDataVerification(let verification):
      return verification
    default:
      return nil
    }
  }
}

public struct RequestDataRow: Identifiable, Equatable {

  public let title: String
  public let value: String

  public var id: String
  public var isSelected: Bool
  public var isVisible: Bool

  public var elementKey: String
  public var namespace: String
  public var docType: String

  public init(
    id: String = UUID().uuidString,
    isSelected: Bool,
    isVisible: Bool,
    title: String,
    value: String,
    elementKey: String = "namespaced_key",
    namespace: String = "doc.namespace",
    docType: String = "mock"
  ) {
    self.id = id
    self.isSelected = isSelected
    self.isVisible = isVisible
    self.title = title
    self.value = value
    self.elementKey = elementKey
    self.namespace = namespace
    self.docType = docType
  }

  public mutating func setSelected(_ isSelected: Bool) {
    self.isSelected = isSelected
  }

  public mutating func setVisible(_ isVisible: Bool) {
    self.isVisible = isVisible
  }
}

public struct RequestDataSection: Identifiable, Equatable {

  public var id: String
  public let type: `Type`
  public let title: String

  public init(
    id: String = UUID().uuidString,
    type: `Type`,
    title: String
  ) {
    self.id = id
    self.type = type
    self.title = title
  }
}

public struct RequestDataVerification: Identifiable, Equatable {

  public var id: String
  public let title: String
  public let items: [RequestDataRow]

  public init(
    id: String = UUID().uuidString,
    title: String,
    items: [RequestDataRow]
  ) {
    self.id = id
    self.title = title
    self.items = items
  }
}

public extension RequestDataSection {
  enum `Type`: Equatable {
    case id
    case mdl
    case custom(String)

    public init(docType: DocumentIdentifier) {
      switch docType {

      case .EuPidDocType:
        self = .id
      case .IsoMdlModel:
        self = .mdl
      case .genericDocument(docType: let docType):
        self = .custom(docType)
      }
    }
  }
}

public struct RequestDataUiModel {
  public static func mock() -> [RequestDataCell] {
    [
      .requestDataSection(.init(type: .id, title: "Digital ID")),
      .requestDataRow(.init(isSelected: true, isVisible: false, title: "Family Name", value: "Tzouvaras")),
      .requestDataRow(.init(isSelected: true, isVisible: false, title: "First Name", value: "Stilianos")),
      .requestDataRow(.init(isSelected: true, isVisible: false, title: "Date of Birth", value: "21-09-1985")),
      .requestDataRow(.init(isSelected: true, isVisible: false, title: "Resident Country", value: "Greece")),
      .requestDataVerification(
        .init(
          title: "Verification data",
          items: [
            .init(isSelected: true, isVisible: false, title: "Family Name", value: "Tzouvaras"),
            .init(isSelected: true, isVisible: false, title: "First Name", value: "Stilianos"),
            .init(isSelected: true, isVisible: false, title: "Date of Birth", value: "21-09-1985"),
            .init(isSelected: true, isVisible: false, title: "Resident Country", value: "Greece")
          ]
        )
      ),
      .requestDataSection(.init(type: .mdl, title: "MDL")),
      .requestDataRow(.init(isSelected: true, isVisible: false, title: "Family Name", value: "Tzouvaras")),
      .requestDataRow(.init(isSelected: true, isVisible: false, title: "First Name", value: "Stilianos")),
      .requestDataVerification(
        .init(
          title: "Verification data",
          items: [
            .init(isSelected: true, isVisible: false, title: "Date of Birth", value: "21-09-1985"),
            .init(isSelected: true, isVisible: false, title: "Resident Country", value: "Greece")
          ]
        )
      )
    ]
  }
}

extension RequestDataUiModel {

  public static func items(for documents: [DocElementsViewModel]) -> [RequestDataCell] {
    var requestDataCell = [RequestDataCell]()

    for document in documents {
      // Section Header
      requestDataCell.append(documentSectionHeader(for: document))

      // Filter fields for Selectable Disclosed Fields
      requestDataCell.append(contentsOf: documentSelectiveDisclosableFields(for: document))

      // Filter fields for mandatory keys for verification
      if let verificationFields = documentMandatoryVerificationFields(for: document) {
        requestDataCell.append(verificationFields)
      }
    }

    return requestDataCell
  }

  fileprivate static func documentSectionHeader(for document: DocElementsViewModel) -> RequestDataCell {
    .requestDataSection(
      .init(
        id: document.docType,
        type: .init(docType: DocumentIdentifier(rawValue: document.docType)),
        title: DocumentIdentifier(rawValue: document.docType).localizedTitle
      )
    )
  }

  fileprivate static func documentSelectiveDisclosableFields(for document: DocElementsViewModel) -> [RequestDataCell] {
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

  fileprivate static func documentMandatoryVerificationFields(for document: DocElementsViewModel) -> RequestDataCell? {
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
