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
import SwiftData
import Foundation

protocol SwiftDataService: Actor {
  func write<T: PersistentModel & IdentifiableObject>(_ object: T) throws
  func writeAll<T: PersistentModel & IdentifiableObject>(_ objects: [T]) throws
  func read<T: PersistentModel & IdentifiableObject, R>(_ type: T.Type, id: String, map: (T) -> R) throws -> R?
  func readAll<T: PersistentModel & IdentifiableObject, R>(_ type: T.Type, map: (T) -> R) throws -> [R]
  func delete<T: PersistentModel & IdentifiableObject>(_ type: T.Type, id: String) throws
  func deleteAll<T: PersistentModel & IdentifiableObject>(of type: T.Type) throws
}

final actor SwiftDataServiceImpl: SwiftDataService {

  private let container: ModelContainer
  private let context: ModelContext

  init(storageConfig: StorageConfig) {
    do {
      self.container = try ModelContainer(
        for: storageConfig.schemas,
        configurations: storageConfig.modelConfiguration
      )
    } catch {
      fatalError("ModelContainer init failed: \(error)")
    }
    self.context = ModelContext(container)
  }

  func write<T: PersistentModel & IdentifiableObject>(_ object: T) throws {
    context.insert(object)
    try context.save()
  }

  func writeAll<T: PersistentModel & IdentifiableObject>(_ objects: [T]) throws {
    for object in objects { context.insert(object) }
    try context.save()
  }

  func read<T: PersistentModel & IdentifiableObject, R>(_ type: T.Type, id: String, map: (T) -> R) throws -> R? {
    var fd = FetchDescriptor<T>(predicate: #Predicate<T> { $0.identifier == id })
    fd.fetchLimit = 1
    if let found = try context.fetch(fd).first { return map(found) }
    return nil
  }

  func readAll<T: PersistentModel & IdentifiableObject, R>(_ type: T.Type, map: (T) -> R) throws -> [R] {
    try context.fetch(FetchDescriptor<T>()).map(map)
  }

  func delete<T: PersistentModel & IdentifiableObject>(_ type: T.Type, id: String) throws {
    var fd = FetchDescriptor<T>(predicate: #Predicate<T> { $0.identifier == id })
    fd.fetchLimit = 1
    if let object = try context.fetch(fd).first {
      context.delete(object)
      try context.save()
    }
  }

  func deleteAll<T: PersistentModel & IdentifiableObject>(of type: T.Type) throws {
    let results = try context.fetch(FetchDescriptor<T>())
    for result in results { context.delete(result) }
    if !results.isEmpty { try context.save() }
  }
}
