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

public struct FAQUIModel: Identifiable {
  public let id: String
  public let value: Value

  public init(id: String, value: Value) {
    self.id = id
    self.value = value
  }
}

public extension FAQUIModel {
  struct Value {
    public let id: String
    public let title: String
    public let content: String
  }

  static func mocks() -> [FAQUIModel] {
    [
      .init(id: UUID().uuidString,
            value: .init(
              id: UUID().uuidString,
              title: "Cell 1",
              content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
            )),
      .init(id: UUID().uuidString,
            value: .init(
              id: UUID().uuidString,
              title: "Cell 2",
              content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
            )),
      .init(id: UUID().uuidString,
            value: .init(
              id: UUID().uuidString,
              title: "Cell 22",
              content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
            )),
      .init(id: UUID().uuidString,
            value: .init(
              id: UUID().uuidString,
              title: "Cell 3",
              content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
            )),
      .init(id: UUID().uuidString,
            value: .init(
              id: UUID().uuidString,
              title: "Cell 4",
              content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
            ))
    ]
  }
}
