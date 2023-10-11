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

public extension String {
  func toJSON() -> Any? {
    guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
    return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
  }

  func urlEncode() -> String {
    return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? self
  }

  func loadFileFromBundle() -> String? {
    let path = self.components(separatedBy: ".")
    guard
      let fileName = path.first,
      let fileExtension = path.last
    else {
      return nil
    }
    guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: fileExtension),
          let data = try? Data(contentsOf: fileURL),
          let string = String(data: data, encoding: .utf8) else {
      return nil
    }
    return string
  }
}

public extension String {

  private var formatter: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.minimumFractionDigits = 1
    formatter.maximumFractionDigits = 2
    formatter.decimalSeparator = "."
    formatter.usesGroupingSeparator = false
    formatter.roundingMode = .floor
    return formatter
  }

  func toInteger() -> Int? {
    return Int(self)
  }

  func toNumeric() -> String {
    if self.toInteger() != nil {
      return self
    } else {
      var text = NSMutableString(string: self)
      if let regex = try? NSRegularExpression(pattern: "[^0-9]") {
        regex.replaceMatches(in: text, options: .reportProgress, range: NSRange(location: 0, length: text.length), withTemplate: "")
      } else {
        text = ""
      }
      return String(text)
    }
  }

  func toAmount() -> String? {
    if let number = formatter.number(from: self) {
      return formatter.string(from: number)
    }
    return nil
  }
}

public extension String {
  func countInstances(of stringToFind: String) -> Int {
    assert(!stringToFind.isEmpty)
    var count = 0
    var searchRange: Range<String.Index>?
    while let foundRange = range(of: stringToFind, options: [], range: searchRange) {
      count += 1
      searchRange = Range(uncheckedBounds: (lower: foundRange.upperBound, upper: endIndex))
    }
    return count
  }
}

public extension String {
  func equals(_ valueToMatch: String, ignoreCase: Bool = false) -> Bool {
    if ignoreCase {
      return self.caseInsensitiveCompare(valueToMatch) == .orderedSame
    } else {
      return self == valueToMatch
    }
  }

  func match(_ regex: String) -> [[String]] {
    let nsString = self as NSString
    return (try? NSRegularExpression(pattern: regex, options: []))?.matches(in: self, options: [], range: NSRange(location: 0, length: nsString.length)).map { match in
      (0..<match.numberOfRanges).map { match.range(at: $0).location == NSNotFound ? "" : nsString.substring(with: match.range(at: $0)) }
    } ?? []
  }
}
