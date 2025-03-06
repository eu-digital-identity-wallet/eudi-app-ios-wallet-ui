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
import SwiftUI
import logic_business
import logic_core
import logic_ui
import Copyable

@Copyable
public struct RequestDataUiModel: Identifiable, Equatable, Sendable, Routable {

  public let id: String
  public let requestDataRow: [RequestDataRow]
  public let requestDataSection: ListItemSection

  public var log: String {
    "id: \(id), title: \(requestDataSection.title)"
  }

  public init(
    id: String = UUID().uuidString,
    requestDataRow: [RequestDataRow],
    requestDataSection: ListItemSection
  ) {
    self.id = id
    self.requestDataRow = requestDataRow
    self.requestDataSection = requestDataSection
  }
}

extension RequestDataUiModel {
  mutating func toggleSelection(id: String) {

    @discardableResult
    func findSelection(id: String, listItems: inout [ExpandableListItem]) -> [ExpandableListItem] {
      for index in listItems.indices {
        switch listItems[index] {
        case .single(let item):

          guard item.collapsed.id == id else {
            continue
          }

          switch item.collapsed.trailingContent {
          case .checkbox(let isEnabled, let isSelected, let onClick):
            guard isEnabled else { break }
            listItems[index] = .single(
              item.copy(
                collapsed: item.collapsed.copy(
                  trailingContent: .checkbox(isEnabled, !isSelected, onClick)
                )
              )
            )
          default:
            break
          }
        case .nested(let item):
          if item.collapsed.id == id {
            listItems[index] = .nested(item.copy(isExpanded: !item.isExpanded))
          } else {
            var children = item.expanded
            findSelection(id: id, listItems: &children)
            listItems[index] = .nested(item.copy(expanded: children))
          }
        }
      }
      return listItems
    }

    var listItems = requestDataSection.listItems

    findSelection(id: id, listItems: &listItems)

    self = self.copy(
      requestDataSection: self.requestDataSection.copy(listItems: listItems)
    )
  }
}

public extension Array where Element == RequestDataUiModel {

  func filterSelectedRows() -> [RequestDataUiModel] {

    func filterSelection(
      currentList: [ExpandableListItem],
      newList: inout [ExpandableListItem]
    ) {
      currentList.forEach {
        switch $0 {
        case .single(let item):
          switch item.collapsed.trailingContent {
          case .checkbox(_, let isSelected, _):
            if isSelected {
              newList.append($0)
            }
          default:
            break
          }
        case .nested(let item):
          newList.append($0)
          let groupPosition = newList.count - 1
          var children: [ExpandableListItem] = []
          filterSelection(currentList: item.expanded, newList: &children)
          let group: ExpandableListItem = .nested(
            .init(
              id: item.id,
              collapsed: item.collapsed,
              expanded: children,
              isExpanded: item.isExpanded
            )
          )
          if !children.isEmpty {
            newList[groupPosition] = group
          } else {
            newList.remove(at: groupPosition)
          }
        }
      }
    }

    var models: [RequestDataUiModel] = []

    self.forEach { model in

      var expandableList: [ExpandableListItem] = []

      filterSelection(currentList: model.requestDataSection.listItems, newList: &expandableList)

      if !expandableList.isEmpty {
        models.append(
          model.copy(
            requestDataSection: .init(
              id: model.requestDataSection.id,
              title: model.requestDataSection.title,
              listItems: expandableList)
          )
        )
      }
    }

    return models
  }

  func canShare() -> Bool {

    func getAllSingleItems(
      all: [ExpandableListItem],
      result: inout [ExpandableListItem.SingleListItemData]
    ) {
      all.forEach { item in
        switch item {
        case .nested(let item):
          getAllSingleItems(all: item.expanded, result: &result)
        case .single(let item):
          result.append(item)
        }
      }
    }

    var listItems: [ExpandableListItem.SingleListItemData] = []
    self.forEach {
      getAllSingleItems(all: $0.requestDataSection.listItems, result: &listItems)
    }

    let canShareDataRows = listItems
      .map {
        $0.collapsed.trailingContent
      }
      .flatMap {
        var selectedItems: [Bool] = []
        switch $0 {
        case .checkbox(_, let isSelected, _):
          selectedItems.append(isSelected)
        default:
          break
        }
        return selectedItems
      }
      .filter { $0 }
      .isEmpty

    return !canShareDataRows
  }
}

