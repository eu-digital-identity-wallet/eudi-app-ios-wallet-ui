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

public enum DocumentTypeIdentifier: RawRepresentable, Equatable, Sendable {

  case mDocPid
  case sdJwtPid
  case other(formatType: String)

  public var rawValue: String {
    return switch self {
    case .mDocPid:
      Self.mDocPidDocType
    case .sdJwtPid:
      Self.sdJwtPidDocType
    case .other(let formatType):
      formatType
    }
  }

  public init(rawValue: String) {
    switch rawValue {
    case Self.mDocPidDocType:
      self = .mDocPid
    case Self.sdJwtPidDocType:
      self = .sdJwtPid
    default:
      self = .other(formatType: rawValue)
    }
  }
}

private extension DocumentTypeIdentifier {
  static let mDocPidDocType = "eu.europa.ec.eudi.pid.1"
  static let sdJwtPidDocType = "urn:eudi:pid:1"
}
