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
import logic_core

public enum RequestDataUIModel: Equatable, ThreadSafeObject {
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

public struct RequestDataRow: Identifiable, Equatable, ThreadSafeObject {

  public enum Value: Equatable, ThreadSafeObject {
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

  @EquatableNoop
  public var id: String

  public let title: String
  public let value: Value

  public var isSelected: Bool
  public var isVisible: Bool
  public var isEnabled: Bool

  public var elementKey: String
  public var namespace: String
  public var docType: String

  public var documentId: String {
    if let lastPart = id.split(separator: "_").last {
      return String(lastPart)
    }
    return id
  }

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

public struct RequestDataSection: Identifiable, Equatable, ThreadSafeObject {

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

public struct RequestDataVerification: Identifiable, Equatable, ThreadSafeObject {

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
  enum `Type`: Equatable, ThreadSafeObject {
    case id
    case mdl
    case age
    case photoId
    case custom(String)

    public init(docType: DocumentTypeIdentifier) {
      switch docType {
      case .PID:
        self = .id
      case .MDL:
        self = .mdl
      case .AGE:
        self = .age
      case .PHOTOID:
        self = .photoId
      case .GENERIC(docType: let docType):
        self = .custom(docType)
      }
    }
  }
}

extension RequestDataUiModel {

  public static func items(
    for docElements: [DocElementsViewModel],
    walletKitController: WalletKitController
  ) -> [RequestDataUIModel] {
    var requestDataCell = [RequestDataUIModel]()

    for docElement in docElements {

        // Filter fields for Selectable Disclosed Fields
        let dataFields = documentSelectiveDisclosableFields(
          for: docElement.elements,
          with: docElement,
          walletKitController: walletKitController
        )

        // Filter fields for mandatory keys for verification
        let verificationFields = documentMandatoryVerificationFields(
          for: docElement.elements,
          with: docElement,
          walletKitController: walletKitController
        )

        guard !dataFields.isEmpty || verificationFields != nil else {
          continue
        }

        // Section Header
        requestDataCell.append(documentSectionHeader(for: docElement))

        if !dataFields.isEmpty {
          requestDataCell.append(contentsOf: dataFields)
        }

        if let verificationFields {
          requestDataCell.append(verificationFields)
        }
    }

    return requestDataCell
  }

  fileprivate static func documentSectionHeader(for docElement: DocElementsViewModel) -> RequestDataUIModel {
    let documentIdentifier = DocumentTypeIdentifier(rawValue: docElement.docType)
    return .requestDataSection(
      .init(
        id: docElement.id,
        type: .init(docType: documentIdentifier),
        title: documentIdentifier.isSupported
        ? documentIdentifier.localizedTitle
        : docElement.displayName.ifNullOrEmpty { documentIdentifier.localizedTitle }
      )
    )
  }

  fileprivate static func documentSelectiveDisclosableFields(
    for docElements: [ElementViewModel],
    with docElement: DocElementsViewModel,
    walletKitController: WalletKitController
  ) -> [RequestDataUIModel] {
    docElements
      .filter { element in
        let mandatoryKeys = walletKitController.mandatoryFields(for: .init(rawValue: docElement.docType))
        return !mandatoryKeys.contains(element.elementIdentifier)
      }
      .map {
        RequestDataUIModel.requestDataRow(
          RequestDataRow(
            id: "\($0.id)_\(docElement.id)",
            isSelected: true,
            isVisible: false,
            title: LocalizableString.shared.get(with: .dynamic(key: $0.elementIdentifier)),
            value: walletKitController.valueForElementIdentifier(
              for: .init(rawValue: docElement.docType),
              with: docElement.id,
              elementIdentifier: $0.elementIdentifier,
              parser: {
                Locale.current.localizedDateTime(
                  date: $0,
                  uiFormatter: "dd MMM yyyy"
                )
              }
            ),
            elementKey: $0.elementIdentifier,
            namespace: $0.nameSpace,
            docType: docElement.docType
          )
        )
      }
  }

  fileprivate static func documentMandatoryVerificationFields(
    for docElements: [ElementViewModel],
    with docElement: DocElementsViewModel,
    walletKitController: WalletKitController
  ) -> RequestDataUIModel? {
    let mandatoryFields = docElements
      .filter { element in
        let mandatoryKeys = walletKitController.mandatoryFields(for: .init(rawValue: docElement.docType))
        return mandatoryKeys.contains(element.elementIdentifier)
      }
      .map {
        RequestDataRow(
          id: "\($0.id)_\(docElement.id)",
          isSelected: true,
          isVisible: false,
          title: LocalizableString.shared.get(with: .dynamic(key: $0.elementIdentifier)),
          value: walletKitController.valueForElementIdentifier(
            for: .init(rawValue: docElement.docType),
            with: docElement.id,
            elementIdentifier: $0.elementIdentifier,
            parser: {
              Locale.current.localizedDateTime(
                date: $0,
                uiFormatter: "dd MMM yyyy"
              )
            }
          ),
          elementKey: $0.elementIdentifier,
          namespace: $0.nameSpace,
          docType: docElement.docType
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
  public static func mock() -> [RequestDataUIModel] {
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
