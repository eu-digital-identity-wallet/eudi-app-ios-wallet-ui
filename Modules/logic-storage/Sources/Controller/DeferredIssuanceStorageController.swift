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

/// Persists the deferred issuance schedule, one entry per document.
public protocol DeferredIssuanceStorageController: StorageController where Value == DeferredIssuance {}

// `identifier` is unique, so storing an existing entry replaces it.
final actor DeferredIssuanceStorageControllerImpl: DeferredIssuanceStorageController {

  private let swiftDataService: SwiftDataService

  init(swiftDataService: SwiftDataService) {
    self.swiftDataService = swiftDataService
  }

  func store(_ value: DeferredIssuance) async throws {
    try await swiftDataService.write(value.toSdModel())
  }

  func store(_ values: [DeferredIssuance]) async throws {
    try await swiftDataService.writeAll(values.toSdModels())
  }

  func update(_ value: DeferredIssuance) async throws {
    try await swiftDataService.write(value.toSdModel())
  }

  func retrieve(_ identifier: String) async throws -> DeferredIssuance {
    let issuance = try await swiftDataService.read(
      predicate: #Predicate<SDDeferredIssuance> { $0.identifier == identifier }
    ) {
      $0.toDeferredIssuance()
    }
    guard let issuance else {
      throw StorageError.itemNotFound
    }
    return issuance
  }

  func retrieveAll() async throws -> [DeferredIssuance] {
    let issuances = try await swiftDataService.readAll(SDDeferredIssuance.self) { $0.toDeferredIssuance() }
    guard !issuances.isEmpty else {
      throw StorageError.itemsNotFound
    }
    return issuances
  }

  func delete(_ identifier: String) async throws {
    try await swiftDataService.delete(
      predicate: #Predicate<SDDeferredIssuance> { $0.identifier == identifier }
    )
  }

  func deleteAll() async throws {
    try await swiftDataService.deleteAll(of: SDDeferredIssuance.self)
  }
}
