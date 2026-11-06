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

/// Stores the documents whose status could not be refreshed at the last revocation check.
public protocol StatusRefreshFailureStorageController: StorageController where Value == StatusRefreshFailure {}

/// The `StatusRefreshFailureStorageController` of the app, on SwiftData.
final actor StatusRefreshFailureStorageControllerImpl: StatusRefreshFailureStorageController {

  private let swiftDataService: SwiftDataService

  init(swiftDataService: SwiftDataService) {
    self.swiftDataService = swiftDataService
  }

  func store(_ value: StatusRefreshFailure) async throws {
    try await swiftDataService.write(value.toSdModel())
  }

  func store(_ values: [StatusRefreshFailure]) async throws {
    try await swiftDataService.writeAll(values.toSdModels())
  }

  func update(_ value: StatusRefreshFailure) async throws {
    try await swiftDataService.write(value.toSdModel())
  }

  func retrieve(_ identifier: String) async throws -> StatusRefreshFailure {
    let failure = try await swiftDataService.read(
      predicate: #Predicate<SDStatusRefreshFailure> { $0.identifier == identifier }
    ) {
      $0.toStatusRefreshFailure()
    }
    guard let failure else {
      throw StorageError.itemNotFound
    }
    return failure
  }

  func retrieveAll() async throws -> [StatusRefreshFailure] {
    let failures = try await swiftDataService.readAll(SDStatusRefreshFailure.self) { $0.toStatusRefreshFailure() }
    guard !failures.isEmpty else {
      throw StorageError.itemsNotFound
    }
    return failures
  }

  func delete(_ identifier: String) async throws {
    try await swiftDataService.delete(
      predicate: #Predicate<SDStatusRefreshFailure> { $0.identifier == identifier }
    )
  }

  func deleteAll() async throws {
    try await swiftDataService.deleteAll(of: SDStatusRefreshFailure.self)
  }
}