public extension RequestDataUiModel {
  static func mockData() -> [RequestDataUiModel] {
    [
      RequestDataUiModel(
        requestDataRow: [
          RequestDataRow(
            claim: .primitive(
              id: UUID().uuidString,
              title: "Family Name",
              path: [],
              value: .string("Tzouvaras"),
              status: .available(isRequired: false)
            )
          ),
          RequestDataRow(
            claim: .primitive(
              id: UUID().uuidString,
              title: "First Name",
              path: [],
              value: .string("Stilianos"),
              status: .available(isRequired: false)
            )
          ),
          RequestDataRow(
            claim: .primitive(
              id: UUID().uuidString,
              title: "Date of Birth",
              path: [],
              value: .string("20-09-1985"),
              status: .available(isRequired: false)
            )
          ),
          RequestDataRow(
            claim: .primitive(
              id: UUID().uuidString,
              title: "Resident Country",
              path: [],
              value: .string("Greece"),
              status: .available(isRequired: false)
            )
          )
        ],
        requestDataSection: .init(
          id: UUID().uuidString,
          title: "MDL",
          listItems: [
            .single(
              .init(
                collapsed: ListItemData(
                  mainText: .custom("Tzouvaras"),
                  overlineText: .custom("Family Name")
                )
              )
            ),
            .single(
              .init(
                collapsed: ListItemData(
                  mainText: .custom("Stilianos"),
                  overlineText: .custom("First Name")
                )
              )
            ),
            .single(
              .init(
                collapsed: ListItemData(
                  mainText: .custom("21-09-1985"),
                  overlineText: .custom("Date of Birth")
                )
              )
            ),
            .single(
              .init(
                collapsed: ListItemData(
                  mainText: .custom("Greece"),
                  overlineText: .custom("Resident")
                )
              )
            )
          ]
        )
      )
    ]
  }
}

extension RequestDataUiModel {

  public static func items(
    for docElements: [DocElementsViewModel],
    walletKitController: WalletKitController
  ) -> [RequestDataUiModel] {
    var requestDataCell = [RequestDataUiModel]()

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

      let dataRows = (dataFields + (verificationFields ?? [])).sorted { $0.claim.title.lowercased() < $1.claim.title.lowercased() }

      guard !dataFields.isEmpty || verificationFields != nil else {
        continue
      }

      let data = RequestDataUiModel(
        requestDataRow: dataRows,
        requestDataSection: .init(
          id: docElement.id,
          title: docElement.displayName.orEmpty,
          listItems: dataRows.toListItems()
        )
      )

      requestDataCell.append(data)
    }

    return requestDataCell
  }

  fileprivate static func documentSelectiveDisclosableFields(
    for docElements: [ElementViewModel],
    with docElement: DocElementsViewModel,
    walletKitController: WalletKitController
  ) -> [RequestDataRow] {
    docElements
      .filter { element in
        let mandatoryKeys = walletKitController.mandatoryFields(for: .init(rawValue: docElement.docType))
        return !mandatoryKeys.contains(element.elementPath.joined(separator: "."))
      }
      .map { element in
        let elementIdentifier = element.elementPath.joined(separator: ".")
        return RequestDataRow(
          id: "\(elementIdentifier)_\(docElement.id)",
          claim: walletKitController.valueForElementIdentifier(
            with: docElement.id,
            elementIdentifier: elementIdentifier,
            isMandatory: false,
            parser: {
              Locale.current.localizedDateTime(
                date: $0,
                uiFormatter: "dd MMM yyyy"
              )
            }
          )
        )
      }
  }

  fileprivate static func documentMandatoryVerificationFields(
    for docElements: [ElementViewModel],
    with docElement: DocElementsViewModel,
    walletKitController: WalletKitController
  ) -> [RequestDataRow]? {
    let mandatoryFields = docElements
      .filter { element in
        let mandatoryKeys = walletKitController.mandatoryFields(for: .init(rawValue: docElement.docType))
        return mandatoryKeys.contains(element.elementPath.joined(separator: "."))
      }
      .map { element in
        let elementIdentifier = element.elementPath.joined(separator: ".")
        return RequestDataRow(
          id: "\(elementIdentifier)_\(docElement.id)",
          claim: walletKitController.valueForElementIdentifier(
            with: docElement.id,
            elementIdentifier: elementIdentifier,
            isMandatory: true,
            parser: {
              Locale.current.localizedDateTime(
                date: $0,
                uiFormatter: "dd MMM yyyy"
              )
            }
          )
        )
      }

    guard !mandatoryFields.isEmpty else {
      return nil
    }

    return mandatoryFields
  }
}
