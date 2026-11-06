/*
 * Copyright (c) 2026 European Commission
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
import logic_storage

extension RevokedDocumentStorageController {
  /// The revocation record of every document that has one. An empty store gives an empty result; any
  /// other failed read throws, so that a caller never mistakes it for "nothing is revoked".
  func retrieveRevocationStatuses() async throws -> [String: DocumentRevocationStatus] {
    let records: [RevokedDocument]
    do {
      records = try await retrieveAll()
    } catch logic_storage.StorageError.itemsNotFound {
      return [:]
    }
    return Dictionary(
      records.map { ($0.identifier, $0.revocationStatus) },
      uniquingKeysWith: { first, _ in first }
    )
  }
}
