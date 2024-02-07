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

  public enum Value: Equatable {
    case string(String)
    case image(Data)

    public var string: String? {
      switch self {
      case .string(let string):
        string
      default:
        nil
      }
    }

    public var image: Data? {
      switch self {
      case .image(let image):
        image
      default:
        nil
      }
    }
  }

  public let title: String
  public let value: Value

  public var id: String
  public var isSelected: Bool
  public var isVisible: Bool
  public var isEnabled: Bool

  public var elementKey: String
  public var namespace: String
  public var docType: String

  public init(
    id: String = UUID().uuidString,
    isSelected: Bool,
    isVisible: Bool,
    title: String,
    value: MdocValue,
    elementKey: String = "namespaced_key",
    namespace: String = "doc.namespace",
    docType: String = "mock"
  ) {
    self.id = id
    self.isSelected = isSelected
    self.isVisible = isVisible
    self.title = title
    switch value {
    case .string(let string):
      self.value = .string(string)
      self.isEnabled = true
    case .unavailable(let string):
      self.value = .string(string)
      self.isEnabled = false
      self.isSelected = false
    case .image(let imageData):
      self.value = .image(imageData)
      self.isEnabled = true
    }
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
  public var items: [RequestDataRow]

  public init(
    id: String = UUID().uuidString,
    title: String,
    items: [RequestDataRow]
  ) {
    self.id = id
    self.title = title
    self.items = items
  }

  mutating func setItems(with items: [RequestDataRow]) {
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

extension RequestDataUiModel {

  public static func items(for documents: [DocElementsViewModel]) -> [RequestDataCell] {
    var requestDataCell = [RequestDataCell]()

    for document in documents {

      // Filter fields for Selectable Disclosed Fields
      let dataFields = documentSelectiveDisclosableFields(for: document)

      // Filter fields for mandatory keys for verification
      let verificationFields = documentMandatoryVerificationFields(for: document)

      guard !dataFields.isEmpty || verificationFields != nil else {
        continue
      }

      // Section Header
      requestDataCell.append(documentSectionHeader(for: document))

      if !dataFields.isEmpty {
        requestDataCell.append(contentsOf: dataFields)
      }

      if let verificationFields {
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
            value: WalletKitController.shared.valueForElementIdentifier(
              for: .init(rawValue: document.docType),
              elementIdentifier: $0.elementIdentifier
            ),
            elementKey: $0.elementIdentifier,
            namespace: $0.nameSpace,
            docType: document.docType
          )
        )
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
          value: WalletKitController.shared.valueForElementIdentifier(
            for: .init(rawValue: document.docType),
            elementIdentifier: $0.elementIdentifier
          ),
          elementKey: $0.elementIdentifier,
          namespace: $0.nameSpace,
          docType: document.docType
        )
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

public struct RequestDataUiModel {
  public static func mock() -> [RequestDataCell] {
    [
      .requestDataSection(.init(type: .id, title: "Digital ID")),
      .requestDataRow(.init(isSelected: true, isVisible: false, title: "Family Name", value: .string("Tzouvaras"))),
      .requestDataRow(.init(isSelected: true, isVisible: false, title: "First Name", value: .string("Stilianos"))),
      .requestDataRow(.init(isSelected: true, isVisible: false, title: "Date of Birth", value: .string("21-09-1985"))),
      .requestDataRow(.init(isSelected: true, isVisible: false, title: "Resident Country", value: .string("Greece"))),
      .requestDataVerification(
        .init(
          title: "Verification data",
          items: [
            .init(isSelected: true, isVisible: false, title: "Family Name", value: .string("Tzouvaras")),
            .init(isSelected: true, isVisible: false, title: "First Name", value: .string("Stilianos")),
            .init(isSelected: true, isVisible: false, title: "Date of Birth", value: .string("21-09-1985")),
            .init(isSelected: true, isVisible: false, title: "Resident Country", value: .string("Greece"))
          ]
        )
      ),
      .requestDataSection(.init(type: .mdl, title: "MDL")),
      .requestDataRow(.init(isSelected: true, isVisible: false, title: "Family Name", value: .string("Tzouvaras"))),
      .requestDataRow(.init(isSelected: true, isVisible: false, title: "First Name", value: .string("Stilianos"))),
      .requestDataVerification(
        .init(
          title: "Verification data",
          items: [
            .init(isSelected: true, isVisible: false, title: "Date of Birth", value: .string("21-09-1985")),
            .init(isSelected: true, isVisible: false, title: "Resident Country", value: .string("Greece"))
          ]
        )
      )
    ]
  }
}
