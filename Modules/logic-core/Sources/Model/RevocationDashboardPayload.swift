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

/// The documents a revocation check newly revoked or newly suspended, each keyed by its identifier with its display name
/// as the value, so two documents with the same name are both listed, as the
/// `RevocationDashboard` notification carries them.
public struct RevocationDashboardPayload: Sendable, Equatable {

  public let revoked: [String: String]
  public let suspended: [String: String]

  public init(revoked: [String: String], suspended: [String: String]) {
    self.revoked = revoked
    self.suspended = suspended
  }

  /// `nil` when the user info has another shape or names no document.
  public init?(userInfo: [AnyHashable: Any]?) {
    guard
      let revoked = userInfo?[DocumentRevocationStatus.revoked.rawValue] as? [String: String],
      let suspended = userInfo?[DocumentRevocationStatus.suspended.rawValue] as? [String: String],
      !revoked.isEmpty || !suspended.isEmpty
    else {
      return nil
    }
    self.init(revoked: revoked, suspended: suspended)
  }

  public var userInfo: [AnyHashable: Any] {
    [
      DocumentRevocationStatus.revoked.rawValue: revoked,
      DocumentRevocationStatus.suspended.rawValue: suspended
    ]
  }
}
