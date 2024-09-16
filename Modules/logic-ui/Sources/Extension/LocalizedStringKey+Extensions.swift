/*
 * Copyright (c) 2023 European Commission
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

extension LocalizedStringKey: @retroactive Hashable {
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
