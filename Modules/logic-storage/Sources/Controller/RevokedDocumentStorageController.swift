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
import Foundation

public protocol RevokedDocumentStorageController: StorageController where Value == RevokedDocument {}

final class RevokedDocumentStorageControllerImpl: RevokedDocumentStorageController {

  private let swiftDataService: SwiftDataService

  init(swiftDataService: SwiftDataService) {
    self.swiftDataService = swiftDataService
  }

  func store(_ value: RevokedDocument) async throws {
    try await swiftDataService.write(value.toSdModel())
  }

  func store(_ values: [RevokedDocument]) async throws {
    try await swiftDataService.writeAll(values.toSdModels())
  }

  func update(_ value: RevokedDocument) async throws {
    try await swiftDataService.write(value.toSdModel())
  }

  func retrieve(_ identifier: String) async throws -> RevokedDocument {
    let revokedDocument = try await swiftDataService.read(
      predicate: #Predicate<SDRevokedDocument> { $0.identifier == identifier }
    ) {
      $0.toRevokedDocument()
    }
    guard let revokedDocument else {
      throw StorageError.itemNotFound
    }
    return revokedDocument
  }

  func retrieveAll() async throws -> [RevokedDocument] {
    let revokedDocuments = try await swiftDataService.readAll(SDRevokedDocument.self) { $0.toRevokedDocument() }
    guard !revokedDocuments.isEmpty else {
      throw StorageError.itemsNotFound
    }
    return revokedDocuments
  }

  func delete(_ identifier: String) async throws {
    try await swiftDataService.delete(
      predicate: #Predicate<SDRevokedDocument> { $0.identifier == identifier }
    )
  }

  func deleteAll() async throws {
    try await swiftDataService.deleteAll(of: SDRevokedDocument.self)
  }
}
