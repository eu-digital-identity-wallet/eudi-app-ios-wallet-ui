/*
 * Copyright (c) 2026 European Commission
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
  public let transactionData: [PresentationListItemSection]

  public var log: String {
    "id: \(section.id), title: \(section.title)"
  }

  public init(
    id: String = UUID().uuidString,
    section: PresentationListItemSection,
    transactionData: [PresentationListItemSection] = []
  ) {
    self.id = id
    self.section = section
    self.transactionData = transactionData
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
            newList.append($0)
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
            return path
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
        var nameSpaceDict = partialResult.items[documentId, default: [nameSpace: [requestItem]]]
        nameSpaceDict[nameSpace, default: [requestItem]].appendIfNotExists(requestItem)
        partialResult.items[documentId] = nameSpaceDict
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
          let row = PresentationExpandableListItem.single(
            item.copy(collapsed: item.collapsed.copy(supportingText: nil))
          )
          switch item.collapsed.trailingContent {
          case .checkbox(_, let isSelected, _):
            if isSelected {
              newList.append(row)
            }
          default:
            newList.append(row)
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

    let checkboxSelections = listItems.compactMap { item -> Bool? in
      if case .checkbox(_, let isSelected, _) = item.collapsed.trailingContent {
        return isSelected
      }
      return nil
    }

    if checkboxSelections.isEmpty {
      return !listItems.isEmpty
    }
    return checkboxSelections.contains(true)
  }

  func hasSelectableClaims() -> Bool {

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

    return listItems.contains { item in
      if case .checkbox = item.collapsed.trailingContent { return true }
      return false
    }
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
                  mainContent: .text(.custom("Tzouvaras")),
                  overlineText: .custom("Family Name")
                ),
                domainModel: nil
              )
            ),
            .single(
              .init(
                collapsed: ListItemData(
                  mainContent: .text(.custom("Stilianos")),
                  overlineText: .custom("First Name")
                ),
                domainModel: nil
              )
            ),
            .single(
              .init(
                collapsed: ListItemData(
                  mainContent: .text(.custom("21-09-1985")),
                  overlineText: .custom("Date of Birth")
                ),
                domainModel: nil
              )
            ),
            .single(
              .init(
                collapsed: ListItemData(
                  mainContent: .text(.custom("Greece")),
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
  /// - Parameter claimsAreSelectable: When `true` each claim row gets a checkbox so the user picks
  ///   what to disclose (proximity). When `false` rows are read-only and the whole set is disclosed
  ///   (presentation, where selection happens at the combination level).
  func toUiModels(
    with walletKitController: WalletKitController,
    claimsAreSelectable: Bool = true,
    overaskedPaths: [String: Set<[String]>] = [:],
    transactionData: [String: [PresentationTransactionData]] = [:]
  ) -> [RequestDataUiModel] {
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

      let overaskedPathsForDocument = overaskedPaths[element.docId] ?? []

      return .init(
        section: .init(
          id: element.docId,
          title: title,
          listItems: dataRows.toListItems(
            claimsAreSelectable: claimsAreSelectable,
            overaskedPaths: overaskedPathsForDocument
          )
        ),
        transactionData: (transactionData[element.docId] ?? []).map { $0.toListItemSection() }
      )
    }
  }
}

private extension PresentationTransactionData {
  func toListItemSection() -> PresentationListItemSection {
    .init(
      id: UUID().uuidString,
      title: type,
      listItems: [.transactionDataRow(overline: .requestTransactionDataType, value: typeName)] + contentListItems
    )
  }

  var typeName: String {
    switch content {
    case .qesApproval:
      LocalizableStringKey.requestTransactionDataTypeQes.toString
    case .generic:
      type
    }
  }

  var contentListItems: [PresentationExpandableListItem] {
    switch content {
    case .qesApproval(let qesApproval):
      qesApproval.toListItems()
    case .generic(let fields):
      fields.map { $0.toExpandableListItem() }
    }
  }
}

private extension QesApprovalTransactionData {
  func toListItems() -> [PresentationExpandableListItem] {
    var items: [PresentationExpandableListItem] = [
      .transactionDataRow(overline: .requestTransactionDataTrustFramework, value: trustFramework)
    ]

    documents.forEach { document in
      if let label = document.label {
        items.append(.transactionDataRow(overline: .requestTransactionDataDocument, value: label))
      }
      items.append(
        .transactionDataRow(
          overline: .requestTransactionDataHash,
          value: document.hash,
          supportingText: document.hashType?.uppercased()
        )
      )
    }

    if let hashAlgorithm {
      items.append(.transactionDataRow(overline: .requestTransactionDataHashAlgorithm, value: hashAlgorithm))
    }

    if let numberOfSignatures {
      items.append(
        .transactionDataRow(overline: .requestTransactionDataNumberOfSignatures, value: String(numberOfSignatures))
      )
    }

    return items
  }
}

private extension ExpandableListItem where T == DocumentElementClaim {
  static func transactionDataRow(
    overline: LocalizableStringKey,
    value: String,
    supportingText: String? = nil
  ) -> Self {
    .single(
      .init(
        collapsed: .init(
          mainContent: .text(.custom(value)),
          overlineText: overline,
          supportingText: supportingText.map { .custom($0) }
        ),
        domainModel: nil
      )
    )
  }
}

private extension PresentationTransactionDataField {
  func toExpandableListItem() -> PresentationExpandableListItem {
    switch value {
    case .text(let text):
      .transactionDataRow(overline: .custom(key), value: text)
    case .group(let fields):
      .nested(
        .init(
          collapsed: .init(mainContent: .text(.custom(key))),
          expanded: fields.map { $0.toExpandableListItem() },
          isExpanded: false
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

  func toListItems(
    claimsAreSelectable: Bool,
    overaskedPaths: Set<[String]>
  ) -> [PresentationExpandableListItem] {
    self.compactMap {
      $0.toListItem(claimsAreSelectable: claimsAreSelectable, overaskedPaths: overaskedPaths)
    }
  }
}

private extension DocumentElementClaim {
  func toListItem(
    claimsAreSelectable: Bool,
    overaskedPaths: Set<[String]>
  ) -> PresentationExpandableListItem? {
    return self.toExpandableListItem(
      claimsAreSelectable: claimsAreSelectable,
      overaskedPaths: overaskedPaths
    )
  }
}

private extension DocumentElementClaim {
  func toExpandableListItem(
    claimsAreSelectable: Bool,
    overaskedPaths: Set<[String]>
  ) -> PresentationExpandableListItem? {
    switch self {
    case .group(let id, let title, let items):
      return .nested(
        .init(
          collapsed: .init(groupId: id, mainContent: .text(.custom(title))),
          expanded: items.compactMap {
            $0.toExpandableListItem(
              claimsAreSelectable: claimsAreSelectable,
              overaskedPaths: overaskedPaths
            )
          },
          isExpanded: false
        )
      )
    case .primitive(
      let id,
      let title,
      _,
      _,
      let claimPath,
      _,
      let value,
      let status
    ):
      let isOverasked = overaskedPaths.contains(claimPath)
      let trailingContent: TrailingContent = claimsAreSelectable
        ? .checkbox(!status.isRequired && status.isAvailable, status.isAvailable, { _ in })
        : .empty
      switch value {
      case .string(let value):
        return .single(
          .init(
            collapsed: .init(
              groupId: id,
              mainContent: .text(.custom(value)),
              overlineText: .custom(title),
              supportingText: isOverasked ? .notRegisteredData : nil,
              supportingTextColor: isOverasked ? Theme.shared.color.warning : Theme.shared.color.secondaryLabel,
              isEnable: !status.isRequired,
              trailingContent: trailingContent
            ),
            domainModel: self
          )
        )
      case .image(let image):
        if path?.last == DocumentJsonKeys.SIGNATURE {
          return .single(
            .init(
              collapsed: .init(
                groupId: id,
                mainContent: .image(image),
                overlineText: .custom(title),
                supportingText: isOverasked ? .notRegisteredData : nil,
                supportingTextColor: isOverasked ? Theme.shared.color.warning : Theme.shared.color.secondaryLabel,
                isEnable: !status.isRequired,
                trailingContent: trailingContent
              ),
              domainModel: self
            )
          )
        } else {
          return .single(
            .init(
              collapsed: .init(
                groupId: id,
                mainContent: .text(.custom(title)),
                supportingText: isOverasked ? .notRegisteredData : nil,
                supportingTextColor: isOverasked ? Theme.shared.color.warning : Theme.shared.color.secondaryLabel,
                leadingContent: .remoteImage(image: image),
                isEnable: !status.isRequired,
                trailingContent: trailingContent
              ),
              domainModel: self
            )
          )
        }
      case .unavailable:
        return nil
      }
    }
  }
}
