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

public typealias PresentationListItemSection = ListItemSection<DocumentElementClaim>
private typealias PresentationExpandableListItem = ExpandableListItem<DocumentElementClaim>

@Copyable
public struct RequestDataUiModel: Identifiable, Equatable, Sendable, Routable {

  public let id: String
  public let section: PresentationListItemSection

  public var log: String {
    "id: \(id), title: \(section.title)"
  }

  public init(
    id: String = UUID().uuidString,
    section: PresentationListItemSection
  ) {
    self.id = id
    self.section = section
  }
}

extension RequestDataUiModel {
  mutating func toggleSelection(id: String) {

    @discardableResult
    func findSelection(id: String, listItems: inout [PresentationExpandableListItem]) -> [PresentationExpandableListItem] {
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

    var listItems = section.listItems

    findSelection(id: id, listItems: &listItems)

    self = self.copy(
      section: self.section.copy(listItems: listItems)
    )
  }
}

public extension Array where Element == RequestDataUiModel {

  // MARK: - TODO FIX RESPONSE PREPARATION
  func prepareRequest() -> RequestItemsWrapper {

    func flatSelectedValues(
      currentList: [PresentationExpandableListItem],
      newList: inout [PresentationExpandableListItem]
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
          flatSelectedValues(currentList: item.expanded, newList: &newList)
        }
      }
    }

    var models: [RequestDataUiModel] = []

    self.forEach { model in

      var expandableList: [PresentationExpandableListItem] = []

      flatSelectedValues(currentList: model.section.listItems, newList: &expandableList)

      if !expandableList.isEmpty {
        models.append(
          model.copy(
            section: .init(
              id: model.section.id,
              title: model.section.title,
              listItems: expandableList.filter {
                $0.domainModel != nil
              }
            )
          )
        )
      }
    }

    let requestConvertible = models
      .reduce(into: [ExpandableListItem]()) { partialResult, document in
        partialResult.append(contentsOf: document.section.listItems)
      }
      .reduce(into: RequestItemsWrapper()) {  partialResult, claim in

        var path: [String] {
          claim.domainModel?.path ?? []
        }

        var documentId: String {
          claim.domainModel?.documentId ?? ""
        }

        var nameSpace: String {
          claim.domainModel?.nameSpace ?? ""
        }

        let requestItem: RequestItem = .init(elementPath: path)
        var nameSpaceDict = partialResult.requestItems[documentId, default: [nameSpace: [requestItem]]]
        nameSpaceDict[nameSpace, default: [requestItem]].appendIfNotExists(requestItem)
        partialResult.requestItems[documentId] = nameSpaceDict
      }

    return requestConvertible
  }

  func filterSelectedRows() -> [PresentationListItemSection] {

    func filterSelection(
      currentList: [PresentationExpandableListItem],
      newList: inout [PresentationExpandableListItem]
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
          var children: [PresentationExpandableListItem] = []
          filterSelection(currentList: item.expanded, newList: &children)
          if !children.isEmpty {
            newList[groupPosition] = .nested(
              .init(
                id: item.id,
                collapsed: item.collapsed,
                expanded: children,
                isExpanded: item.isExpanded
              )
            )
          } else {
            newList.remove(at: groupPosition)
          }
        }
      }
    }

    var sections: [PresentationListItemSection] = []

    self.forEach { model in

      var expandableList: [PresentationExpandableListItem] = []

      filterSelection(currentList: model.section.listItems, newList: &expandableList)

      if !expandableList.isEmpty {
        sections.append(
          .init(
            id: model.section.id,
            title: model.section.title,
            listItems: expandableList
          )
        )
      }
    }

    return sections
  }

  func canShare() -> Bool {

    func getAllSingleItems(
      all: [PresentationExpandableListItem],
      result: inout [PresentationExpandableListItem.SingleListItemData]
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

    var listItems: [PresentationExpandableListItem.SingleListItemData] = []
    self.forEach {
      getAllSingleItems(all: $0.section.listItems, result: &listItems)
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
        section: .init(
          id: UUID().uuidString,
          title: "MDL",
          listItems: [
            .single(
              .init(
                collapsed: ListItemData(
                  mainText: .custom("Tzouvaras"),
                  overlineText: .custom("Family Name")
                ),
                domainModel: nil
              )
            ),
            .single(
              .init(
                collapsed: ListItemData(
                  mainText: .custom("Stilianos"),
                  overlineText: .custom("First Name")
                ),
                domainModel: nil
              )
            ),
            .single(
              .init(
                collapsed: ListItemData(
                  mainText: .custom("21-09-1985"),
                  overlineText: .custom("Date of Birth")
                ),
                domainModel: nil
              )
            ),
            .single(
              .init(
                collapsed: ListItemData(
                  mainText: .custom("Greece"),
                  overlineText: .custom("Resident")
                ),
                domainModel: nil
              )
            )
          ]
        )
      )
    ]
  }
}

