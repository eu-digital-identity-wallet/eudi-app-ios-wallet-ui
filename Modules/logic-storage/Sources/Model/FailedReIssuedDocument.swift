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
import SwiftData

@Model
final class SDFailedReIssuedDocument: IdentifiableObject {

  @Attribute(.unique) var identifier: String

  init(identifier: String) {
    self.identifier = identifier
  }
}

public struct FailedReIssuedDocument: Sendable {

  public let identifier: String

  public init(identifier: String) {
    self.identifier = identifier
  }
}

extension SDFailedReIssuedDocument {
  func toFailedReIssuedDocument() -> FailedReIssuedDocument {
    FailedReIssuedDocument(identifier: identifier)
  }
}

extension FailedReIssuedDocument {
  func toSdModel() -> SDFailedReIssuedDocument {
    SDFailedReIssuedDocument(identifier: identifier)
  }
}

extension Array where Element == SDFailedReIssuedDocument {
  func toBookmarks() -> [FailedReIssuedDocument] {
    map { $0.toFailedReIssuedDocument() }
  }
}

extension Array where Element == FailedReIssuedDocument {
  func toSdModels() -> [SDFailedReIssuedDocument] {
    map { $0.toSdModel() }
  }
}
