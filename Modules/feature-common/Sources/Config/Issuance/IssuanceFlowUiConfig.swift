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
import logic_ui
import logic_core

public struct IssuanceFlowUiConfig: UIConfigType, Equatable {

  public let flow: Flow

  public var log: String {
    switch flow {
    case .noDocument:
      return "flow: noDocument"
    case .extraDocument(let identifier):
      return "flow: extraDocument(\(identifier?.rawValue ?? ""))"
    }
  }

  public var isNoDocumentFlow: Bool {
    if case .noDocument = flow {
      return true
    }
    return false
  }

  public var isExtraDocumentFlow: Bool {
    if case .extraDocument = flow {
      return true
    }
    return false
  }

  public init(flow: Flow) {
    self.flow = flow
  }
}

public extension IssuanceFlowUiConfig {
  enum Flow: Equatable, Sendable {
    case noDocument
    case extraDocument(filterType: DocumentTypeIdentifier?)
  }
}
