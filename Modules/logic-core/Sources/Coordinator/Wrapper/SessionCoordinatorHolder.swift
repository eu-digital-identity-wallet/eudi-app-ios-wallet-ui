/*
 * Copyright (c) 2025 European Commission
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
  func clear()
  func setActiveRemoteCoordinator(_ coordinator: RemoteSessionCoordinator)
  func setActiveProximityCoordinator(_ coordinator: ProximitySessionCoordinator)
  func getActiveRemoteCoordinator() throws -> RemoteSessionCoordinator
  func getActiveProximityCoordinator() throws -> ProximitySessionCoordinator
}

final class SessionCoordinatorHolderImpl: SessionCoordinatorHolder, @unchecked Sendable {

  private var activeRemoteCoordinator: RemoteSessionCoordinator?
  private var activeProximityCoordinator: ProximitySessionCoordinator?

  init() {}

  public func clear() {
    activeRemoteCoordinator = nil
    activeProximityCoordinator = nil
  }

  public func setActiveRemoteCoordinator(_ coordinator: RemoteSessionCoordinator) {
    activeRemoteCoordinator = coordinator
  }

  public func setActiveProximityCoordinator(_ coordinator: ProximitySessionCoordinator) {
    activeProximityCoordinator = coordinator
  }

  public func getActiveRemoteCoordinator() throws -> RemoteSessionCoordinator {
    guard let activeRemoteCoordinator else {
      fatalError("RemoteSessionCoordinator is not set")
    }
    return activeRemoteCoordinator
  }

  public func getActiveProximityCoordinator() throws -> ProximitySessionCoordinator {
    guard let activeProximityCoordinator else {
      fatalError("ProximitySessionCoordinator is not set")
    }
    return activeProximityCoordinator
  }
}
