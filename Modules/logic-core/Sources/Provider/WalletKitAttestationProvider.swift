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
import logic_api
import JOSESwift
import Foundation

protocol WalletKitAttestationProvider: WalletAttestationsProvider {
  var baseUrl: String { get }
  func getWalletAttestation(key: any JOSESwift.JWK) async throws -> String
  func getKeysAttestation(keys: [any JOSESwift.JWK], nonce: String?) async throws -> String
}

final class WalletKitAttestationProviderImpl: WalletKitAttestationProvider {

  let repository: WalletAttestationRepository
  let baseUrl: String

  init(with repository: WalletAttestationRepository, and configLogic: WalletProviderAttestationConfig) {
    self.repository = repository
    self.baseUrl = configLogic.walletProviderAttestationUrl
  }

  func getWalletAttestation(key: any JOSESwift.JWK) async throws -> String {

    let jwkDict = try key.toDictionary()
    let payload = ["jwk": jwkDict]

    let encodedPayload = try JSONSerialization.data(withJSONObject: payload, options: [])

    let response = try await repository.issueWalletInstanceAttestation(host: self.baseUrl, payload: encodedPayload)
    return response.walletInstanceAttestation
  }

  func getKeysAttestation(keys: [any JOSESwift.JWK], nonce: String?) async throws -> String {

    let jwkDict = try keys.map { try $0.toDictionary() }

    var payload: [String: Any] = [
      "jwkSet": [
        "keys": jwkDict
      ]
    ]

    if let nonce {
      payload["nonce"] = nonce
    }

    let encodedPayload = try JSONSerialization.data(withJSONObject: payload, options: [])

    let response = try await repository.issueWalletUnitAttestation(host: self.baseUrl, payload: encodedPayload)
    return response.walletUnitAttestation
  }
}
