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
import SwiftUI

public enum DocumentElementClaim: Sendable, Equatable {

  case group(
    id: String,
    title: String,
    items: [DocumentElementClaim]
  )
  case primitive(
    id: String,
    title: String,
    documentId: String,
    nameSpace: String?,
    path: [String],
    type: DocumentElementType,
    value: DocumentElementValue,
    status: DocumentElementClaim.Status
  )

  public var id: String {
    return switch self {
    case .group(let id, _, _):
      id
    case .primitive(let id, _, _, _, _, _, _, _):
      id
    }
  }

  public var title: String {
    return switch self {
    case .group(_, let title, _):
      title
    case .primitive(_, let title, _, _, _, _, _, _):
      title
    }
  }

  public var path: [String]? {
    return switch self {
    case .group:
      nil
    case .primitive(_, _, _, _, let path, _, _, _):
      path
    }
  }

  public var documentId: String? {
    return switch self {
    case .group:
      nil
    case .primitive(_, _, let documentId, _, _, _, _, _):
      documentId
    }
  }

  public var nameSpace: String? {
    return switch self {
    case .group:
      nil
    case .primitive(_, _, _, let nameSpace, _, _, _, _):
      nameSpace
    }
  }

  public var type: DocumentElementType? {
    return switch self {
    case .group:
      nil
    case .primitive(_, _, _, _, _, let type, _, _):
      type
    }
  }
}

public extension DocumentElementClaim {

  enum `Status`: Sendable, Equatable {
    case available(isRequired: Bool)
    case notAvailable

    public var isRequired: Bool {
      return switch self {
      case .available(let isRequired):
        isRequired
      case .notAvailable:
        false
      }
    }

    public var isAvailable: Bool {
      return switch self {
      case .available:
        true
      case .notAvailable:
        false
      }
    }
  }
}

public enum DocumentElementValue: Sendable, Equatable {
  case string(String)
  case unavailable(String)
  case image(Image)

  public var string: String? {
    switch self {
    case .string(let string):
      return string
    case .unavailable(let string):
      return string
    default:
      return nil
    }
  }

  public var image: Image? {
    switch self {
    case .image(let image):
      return image
    default:
      return nil
    }
  }
}

public enum DocumentElementType: Equatable, Sendable {
  case mdoc
  case sdjwt
}
