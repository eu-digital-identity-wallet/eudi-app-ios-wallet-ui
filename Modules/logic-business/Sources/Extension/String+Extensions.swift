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

public extension String? {
  var orEmpty: String {
    guard let self = self else {
      return ""
    }
    return self
  }
  func ifNull(_ fallback: () -> String) -> String {
    guard let self = self else {
      return fallback()
    }
    return self
  }
  func ifNullOrEmpty(_ fallback: () -> String) -> String {
    guard let self = self, !self.isEmpty else {
      return fallback()
    }
    return self
  }
}

public extension String {
  func padded(toWidth width: Int, withPad pad: String = " ", startingAt start: Int = 0) -> String {
    let padLength = width - self.count
    guard padLength > 0 else { return self }

    let padding = String(repeating: pad, count: padLength)
    return padding + self
  }

  func padded(withPad pad: String = " ", padLength: Int) -> String {
    guard padLength > 0 else { return self }

    let padding = String(repeating: pad, count: padLength)
    return self + padding
  }
}

public extension String {
  var valueFromBundle: String {
    Bundle.main.infoDictionary?[self] as? String ?? ""
  }

  var optionalValueFromBundle: String? {
    guard let value = Bundle.main.infoDictionary?[self] as? String, !value.isEmpty else {
      return nil
    }
    return value
  }
}

public extension String {

  var decodeBase64: String? {
    guard
      let data = Data(base64Encoded: self),
      let decoded = String(data: data, encoding: .utf8)
    else {
      return nil
    }
    return decoded
  }

  var toBase64: String? {
    guard
      let data = self.data(using: .utf8)
    else {
      return nil
    }
    return data.base64EncodedString()
  }
}

public extension String? {

  func isNullOrEmpty() -> Bool {
    return self == nil || self?.isEmpty == true
  }

}

public extension String {
  func toCompatibleUrl() -> URL? {
    guard let decoded = self.removingPercentEncoding else { return nil }
    return if let url = URL(string: decoded) {
      url
    } else if let encodedString = decoded.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: encodedString) {
      url
    } else {
      nil
    }
  }
}
