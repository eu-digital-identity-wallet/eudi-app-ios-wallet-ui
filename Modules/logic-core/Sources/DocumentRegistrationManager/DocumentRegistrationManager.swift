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
import IdentityDocumentServices

public struct RegistrationDescriptor: Sendable, Equatable {

  public let documentIdentifier: String
  public let mobileDocumentType: String
  public let invalidationDate: Date?

  public init(
    documentIdentifier: String,
    mobileDocumentType: String,
    invalidationDate: Date?
  ) {
    self.documentIdentifier = documentIdentifier
    self.mobileDocumentType = mobileDocumentType
    self.invalidationDate = invalidationDate
  }
}

public protocol DocumentRegistrationManager: Sendable {
  func reconcile(desired: [RegistrationDescriptor]) async
}

@available(iOS 26.0, *)
final actor DocumentRegistrationManagerImpl: DocumentRegistrationManager {

  init() {}

  @available(iOS 26, *)
  private func makeStore() -> IdentityDocumentProviderRegistrationStore {
    IdentityDocumentProviderRegistrationStore()
  }

  func reconcile(desired: [RegistrationDescriptor]) async {

    let store = makeStore()

    guard await store.status == .authorized else { return }
    guard let current = try? await store.registrations else { return }

    let desiredIdentifiers = Set(desired.map { $0.documentIdentifier })
    for registration in current where !desiredIdentifiers.contains(registration.documentIdentifier) {
      try? await store.removeRegistration(
        forDocumentIdentifier: registration.documentIdentifier
      )
    }

    let registered = Dictionary(
      current
        .compactMap { $0 as? MobileDocumentRegistration }
        .map { ($0.documentIdentifier, $0) },
      uniquingKeysWith: { first, _ in first }
    )

    for descriptor in desired where needsWrite(descriptor, registered: registered[descriptor.documentIdentifier]) {
      try? await store.addRegistration(
        MobileDocumentRegistration(
          mobileDocumentType: descriptor.mobileDocumentType,
          supportedAuthorityKeyIdentifiers: [],
          documentIdentifier: descriptor.documentIdentifier,
          invalidationDate: descriptor.invalidationDate
        )
      )
    }
  }

  private func needsWrite(
    _ descriptor: RegistrationDescriptor,
    registered: MobileDocumentRegistration?
  ) -> Bool {
    guard let registered else { return true }
    return registered.mobileDocumentType != descriptor.mobileDocumentType
    || registered.invalidationDate != descriptor.invalidationDate
  }
}

enum RegistrationError: Error {
  case apiNotAvailable
  case registrationNotFound
}
