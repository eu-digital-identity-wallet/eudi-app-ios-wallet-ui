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
import SiopOpenID4VP
import logic_business

protocol AuthorizationUseCaseType {
  func process(_ link: String, delayInMillis: Int?) async -> AuthorizationProcessPartialState
  func dispatch(
    _ resolved: ResolvedRequestData,
    isPositive: Bool,
    delayInMillis: Int?
  ) async throws -> AuthorizationDispatchPartialState
}

final class AuthorizationUseCase: AuthorizationUseCaseType {

  // Initialize SiopOpenID4VP
  private let siopOpenID4VP: SiopOpenID4VPType

  // Initialize SiopIdTokenProvider
  private let provider: SiopIdTokenProviderType

  private let configLogic: ConfigLogic

  init(
    configLogic: ConfigLogic = ConfigProvider.shared.getConfigLogic(),
    siopOpenID4VP: SiopOpenID4VPType = SiopOpenID4VP(),
    provider: SiopIdTokenProviderType = SiopIdTokenProvider()
  ) {
    self.configLogic = configLogic
    self.siopOpenID4VP = siopOpenID4VP
    self.provider = provider
  }

  func process(_ link: String, delayInMillis: Int?) async -> AuthorizationProcessPartialState {

    if let delayInMillis {
      try? await Task.sleep(for: .milliseconds(delayInMillis))
    }

    do {

      guard let url = URL(string: link) else {
        throw RuntimeError.customError("URL is invalid")
      }

      let authRequest = try await self.siopOpenID4VP.authorize(url: url)

      var resolveData: ResolvedRequestData {
        switch authRequest {
        case .notSecured(let data):
          return data
        case .jwt(let request):
          return request
        }
      }

      switch resolveData {
      case .vpToken(let request):
        return .success(resolveData, request.clientId)
      case .idToken(let request):
        return .success(resolveData, request.clientId)
      default:
        throw RuntimeError.notSupported
      }

    } catch {
      return .failure(error.localizedDescription)
    }
  }

  func dispatch(
    _ resolved: ResolvedRequestData,
    isPositive: Bool,
    delayInMillis: Int?
  ) async throws -> AuthorizationDispatchPartialState {
    do {

      if let delayInMillis {
        try? await Task.sleep(for: .milliseconds(delayInMillis))
      }

      var consensus: ClientConsent = .negative(message: "user cancelled flow")

      if isPositive {
        switch resolved {
        case .idToken:
          let jwtString = try self.provider.build(request: resolved)
          consensus = .idToken(idToken: jwtString)
        case .vpToken:
          consensus = .vpToken(
            vpToken: "dummy_vp_token",
            presentationSubmission: .init(
              id: "dummy_id",
              definitionID: "dummy_definition_id",
              descriptorMap: []
            )
          )
        default:
          throw RuntimeError.notSupported
        }
      }

      let response: AuthorizationResponse = try .init(
        resolvedRequest: resolved,
        consent: consensus,
        walletOpenId4VPConfig: configLogic.walletConfiguration
      )

      let outcome = try await self.siopOpenID4VP.dispatch(response: response)

      switch outcome {
      case .accepted(let redirectURI):
        return .success(redirectURI)
      case .rejected:
        return .success(nil)
      }

    } catch {
      return .failure(error.localizedDescription)
    }
  }
}

enum AuthorizationProcessPartialState {
  case success(ResolvedRequestData, String)
  case failure(String)
}

enum AuthorizationDispatchPartialState {
  case success(URL?)
  case failure(String)
}
