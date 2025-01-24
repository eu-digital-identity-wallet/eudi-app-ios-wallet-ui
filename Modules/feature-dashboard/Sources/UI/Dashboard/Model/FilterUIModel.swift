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

public enum FilterSections {
  case issuedSortingDate
  case sortBy
  case issuer(options: [String])
  case expiryPeriod
  case state

  var sectionTitle: String {
    switch self {
    case .issuedSortingDate:
      return LocalizableString.shared.get(with: .sortByIssuedDateSectionTitle)
    case .sortBy:
      return LocalizableString.shared.get(with: .sortBy)
    case .issuer:
      return LocalizableString.shared.get(with: .issuerSectionTitle)
    case .expiryPeriod:
      return LocalizableString.shared.get(with: .expiryPeriodSectionTitle)
    case .state:
      return LocalizableString.shared.get(with: .state)
    }
  }

  var sorting: [String] {
    switch self {
    case .issuedSortingDate:
      return [
        LocalizableString.shared.get(with: .ascending).capitalized,
        LocalizableString.shared.get(with: .descending).capitalized
      ]
    case .sortBy:
      return []
    case .issuer:
      return []
    case .expiryPeriod:
      return []
    case .state:
      return []
    }
  }

  var options: [String] {
    switch self {
    case .issuedSortingDate:
      return []
    case .sortBy:
      return [
        LocalizableString.shared.get(with: .defaultLabel).capitalized,
        LocalizableString.shared.get(with: .dateIssued).capitalized,
        LocalizableString.shared.get(with: .expiryDate).capitalized
      ]
    case .issuer(let options):
      return options
    case .expiryPeriod:
      return [
        LocalizableString.shared.get(with: .nextSevenDays).capitalized,
        LocalizableString.shared.get(with: .nextThirtyDays).capitalized,
        LocalizableString.shared.get(with: .beyondThiryDays).capitalized,
        LocalizableString.shared.get(with: .beforeToday).capitalized
      ]
    case .state:
      return [
        LocalizableString.shared.get(with: .valid).capitalized,
        LocalizableString.shared.get(with: .expired).capitalized
      ]
    }
  }

  var hasToggle: Bool {
    switch self {
    case .issuedSortingDate:
      return false
    case .sortBy:
      return false
    case .issuer:
      return true
    case .expiryPeriod:
      return false
    case .state:
      return false
    }
  }
}
