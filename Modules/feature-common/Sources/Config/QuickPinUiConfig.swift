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
import logic_ui

public struct QuickPinUiConfig: UIConfigType, Equatable {

  public let flow: Flow

  public var log: String {
    return "flow: \(flow.rawValue)"
  }

  public var isSetFlow: Bool {
    self.flow == .set
  }

  public var isUpdateFlow: Bool {
    self.flow == .update
  }

  public init(flow: Flow) {
    self.flow = flow
  }
}

public extension QuickPinUiConfig {
  enum Flow: String, Equatable, Sendable {
    case set
    case update
  }
}
