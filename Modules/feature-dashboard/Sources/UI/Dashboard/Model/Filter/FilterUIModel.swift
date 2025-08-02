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
  public let startDate: Date?
  public let endDate: Date?
  public let filterAction: FilterAction
  public let filterSectionType: FilterElementType

  init(
    id: String,
    title: String,
    selected: Bool,
    startDate: Date? = nil,
    endDate: Date? = nil,
    filterAction: FilterAction,
    filterSectionType: FilterElementType
  ) {
    self.id = id
    self.title = title
    self.selected = selected
    self.startDate = startDate
    self.endDate = endDate
    self.filterAction = filterAction
    self.filterSectionType = filterSectionType
  }
}

public extension FilterUISection {
  enum Element: Sendable {
    case issuedSortingDate
    case sortBy
    case issuer(options: [String])
    case expiryPeriod
    case state

    var sectionTitle: LocalizableStringKey {
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
          LocalizableStringKey.ascending.toString,
          LocalizableStringKey.descending.toString
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
          LocalizableStringKey.defaultLabel.toString,
          LocalizableStringKey.dateIssued.toString,
          LocalizableStringKey.expiryDate.toString
        ]
      case .issuer(let options):
        return options
      case .expiryPeriod:
        return [
          LocalizableStringKey.nextSevenDays.toString,
          LocalizableStringKey.nextThirtyDays.toString,
          LocalizableStringKey.beyondThiryDays.toString,
          LocalizableStringKey.beforeToday.toString
        ]
      case .state:
        return [
          LocalizableStringKey.valid.toString,
          LocalizableStringKey.expired.toString
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
