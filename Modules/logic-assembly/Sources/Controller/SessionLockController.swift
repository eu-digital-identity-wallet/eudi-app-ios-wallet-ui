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
import UIKit
import logic_ui
import logic_authentication

/// Drives the session lock from the app's scene, as the Android wallet's host activity does: it records
/// the background, applies the timeout when the app returns and before a link is handled, checks the idle
/// limit every second while the app is in front, and sends a locked wallet to login each time.
public protocol SessionLockController {
  /// Starts counting interaction and the idle check. Call it when the app's window appears.
  @MainActor func start()
  /// Call it when the scene goes to the background.
  @MainActor func sceneDidEnterBackground()
  /// Call it when the scene is in front again.
  @MainActor func sceneDidBecomeActive()
  /// Call it before an incoming link is looked at.
  @MainActor func willHandleLink()
}

/// The `SessionLockController` of the app, registered once per process. Like `RouterHostImpl`, its work
/// runs on the main actor.
final class SessionLockControllerImpl: SessionLockController {

  private let sessionController: SessionController
  private let routerHost: RouterHost
  private let userInteractionController: UserInteractionController
  private let walletKitController: WalletKitController
  private let isCovered: @MainActor () -> Bool
  private let idleCheckInterval: TimeInterval
  @MainActor private var idleCheck: Task<Void, Never>?
  @MainActor private var wasUnlocked = false

  init(
    sessionController: SessionController,
    routerHost: RouterHost,
    userInteractionController: UserInteractionController,
    walletKitController: WalletKitController,
    isCovered: @escaping @MainActor () -> Bool,
    idleCheckInterval: TimeInterval = Constants.idleCheckInterval
  ) {
    self.sessionController = sessionController
    self.routerHost = routerHost
    self.userInteractionController = userInteractionController
    self.walletKitController = walletKitController
    self.isCovered = isCovered
    self.idleCheckInterval = idleCheckInterval
  }

  @MainActor
  func start() {
    userInteractionController.start { [sessionController] in sessionController.recordInteraction() }
    startIdleCheck()
  }

  /// The idle check stops before the background is recorded, so that it cannot use up the record.
  @MainActor
  func sceneDidEnterBackground() {
    idleCheck?.cancel()
    idleCheck = nil
    sessionController.setCovered(isCovered())
    sessionController.recordBackground(isProtectedFlow: routerHost.isInProtectedFlow())
  }

  @MainActor
  func sceneDidBecomeActive() {
    applyTimeout()
    startIdleCheck()
  }

  @MainActor
  func willHandleLink() {
    applyTimeout()
  }

  /// One idle check: the cover is refreshed, the timeout applied and a locked wallet sent to login.
  @MainActor
  func checkIdle() {
    sessionController.setCovered(isCovered())
    applyTimeout()
  }

  /// A lock, whatever caused it (a timeout here, or the end of a cover or an external flow), also ends a
  /// running presentation, once, so that a proximity session does not outlive its screens, as on Android,
  /// where the cleared screens stop it.
  @MainActor
  private func applyTimeout() {
    sessionController.lockIfExpired()
    let isUnlocked = sessionController.isUnlocked
    if wasUnlocked && !isUnlocked {
      Task { [walletKitController] in await walletKitController.stopPresentation() }
    }
    wasUnlocked = isUnlocked
    routerHost.requireLoginIfLocked()
  }

  /// Checks the idle limit every `idleCheckInterval` while the app is active; the check is cancelled in the
  /// background. A check whose wait had already ended when it was cancelled does not run either, so that it cannot
  /// use up the background record.
  @MainActor
  private func startIdleCheck() {
    idleCheck?.cancel()
    idleCheck = Task { [weak self, idleCheckInterval] in
      while true {
        do {
          try await Task.sleep(seconds: idleCheckInterval)
        } catch {
          return
        }
        guard !Task.isCancelled, let self else { return }
        self.checkIdle()
      }
    }
  }
}

extension SessionLockControllerImpl {
  enum Constants {
    /// Seconds between two idle checks while the app is in front.
    static let idleCheckInterval: TimeInterval = 1
  }
}
