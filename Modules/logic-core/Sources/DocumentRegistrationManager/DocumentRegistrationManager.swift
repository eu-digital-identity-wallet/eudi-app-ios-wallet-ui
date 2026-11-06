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

  /// iOS reports `notDetermined` until the app's first registration, even when "Allow on websites" is on in
  /// Settings, and that registration is what authorises the app. Waiting for `authorized` before registering meant a
  /// new install never registered, so websites found "no eligible IDs". Until then the store is touched only to
  /// register: reading its registrations while `notDetermined` did not return on the simulator.
  func reconcile(desired: [RegistrationDescriptor]) async {

    let store = makeStore()

    let status = await store.status
    guard Self.mayRegister(with: status) else { return }
    if status == .notDetermined {
      guard !desired.isEmpty else { return }
      for descriptor in desired {
        try? await store.addRegistration(descriptor.mobileDocumentRegistration)
      }
      guard await store.status == .authorized else { return }
    }
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
      try? await store.addRegistration(descriptor.mobileDocumentRegistration)
    }
  }

  /// True unless the user turned the app off as a document provider (`notAuthorized`) or the device cannot provide
  /// documents (`notSupported`).
  static func mayRegister(with status: IdentityDocumentProviderRegistrationStore.Status) -> Bool {
    switch status {
    case .authorized, .notDetermined:
      true
    case .notAuthorized, .notSupported:
      false
    @unknown default:
      false
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

@available(iOS 26.0, *)
private extension RegistrationDescriptor {

  var mobileDocumentRegistration: MobileDocumentRegistration {
    MobileDocumentRegistration(
      mobileDocumentType: mobileDocumentType,
      supportedAuthorityKeyIdentifiers: [],
      documentIdentifier: documentIdentifier,
      invalidationDate: invalidationDate
    )
  }
}
