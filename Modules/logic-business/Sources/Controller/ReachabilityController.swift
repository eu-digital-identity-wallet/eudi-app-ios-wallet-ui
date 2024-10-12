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
import BluetoothKit
import UIKit

public protocol ReachabilityController: Sendable {
  func hasInternet() -> Bool
  func getBleAvailibity() -> AnyPublisher<Reachability.BleAvailibity, Never>
  @MainActor func openBleSettings()
}

final class ReachabilityControllerImpl: ReachabilityController, BKAvailabilityObserver, ObservableObject, @unchecked Sendable {

  @Published private var networkPath: NWPath
  @Published private var bleAvailibity: Reachability.BleAvailibity = .unavailable

  private let sendableAnyCancellable: SendableAnyCancellable = .init()

  private let monitor: NWPathMonitor
  private let central = BKCentral()

  init(
    requiredInterfaceType: NWInterface.InterfaceType? = nil,
    prohibitedInterfaceTypes: [NWInterface.InterfaceType]? = nil,
    queue: DispatchQueue = .main
  ) {

    // Network Reachability
    precondition(!(requiredInterfaceType != nil && prohibitedInterfaceTypes != nil), "Parameter combination not supported")

    if let requiredInterfaceType = requiredInterfaceType {
      monitor = NWPathMonitor(requiredInterfaceType: requiredInterfaceType)
    } else if let prohibitedInterfaceTypes = prohibitedInterfaceTypes {
      monitor = NWPathMonitor(prohibitedInterfaceTypes: prohibitedInterfaceTypes)
    } else {
      monitor = NWPathMonitor()
    }

    networkPath = monitor.currentPath

    monitor.pathUpdateHandler = { [weak self] path in
      self?.networkPath = path
    }

    monitor.start(queue: queue)
  }

  deinit {
    monitor.cancel()
    sendableAnyCancellable.cancel()
    stopCentral()
  }

  func hasInternet() -> Bool {
    return networkPath.status == .satisfied
  }

  public func getBleAvailibity() -> AnyPublisher<Reachability.BleAvailibity, Never> {
    return Deferred {
      Future { [weak self] promise in

        guard let self = self else { return }

        self.$bleAvailibity
          .dropFirst()
          .sink(
            receiveValue: { [weak self] value in
              guard let self = self else { return }
              self.stopCentral()
              promise(.success(value))
            }
          )
          .store(in: &self.sendableAnyCancellable.cancellables)

        self.startCentral()
      }
    }.eraseToAnyPublisher()
  }

  public func openBleSettings() {

    let address = self.bleAvailibity == .disabled
    ? "App-Prefs:root=General"
    : UIApplication.openSettingsURLString

    if let settings = URL(string: address) {
      UIApplication.shared.open(settings, options: [:])
    }
  }

  private func stopCentral() {
    _ = try? central.stop()
  }

  private func startCentral() {
    do {
      central.addAvailabilityObserver(self)
      try central.startWithConfiguration(
        BKConfiguration(
          dataServiceUUID: UUID(),
          dataServiceCharacteristicUUID: UUID()
        )
      )
    } catch let error {
      error.log()
    }
  }
}

extension ReachabilityControllerImpl {

  func availabilityObserver(
    _ availabilityObservable: BluetoothKit.BKAvailabilityObservable,
    availabilityDidChange availability: BluetoothKit.BKAvailability
  ) {
    self.bleAvailibity = mapAvailability(availability)
  }

  func availabilityObserver(
    _ availabilityObservable: BluetoothKit.BKAvailabilityObservable,
    unavailabilityCauseDidChange unavailabilityCause: BluetoothKit.BKUnavailabilityCause
  ) {
    self.bleAvailibity = mapAvailability(.unavailable(cause: unavailabilityCause))
  }

  private func mapAvailability(_ availability: BKAvailability?) -> Reachability.BleAvailibity {
    guard let availability = availability else {
      return .unavailable
    }
    return switch availability {
    case .available: .available
    case .unavailable(cause: .poweredOff): .disabled
    case .unavailable(cause: .resetting): .unavailable
    case .unavailable(cause: .unsupported): .unavailable
    case .unavailable(cause: .unauthorized): .noPermission
    case .unavailable(cause: .any): .unavailable
    }
  }
}

public struct Reachability {}

public extension Reachability {
  enum BleAvailibity: Equatable, Sendable {
    case available
    case noPermission
    case disabled
    case unavailable
  }
}
