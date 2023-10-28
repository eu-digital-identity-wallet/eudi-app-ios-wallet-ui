/*
 * Copyright (c) 2023 European Commission
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import Foundation

public struct DocumentUIModel: Identifiable {
  public let id: String
  public let value: Value

  public init(id: String, value: Value) {
    self.id = id
    self.value = value
  }
}

public extension DocumentUIModel {
  struct Value {
    public let id: String
    public let title: String
    public let status: String
  }

  static func mocks() -> [DocumentUIModel] {
    [
      .init(
        id: UUID().uuidString,
        value: .init(id: UUID().uuidString, title: "Digital ID", status: "Active")
      ),
      .init(
        id: UUID().uuidString,
        value: .init(id: UUID().uuidString, title: "EUDI Conference", status: "Active")
      ),
      .init(
        id: UUID().uuidString,
        value: .init(id: UUID().uuidString, title: "Passport", status: "Active")
      ),
      .init(
        id: UUID().uuidString,
        value: .init(id: UUID().uuidString, title: "Document 1", status: "Active")
      ),
      .init(
        id: UUID().uuidString,
        value: .init(id: UUID().uuidString, title: "Document 2", status: "Active")
      ),
      .init(
        id: UUID().uuidString,
        value: .init(id: UUID().uuidString, title: "Document 3", status: "Active")
      ),
      .init(
        id: UUID().uuidString,
        value: .init(id: UUID().uuidString, title: "Document 4", status: "Active")
      ),
      .init(
        id: UUID().uuidString,
        value: .init(id: UUID().uuidString, title: "Document 5", status: "Active")
      ),
      .init(
        id: UUID().uuidString,
        value: .init(id: UUID().uuidString, title: "Document 6", status: "Active")
      ),
      .init(
        id: UUID().uuidString,
        value: .init(id: UUID().uuidString, title: "Passport", status: "Active")
      )
    ]
  }
}
