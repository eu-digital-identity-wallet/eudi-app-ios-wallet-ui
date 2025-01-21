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

enum FilterSections {
  // MARK: - DOCUMENT FILTER SECTIONS
  case issuedSortingDate
  case issuer(options: [String])

  var sectionTitle: String {
    switch self {
    case .issuedSortingDate:
      return LocalizableString.shared.get(with: .sortByIssuedDateSectionTitle)
    case .issuer:
      return LocalizableString.shared.get(with: .issuerSectionTitle)
    }
  }

  var sorting: [String] {
    switch self {
    case .issuedSortingDate:
      return [
        LocalizableString.shared.get(with: .ascending).capitalized,
        LocalizableString.shared.get(with: .descending).capitalized
      ]
    case .issuer:
      return []
    }
  }

  var options: [String] {
    switch self {
    case .issuedSortingDate:
      return []
    case .issuer(let options):
      return options
    }
  }

  var hasToggle: Bool {
    switch self {
    case .issuedSortingDate:
      return false
    case .issuer:
      return true
    }
  }
}
