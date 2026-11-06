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
import SwiftData

/// A document whose status could not be refreshed at the last revocation check. A new model, so the
/// store change is additive.
@Model
final class SDStatusRefreshFailure: IdentifiableObject {

  @Attribute(.unique) var identifier: String

  init(identifier: String) {
    self.identifier = identifier
  }
}

/// A document whose status could not be refreshed at the last revocation check.
public struct StatusRefreshFailure: Sendable {

  public let identifier: String

  public init(identifier: String) {
    self.identifier = identifier
  }
}

extension SDStatusRefreshFailure {
  func toStatusRefreshFailure() -> StatusRefreshFailure {
    StatusRefreshFailure(identifier: identifier)
  }
}

extension StatusRefreshFailure {
  func toSdModel() -> SDStatusRefreshFailure {
    SDStatusRefreshFailure(identifier: identifier)
  }
}

extension Array where Element == StatusRefreshFailure {
  func toSdModels() -> [SDStatusRefreshFailure] {
    map { $0.toSdModel() }
  }
}
