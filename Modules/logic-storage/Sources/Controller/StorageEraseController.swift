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

/// Erases the whole SwiftData store for the factory reset, after its records were deleted one store at a time.
public protocol StorageEraseController: Sendable {
  func eraseStore() async throws
}

/// Deletes all the data in the store through `SwiftDataService`, which then opens it again, empty.
final actor StorageEraseControllerImpl: StorageEraseController {

  private let swiftDataService: SwiftDataService

  init(swiftDataService: SwiftDataService) {
    self.swiftDataService = swiftDataService
  }

  func eraseStore() async throws {
    try await swiftDataService.eraseStore()
  }
}
