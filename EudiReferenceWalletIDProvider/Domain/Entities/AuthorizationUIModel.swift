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
import logic_ui
import logic_resources

struct AuthorizationUIModel: Sendable {
  let issuerName: String
  let document: [AuthorizationUIDocument]
}

typealias AuthorizationListItemSection = ListItemSection<AuthorizationUIRequestedElement>

struct AuthorizationUIRequestItem: Sendable, Identifiable {
  let id: String
  let section: AuthorizationListItemSection

  init(
    id: String = UUID().uuidString,
    section: AuthorizationListItemSection
  ) {
    self.id = id
    self.section = section
  }
}

struct AuthorizationUIDocument: Sendable, Identifiable, Hashable {
  let id: String
  let name: String
  let requestedElements: [AuthorizationUIRequestedElement]

  init(
    id: String = UUID().uuidString,
    name: String,
    requestedElements: [AuthorizationUIRequestedElement] = []
  ) {
    self.id = id
    self.name = name
    self.requestedElements = requestedElements
  }
}

struct AuthorizationUIRequestedElement: Sendable, Hashable {
  let namespace: String
  let elementKey: String
}

extension Array where Element == AuthorizationUIDocument {
  func toRequestItems() -> [AuthorizationUIRequestItem] {
    self.map { document in
      let listItems: [ExpandableListItem<AuthorizationUIRequestedElement>] = document.requestedElements.map { element in
        .single(
          .init(
            collapsed: .init(
              mainContent: .text(.custom(element.elementKey))
            ),
            domainModel: element
          )
        )
      }

      return AuthorizationUIRequestItem(
        id: document.id,
        section: .init(
          id: document.id,
          title: document.name,
          listItems: listItems
        )
      )
    }
  }
}
