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
import logic_resources
import OrderedCollections

public typealias DocumentCategories = OrderedDictionary<DocumentCategory, [DocumentTypeIdentifier]>

public enum DocumentCategory: Sendable, Equatable {
  case Government
  case Travel
  case Finance
  case Education
  case Health
  case SocialSecurity
  case Retail
  case Other

  public var title: LocalizableString.Key {
    return switch self {
    case .Government:
        .categoryGovernment
    case .Travel:
        .categoryTravel
    case .Finance:
        .categoryFinance
    case .Education:
        .categoryEducation
    case .Health:
        .categoryHealth
    case .SocialSecurity:
        .categorySocialSecurity
    case .Retail:
        .categoryRetail
    case .Other:
        .categoryOther
    }
  }

  public var filterAttribute: String {
    return switch self {
    case .Government:
        LocalizableString.shared.get(with: .categoryGovernment)
    case .Travel:
        LocalizableString.shared.get(with: .categoryTravel)
    case .Finance:
        LocalizableString.shared.get(with: .categoryFinance)
    case .Education:
        LocalizableString.shared.get(with: .categoryEducation)
    case .Health:
        LocalizableString.shared.get(with: .categoryHealth)
    case .SocialSecurity:
        LocalizableString.shared.get(with: .categorySocialSecurity)
    case .Retail:
        LocalizableString.shared.get(with: .categoryRetail)
    case .Other:
        LocalizableString.shared.get(with: .categoryOther)
    }
  }

  public var order: Int {
    return switch self {
    case .Government:
      1
    case .Travel:
      2
    case .Finance:
      3
    case .Education:
      4
    case .Health:
      5
    case .SocialSecurity:
      6
    case .Retail:
      7
    case .Other:
      8
    }
  }
}
