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
final class SDBookmark: IdentifiableObject {

  @Attribute(.unique) var identifier: String

  init(identifier: String) {
    self.identifier = identifier
  }
}

public struct Bookmark: Sendable {

  public let identifier: String

  public init(identifier: String) {
    self.identifier = identifier
  }
}

extension SDBookmark {
  func toBookmark() -> Bookmark {
    Bookmark(identifier: identifier)
  }
}

extension Bookmark {
  func toSdModel() -> SDBookmark {
    SDBookmark(identifier: identifier)
  }
}

extension Array where Element == SDBookmark {
  func toBookmarks() -> [Bookmark] {
    map { $0.toBookmark() }
  }
}

extension Array where Element == Bookmark {
  func toSdModels() -> [SDBookmark] {
    map { $0.toSdModel() }
  }
}
