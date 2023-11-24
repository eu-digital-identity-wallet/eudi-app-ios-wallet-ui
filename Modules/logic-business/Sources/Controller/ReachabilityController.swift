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
