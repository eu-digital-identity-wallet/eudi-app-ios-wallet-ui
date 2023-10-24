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
import logic_api
import logic_business

public protocol StartupInteractorType {
  func splashSetup(splashAnimationDuration: TimeInterval) async -> SplashSetupPartialState
  func sampleCall() async -> SamplePartialState
}

public final actor StartupInteractor: StartupInteractorType {

  private let repository: SampleRepositoryType

  public init(with repository: SampleRepositoryType = SampleRepository()) {
    self.repository = repository
  }

  public func sampleCall() async -> SamplePartialState {
    do {
      let response = try await repository.sampleCall()
      return .success(response)
    } catch {
      return .failure(error)
    }
  }

  public func splashSetup(splashAnimationDuration: TimeInterval) async -> SplashSetupPartialState {
    do {
      switch try await delayFor(atLeast: splashAnimationDuration, task: setupCalls) {
      case .success(let value):
        return .success
      case .failure(let error):
        throw error
      }
    } catch {
      return .failure(error)
    }
  }

  private func setupCalls() async throws {
    // TODO: Add any calls we might need to do during splash animation?
    await self.sampleCall()
    try await Task.sleep(nanoseconds: 1_750_000_000)
  }

}
public enum SamplePartialState {
  case success(_ response: SampleResponseDTO)
  case failure(_ error: Error)
}

public enum SplashSetupPartialState {
  case success
  case failure(_ error: Error)
}
