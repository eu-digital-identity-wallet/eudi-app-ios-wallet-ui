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

public struct IssuanceFlowUiConfig: UIConfigType, Equatable {

  public let flow: Flow
  public let credentialOfferUri: String?

  public var log: String {
    return "flow: \(flow.rawValue)" +
    " credentialOfferUri: \(credentialOfferUri.orEmpty)"
  }

  public var isNoDocumentFlow: Bool {
    self.flow == .noDocument
  }

  public var isExtraDocumentFlow: Bool {
    self.flow == .extraDocument
  }

  public init(flow: Flow, credentialOfferUri: String? = nil) {
    self.flow = flow
    self.credentialOfferUri = credentialOfferUri
  }

  public func copy(
    flow: Flow? = nil,
    credentialOfferUri: String? = nil
  ) -> IssuanceFlowUiConfig {
    return .init(
      flow: flow ?? self.flow,
      credentialOfferUri: credentialOfferUri ?? self.credentialOfferUri
    )
  }
}

public extension IssuanceFlowUiConfig {
  enum Flow: String, Equatable {
    case noDocument
    case extraDocument
  }
}
