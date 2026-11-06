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

public struct Prefs {}

public extension Prefs {
  enum Key: String, CaseIterable {
    case biometryEnabled
    /// Set when biometric unlock is bound to the enrolment of the moment it was turned on; unset on installs from
    /// before the binding.
    case biometricUnlockBound
    /// Where builds before the session lock kept a link for after login; now only removed at start.
    case cachedDeepLink
    case runAtLeastOnce
    case language
    case batchCounter
    case validateIssuerRegistrationCertificate
    case trustMarkIntroductionCompleted
    /// Changes whenever the transaction history is written or deleted, by the app or the ID Provider extension, so
    /// the history is read again only when it changed.
    case transactionLogRevision
    /// Advances with every completed factory reset, so the ID Provider extension can clear its own caches and log.
    case walletResetGeneration
    /// The "Allow document requests from apps and websites (DC API)" setting for the Digital Credential API: on
    /// until the user turns it off, as on Android (registered with the other defaults in `PrefsControllerImpl`).
    case offerDocumentsToApps
  }
}
