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

public struct AddDocumentUIModel: Identifiable {

  public let id: String
  public let documentName: LocalizableString.Key
  public let image: Image
  public let type: DocumentTypeIdentifier
  public var isEnabled: Bool
  public var isLoading: Bool

  public init(
    isEnabled: Bool,
    documentName: LocalizableString.Key,
    image: Image,
    isLoading: Bool = false,
    type: DocumentTypeIdentifier
  ) {
    self.id = UUID().uuidString
    self.isEnabled = isEnabled
    self.documentName = documentName
    self.image = image
    self.isLoading = isLoading
    self.type = type
  }

}

public extension AddDocumentUIModel {

  static var items: [AddDocumentUIModel] {
    [
      .init(
        isEnabled: true,
        documentName: .pid,
        image: Theme.shared.image.id,
        isLoading: false,
        type: .PID
      ),
      .init(
        isEnabled: true,
        documentName: .mdl,
        image: Theme.shared.image.id,
        isLoading: false,
        type: .MDL
      ),
      .init(
        isEnabled: true,
        documentName: .ageVerification,
        image: Theme.shared.image.id,
        isLoading: false,
        type: .AGE
      ),
      .init(
        isEnabled: true,
        documentName: .photoId,
        image: Theme.shared.image.id,
        isLoading: false,
        type: .PHOTOID
      )
    ]
  }

  static var mocks: [AddDocumentUIModel] {
    AddDocumentUIModel.items.map({
        var cell = $0
        cell.isEnabled = true
        cell.isLoading = false
        return cell
      }
    )
  }
}
