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
import Foundation

struct WalletInstanceAttestationApi: NetworkRequest {
  typealias Response = WalletInstanceAttestation

  var method: NetworkMethod { .POST }
  var additionalHeaders: [String: String] {[:]}
  var path: String { "wallet-instance-attestation/jwk" }

  var body: Data? {
    return request
  }
  let request: Data
  let host: String
}

struct WalletUnitAttestationApi: NetworkRequest {
  typealias Response = WalletUnitAttestation

  var method: NetworkMethod { .POST }
  var additionalHeaders: [String: String] {[:]}
  var path: String { "wallet-unit-attestation/jwk-set" }

  var body: Data? {
    return request
  }
  let request: Data
  let host: String
}
