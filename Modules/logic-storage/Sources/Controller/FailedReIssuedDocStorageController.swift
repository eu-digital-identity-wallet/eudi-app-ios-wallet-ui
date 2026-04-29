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

public protocol FailedReIssuedDocStorageController: StorageController where Value == FailedReIssuedDocument {}

final actor FailedReIssuedDocStorageControllerImpl: FailedReIssuedDocStorageController {

  private let swiftDataService: SwiftDataService

  init(swiftDataService: SwiftDataService) {
    self.swiftDataService = swiftDataService
  }

  func store(_ value: FailedReIssuedDocument) async throws {
    try await swiftDataService.write(value.toSdModel())
  }

  func store(_ values: [FailedReIssuedDocument]) async throws {
    try await swiftDataService.writeAll(values.toSdModels())
  }

  func update(_ value: FailedReIssuedDocument) async throws {
    try await swiftDataService.write(value.toSdModel())
  }

  func retrieve(_ identifier: String) async throws -> FailedReIssuedDocument {
    let failedDocument = try await swiftDataService.read(
      predicate: #Predicate<SDFailedReIssuedDocument> { $0.identifier == identifier }
    ) {
      $0.toFailedReIssuedDocument()
    }
    guard let failedDocument else {
      throw StorageError.itemNotFound
    }
    return failedDocument
  }

  func retrieveAll() async throws -> [FailedReIssuedDocument] {
    let failedDocuments = try await swiftDataService.readAll(SDFailedReIssuedDocument.self) { $0.toFailedReIssuedDocument() }
    guard !failedDocuments.isEmpty else {
      throw StorageError.itemsNotFound
    }
    return failedDocuments
  }

  func delete(_ identifier: String) async throws {
    try await swiftDataService.delete(
      predicate: #Predicate<SDFailedReIssuedDocument> { $0.identifier == identifier }
    )
  }

  func deleteAll() async throws {
    try await swiftDataService.deleteAll(of: SDFailedReIssuedDocument.self)
  }
}
