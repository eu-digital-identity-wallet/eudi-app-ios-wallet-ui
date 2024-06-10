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

extension Array where Element == NameValue {

  public func decodeGender() -> [NameValue] {
    self.map { nameValue in
      if nameValue.name == "sex" || nameValue.name == "gender" {
        switch nameValue.value {
        case "1", "male":
          return NameValue(
            name: nameValue.name,
            value: "male",
            ns: nameValue.ns,
            order: nameValue.order,
            children: nameValue.children
          )
        case "2", "female":
          return NameValue(
            name: nameValue.name,
            value: "female",
            ns: nameValue.ns,
            order: nameValue.order,
            children: nameValue.children
          )
        default:
          return nameValue
        }

      } else {
        return nameValue
      }
    }
  }

  public func mapTrueFalseToLocalizable() -> [NameValue] {
    self.map {
      if $0.value == "true" || $0.value == "false" {
        return NameValue(
          name: $0.name,
          value: LocalizableString.shared.get(with: $0.value == "true" ? .yes : .no),
          ns: $0.ns,
          order: $0.order,
          children: $0.children
        )
      } else {
        return $0
      }
    }
  }

  public func parseDates(parser: (String) -> String) -> [NameValue] {
    self.map {
      NameValue(
        name: $0.name,
        value: parser($0.value),
        ns: $0.ns,
        order: $0.order,
        children: $0.children
      )
    }
  }
}
