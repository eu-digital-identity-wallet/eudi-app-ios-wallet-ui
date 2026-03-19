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
import IdentityDocumentServices

public protocol DocumentRegistrationManager: Sendable {
  func addRegistration(
    mobileDocumentType: String,
    supportedAuthorityKeyIdentifiers: [Data],
    documentIdentifier: String,
    invalidationDate: Date?
  ) async throws
  func removeRegistration(
    documentIdentifiers: [String]
  ) async throws
}

@available(iOS 26.0, *)
final actor DocumentRegistrationManagerImpl: DocumentRegistrationManager {

  init() {}

  @available(iOS 26, *)
  private func makeStore() -> IdentityDocumentProviderRegistrationStore {
    IdentityDocumentProviderRegistrationStore()
  }

  func addRegistration(
    mobileDocumentType: String,
    supportedAuthorityKeyIdentifiers: [Data],
    documentIdentifier: String,
    invalidationDate: Date?
  ) async throws {

    let store = makeStore()

    let registration = MobileDocumentRegistration(
      mobileDocumentType: mobileDocumentType,
      supportedAuthorityKeyIdentifiers: supportedAuthorityKeyIdentifiers,
      documentIdentifier: documentIdentifier,
      invalidationDate: invalidationDate
    )

    try await store.addRegistration(registration)
  }

  func removeRegistration(
    documentIdentifiers: [String]
  ) async throws {

    let store = makeStore()
    for documentIdentifier in documentIdentifiers {
      try await store.removeRegistration(
        forDocumentIdentifier: documentIdentifier
      )
    }
  }
}

enum RegistrationError: Error {
  case apiNotAvailable
  case registrationNotFound
}
