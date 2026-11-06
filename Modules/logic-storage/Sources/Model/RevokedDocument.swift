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

@Model
final class SDRevokedDocument: IdentifiableObject {

  @Attribute(.unique) var identifier: String
  var status: String?

  init(identifier: String, status: String? = nil) {
    self.identifier = identifier
    self.status = status
  }
}

public struct RevokedDocument: Sendable {

  public let identifier: String
  /// The status-list outcome, as the raw value of `logic-core`'s `DocumentRevocationStatus`. A record
  /// stored before the status was kept has none.
  public let status: String?

  public init(identifier: String, status: String? = nil) {
    self.identifier = identifier
    self.status = status
  }
}

extension SDRevokedDocument {
  func toRevokedDocument() -> RevokedDocument {
    RevokedDocument(identifier: identifier, status: status)
  }
}

extension RevokedDocument {
  func toSdModel() -> SDRevokedDocument {
    SDRevokedDocument(identifier: identifier, status: status)
  }
}

extension Array where Element == SDRevokedDocument {
  func toRevokedDocuments() -> [RevokedDocument] {
    map { $0.toRevokedDocument() }
  }
}

extension Array where Element == RevokedDocument {
  func toSdModels() -> [SDRevokedDocument] {
    map { $0.toSdModel() }
  }
}
