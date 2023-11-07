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
import logic_ui
import logic_resources

public protocol AddDocumentInteractorType {
 func fetchStoredDocuments() -> StoredDocumentsPartialState
}

public final class AddDocumentInteractor: AddDocumentInteractorType {

  public init() {}

  public func fetchStoredDocuments() -> StoredDocumentsPartialState {
    // Add Some logic from walletCore about active documents in storage.
    // Filter the ones we can add, currently Dummy
    return .success([
      .init(
        isEnabled: true,
        documentName: .pid,
        image: Theme.shared.image.idStroke,
        type: .pid
      ),
      .init(
        isEnabled: false,
        documentName: LocalizableString.Key.mdl,
        image: Theme.shared.image.id,
        type: .mdl
      )
    ])
  }
}

public enum StoredDocumentsPartialState {
  case success([AddDocumentCellModel])
  case failure(Error)
}
