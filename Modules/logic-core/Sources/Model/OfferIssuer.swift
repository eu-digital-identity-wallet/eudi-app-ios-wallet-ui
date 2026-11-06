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
import OpenID4VCI
import logic_business

/// The issuer a credential offer link comes from, read from the link alone before anything is fetched, so that the
/// wallet contacts no host other than a configured issuer's and never gives one issuer's client settings to another;
/// as the Android wallet's `offerIssuerOf`, the link is read with the OpenID4VCI library's own parser. An offer the
/// wallet fetched from such a link is turned into a link that carries it by value (`byValueLink(offerUri:offer:)`)
/// and read again.
public enum OfferIssuer: Equatable, Sendable {
  case configured(String)
  case notConfigured
  /// The link carries no offer, carries it more than once in any spelling, or spells it otherwise than the
  /// OpenID4VCI library reads it.
  case unreadable

  /// An offer passed by value (`credential_offer`) must name one of `configuredIssuers` as its `credential_issuer`,
  /// compared exactly. An offer passed by reference (`credential_offer_uri`) is fetched from that address, so the
  /// address must be `https` on the origin of a configured issuer, which is then returned; the offer fetched from
  /// there is checked by value in turn (`WalletKitController.resolveOfferUrlDocTypes(offerUri:)`).
  public static func of(offerUri: String, configuredIssuers: [String]) -> OfferIssuer {
    let offerParameterNames = ["credential_offer", "credential_offer_uri"]
    let offerParameters = URL(string: offerUri)
      .flatMap { URLComponents(url: $0, resolvingAgainstBaseURL: false)?.queryItems }?
      .filter { offerParameterNames.contains($0.name.lowercased()) } ?? []
    guard
      offerParameters.count == 1,
      let parameter = offerParameters.first,
      offerParameterNames.contains(parameter.name),
      parameter.value?.isEmpty == false,
      let request = try? CredentialOfferRequest(urlString: offerUri)
    else {
      return .unreadable
    }
    switch request {
    case .passByValue(let metaData):
      guard let issuer = CredentialOfferRequestObject(jsonString: metaData)?.credentialIssuer else {
        return .unreadable
      }
      return configuredIssuers.contains(issuer) ? .configured(issuer) : .notConfigured
    case .fetchByReference(let reference):
      guard reference.isHttpsWebLink else {
        return .notConfigured
      }
      let issuer = configuredIssuers.first { issuer in
        URL(string: issuer).map { $0.isHttpsWebLink && $0.hasSameOrigin(as: reference) } ?? false
      }
      return issuer.map(OfferIssuer.configured) ?? .notConfigured
    }
  }

  /// Throws `WalletCoreError.issuerNotConfigured` unless `offerUri` comes from one of `configuredIssuers`.
  public static func requireConfigured(offerUri: String, configuredIssuers: [String]) throws {
    guard case .configured = of(offerUri: offerUri, configuredIssuers: configuredIssuers) else {
      throw WalletCoreError.issuerNotConfigured
    }
  }

  /// `offerUri` with its whole query replaced by `offer`, the JSON of an offer the wallet fetched itself, passed by
  /// value (`credential_offer`), and its fragment dropped, so that the OpenID4VCI library reads that offer and fetches
  /// nothing more for it. Every character of the offer outside the unreserved set is percent-encoded, so `&`, `=`, `+`
  /// or `#` in it keep their meaning.
  public static func byValueLink(offerUri: String, offer: String) -> String? {
    let unreserved = CharacterSet(
      charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~"
    )
    guard
      var components = URLComponents(string: offerUri),
      let value = offer.addingPercentEncoding(withAllowedCharacters: unreserved)
    else {
      return nil
    }
    components.percentEncodedQueryItems = [URLQueryItem(name: "credential_offer", value: value)]
    components.fragment = nil
    return components.string
  }
}
