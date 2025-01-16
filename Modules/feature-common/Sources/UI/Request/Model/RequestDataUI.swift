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
import logic_ui

public struct RequestDataUI: Identifiable, Equatable, Sendable, UIModel {
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
  public static func from(models: [RequestDataUIModel]) -> [RequestDataUI] {
    var result = [RequestDataUI]()

    var currentSection: RequestDataSection?
    var currentRows = [RequestDataRow]()
    var currentVerificationRows = [RequestDataRow]()

    for model in models {
      if let section = model.isDataSection {
        // If we encounter a new section, save the current data and reset
        if let previousSection = currentSection, !currentRows.isEmpty {
          result.append(
            RequestDataUI(
              id: previousSection.id,
              requestDataRow: currentRows,
              requestDataSection: previousSection
            )
          )
        }
        currentSection = section
        currentRows = []
        currentVerificationRows = []
      } else if let row = model.isDataRow {
        currentRows.append(row)
      } else if let row = model.isDataVerification {
        currentVerificationRows = row.items
      }
    }

    // Append the last section if it exists
    if let lastSection = currentSection, !currentRows.isEmpty {
      result.append(
        RequestDataUI(
          id: lastSection.id,
          requestDataRow: currentRows,
          requestDataSection: lastSection,
          requestDataVerification: currentVerificationRows
        )
      )
    }

    return result
  }
}

extension RequestDataUI {
  mutating func toggleContentVisibility(isVisible: Bool) {
    // Update visibility for `requestDataRow`
    if var rows = requestDataRow {
      for index in rows.indices {
        rows[index].setVisible(isVisible)
      }
      self = RequestDataUI(
//        id: id,
        requestDataRow: rows,
        requestDataSection: requestDataSection,
        requestDataVerification: requestDataVerification
      )
    }

    // Update visibility for `requestDataVerification`
    if var verificationRows = requestDataVerification {
      for index in verificationRows.indices {
        verificationRows[index].setVisible(isVisible)
      }
      self = RequestDataUI(
//        id: id,
        requestDataRow: requestDataRow,
        requestDataSection: requestDataSection,
        requestDataVerification: verificationRows
      )
    }
  }

  mutating func toggleSelection(id: String) {
    // Update visibility for `requestDataRow`
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

    // Update visibility for `requestDataVerification`
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
          return true // Disabled rows are considered selected
        }
        return row.isSelected
      } ?? true // Default to true if `requestDataRow` is nil

      let allVerificationRowsSelected = requestDataUI.requestDataVerification?.allSatisfy { row in
        if !row.isEnabled {
          return true // Disabled rows are considered selected
        }
        return row.isSelected
      } ?? true // Default to true if `requestDataVerification` is nil

      return allRowsSelected && allVerificationRowsSelected
    }
  }
}

public extension Array where Element == RequestDataUI {

  func filterSelectedRows() -> [RequestDataUI] {
    self.map { ui in
      var filteredUI = ui
      filteredUI.requestDataRow = ui.requestDataRow?.filter { $0.isSelected }
      return filteredUI
    }
  }

  func toModels() -> [RequestDataUIModel] {
    var result = [RequestDataUIModel]()

    for data in self {
      result.append(.requestDataSection(data.requestDataSection))
      if let rows = data.requestDataRow {
        result.append(contentsOf: rows.map { .requestDataRow($0) })
      }
      if let verificationRows = data.requestDataVerification {
        let verificationModel = RequestDataVerification(title: "", items: verificationRows)
        result.append(.requestDataVerification(verificationModel))
      }
    }

    return result
  }

  func canShare() -> Bool {
    // Check if there are any selected verification items
    let hasVerificationItems = !self.compactMap { ui in
      ui.requestDataVerification?.first(where: { $0.isSelected })
    }.isEmpty

    // Filter only data row items that are enabled
    let onlyDataRowItems: [RequestDataRow] = self.compactMap { ui in
      ui.requestDataRow?.filter { $0.isEnabled }
    }.flatMap { $0 } // Flatten to get a single array of rows

    // Check if any of the data row items are selected
    let canShareDataRows = !onlyDataRowItems.map { $0.isSelected }
      .filter { $0 }
      .isEmpty

    // Combine the conditions
    return hasVerificationItems || canShareDataRows
  }
}
