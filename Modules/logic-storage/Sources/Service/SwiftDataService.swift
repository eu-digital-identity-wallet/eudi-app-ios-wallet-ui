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
import SwiftData
import Foundation

protocol SwiftDataService: Actor {
  func write<T: PersistentModel & IdentifiableObject>(_ object: T) throws
  func writeAll<T: PersistentModel & IdentifiableObject>(_ objects: [T]) throws
  func read<T: PersistentModel & IdentifiableObject, R>(predicate: Predicate<T>, map: (T) -> R) throws -> R?
  func readAll<T: PersistentModel & IdentifiableObject, R>(_ type: T.Type, map: (T) -> R) throws -> [R]
  func readAll<T: PersistentModel & IdentifiableObject, R>(predicate: Predicate<T>, map: (T) -> R) throws -> [R]
  func delete<T: PersistentModel & IdentifiableObject>(predicate: Predicate<T>) throws
  func deleteAll<T: PersistentModel & IdentifiableObject>(of type: T.Type) throws
  func eraseStore() throws
}

final actor SwiftDataServiceImpl: SwiftDataService {

  private let storageConfig: StorageConfig
  private var container: ModelContainer
  private var context: ModelContext

  init(storageConfig: StorageConfig) {
    self.storageConfig = storageConfig
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

  func read<T: PersistentModel & IdentifiableObject, R>(predicate: Predicate<T>, map: (T) -> R) throws -> R? {
    var fd = FetchDescriptor<T>(predicate: predicate)
    fd.fetchLimit = 1
    return try context.fetch(fd).first.map(map)
  }

  /// Reads every object in batches of `Constants.readBatchSize`, so a large store is never materialised at once.
  func readAll<T: PersistentModel & IdentifiableObject, R>(_ type: T.Type, map: (T) -> R) throws -> [R] {
    try readAll(FetchDescriptor<T>(), map: map)
  }

  /// Reads the objects that match `predicate`, in batches as `readAll(_:map:)` does.
  func readAll<T: PersistentModel & IdentifiableObject, R>(predicate: Predicate<T>, map: (T) -> R) throws -> [R] {
    try readAll(FetchDescriptor<T>(predicate: predicate), map: map)
  }

  func delete<T: PersistentModel & IdentifiableObject>(predicate: Predicate<T>) throws {
    var fd = FetchDescriptor<T>(predicate: predicate)
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

extension SwiftDataServiceImpl {

  /// Erases the store's files, the write-ahead log included, so deleted rows cannot be read back from disk, and
  /// opens an empty store in their place, as the Android wallet rebuilds its database on reset.
  func eraseStore() throws {
    container.deleteAllData()
    container = try ModelContainer(for: storageConfig.schemas, configurations: storageConfig.modelConfiguration)
    context = ModelContext(container)
  }
}

private extension SwiftDataServiceImpl {

  enum Constants {
    static let readBatchSize = 100
  }

  func readAll<T: PersistentModel & IdentifiableObject, R>(
    _ descriptor: FetchDescriptor<T>,
    map: (T) -> R
  ) throws -> [R] {
    var results: [R] = []
    try context.enumerate(descriptor, batchSize: Constants.readBatchSize) { results.append(map($0)) }
    return results
  }
}
