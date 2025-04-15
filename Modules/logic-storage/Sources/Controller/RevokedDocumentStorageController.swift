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
import RealmSwift

public protocol RevokedDocumentStorageController: StorageController where Value == RevokedDocument {}

final class RevokedDocumentStorageControllerImpl: RevokedDocumentStorageController {

  private let realmService: RealmService

  init(realmService: RealmService) {
    self.realmService = realmService
  }

  func store(_ value: RevokedDocument) async throws {
    try await dbAsync {
      let realm = try self.realmService.get()
      let realmValue = value.toRealmRevokedDocument()
      try realm.write {
        realm.add(realmValue, update: .all)
      }
    }
  }

  func store(_ values: [RevokedDocument]) async throws {
    try await dbAsync {
      let realm = try self.realmService.get()
      let realmValues = values.toRealmRevokedDocuments()
      try realm.write {
        realm.add(realmValues, update: .all)
      }
    }
  }

  func update(_ value: RevokedDocument) async throws {
    try await dbAsync {
      let realm = try self.realmService.get()
      let realmValue = value.toRealmRevokedDocument()
      try realm.write {
        realm.add(realmValue, update: .modified)
      }
    }
  }

  func retrieve(_ identifier: String) async throws -> RevokedDocument {
    try await dbAsync {
      let realm = try self.realmService.get()
      guard
        let revokedDocument = realm.object(
          ofType: RealmRevokedDocument.self,
          forPrimaryKey: identifier
        )?.toRevokedDocument()
      else {
        throw StorageError.itemNotFound
      }
      return revokedDocument
    }
  }

  func retrieveAll() async throws -> [RevokedDocument] {
    try await dbAsync {
      let realm = try self.realmService.get()
      let revokedDocuments = realm.objects(RealmRevokedDocument.self)
      guard !revokedDocuments.isEmpty else {
        throw StorageError.itemsNotFound
      }
      return revokedDocuments.toList().toRealmRevokedDocument()
    }
  }

  func delete(_ identifier: String) async throws {
    try await dbAsync {
      let realm = try self.realmService.get()

      guard
        let value = realm.object(
          ofType: RealmRevokedDocument.self,
          forPrimaryKey: identifier
        )
      else {
        return
      }

      try realm.write {
        realm.delete(value)
      }
    }
  }

  func deleteAll() async throws {
    try await dbAsync {
      let realm = try self.realmService.get()
      let values = realm.objects(RealmRevokedDocument.self)
      guard !values.isEmpty else {
        return
      }
      try realm.write {
        realm.delete(values)
      }
    }
  }
}
