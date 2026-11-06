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

/// What the wallet established about the relying party's registration when it shared data, recorded beside the
/// history entry because wallet-kit does not keep it there, as the Android wallet's `RecordedRegistrationCheckDomain`.
/// An entry with no record, written before it existed or by the ID Provider extension, counts as not verified.
public enum RecordedRegistrationCheck: String, Sendable, Equatable {
  case verified
  case notVerified
  /// The registration certificate was issued to another party than the one that asked for the data.
  case notBoundToRequester
  /// The registration was not checked, because checking is turned off or the request carried none.
  case notEvaluated

  /// The outcome `status` shows, with `isNotBoundToRequester` from wallet-kit's registration violations. A
  /// registration counts as verified only for a requester that authenticated (`isRequesterAuthenticated`): wallet-kit
  /// binds a registration to the reader certificate even when that certificate failed validation, and the subject it
  /// compares is the reader's own choice.
  public init(status: RegistrationStatus, isNotBoundToRequester: Bool, isRequesterAuthenticated: Bool) {
    switch status {
    case .verified: self = isRequesterAuthenticated ? .verified : .notVerified
    case .notVerified: self = isNotBoundToRequester ? .notBoundToRequester : .notVerified
    case .notSupported: self = .notEvaluated
    }
  }
}
