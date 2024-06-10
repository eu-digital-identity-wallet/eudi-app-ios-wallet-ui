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

public enum DocumentTypeIdentifier: RawRepresentable, Equatable {

  case PID
  case MDL
  case AGE
  case GENERIC(docType: String)

  public var localizedTitle: String {
    return switch self {
    case .PID:
      LocalizableString.shared.get(with: .pid)
    case .MDL:
      LocalizableString.shared.get(with: .mdl)
    case .AGE:
      LocalizableString.shared.get(with: .ageVerification)
    case .GENERIC(let docType):
      LocalizableString.shared.get(with: .dynamic(key: docType))
    }
  }

  public var rawValue: String {
    return switch self {
    case .PID:
      "eu.europa.ec.eudiw.pid.1"
    case .MDL:
      "org.iso.18013.5.1.mDL"
    case .AGE:
      "eu.europa.ec.eudiw.pseudonym.age_over_18.1"
    case .GENERIC(let docType):
      docType
    }
  }

  public var isSupported: Bool {
    return switch self {
    case .PID, .MDL, .AGE: true
    case .GENERIC: false
    }
  }

  public init(rawValue: String) {
    switch rawValue {
    case "eu.europa.ec.eudiw.pid.1":
      self = .PID
    case "org.iso.18013.5.1.mDL":
      self = .MDL
    case "eu.europa.ec.eudiw.pseudonym.age_over_18.1":
      self = .AGE
    default:
      self = .GENERIC(docType: rawValue)
    }
  }
}
