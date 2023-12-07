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
import logic_business

public struct AddDocumentCellModel: Identifiable {

  public let id: String
  public let isEnabled: Bool
  public let documentName: LocalizableString.Key
  public let image: Image
  public let isLoading: Bool
  public let type: DocumentIdentifier

  public init(
    isEnabled: Bool,
    documentName: LocalizableString.Key,
    image: Image,
    isLoading: Bool = false,
    type: DocumentIdentifier
  ) {
    self.id = UUID().uuidString
    self.isEnabled = isEnabled
    self.documentName = documentName
    self.image = image
    self.isLoading = isLoading
    self.type = type
  }

}

public extension AddDocumentCellModel {

  static var mocks: [AddDocumentCellModel] {
    [
      .init(
        isEnabled: true,
        documentName: .pid,
        image: Theme.shared.image.idStroke,
        type: .EuPidDocType
      ),
      .init(
        isEnabled: false,
        documentName: .mdl,
        image: Theme.shared.image.id,
        type: .IsoMdlModel
      )
    ]
  }

  static func mock() -> AddDocumentCellModel {
    .init(isEnabled: true, documentName: .pid, image: Theme.shared.image.id, type: .EuPidDocType)
  }
}
