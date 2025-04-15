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

public extension DocClaim {
  func parseDate(parser: (String) -> String) -> DocClaim {
    switch self.dataValue {
    case .date:
      let path = self.path
      var docClaim = DocClaim(
        name: self.name,
        displayName: self.displayName,
        dataValue: self.dataValue,
        stringValue: parser(self.stringValue),
        isOptional: self.isOptional,
        order: self.order,
        namespace: self.namespace,
        children: self.children
      )
      docClaim.path = path
      return docClaim
    default:
      return self
    }
  }
  func parseUserPseudonym() -> DocClaim {
    if self.name == DocumentJsonKeys.USER_PSEUDONYM {
      let path = self.path
      var docClaim = DocClaim(
        name: self.name,
        displayName: self.displayName,
        dataValue: self.dataValue,
        stringValue: self.dataValue.base64.orEmpty,
        isOptional: self.isOptional,
        order: self.order,
        namespace: self.namespace,
        children: self.children
      )
      docClaim.path = path
      return docClaim
    } else {
      return self
    }
  }
}

public extension RangeReplaceableCollection where Element == DocClaim {

  func parseDates(parser: (String) -> String) -> [DocClaim] {
    self.map {
      $0.parseDate(parser: parser)
    }
  }

  func parseUserPseudonyms() -> [DocClaim] {
    self.map {
      $0.parseUserPseudonym()
    }
  }
}
