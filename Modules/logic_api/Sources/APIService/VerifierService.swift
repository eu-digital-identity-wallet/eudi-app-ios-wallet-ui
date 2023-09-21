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
import Foundation
import PresentationExchange

public protocol VerifierServiceType {
  func initiate(
    type: String,
    idTokenType: String?,
    responseMode: String?,
    nonce: String,
    definition: PresentationDefinition?
  ) async throws -> InitiateResponseDTO

  func idStatus(
    id: String,
    nonce: String
  ) async throws -> IdStatusResponseDTO

  func vpStatus(
    id: String,
    nonce: String
  ) async throws -> VpStatusResponseDTO
}

public final class VerifierService: VerifierServiceType {

  public init() {}

  public func initiate(
    type: String,
    idTokenType: String?,
    responseMode: String?,
    nonce: String,
    definition: PresentationDefinition?
  ) async throws -> InitiateResponseDTO {
    let request = InitiateRequest(
      request: .init(
        type: type,
        id_token_type: idTokenType,
        response_mode: responseMode,
        nonce: nonce,
        presentation_definition: definition
      )
    )
    return try await NetworkManager.shared.execute(with: request)
  }

  public func idStatus(id: String, nonce: String) async throws -> IdStatusResponseDTO {
    let request = StatusRequest(id: id)
    return try await NetworkManager.shared.execute(
      with: request,
      parameters: [.init(key: "nonce", value: nonce)]
    )
  }

  public func vpStatus(id: String, nonce: String) async throws -> VpStatusResponseDTO {
    let request = StatusRequest(id: id)
    return try await NetworkManager.shared.execute(
      with: request,
      parameters: [.init(key: "nonce", value: nonce)]
    )
  }
}
