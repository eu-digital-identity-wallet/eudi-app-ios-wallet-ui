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
import StatiumSwift

/// What a revocation check does with a document's record after reading its status, as the Android
/// wallet's `revocationUpdateFor`.
enum RevocationRecordUpdate: Equatable {
  case keep
  case clear
  case record(DocumentRevocationStatus)

  /// A revocation never changes. Valid clears a suspended or unrecognised record. Any other status is
  /// recorded unless the same one is already stored.
  static func after(stored: DocumentRevocationStatus?, observed: CredentialStatus) -> RevocationRecordUpdate {
    let target: DocumentRevocationStatus
    switch observed {
    case .valid:
      return stored == .suspended || stored == .unrecognised ? .clear : .keep
    case .invalid:
      target = .revoked
    case .suspended:
      target = .suspended
    case .applicationSpecific, .reserved:
      target = .unrecognised
    }
    return stored == .revoked || stored == target ? .keep : .record(target)
  }
}
