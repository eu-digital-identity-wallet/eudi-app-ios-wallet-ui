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
import logic_core

public struct AddDocumentUIModel: Identifiable, Sendable, Equatable {

  public let id: String
  public let listItem: ListItemData
  public let configId: String
  public let docTypeIdentifier: DocumentTypeIdentifier
  public var isEnabled: Bool
  public var isLoading: Bool

  public init(
    listItem: ListItemData,
    isEnabled: Bool,
    isLoading: Bool = false,
    configId: String,
    docTypeIdentifier: DocumentTypeIdentifier
  ) {
    self.id = UUID().uuidString
    self.isEnabled = isEnabled
    self.listItem = listItem
    self.isLoading = isLoading
    self.configId = configId
    self.docTypeIdentifier = docTypeIdentifier
  }
}

public extension AddDocumentUIModel {
  static var mocks: [AddDocumentUIModel] {
    [
      .init(
        listItem: .init(
          mainContent: .text(.custom("Document name 1"))
        ),
        isEnabled: true,
        isLoading: true,
        configId: "id",
        docTypeIdentifier: .mDocPid
      ),
      .init(
        listItem: .init(
          mainContent: .text(.custom("Document name 2"))
        ),
        isEnabled: true,
        isLoading: true,
        configId: "id",
        docTypeIdentifier: .mDocPid
      ),
      .init(
        listItem: .init(
          mainContent: .text(.custom("Document name 3"))
        ),
        isEnabled: true,
        isLoading: true,
        configId: "id",
        docTypeIdentifier: .mDocPid
      ),
      .init(
        listItem: .init(
          mainContent: .text(.custom("Document name 4"))
        ),
        isEnabled: true,
        isLoading: true,
        configId: "id",
        docTypeIdentifier: .mDocPid
      )
    ]
  }
}
