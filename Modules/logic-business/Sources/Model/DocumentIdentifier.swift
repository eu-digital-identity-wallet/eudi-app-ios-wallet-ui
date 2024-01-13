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
import MdocDataModel18013
import logic_resources

public enum DocumentIdentifier: RawRepresentable, Equatable {

  case EuPidDocType
  case IsoMdlModel
  case genericDocument(docType: String)

  public var localizedTitle: String {
    return switch self {
    case .EuPidDocType:
      LocalizableString.shared.get(with: .pid)
    case .IsoMdlModel:
      LocalizableString.shared.get(with: .mdl)
    case .genericDocument(let docType):
      LocalizableString.shared.get(with: .dynamic(key: docType))
    }
  }

  public var rawValue: String {
    return switch self {
    case .EuPidDocType:
      MdocDataModel18013.EuPidModel.euPidDocType
    case .IsoMdlModel:
      MdocDataModel18013.IsoMdlModel.isoDocType
    case .genericDocument(let docType):
      docType
    }
  }

  public init(rawValue: String) {
    switch rawValue {
    case MdocDataModel18013.EuPidModel.euPidDocType:
      self = .EuPidDocType
    case MdocDataModel18013.IsoMdlModel.isoDocType:
      self = .IsoMdlModel
    default:
      self = .genericDocument(docType: rawValue)
    }
  }
}
