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

/// Holds each presentation's registration outcome, by wallet-kit's transaction identifier, until wallet-kit writes
/// that presentation's history entry, as the Android wallet keys it; an outcome never reaches another presentation's
/// entry.
public protocol RegistrationCheckProvider: Sendable {
  func record(_ check: RecordedRegistrationCheck, for transactionIdentifier: String) async
  /// The outcome recorded for `transactionIdentifier`, which it removes.
  func removeCheck(for transactionIdentifier: String) async -> RecordedRegistrationCheck?
}

/// Keeps the outcomes in memory, one per transaction, for this process.
final actor RegistrationCheckProviderImpl: RegistrationCheckProvider {

  private var checks: [String: RecordedRegistrationCheck] = [:]

  func record(_ check: RecordedRegistrationCheck, for transactionIdentifier: String) {
    checks[transactionIdentifier] = check
  }

  func removeCheck(for transactionIdentifier: String) -> RecordedRegistrationCheck? {
    checks.removeValue(forKey: transactionIdentifier)
  }
}
