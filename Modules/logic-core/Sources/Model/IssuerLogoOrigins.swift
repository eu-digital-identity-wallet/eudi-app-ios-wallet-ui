/*
 * Copyright (c) 2026 European Commission
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

/// Where an issuer's logo may load from, as the Android wallet's `getIssuerLogo`: the issuer's own origin and the
/// `VciConfig.logoOrigins` of that issuer only, so that one issuer's metadata cannot point the wallet at another
/// issuer's origins.
public struct IssuerLogoOrigins: Equatable, Sendable {

  /// Each configured issuer's `credentialIssuerURL`, with its `VciConfig.logoOrigins`.
  public let logoOriginsByIssuer: [String: [String]]

  public init(logoOriginsByIssuer: [String: [String]]) {
    self.logoOriginsByIssuer = logoOriginsByIssuer
  }

  /// The origins the logo of a document issued by `issuerIdentifier` may load from; none without an issuer.
  public func origins(ofIssuer issuerIdentifier: String?) -> [String] {
    guard let issuerIdentifier else { return [] }
    return [issuerIdentifier] + (logoOriginsByIssuer[issuerIdentifier] ?? [])
  }

  /// The origins the logo of the offer behind `offerUri` may load from: its configured issuer's
  /// (`OfferIssuer`), or none.
  public func origins(ofOffer offerUri: String) -> [String] {
    guard
      case .configured(let issuer) = OfferIssuer.of(
        offerUri: offerUri,
        configuredIssuers: Array(logoOriginsByIssuer.keys)
      )
    else {
      return []
    }
    return origins(ofIssuer: issuer)
  }
}
