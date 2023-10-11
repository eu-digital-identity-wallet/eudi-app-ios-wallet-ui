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
import Combine
import Network

public final class ReachabilityController: ObservableObject {

  public static let shared = ReachabilityController()

  @Published public private(set) var currentPath: NWPath

  public private(set) lazy var publisher = makePublisher()
  public private(set) lazy var stream = makeStream()

  private let monitor: NWPathMonitor
  private lazy var subject = CurrentValueSubject<NWPath, Never>(monitor.currentPath)
  private var subscription: AnyCancellable?

  public init(
    requiredInterfaceType: NWInterface.InterfaceType? = nil,
    prohibitedInterfaceTypes: [NWInterface.InterfaceType]? = nil,
    queue: DispatchQueue = .main) {

      precondition(!(requiredInterfaceType != nil && prohibitedInterfaceTypes != nil), "Parameter combination not supported")

      if let requiredInterfaceType = requiredInterfaceType {
        monitor = NWPathMonitor(requiredInterfaceType: requiredInterfaceType)
      } else if let prohibitedInterfaceTypes = prohibitedInterfaceTypes {
        monitor = NWPathMonitor(prohibitedInterfaceTypes: prohibitedInterfaceTypes)
      } else {
        monitor = NWPathMonitor()
      }

      currentPath = monitor.currentPath

      monitor.pathUpdateHandler = { [weak self] path in
        self?.currentPath = path
        self?.subject.send(path)
      }

      monitor.start(queue: queue)
    }

  deinit {
    monitor.cancel()
    subject.send(completion: .finished)
  }

  private func makePublisher() -> AnyPublisher<NWPath, Never> {
    return subject.eraseToAnyPublisher()
  }

  private func makeStream() -> AsyncStream<NWPath> {
    return AsyncStream { continuation in
      var subscription: AnyCancellable?

      subscription = subject.sink { _ in
        continuation.finish()
      } receiveValue: { value in
        continuation.yield(value)
      }

      self.subscription = subscription
    }
  }
}

extension NWPath {
  public var isReachable: Bool { status == .satisfied }
}
