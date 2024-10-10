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

public enum DocumentTypeIdentifier: RawRepresentable, Equatable, Sendable {

  case PID
  case MDL
  case AGE
  case PHOTOID
  case GENERIC(docType: String)

  public var localizedTitle: String {
    return switch self {
    case .PID:
      LocalizableString.shared.get(with: .pid)
    case .MDL:
      LocalizableString.shared.get(with: .mdl)
    case .AGE:
      LocalizableString.shared.get(with: .ageVerification)
    case .PHOTOID:
      LocalizableString.shared.get(with: .photoId)
    case .GENERIC(let docType):
      LocalizableString.shared.get(with: .dynamic(key: docType))
    }
  }

  public var rawValue: String {
    return switch self {
    case .PID:
      Self.pidDocType
    case .MDL:
      Self.mdlDocType
    case .AGE:
      Self.ageDocType
    case .PHOTOID:
      Self.photoIdDocType
    case .GENERIC(let docType):
      docType
    }
  }

  public var isSupported: Bool {
    return switch self {
    case .PID, .MDL, .AGE, .PHOTOID: true
    case .GENERIC: false
    }
  }

  public init(rawValue: String) {
    switch rawValue {
    case Self.pidDocType:
      self = .PID
    case Self.mdlDocType:
      self = .MDL
    case Self.ageDocType:
      self = .AGE
    case Self.photoIdDocType:
      self = .PHOTOID
    default:
      self = .GENERIC(docType: rawValue)
    }
  }
}

private extension DocumentTypeIdentifier {
  static let pidDocType = "eu.europa.ec.eudi.pid.1"
  static let mdlDocType = "org.iso.18013.5.1.mDL"
  static let ageDocType = "eu.europa.ec.eudi.pseudonym.age_over_18.1"
  static let photoIdDocType = "org.iso.23220.2.photoid.1"
}
