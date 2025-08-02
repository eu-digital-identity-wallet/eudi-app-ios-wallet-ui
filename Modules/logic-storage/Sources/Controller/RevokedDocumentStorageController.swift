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
import RealmSwift

public protocol RevokedDocumentStorageController: StorageController where Value == RevokedDocument {}

final class RevokedDocumentStorageControllerImpl: RevokedDocumentStorageController {

  private let realmService: RealmService

  init(realmService: RealmService) {
    self.realmService = realmService
  }

  func store(_ value: RevokedDocument) async throws {
    try await realmService.write(value.toRealmRevokedDocument())
  }

  func store(_ values: [RevokedDocument]) async throws {
    try await realmService.writeAll(values.toRealmRevokedDocuments())
  }

  func update(_ value: RevokedDocument) async throws {
    try await realmService.write(value.toRealmRevokedDocument())
  }

  func retrieve(_ identifier: String) async throws -> RevokedDocument {
    let revokedDocument = try await realmService.read(RealmRevokedDocument.self, id: identifier) {
      $0.toRevokedDocument()
    }
    guard let revokedDocument else {
      throw StorageError.itemNotFound
    }
    return revokedDocument
  }

  func retrieveAll() async throws -> [RevokedDocument] {
    let revokedDocuments = try await realmService.readAll(RealmRevokedDocument.self) { $0.toRevokedDocument() }
    guard !revokedDocuments.isEmpty else {
      throw StorageError.itemsNotFound
    }
    return revokedDocuments
  }

  func delete(_ identifier: String) async throws {
    try await realmService.delete(RealmRevokedDocument.self, id: identifier)
  }

  func deleteAll() async throws {
    try await realmService.deleteAll(of: RealmRevokedDocument.self)
  }
}
