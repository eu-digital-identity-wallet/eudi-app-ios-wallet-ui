/*
 * Copyright (c) 2025 European Commission
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

public extension DocClaimsDecodable {

  var issuerName: String {
    issuerDisplay?.first(
      where: {
        $0.localeIdentifier == Locale.current.systemLanguageCode
      }
    )?.name
    ?? issuerDisplay?.first?.name
    ?? LocalizableStringKey.unknown.toString
  }

  var issuerLogo: URL? {
    issuerDisplay?.first?.logo?.uri
  }

  var documentTypeIdentifier: DocumentTypeIdentifier {
    DocumentTypeIdentifier(rawValue: docType ?? credentialIssuerIdentifier ?? "")
  }

  func getExpiryDate(parser: (Date) -> String) -> String? {
    if let expiryDate = expiryDateValue {
      return parser(expiryDate)
    } else {
      return nil
    }
  }

  var hasExpired: Bool {
    guard let value = expiryDateValue else {
      return false
    }
    let order = Calendar.current.compare(value, to: Date.now, toGranularity: .day)
    switch order {
    case .orderedAscending:
      return true
    default:
      return false
    }
  }

  func getBearersName() -> (first: String, last: String)? {
    var name: (first: String, last: String)?

    let firstName = self.docClaims.first(where: { $0.name == DocumentJsonKeys.FIRST_NAME })?.stringValue
    let lastName = self.docClaims.first(where: { $0.name == DocumentJsonKeys.LAST_NAME })?.stringValue

    if let firstName, let lastName {
      name = (firstName, lastName)
    }

    return name
  }

  func getPortrait() -> Image? {
    var image: Image?

    let uiImage = self.docClaims.first(where: { $0.name == DocumentJsonKeys.PORTRAIT })?.dataValue.image

    if let uiImage {
      image = Image(uiImage: uiImage)
    }

    return image
  }

  private var expiryDateValue: Date? {
    self.validUntil
  }
}
