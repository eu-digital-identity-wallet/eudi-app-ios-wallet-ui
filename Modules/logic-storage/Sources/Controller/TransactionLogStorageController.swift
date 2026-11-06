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
import Foundation
import logic_business

public protocol TransactionLogStorageController: StorageController where Value == TransactionLog {
  func retrieve(parentPresentationId: String) async throws -> [TransactionLog]
  /// Changes whenever the history is written or deleted, here or in the ID Provider extension; equal values mean
  /// the history did not change between two reads.
  func retrieveRevision() async -> String
}

final actor TransactionLogStorageControllerImpl: TransactionLogStorageController {

  private let swiftDataService: SwiftDataService
  private let prefsController: PrefsController

  init(swiftDataService: SwiftDataService, prefsController: PrefsController) {
    self.swiftDataService = swiftDataService
    self.prefsController = prefsController
  }

  func retrieveRevision() async -> String {
    prefsController.getOptionalString(forKey: .transactionLogRevision)
  }

  func store(_ value: TransactionLog) async throws {
    defer { recordChange() }
    try await swiftDataService.write(value.toSdModel())
  }

  func store(_ values: [TransactionLog]) async throws {
    defer { recordChange() }
    try await swiftDataService.writeAll(values.toSdModels())
  }

  func update(_ value: TransactionLog) async throws {
    defer { recordChange() }
    try await swiftDataService.write(value.toSdModel())
  }

  func retrieve(_ identifier: String) async throws -> TransactionLog {
    let log = try await swiftDataService.read(
      predicate: #Predicate<SDTransactionLog> { $0.identifier == identifier }
    ) {
      $0.toTransactionLog()
    }
    guard let log else {
      throw StorageError.itemNotFound
    }
    return log
  }

  func retrieve(parentPresentationId: String) async throws -> [TransactionLog] {
    try await swiftDataService.readAll(
      predicate: #Predicate<SDTransactionLog> { $0.parentPresentationId == parentPresentationId }
    ) {
      $0.toTransactionLog()
    }
  }

  func retrieveAll() async throws -> [TransactionLog] {
    let logs = try await swiftDataService.readAll(SDTransactionLog.self) { $0.toTransactionLog() }
    guard !logs.isEmpty else {
      throw StorageError.itemsNotFound
    }
    return logs
  }

  func delete(_ identifier: String) async throws {
    defer { recordChange() }
    try await swiftDataService.delete(
      predicate: #Predicate<SDTransactionLog> { $0.identifier == identifier }
    )
  }

  func deleteAll() async throws {
    defer { recordChange() }
    try await swiftDataService.deleteAll(of: SDTransactionLog.self)
  }
}

private extension TransactionLogStorageControllerImpl {

  /// Marks the history as changed, also after a write that failed part way, so the next read does not trust a
  /// stale copy.
  /// A fresh token, not a count: the app and the ID Provider extension both write the history, and two processes that
  /// each add one to the same count could store the same value.
  func recordChange() {
    prefsController.setValue(UUID().uuidString, forKey: .transactionLogRevision)
  }
}
