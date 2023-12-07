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

  func getBearersName() -> String? {
    var name: String?

    switch self {
    case let pid as EuPidModel:
      if let firstName = pid.given_name, let lastName = pid.family_name {
        name = "\(firstName) \(lastName)"
      }
    case let mdl as IsoMdlModel:
      if let firstName = mdl.givenName, let lastName = mdl.familyName {
        name = "\(firstName) \(lastName)"
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
        name = "\(firstName) \(lastName)"
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