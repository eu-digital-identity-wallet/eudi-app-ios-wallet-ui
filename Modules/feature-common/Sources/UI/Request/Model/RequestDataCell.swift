/*
 * Copyright (c) 2023 European Commission
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import Foundation
import SwiftUI

public protocol RequestDataCell: Identifiable {
  var id: String { get }
}

public struct RequestDataRow: RequestDataCell {

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

public struct RequestDataSection: RequestDataCell {

  public var id: String
  public let type: `Type`
  public let title: String

  public init(type: `Type`, title: String) {
    self.id = UUID().uuidString
    self.type = type
    self.title = title
  }
}

public struct RequestDataVerification: RequestDataCell {

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
  public static func mock() -> [any RequestDataCell] {
    [
      RequestDataSection(type: .id, title: "Digital ID"),
      RequestDataRow(isSelected: true, isVisible: false, title: "Family Name", value: "Tzouvaras"),
      RequestDataRow(isSelected: true, isVisible: false, title: "First Name", value: "Stilianos"),
      RequestDataRow(isSelected: true, isVisible: false, title: "Date of Birth", value: "21-09-1985"),
      RequestDataRow(isSelected: true, isVisible: false, title: "Resident Country", value: "Greece"),
      RequestDataVerification(
        title: "Verification data",
        items: [
          RequestDataRow(isSelected: true, isVisible: false, title: "Family Name", value: "Tzouvaras"),
          RequestDataRow(isSelected: true, isVisible: false, title: "First Name", value: "Stilianos"),
          RequestDataRow(isSelected: true, isVisible: false, title: "Date of Birth", value: "21-09-1985"),
          RequestDataRow(isSelected: true, isVisible: false, title: "Resident Country", value: "Greece")
        ]
      )
    ]
  }
}
