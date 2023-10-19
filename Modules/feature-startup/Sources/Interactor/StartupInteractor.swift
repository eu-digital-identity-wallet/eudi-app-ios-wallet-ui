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

public protocol StartupInteractorType {
  func splashSetup(splashAnimationDuration: TimeInterval) async throws -> SplashSetupPartialState
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

  public func splashSetup(splashAnimationDuration: TimeInterval) async throws -> SplashSetupPartialState {
    switch try await delayFor(atLeast: splashAnimationDuration, task: setupCalls) {
    case .success(let value):
      return .success(value)
    case .failure(let error):
      return .failure(error)
    }
  }

  private func setupCalls() async throws -> Int {
    // TODO: Add any calls we might need to do during splash animation?
    try await Task.sleep(nanoseconds: 1_750_000_000)
    return 1
  }

}
public enum SamplePartialState {
  case success(_ response: SampleResponseDTO)
  case failure(_ error: Error)
}

public enum SplashSetupPartialState {
  case success(_ response: Int)
  case failure(_ error: Error)
}

private func delayFor<Value>(atLeast: TimeInterval, task: @escaping () async throws -> Value) async throws -> Result<Value, any Error> {
  // Record the starting time
  let start = DispatchTime.now().uptimeNanoseconds

  // Start the async task
  let task = Task { try await task() }
  // Minimum time to wait in nanoseconds
  let minimumTime: UInt64 = UInt64(atLeast * 1_000_000_000)

  // Fetch result from the task
  if let result = try? await task.value {
    // Record the ending time
    let end = DispatchTime.now().uptimeNanoseconds

    // Calculate the elapsed time
    let elapsed = end - start
    // If the elapsed time is less than the minimum time, sleep the remaining time of the animation
    if elapsed < minimumTime {
      let remaining = minimumTime - elapsed
      try await Task.sleep(nanoseconds: remaining)
    }

    return .success(result)
  } else {
    return await task.result
  }
}
