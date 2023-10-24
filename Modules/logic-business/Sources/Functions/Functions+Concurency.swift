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

public func delayFor<Value>(atLeast: TimeInterval, task: @escaping () async throws -> Value) async throws -> Result<Value, any Error> {
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
