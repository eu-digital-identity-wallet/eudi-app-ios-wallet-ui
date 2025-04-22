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

protocol RealmService: Sendable {
  @MainActor func write<T: Object>(_ object: T) async throws
  @MainActor func writeAll<T: Object>(_ objects: [T]) async throws
  @MainActor func read<T: Object, R: Sendable>(_ type: T.Type, id: String, map: (T) -> R) async throws -> R?
  @MainActor func readAll<T: Object, R: Sendable>(_ type: T.Type, map: (T) -> R) async throws -> [R]
  @MainActor func delete<T: Object>(_ type: T.Type, id: String) async throws
  @MainActor func deleteAll<T: Object>(of type: T.Type) async throws
}

final class RealmServiceImpl: RealmService {

  private let storageConfig: StorageConfig

  init(storageConfig: StorageConfig) {
    self.storageConfig = storageConfig
  }

  func write<T: Object>(_ object: T) async throws {
    let realm = try await openRealm()
    try await realm.asyncWrite {
      realm.add(object, update: .modified)
    }
  }

  func writeAll<T: Object>(_ objects: [T]) async throws {
    let realm = try await openRealm()
    try await realm.asyncWrite {
      realm.add(objects, update: .modified)
    }
  }

  func read<T: Object, R: Sendable>(_ type: T.Type, id: String, map: (T) -> R) async throws -> R? {
    let realm = try await openRealm()
    guard let obj = realm.object(ofType: type, forPrimaryKey: id) else {
      return nil
    }
    return map(obj)
  }

  func readAll<T: Object, R: Sendable>(_ type: T.Type, map: (T) -> R) async throws -> [R] {
    let realm = try await openRealm()
    let items = Array(realm.objects(type))
    return items.map(map)
  }

  func delete<T: Object>(_ type: T.Type, id: String) async throws {
    let realm = try await openRealm()
    try await realm.asyncWrite {
      if let value = realm.object(ofType: type, forPrimaryKey: id) {
        realm.delete(value)
      }
    }
  }

  func deleteAll<T: Object>(of type: T.Type) async throws {
    let realm = try await openRealm()
    try await realm.asyncWrite {
      let all = realm.objects(type)
      if !all.isEmpty {
        realm.delete(all)
      }
    }
  }
}

private extension RealmServiceImpl {
  @MainActor
  func openRealm() async throws -> Realm {
    try await Realm.open(configuration: storageConfig.realmConfiguration)
  }
}
