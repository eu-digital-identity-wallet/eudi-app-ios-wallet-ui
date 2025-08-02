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

public protocol TransactionLogStorageController: StorageController where Value == TransactionLog {}

final class TransactionLogStorageControllerImpl: TransactionLogStorageController {

  private let realmService: RealmService

  init(realmService: RealmService) {
    self.realmService = realmService
  }

  func store(_ value: TransactionLog) async throws {
    try await realmService.write(value.toRealmTransactionLog())
  }

  func store(_ values: [TransactionLog]) async throws {
    try await realmService.writeAll(values.toRealmTransactionLogs())
  }

  func update(_ value: TransactionLog) async throws {
    try await realmService.write(value.toRealmTransactionLog())
  }

  func retrieve(_ identifier: String) async throws -> TransactionLog {
    let log = try await realmService.read(RealmTransactionLog.self, id: identifier) {
      $0.toTransactionLog()
    }
    guard let log else {
      throw StorageError.itemNotFound
    }
    return log
  }

  func retrieveAll() async throws -> [TransactionLog] {
    let logs = try await realmService.readAll(RealmTransactionLog.self) { $0.toTransactionLog() }
    guard !logs.isEmpty else {
      throw StorageError.itemsNotFound
    }
    return logs
  }

  func delete(_ identifier: String) async throws {
    try await realmService.delete(RealmTransactionLog.self, id: identifier)
  }

  func deleteAll() async throws {
    try await realmService.deleteAll(of: RealmTransactionLog.self)
  }
}
