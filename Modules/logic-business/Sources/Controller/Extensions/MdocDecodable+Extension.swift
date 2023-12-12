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
import UIKit
import MdocDataModel18013
import logic_resources

public extension MdocDecodable {

  func getExpiryDate() -> String? {

    let expiryDate: String? = switch self {
    case let pid as EuPidModel:
      pid.expiry_date
    case let mdl as IsoMdlModel:
      mdl.expiryDate
    case let generic as GenericMdocModel:
      generic.displayStrings.first(
        where: {
          $0.name.replacingOccurrences(of: "_", with: "").lowercased() == "expirydate"
        }
      )?.value
    default:
      nil
    }

    if let expiryDate {
      return tryParseDate(dateString: expiryDate)
    } else {
      return nil
    }
  }

  func getBearersName() -> (first: String, last: String)? {
    var name: (first: String, last: String)?

    switch self {
    case let pid as EuPidModel:
      if let firstName = pid.given_name, let lastName = pid.family_name {
        name = (firstName, lastName)
      }
    case let mdl as IsoMdlModel:
      if let firstName = mdl.givenName, let lastName = mdl.familyName {
        name = (firstName, lastName)
      }
    case let generic as GenericMdocModel:
      if
        let firstName = generic.displayStrings.first(
          where: {
            $0.name.replacingOccurrences(of: "_", with: "").lowercased() == "givenname"
          }
        )?.value,
        let lastName = generic.displayStrings.first(
          where: {
            $0.name.replacingOccurrences(of: "_", with: "").lowercased() == "familyname"
          }
        )?.value {
        name = (firstName, lastName)
      }
    default: break
    }

    return name
  }

  func getPortrait() -> Image? {
    var image: Image?

    switch self {
    case let mdl as IsoMdlModel:
      if let portrait = mdl.portrait, let uiImage = UIImage(data: Data(portrait)) {
        image = Image(uiImage: uiImage)
      }
    default: break
    }

    return image
  }

  func getDrivingPrivileges() -> NameValue? {
    guard
      let mdl = self as? IsoMdlModel,
      let drivingPrivileges = mdl.drivingPrivileges
    else {
      return nil
    }

    return NameValue(
      name: IsoMdlModel.CodingKeys.drivingPrivileges.rawValue,
      value: String(drivingPrivileges.drivingPrivileges
        .reduce(into: "", { partialResult, privilege in
          guard
            let issueDate = privilege.issueDate,
            let expiryDate = privilege.expiryDate
          else {
            return
          }
          partialResult +=  """
                            \(LocalizableString.shared.get(with: .vehicleCategory)): \(privilege.vehicleCategoryCode)
                            \(LocalizableString.shared.get(with: .dateOfIssue)): \(tryParseDate(dateString: issueDate))
                            \(LocalizableString.shared.get(with: .dateOfExpiry)): \(tryParseDate(dateString: expiryDate))

                            """
        })
          .dropLast()),
      order: IsoMdlModel.CodingKeys.allCases.firstIndex(of: .drivingPrivileges) ?? .max
    )
  }

  func tryParseDate(dateString: String) -> String {
    Locale.current.localizedDateTime(
      date: dateString,
      uiFormatter: "dd MMM yyyy"
    )
  }
}

extension Array where Element == NameValue {

  public func decodeGender() -> [NameValue] {
    self.map { nameValue in
      if nameValue.name == IsoMdlModel.CodingKeys.sex.rawValue ||
          nameValue.name == EuPidModel.CodingKeys.gender.rawValue {
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

  public func parseDates() -> [NameValue] {
    self.map {
      NameValue(
        name: $0.name,
        value: parseDate(dateString: $0.value),
        ns: $0.ns,
        order: $0.order,
        children: $0.children
      )
    }
  }

  private func parseDate(dateString: String) -> String {
    Locale.current.localizedDateTime(
      date: dateString,
      uiFormatter: "dd MMM yyyy"
    )
  }
}
