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

  @EquatableNoop
  public var id: String

  public let section: PresentationListItemSection

  public var log: String {
    "id: \(section.id), title: \(section.title)"
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

    func findSelection(id: String, listItems: inout [PresentationExpandableListItem]) {
      for index in listItems.indices {
        switch listItems[index] {
        case .single(let item):

          guard item.collapsed.groupId == id else {
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
          if item.collapsed.groupId == id {
            listItems[index] = .nested(item.copy(isExpanded: !item.isExpanded))
          } else {
            var children = item.expanded
            findSelection(id: id, listItems: &children)
            listItems[index] = .nested(item.copy(expanded: children))
          }
        }
      }
    }

    var listItems = section.listItems

    findSelection(id: id, listItems: &listItems)

    self = self.copy(
      section: self.section.copy(listItems: listItems)
    )
  }
}

public extension Array where Element == RequestDataUiModel {

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
              listItems: expandableList
            )
          )
        )
      }
    }

    let requestConvertible = models
      .reduce(into: [PresentationExpandableListItem]()) { partialResult, document in
        partialResult.append(contentsOf: document.section.listItems)
      }
      .reduce(into: RequestItemsWrapper()) { partialResult, claim in

        var path: [String] {
          switch claim.domainModel?.type {
          case .mdoc:
            guard let path = claim.domainModel?.path, path.count > 1 else {
              return []
            }
            return [path[1]]
          case .sdjwt:
            guard let path = claim.domainModel?.path else {
              return []
            }
            let claimPath = path.compactMap {
              return if !$0.isEmpty {
                $0
              } else {
                nil
              }
            }
            return claimPath
          default:
            return []
          }
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

public extension Array where Element == DocElements {
  func toUiModels(with walletKitController: WalletKitController) -> [RequestDataUiModel] {
    self.compactMap { element in

      var title: String {
        return switch element {
        case .msoMdoc(let msoMdocElements):
          msoMdocElements.displayName.ifNilOrEmpty { msoMdocElements.docType }
        case .sdJwt(let sdJwtElements):
          sdJwtElements.displayName.ifNilOrEmpty { sdJwtElements.vct }
        }
      }

      var type: DocumentElementType {
        return switch element {
        case .msoMdoc:
            .mdoc
        case .sdJwt:
            .sdjwt
        }
      }

      let claims = switch element {
      case .msoMdoc(let doc):
        doc.nameSpacedElements
          .reduce(into: [MsoMdocElement]()) { partialResult, nameSpaceElement in
            partialResult.append(contentsOf: nameSpaceElement.elements)
          }
          .reduce(into: [DocClaim]()) { partialResult, element in
            if let claim = element.docClaim {
              partialResult.append(claim)
            }
          }
      case .sdJwt(let doc):
        doc.sdJwtElements
          .reduce(into: [SdJwtElement]()) { partialResult, sdJwtElement in
            partialResult.append(sdJwtElement)
          }
          .reduce(into: [DocClaim]()) { partialResult, element in
            if let claim = element.docClaim {
              partialResult.append(claim)
            }
          }
      }

      let dataFields = claims.selectiveDisclosableFields(
        id: element.docId,
        type: type,
        walletKitController: walletKitController
      )

      let dataRows = dataFields.sorted { $0.title.lowercased() < $1.title.lowercased() }

      guard !dataFields.isEmpty else {
        return nil
      }

      return .init(
        section: .init(
          id: element.docId,
          title: title,
          listItems: dataRows.toListItems()
        )
      )
    }
  }
}

private extension Array where Element == DocClaim {
  func selectiveDisclosableFields(
    id: String,
    type: DocumentElementType,
    walletKitController: WalletKitController
  ) -> [DocumentElementClaim] {
    self
      .reduce(into: [DocumentElementClaim]()) { partialResult, claim in
        partialResult.append(
          contentsOf: walletKitController.parseDocClaim(
            docId: id,
            groupId: UUID().uuidString,
            docClaim: claim,
            type: type,
            parser: {
              Locale.current.localizedDateTime(
                date: $0,
                uiFormatter: "dd MMM yyyy"
              )
            }
          )
        )
      }.sortByName()
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
          collapsed: .init(groupId: id, mainText: .custom(title)),
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
      _,
      let value,
      let status
    ):
      switch value {
      case .string(let value):
        return .single(
          .init(
            collapsed: .init(
              groupId: id,
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
            collapsed: .init(
              groupId: id,
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
