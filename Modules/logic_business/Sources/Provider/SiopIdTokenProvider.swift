/*
 * Copyright (c) 2023 European Commission
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import SiopOpenID4VP
import CryptoKit
import Foundation
import JOSESwift

public protocol SiopIdTokenProviderType {
  func buildNonce() -> String
  func build(
    request: ResolvedRequestData,
    ttl: TimeInterval,
    kid: UUID
  ) throws -> JWTString
  func verifyAndDecode(jwt: String) throws -> HolderInfoDomain
}

public extension SiopIdTokenProviderType {
  func build(
    request: ResolvedRequestData
  ) throws -> JWTString {
    try build(request: request, ttl: 600.0, kid: UUID())
  }
}

public final class SiopIdTokenProvider: SiopIdTokenProviderType {

  private let configLogic: ConfigLogic
  private let privateKey: SecKey
  private let publicKey: SecKey

  public init(configLogic: ConfigLogic = ConfigProvider.shared.getConfigLogic()) {
    guard
      let privateKey = SiopIdTokenProvider.fetchPrivateKey(),
      let publicKey = SiopIdTokenProvider.fetchPublicKey(from: privateKey)
    else {
      fatalError("Unable to initialize SiopIdTokenProvider. Missing KeyPair")
    }
    self.configLogic = configLogic
    self.privateKey = privateKey
    self.publicKey = publicKey
  }

  public func verifyAndDecode(jwt: String) throws -> HolderInfoDomain {
    let jws = try getJWS(compactSerialization: jwt)
    guard
      try verify(jws: jws),
      let holderInfo = try? JSONDecoder().decode(HolderInfoDomain.self, from: jws.payload.data())
    else {
      throw SiopIdTokenError.invalidJWS
    }
    return holderInfo
  }

  public func buildNonce() -> String {
    return Data(ChaChaPoly.Nonce()).toNonceString()
  }

  public func build(
    request: ResolvedRequestData,
    ttl: TimeInterval,
    kid: UUID
  ) throws -> JWTString {

    var idTokenData: ResolvedRequestData.IdTokenData?
    switch request {
    case .idToken(request: let data):
      idTokenData = data
    default: throw SiopIdTokenError.notSupportedRequest
    }

    guard let idTokenData = idTokenData else {
      throw SiopIdTokenError.invalidIdTokenRequest
    }

    guard let walletConfiguration = configLogic.walletConfiguration else {
      throw SiopIdTokenError.invalidWalletConfig
    }

    guard let holderInfo = configLogic.holderInfo else {
      throw SiopIdTokenError.invalidHolderConfig
    }

    let rsaJWK = try RSAPublicKey(
      publicKey: publicKey,
      additionalParameters: [
        "use": "sig",
        "kid": kid.uuidString
      ]
    )

    let subjectJwk = JWKSet(keys: [rsaJWK])
    let (iat, exp) = computeTokenDates(ttl: ttl)
    let issuerClaim = try buildIssuerClaim(
      walletConfiguration: walletConfiguration,
      rsaJWK: rsaJWK
    )

    // NOTE: By SIOPv2 draft 12 issuer = subject
    let claimSet = try ([
      JWTClaimNames.issuer: issuerClaim,
      JWTClaimNames.subject: issuerClaim,
      JWTClaimNames.audience: idTokenData.clientId,
      JWTClaimNames.issuedAt: Int(iat.timeIntervalSince1970.rounded()),
      JWTClaimNames.expirationTime: Int(exp.timeIntervalSince1970.rounded()),
      "sub_jwk": subjectJwk.toDictionary()
    ] as [String: Any])
      .merging(holderInfo.toDictionary(), uniquingKeysWith: { _, new in
        new
      })
      .toThrowingJSONData()

    return try sign(
      payload: Payload(claimSet),
      kid: kid,
      signingKey: privateKey
    )
  }
}

fileprivate extension SiopIdTokenProvider {

  static func fetchPublicKey(from privateKey: SecKey) -> SecKey? {
    guard let publicKey = SecKeyCopyPublicKey(privateKey) else {
      return nil
    }
    return publicKey
  }

  static func fetchPrivateKey() -> SecKey? {

    guard
      let contents = "keypair.der".loadFileFromBundle()?.replacingOccurrences(of: "\n", with: ""),
      let data = Data(base64Encoded: contents)
    else {
      return nil
    }

    let attributes: [CFString: Any] = [
      kSecAttrKeyType: kSecAttrKeyTypeRSA,
      kSecAttrKeyClass: kSecAttrKeyClassPrivate
    ]

    var error: Unmanaged<CFError>?
    guard let secKey = SecKeyCreateWithData(data as CFData, attributes as CFDictionary, &error) else {
      if let error = error?.takeRetainedValue() {
        print("Failed to create SecKey:", error)
      }
      return nil
    }
    return secKey
  }
}

private extension SiopIdTokenProvider {

  func verifier(algorithhm: SignatureAlgorithm, publicKey: SecKey) throws -> Verifier {
    guard let verifier = Verifier(verifyingAlgorithm: .RS256, key: publicKey) else {
      throw SiopIdTokenError.invalidVerifier
    }
    return verifier
  }

  func signer(algorithhm: SignatureAlgorithm, privateKey: SecKey) throws -> Signer<SecKey> {
    guard let signer = Signer(signingAlgorithm: algorithhm, key: privateKey) else {
      throw SiopIdTokenError.invalidSigner
    }
    return signer
  }

  func computeTokenDates(ttl: TimeInterval) -> (Date, Date) {
    let iat = Date()
    let exp = iat.addingTimeInterval(ttl)
    return (iat, exp)
  }

  func buildIssuerClaim(
    walletConfiguration: WalletOpenId4VPConfiguration,
    rsaJWK: RSAPublicKey
  ) throws -> String {
    switch walletConfiguration.preferredSubjectSyntaxType {
    case .jwkThumbprint:
      return try rsaJWK.thumbprint(algorithm: .SHA256)
    case .decentralizedIdentifier:
      return walletConfiguration.decentralizedIdentifier.stringValue
    }
  }

  func sign(
    payload: Payload,
    kid: UUID,
    signingKey: SecKey
  ) throws -> JWTString {
    let header = try JWSHeader(
      parameters: [
        "alg": SignatureAlgorithm.RS256.rawValue,
        "kid": kid.uuidString
      ]
    )

    let signer = try self.signer(
      algorithhm: .RS256,
      privateKey: signingKey
    )

    return try JWS(
      header: header,
      payload: payload,
      signer: signer
    ).compactSerializedString
  }

  func verify(jws: JWS) throws -> Bool {
    let verifier = try self.verifier(algorithhm: .RS256, publicKey: publicKey)
    return try jws.validate(using: verifier).isValid(for: verifier)
  }

  func getJWS(compactSerialization: String) throws -> JWS {
    guard let jws = try? JWS(compactSerialization: compactSerialization) else {
      throw JOSEError.invalidJWS
    }
    return jws
  }
}

fileprivate extension Data {
  func toNonceString() -> String {
    return self.base64EncodedString()
      .replacingOccurrences(of: "+", with: "-")
      .replacingOccurrences(of: "/", with: "_")
      .trimmingCharacters(in: CharacterSet(charactersIn: "="))
  }
}
