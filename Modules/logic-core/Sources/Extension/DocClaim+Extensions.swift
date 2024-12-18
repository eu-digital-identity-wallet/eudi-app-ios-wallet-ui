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
import logic_resources

extension RangeReplaceableCollection where Element == DocClaim {

  public func parseDates(parser: (String) -> String) -> [DocClaim] {
    self.map {
      return switch $0.dataValue {
      case .date:
        DocClaim(
          name: $0.name,
          displayName: $0.displayName,
          dataValue: $0.dataValue,
          stringValue: parser($0.stringValue),
          valueType: $0.valueType,
          isOptional: $0.isOptional,
          order: $0.order,
          namespace: $0.namespace,
          children: $0.children
        )
      default: $0
      }
    }
  }

  public func parseUserPseudonym() -> [DocClaim] {
    self.map {
      if $0.name == DocumentJsonKeys.USER_PSEUDONYM {
        return DocClaim(
          name: $0.name,
          displayName: $0.displayName,
          dataValue: $0.dataValue,
          stringValue: $0.dataValue.base64.orEmpty,
          valueType: $0.valueType,
          isOptional: $0.isOptional,
          order: $0.order,
          namespace: $0.namespace,
          children: $0.children
        )
      } else {
        return $0
      }
    }
  }
}

public extension DocClaim {
  func flattenNested(nested: [DocClaim]) -> DocClaim {
    let flat = nested
      .parseDates(
        parser: {
          Locale.current.localizedDateTime(
            date: $0,
            uiFormatter: "dd MMM yyyy"
          )
        }
      )
      .parseUserPseudonym()
      .reduce(into: "") { partialResult, docClaim in
        if let nestedChildren = docClaim.children {
          let deepNested = flattenNested(nested: nestedChildren.sorted(by: {$0.order < $1.order}))
          partialResult += "\(deepNested.stringValue)\n"
        } else {
          partialResult += "\(docClaim.displayName.ifNilOrEmpty { docClaim.name }): \(docClaim.stringValue)\n"
        }
      }
      .dropLast()

    return DocClaim(
      name: self.name,
      displayName: self.displayName,
      dataValue: self.dataValue,
      stringValue: String(flat),
      valueType: self.valueType,
      isOptional: self.isOptional,
      order: self.order,
      namespace: self.namespace,
      children: nil
    )
  }
}
