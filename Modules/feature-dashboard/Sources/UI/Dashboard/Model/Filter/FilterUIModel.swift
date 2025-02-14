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
import logic_business

public struct FilterUISection: Sendable, Identifiable {
  public let id: String
  public let filters: [FilterUIItem]
  public let sectionTitle: String
}

public struct FilterUIItem: Sendable, Identifiable {
  public let id: String
  public let title: String
  public let selected: Bool
  public let filterAction: FilterAction
}

public extension FilterUISection {
  enum Element: Sendable {
    case issuedSortingDate
    case sortBy
    case issuer(options: [String])
    case expiryPeriod
    case state

    var sectionTitle: LocalizableString.Key {
      switch self {
      case .issuedSortingDate:
        return .sortByIssuedDateSectionTitle
      case .sortBy:
        return .sortBy
      case .issuer:
          return .filterByIssuer
      case .expiryPeriod:
        return .selectExpiryPeriod
      case .state:
          return .filterByState
      }
    }

    var sorting: [String] {
      switch self {
      case .issuedSortingDate:
        return [
          LocalizableString.shared.get(with: .ascending),
          LocalizableString.shared.get(with: .descending)
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
          LocalizableString.shared.get(with: .defaultLabel),
          LocalizableString.shared.get(with: .dateIssued),
          LocalizableString.shared.get(with: .expiryDate)
        ]
      case .issuer(let options):
        return options
      case .expiryPeriod:
        return [
          LocalizableString.shared.get(with: .nextSevenDays),
          LocalizableString.shared.get(with: .nextThirtyDays),
          LocalizableString.shared.get(with: .beyondThiryDays),
          LocalizableString.shared.get(with: .beforeToday)
        ]
      case .state:
        return [
          LocalizableString.shared.get(with: .valid),
          LocalizableString.shared.get(with: .expired)
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
}
