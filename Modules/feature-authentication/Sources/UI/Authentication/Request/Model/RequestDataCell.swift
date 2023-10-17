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

protocol RequestDataCell: Identifiable {
  var id: String { get }
}

struct RequestDataRow: RequestDataCell {

  let title: String
  let value: String

  var id: String
  var isSelected: Bool
  var isVisible: Bool

  init(isSelected: Bool, isVisible: Bool, title: String, value: String) {
    self.id = UUID().uuidString
    self.isSelected = isSelected
    self.isVisible = isVisible
    self.title = title
    self.value = value
  }

  mutating func setSelected(_ isSelected: Bool) {
    self.isSelected = isSelected
  }

  mutating func setVisible(_ isVisible: Bool) {
    self.isVisible = isVisible
  }
}

struct RequestDataSection: RequestDataCell {

  var id: String
  let type: `Type`
  let title: String

  init(type: `Type`, title: String) {
    self.id = UUID().uuidString
    self.type = type
    self.title = title
  }
}

extension RequestDataSection {
  enum `Type` {
    case id
    case mdl
  }
}
