/*
 * Copyright (c) 2026 European Commission
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

public protocol SessionCoordinatorHolder: Sendable {
  func clear() async
  func clearRemoteCoordinator(_ coordinator: RemoteSessionCoordinator) async
  func clearProximityCoordinator(_ coordinator: ProximitySessionCoordinator) async
  func setActiveRemoteCoordinator(_ coordinator: RemoteSessionCoordinator) async
  func setActiveProximityCoordinator(_ coordinator: ProximitySessionCoordinator) async
}

final actor SessionCoordinatorHolderImpl: SessionCoordinatorHolder {

  private var activeRemoteCoordinator: RemoteSessionCoordinator?
  private var activeProximityCoordinator: ProximitySessionCoordinator?
  /// The last stopped proximity coordinator, kept until the next one starts. The transfer library's
  /// `MdocGattServer` holds wallet-kit's Bluetooth service, which this coordinator owns, only weakly, still reads
  /// it after `stop()` (in a task, and when the reader disconnects later) and stops the app with `fatalError`
  /// once it is gone.
  private var stoppedProximityCoordinator: ProximitySessionCoordinator?

  init() {}

  /// Stops a running proximity session before letting it go, rather than leaving that to the coordinator's
  /// `deinit`, which runs only once every screen that holds the coordinator is gone.
  public func clear() {
    if let activeProximityCoordinator {
      activeProximityCoordinator.stopPresentation()
      stoppedProximityCoordinator = activeProximityCoordinator
    }
    activeRemoteCoordinator = nil
    activeProximityCoordinator = nil
  }

  public func clearRemoteCoordinator(_ coordinator: RemoteSessionCoordinator) {
    guard activeRemoteCoordinator === coordinator else { return }
    activeRemoteCoordinator = nil
  }

  public func clearProximityCoordinator(_ coordinator: ProximitySessionCoordinator) {
    guard activeProximityCoordinator === coordinator else { return }
    coordinator.stopPresentation()
    stoppedProximityCoordinator = coordinator
    activeProximityCoordinator = nil
  }

  public func setActiveRemoteCoordinator(_ coordinator: RemoteSessionCoordinator) {
    activeRemoteCoordinator = coordinator
  }

  public func setActiveProximityCoordinator(_ coordinator: ProximitySessionCoordinator) {
    stoppedProximityCoordinator = nil
    activeProximityCoordinator = coordinator
  }
}
