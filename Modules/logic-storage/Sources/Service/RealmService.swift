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
import Foundation

actor RealmService {

  private let realm: Realm

  init(_ config: Realm.Configuration) async throws {
    realm = try await Realm.open(configuration: config)
  }

  func write<T: Object>(_ object: T) async throws {
    try await realm.asyncWrite {
      realm.add(object, update: .modified)
    }
  }

  func writeAll<T: Object>(_ objects: [T]) async throws {
    try await realm.asyncWrite {
      realm.add(objects, update: .modified)
    }
  }

  func read<T: Object, R: Sendable>(_ type: T.Type, id: String, map: (T) -> R) async throws -> R? {
    guard let obj = realm.object(ofType: type, forPrimaryKey: id) else {
      return nil
    }
    return map(obj)
  }

  func readAll<T: Object, R: Sendable>(_ type: T.Type, map: (T) -> R) async throws -> [R] {
    let items = Array(realm.objects(type))
    return items.map(map)
  }

  func delete<T: Object>(_ type: T.Type, id: String) async throws {
    try await realm.asyncWrite {
      if let value = realm.object(ofType: type, forPrimaryKey: id) {
        realm.delete(value)
      }
    }
  }

  func deleteAll<T: Object>(of type: T.Type) async throws {
    try await realm.asyncWrite {
      let all = realm.objects(type)
      if !all.isEmpty {
        realm.delete(all)
      }
    }
  }

  func close() {
    realm.invalidate()
  }
}
