/*
 * Copyright (c) 2025 European Commission
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
public extension Array {

  func removeTrailingContent<T: Sendable>() -> [ListItemSection<T>] where Element == ListItemSection<T> {

    func removeTrailingFromExpandableItems(with items: [ExpandableListItem<T>]) -> [ExpandableListItem<T>] {
      items.map { item in
        return switch item {
        case .single(let item):
          ExpandableListItem<T>.single(
            .init(
              collapsed: item.collapsed.copy(trailingContent: nil),
              domainModel: item.domainModel
            )
          )
        case .nested(let item):
          ExpandableListItem<T>.nested(
            .init(
              collapsed: item.collapsed,
              expanded: removeTrailingFromExpandableItems(with: item.expanded),
              isExpanded: false
            )
          )
        }
      }
    }

    return self.map { section in
      let items = section.listItems.map {
        switch $0 {
        case .single(let item):
          return ExpandableListItem<T>.single(
            .init(
              collapsed: item.collapsed.copy(trailingContent: nil),
              domainModel: item.domainModel
            )
          )
        case .nested(let item):
          return ExpandableListItem<T>.nested(
            .init(
              collapsed: item.collapsed,
              expanded: removeTrailingFromExpandableItems(with: item.expanded),
              isExpanded: false
            )
          )
        }
      }
      return ListItemSection<T>.init(id: section.id, title: section.title, listItems: items)
    }
  }
}
