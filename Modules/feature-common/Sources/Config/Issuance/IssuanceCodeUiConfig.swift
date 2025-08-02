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

public struct IssuanceCodeUiConfig: UIConfigType, Equatable {

  public let offerUri: String
  public let issuerName: String
  public let txCodeLength: Int
  public let docOffers: [OfferedDocModel]
  public let successNavigation: UIConfig.TwoWayNavigationType
  public let navigationCancelType: UIConfig.ThreeWayNavigationType

  public var log: String {
    return "offerUri: \(offerUri)" +
    " issuerName: \(issuerName)" +
    " txCodeLength: \(txCodeLength)" +
    " docOffers \(docOffers.map { $0.displayName }.joined(separator: ",") )" +
    " onSuccessNav: \(successNavigation.key)" +
    " onBackNav: \(navigationCancelType.key)"
  }

  public init(
    offerUri: String,
    issuerName: String,
    txCodeLength: Int,
    docOffers: [OfferedDocModel],
    successNavigation: UIConfig.TwoWayNavigationType,
    navigationCancelType: UIConfig.ThreeWayNavigationType
  ) {
    self.offerUri = offerUri
    self.issuerName = issuerName
    self.txCodeLength = txCodeLength
    self.docOffers = docOffers
    self.successNavigation = successNavigation
    self.navigationCancelType = navigationCancelType
  }
}
