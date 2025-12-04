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

public protocol WalletAttestationRepository: Sendable {
  func issueWalletUnitAttestation(host: String, payload: Data) async throws -> WalletUnitAttestation
  func issueWalletInstanceAttestation(host: String, payload: Data) async throws -> WalletInstanceAttestation
}

final class WalletAttestationRepositoryImpl: WalletAttestationRepository {

  private let networkManager: NetworkManager

  init(networkManager: NetworkManager) {
    self.networkManager = networkManager
  }

  func issueWalletUnitAttestation(host: String, payload: Data) async throws -> WalletUnitAttestation {
    try await networkManager.execute(with: WalletUnitAttestationApi(request: payload, host: host), parameters: nil)
  }

  func issueWalletInstanceAttestation(host: String, payload: Data) async throws -> WalletInstanceAttestation {
    try await networkManager.execute(with: WalletInstanceAttestationApi(request: payload, host: host), parameters: nil)
  }
}
