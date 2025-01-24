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

public struct RequestDataUI: Identifiable, Equatable, Sendable, Routable {
  public let id: String
  public var requestDataRow: [RequestDataRow]
  public var requestDataSection: RequestDataSection

  public init(
    id: String = UUID().uuidString,
    requestDataRow: [RequestDataRow],
    requestDataSection: RequestDataSection
  ) {
    self.id = id
    self.requestDataRow = requestDataRow
    self.requestDataSection = requestDataSection
  }
}

extension RequestDataUI {
  mutating func toggleSelection(id: String) {
    var rows = requestDataRow

    for index in rows.indices where rows[index].id == id {
      rows[index].setSelected(!rows[index].isSelected)
    }
    self = RequestDataUI(
      id: self.requestDataSection.id,
      requestDataRow: rows,
      requestDataSection: requestDataSection
    )
  }
}

public extension Array where Element == RequestDataUI {
  func filterSelectedRows() -> [RequestDataUI] {
    self.map { ui in
      var filteredUI = ui
      filteredUI.requestDataRow = ui.requestDataRow.filter { $0.isSelected }
      return filteredUI
    }
  }

  func canShare() -> Bool {
    let onlyDataRowItems: [RequestDataRow] = self.compactMap { ui in
      ui.requestDataRow.filter { $0.isEnabled }
    }.flatMap { $0 }

    let canShareDataRows = !onlyDataRowItems.map { $0.isSelected }
      .filter { $0 }
      .isEmpty

    return canShareDataRows
  }
}
