/*
 * Copyright (c) 2023 European Commission
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
@preconcurrency import Combine

public extension Publisher where Self.Failure == Never, Self.Output: Sendable {
  func toAsyncStream() -> AsyncStream<Self.Output> {
    return AsyncStream(bufferingPolicy: .bufferingNewest(1)) { continuation in

      let cancellable = self
        .sink(
          receiveCompletion: { _ in
            continuation.finish()
          },
          receiveValue: { value in
            _ = continuation.yield(value)
          }
        )
      continuation.onTermination = { _ in
        cancellable.cancel()
      }
    }
  }
}
