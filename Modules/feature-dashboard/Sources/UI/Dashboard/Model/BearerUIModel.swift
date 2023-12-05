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
import logic_resources
import MdocDataModel18013
import UIKit

public struct BearerUIModel: Identifiable {
  public let id: String
  public let value: Value

  public init(id: String, value: Value) {
    self.id = id
    self.value = value
  }
}

public extension BearerUIModel {

  struct Value {
    public let name: String
    public let image: Image
  }

  static func mock() -> BearerUIModel {
    .init(
      id: UUID().uuidString,
      value: .init(
        name: "Elena P.",
        image: Theme.shared.image.user
      )
    )
  }
}

extension Array where Element == MdocDecodable {
  func transformToBearerUi() -> BearerUIModel? {

    var image: Image?
    var name: String?

    self.forEach { item in

      switch item {
      case let pid as EuPidModel:
        if let firstName = pid.given_name, let lastName = pid.family_name {
          name = "\(firstName) \(lastName)"
        }
      case let mdl as IsoMdlModel:
        if let firstName = mdl.givenName, let lastName = mdl.familyName {
          name = "\(firstName) \(lastName)"
        }
        if let portrait = mdl.portrait, let uiImage = UIImage(data: Data(portrait)) {
          image = Image(uiImage: uiImage)
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
    }

    guard let name, let image else { return nil }

    return .init(
      id: UUID().uuidString,
      value: .init(
        name: name,
        image: image
      )
    )
  }
}
