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
import logic_ui
import logic_business

public struct IssuanceDetailUiConfig: UIConfigType, Equatable {

  public let flow: Flow

  public var log: String {
    return "flow: \(flow.key)"
  }

  public init(flow: Flow) {
    self.flow = flow
  }

  public var documentId: String {
    switch self.flow {
    case .noDocument(let id):
      return id
    case .extraDocument(let id):
      return id
    }
  }

  public var isExtraDocument: Bool {
    switch self.flow {
    case .noDocument:
      return false
    case .extraDocument:
      return true
    }
  }
}

public extension IssuanceDetailUiConfig {
  enum Flow: Equatable, ThreadSafeObject {

    case noDocument(String)
    case extraDocument(String)

    var key: String {
      return switch self {
      case .noDocument(let id):
        "Type: noDocument Id: \(id)"
      case .extraDocument(let id):
        "Type: extraDocument Id: \(id)"
      }
    }
  }
}