public extension Array where Element == DocElementsViewModel {

  private func selectiveDisclosableFields(
    for docElements: [ElementViewModel],
    with docElement: DocElementsViewModel,
    walletKitController: WalletKitController
  ) -> [DocumentElementClaim] {
    docElements
      .map { element in
        let elementIdentifier = element.elementPath.joined(separator: ".")
        return walletKitController.valueForElementIdentifier(
          with: docElement.id,
          elementIdentifier: elementIdentifier,
          nameSpace: element.nameSpace,
          parser: {
            Locale.current.localizedDateTime(
              date: $0,
              uiFormatter: "dd MMM yyyy"
            )
          }
        )
      }
  }

  func toUiModels(with walletKitController: WalletKitController) -> [RequestDataUiModel] {
    self.compactMap { docElement in

      let dataFields = selectiveDisclosableFields(
        for: docElement.elements,
        with: docElement,
        walletKitController: walletKitController
      )

      let dataRows = dataFields.sorted { $0.title.lowercased() < $1.title.lowercased() }

      guard !dataFields.isEmpty else {
        return nil
      }

      return .init(
        section: .init(
          id: docElement.id,
          title: docElement.displayName.orEmpty,
          listItems: dataRows.toListItems()
        )
      )
    }
  }
}

private extension Array where Element == DocumentElementClaim {
  func toListItems() -> [PresentationExpandableListItem] {
    self.compactMap { $0.toListItem() }
  }
}

private extension DocumentElementClaim {
  func toListItem() -> PresentationExpandableListItem? {
    return self.toExpandableListItem()
  }
}

private extension DocumentElementClaim {
  func toExpandableListItem() -> PresentationExpandableListItem? {
    switch self {
    case .group(let id, let title, let items):
      return .nested(
        .init(
          id: id,
          collapsed: .init(mainText: .custom(title)),
          expanded: items.compactMap { $0.toExpandableListItem() },
          isExpanded: false
        )
      )
    case .primitive(
      let id,
      let title,
      _,
      _,
      _,
      let value,
      let status
    ):
      switch value {
      case .string(let value):
        return .single(
          .init(
            id: id,
            collapsed: .init(
              mainText: .custom(value),
              overlineText: .custom(title),
              isEnable: !status.isRequired,
              trailingContent: .checkbox(
                !status.isRequired && status.isAvailable,
                status.isAvailable,
                { _ in }
              )
            ),
            domainModel: self
          )
        )
      case .image(let image):
        return .single(
          .init(
            id: id,
            collapsed: .init(
              mainText: .custom(title),
              leadingIcon: .init(image: image),
              isEnable: !status.isRequired,
              trailingContent: .checkbox(
                !status.isRequired && status.isAvailable,
                status.isAvailable,
                { _ in }
              )
            ),
            domainModel: self
          )
        )
      case .unavailable:
        return nil
      }
    }
  }
}
