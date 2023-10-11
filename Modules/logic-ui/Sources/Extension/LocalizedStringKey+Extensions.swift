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

import SwiftUI

extension LocalizedStringKey {
  struct Data: Equatable {
    let key: String
    let arguments: [String]
  }
}

extension LocalizedStringKey {

  func isEqual(to other: LocalizedStringKey) -> Bool {
    return self.data == other.data
  }

  var data: Data? {
    let description = "\(self)"
    do {
      let regex = try NSRegularExpression(pattern: "\"([^\"]*)\"")
      let results = regex.matches(in: description, range: NSRange(description.startIndex..., in: description))
      let values = results.map { String(description[Range($0.range(at: 1), in: description)!]) }
      if let key = values.first {
        return .init(key: key, arguments: Array(values.dropFirst()))
      }
    } catch let error {
      error.log()
    }
    return nil
  }
}

extension LocalizedStringKey: Hashable {
  public func hash(into hasher: inout Hasher) {
    let data = self.data
    hasher.combine(data?.key)
    hasher.combine(data?.arguments)
  }
}

extension LocalizedStringKey {
  static func == (a: LocalizedStringKey, b: LocalizedStringKey) -> Bool {
    return a.isEqual(to: b)
  }
}
