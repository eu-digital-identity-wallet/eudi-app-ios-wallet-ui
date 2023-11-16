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

public enum RequestDataCell: Equatable {
  case requestDataRow(RequestDataRow)
  case requestDataSection(RequestDataSection)
  case requestDataVerification(RequestDataVerification)

  var isDataRow: RequestDataRow? {
    switch self {
    case .requestDataRow(let row):
      return row
    default:
      return nil
    }
  }

  var isDataSection: RequestDataSection? {
    switch self {
    case .requestDataSection(let section):
      return section
    default:
      return nil
    }
  }

  var isDataVerification: RequestDataVerification? {
    switch self {
    case .requestDataVerification(let verification):
      return verification
    default:
      return nil
    }
  }
}

public struct RequestDataRow: Identifiable, Equatable {

  public let title: String
  public let value: String

  public var id: String
  public var isSelected: Bool
  public var isVisible: Bool

  public init(isSelected: Bool, isVisible: Bool, title: String, value: String) {
    self.id = UUID().uuidString
    self.isSelected = isSelected
    self.isVisible = isVisible
    self.title = title
    self.value = value
  }

  public mutating func setSelected(_ isSelected: Bool) {
    self.isSelected = isSelected
  }

  public mutating func setVisible(_ isVisible: Bool) {
    self.isVisible = isVisible
  }
}

public struct RequestDataSection: Identifiable, Equatable {

  public var id: String
  public let type: `Type`
  public let title: String

  public init(type: `Type`, title: String) {
    self.id = UUID().uuidString
    self.type = type
    self.title = title
  }
}

public struct RequestDataVerification: Identifiable, Equatable {

  public var id: String
  public let title: String
  public let items: [RequestDataRow]

  public init(title: String, items: [RequestDataRow]) {
    self.id = UUID().uuidString
    self.title = title
    self.items = items
  }
}

public extension RequestDataSection {
  enum `Type` {
    case id
    case mdl
  }
}

public struct RequestDataUiModel {
  public static func mock() -> [RequestDataCell] {
    [
      .requestDataSection(.init(type: .id, title: "Digital ID")),
      .requestDataRow(.init(isSelected: true, isVisible: false, title: "Family Name", value: "Tzouvaras")),
      .requestDataRow(.init(isSelected: true, isVisible: false, title: "First Name", value: "Stilianos")),
      .requestDataRow(.init(isSelected: true, isVisible: false, title: "Date of Birth", value: "21-09-1985")),
      .requestDataRow(.init(isSelected: true, isVisible: false, title: "Resident Country", value: "Greece")),
      .requestDataVerification(
        .init(
          title: "Verification data",
          items: [
            .init(isSelected: true, isVisible: false, title: "Family Name", value: "Tzouvaras"),
            .init(isSelected: true, isVisible: false, title: "First Name", value: "Stilianos"),
            .init(isSelected: true, isVisible: false, title: "Date of Birth", value: "21-09-1985"),
            .init(isSelected: true, isVisible: false, title: "Resident Country", value: "Greece")
          ]
        )
      ),
      .requestDataSection(.init(type: .mdl, title: "MDL")),
      .requestDataRow(.init(isSelected: true, isVisible: false, title: "Family Name", value: "Tzouvaras")),
      .requestDataRow(.init(isSelected: true, isVisible: false, title: "First Name", value: "Stilianos")),
      .requestDataVerification(
        .init(
          title: "Verification data",
          items: [
            .init(isSelected: true, isVisible: false, title: "Date of Birth", value: "21-09-1985"),
            .init(isSelected: true, isVisible: false, title: "Resident Country", value: "Greece")
          ]
        )
      )
    ]
  }
}
