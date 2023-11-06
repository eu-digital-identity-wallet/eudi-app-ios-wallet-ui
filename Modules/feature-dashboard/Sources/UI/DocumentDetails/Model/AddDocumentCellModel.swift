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

import SwiftUI
import logic_resources

public struct AddDocumentCellModel: Identifiable {
  public let id: String
  public let value: Value

  public init(value: Value) {
    self.id = UUID().uuidString
    self.value = value
  }
}

public extension AddDocumentCellModel {
  struct Value {
    internal init(
      isEnabled: Bool,
      documentName: LocalizableString.Key,
      image: Image,
      action: @escaping () -> Void
    ) {
      self.id = UUID().uuidString
      self.isEnabled = isEnabled
      self.documentName = documentName
      self.image = image
      self.action = action
    }

    public let id: String
    public let isEnabled: Bool
    public let documentName: LocalizableString.Key
    public let image: Image
    public let action: () -> Void

  }

  static func mock() -> AddDocumentCellModel {
    .init(value: .init(isEnabled: true, documentName: .pid, image: Theme.shared.image.id, action: {}))
  }
}
