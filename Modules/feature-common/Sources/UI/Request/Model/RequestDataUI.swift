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
  public var requestDataRow: [RequestDataRow]?
  public var requestDataSection: RequestDataSection
  public var requestDataVerification: [RequestDataRow]?

  public init(
    id: String = UUID().uuidString,
    requestDataRow: [RequestDataRow]? = nil,
    requestDataSection: RequestDataSection,
    requestDataVerification: [RequestDataRow]? = nil
  ) {
    self.id = id
    self.requestDataRow = requestDataRow
    self.requestDataSection = requestDataSection
    self.requestDataVerification = requestDataVerification
  }
}

extension RequestDataUI {
  mutating func toggleContentVisibility(isVisible: Bool) {
    if var rows = requestDataRow {
      for index in rows.indices {
        rows[index].setVisible(isVisible)
      }
      self = RequestDataUI(
        requestDataRow: rows,
        requestDataSection: requestDataSection,
        requestDataVerification: requestDataVerification
      )
    }

    if var verificationRows = requestDataVerification {
      for index in verificationRows.indices {
        verificationRows[index].setVisible(isVisible)
      }
      self = RequestDataUI(
        requestDataRow: requestDataRow,
        requestDataSection: requestDataSection,
        requestDataVerification: verificationRows
      )
    }
  }

  mutating func toggleSelection(id: String) {
    if var rows = requestDataRow {
      for index in rows.indices {
        if rows[index].id == id {
          rows[index].setSelected(!rows[index].isSelected)
        }
      }
      self = RequestDataUI(
        id: self.requestDataSection.id,
        requestDataRow: rows,
        requestDataSection: requestDataSection,
        requestDataVerification: requestDataVerification
      )
    }

    if var verificationRows = requestDataVerification {
      for index in verificationRows.indices {
        if verificationRows[index].id == id {
          verificationRows[index].setSelected(!verificationRows[index].isSelected)
        }
      }
      self = RequestDataUI(
        id: self.requestDataSection.id,
        requestDataRow: requestDataRow,
        requestDataSection: requestDataSection,
        requestDataVerification: verificationRows
      )
    }
  }
}

public extension Array where Element == RequestDataUI {
  func areAllItemsSelected() -> Bool {
    return self.allSatisfy { requestDataUI in
      let allRowsSelected = requestDataUI.requestDataRow?.allSatisfy { row in
        if !row.isEnabled {
          return true
        }
        return row.isSelected
      } ?? true

      let allVerificationRowsSelected = requestDataUI.requestDataVerification?.allSatisfy { row in
        if !row.isEnabled {
          return true
        }
        return row.isSelected
      } ?? true

      return allRowsSelected && allVerificationRowsSelected
    }
  }

  func filterSelectedRows() -> [RequestDataUI] {
    self.map { ui in
      var filteredUI = ui
      filteredUI.requestDataRow = ui.requestDataRow?.filter { $0.isSelected }
      return filteredUI
    }
  }

  func canShare() -> Bool {
    let hasVerificationItems = !self.compactMap { ui in
      ui.requestDataVerification?.first(where: { $0.isSelected })
    }.isEmpty

    let onlyDataRowItems: [RequestDataRow] = self.compactMap { ui in
      ui.requestDataRow?.filter { $0.isEnabled }
    }.flatMap { $0 } // Flatten to get a single array of rows

    let canShareDataRows = !onlyDataRowItems.map { $0.isSelected }
      .filter { $0 }
      .isEmpty

    return hasVerificationItems || canShareDataRows
  }
}
