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
import logic_resources
import logic_core

public struct AddDocumentUIModel: Identifiable, Sendable {

  public let id: String
  public let documentName: LocalizableString.Key
  public let image: Image?
  public let configId: String
  public var isEnabled: Bool
  public var isLoading: Bool

  public init(
    isEnabled: Bool,
    documentName: LocalizableString.Key,
    image: Image? = nil,
    isLoading: Bool = false,
    configId: String
  ) {
    self.id = UUID().uuidString
    self.isEnabled = isEnabled
    self.documentName = documentName
    self.image = image
    self.isLoading = isLoading
    self.configId = configId
  }
}

public extension AddDocumentUIModel {
  static var mocks: [AddDocumentUIModel] {
    [
      .init(
        isEnabled: true,
        documentName: .custom("Document name 1"),
        isLoading: true,
        configId: "id"
      ),
      .init(
        isEnabled: true,
        documentName: .custom("Document name 2"),
        isLoading: true,
        configId: "id"
      ),
      .init(
        isEnabled: true,
        documentName: .custom("Document name 3"),
        isLoading: true,
        configId: "id"
      ),
      .init(
        isEnabled: true,
        documentName: .custom("Document name 4"),
        isLoading: true,
        configId: "id"
      )
    ]
  }
}
