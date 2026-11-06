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

extension String {
  func toBool() -> Bool {
    Bool(self) ?? false
  }

  /// The size of this Base64 content once decoded, in either alphabet, or nil when it is not Base64; worked out from
  /// the length, as on Android, so that reading the history does not decode every document again.
  var decodedBase64ByteCount: Int? {
    let content = filter { !$0.isWhitespace }
    let data = content.prefix { $0 != "=" }
    let padding = content.count - data.count
    let isBase64Digit: (Character) -> Bool = { $0.isASCII && ($0.isLetter || $0.isNumber) }
    let isStandard = data.allSatisfy { isBase64Digit($0) || $0 == "+" || $0 == "/" }
    let isUrlSafe = data.allSatisfy { isBase64Digit($0) || $0 == "-" || $0 == "_" }
    guard
      isStandard || isUrlSafe,
      data.count % 4 != 1,
      padding <= 2,
      padding == 0 || content.count % 4 == 0,
      content.dropFirst(data.count).allSatisfy({ $0 == "=" })
    else {
      return nil
    }
    return data.count * 3 / 4
  }
}
