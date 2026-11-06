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
import Combine
import UIKit

/// Covers the wallet's screens, the ID Provider extension's included, while the screen is recorded, mirrored or shared,
/// and in the app switcher, when `ConfigUiLogic.hideContentWhileCaptured` is on.
public protocol ScreenCaptureController: Sendable {
  /// Starts following the window scenes of the process, in the app or in the ID Provider extension. A later call
  /// follows the scenes connected since; it does nothing more for a scene already followed.
  @MainActor func start()
}

/// What `ScreenCaptureControllerImpl` needs from a window scene: `UIWindowScene` in the app and the extension, a
/// recording double in the tests.
protocol ScreenCaptureScene: AnyObject, Sendable {
  /// Whether the scene is recorded, mirrored or shared.
  @MainActor var isCaptured: Bool { get }
  /// Whether the scene is in the foreground and active: not in the app switcher, behind a system prompt or in the
  /// background.
  @MainActor var isForegroundActive: Bool { get }
  /// Calls `onChange` with `isCaptured` each time the scene's capture state changes.
  @MainActor func observeCaptureState(onChange: @escaping @MainActor (Bool) -> Void)
  /// Ends text editing in the scene's windows, which puts the keyboard away.
  @MainActor func endEditing()
  /// Makes the scene's cover, hidden until the controller shows it.
  @MainActor func makeCoverWindow() -> ScreenCaptureCoverWindow
}

/// The `ScreenCaptureController` of the app and the ID Provider extension: follows each window scene's capture state
/// and activation, and shows the scene's `ScreenCaptureCoverWindow` above every other window, so that sheets, alerts
/// and the RQES SDK's screens are covered too. While the scene is captured the cover says so; while the scene is
/// inactive or in the background it shows only the wallet's mark, for the app switcher. The keyboard is put away under
/// either. The cover window never becomes key, so `UIApplication.currentUIWindow`, and what relies on it, stay on the
/// wallet's own window.
@MainActor
final class ScreenCaptureControllerImpl: ScreenCaptureController {

  private let isEnabled: Bool
  private var scenes: [ObjectIdentifier: any ScreenCaptureScene] = [:]
  private var capturedScenes = Set<ObjectIdentifier>()
  private var inactiveScenes = Set<ObjectIdentifier>()
  private var coverWindows: [ObjectIdentifier: ScreenCaptureCoverWindow] = [:]
  private var cancellables = Set<AnyCancellable>()

  /// `nonisolated` because Swinject's registration closure, which is not on the main actor, creates the controller;
  /// the initializer stores only a `Bool`.
  /// - Parameter isEnabled: `ConfigUiLogic.hideContentWhileCaptured`.
  nonisolated init(isEnabled: Bool) {
    self.isEnabled = isEnabled
  }

  /// Whether a scene is covered: while it is captured, and while it is not active, as in the app switcher.
  static func shouldCover(isCaptured: Bool, isForegroundActive: Bool) -> Bool {
    isCaptured || !isForegroundActive
  }

  func start() {
    start(scenes: UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene })
  }

  /// Follows each of `scenes` not followed yet, and covers it at once if it is captured or not active. Does nothing
  /// while the setting is off, and then does not read `scenes`, so the ID Provider extension, where
  /// `UIApplication.shared` is not meant to be used, reaches it only with the setting on.
  func start(scenes newScenes: @autoclosure () -> [any ScreenCaptureScene]) {
    guard isEnabled else { return }
    if cancellables.isEmpty {
      observeScenesAndKeyboard()
    }
    for scene in newScenes() {
      let sceneId = ObjectIdentifier(scene)
      guard scenes[sceneId] == nil else { continue }
      scenes[sceneId] = scene
      if scene.isCaptured {
        capturedScenes.insert(sceneId)
      }
      if !scene.isForegroundActive {
        inactiveScenes.insert(sceneId)
      }
      updateCover(sceneId: sceneId)
      scene.observeCaptureState { [weak self] isCaptured in
        self?.setCaptured(isCaptured, sceneId: sceneId)
      }
    }
  }

  /// Follows the scenes' activation and disconnection, and the keyboard, for the scenes followed. UIKit posts these
  /// on the main thread and they are handled there at once, without a hop through the main queue, so that the cover
  /// is up before iOS takes the app switcher's snapshot and the keyboard goes before it is drawn.
  private func observeScenesAndKeyboard() {
    NotificationCenter.default.publisher(for: UIScene.willDeactivateNotification)
      .compactMap { Self.sceneId(of: $0) }
      .sink { [weak self] in self?.setForegroundActive(false, sceneId: $0) }
      .store(in: &cancellables)

    NotificationCenter.default.publisher(for: UIScene.didActivateNotification)
      .compactMap { Self.sceneId(of: $0) }
      .sink { [weak self] in self?.setForegroundActive(true, sceneId: $0) }
      .store(in: &cancellables)

    NotificationCenter.default.publisher(for: UIScene.didDisconnectNotification)
      .compactMap { Self.sceneId(of: $0) }
      .sink { [weak self] in self?.stopFollowing(sceneId: $0) }
      .store(in: &cancellables)

    NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
      .sink { [weak self] _ in self?.endEditingInCoveredScenes() }
      .store(in: &cancellables)
  }

  /// The key of the scene a scene notification is about, if it has one.
  private static func sceneId(of notification: Notification) -> ObjectIdentifier? {
    (notification.object as AnyObject?).map(ObjectIdentifier.init)
  }

  /// Records whether a followed scene is captured, and covers or uncovers it.
  private func setCaptured(_ isCaptured: Bool, sceneId: ObjectIdentifier) {
    guard scenes[sceneId] != nil else { return }
    if isCaptured {
      capturedScenes.insert(sceneId)
    } else {
      capturedScenes.remove(sceneId)
    }
    updateCover(sceneId: sceneId)
  }

  /// Records whether a followed scene is active, reads its capture state again in case a change came in a different
  /// order, and covers or uncovers it.
  private func setForegroundActive(_ isForegroundActive: Bool, sceneId: ObjectIdentifier) {
    guard let scene = scenes[sceneId] else { return }
    if isForegroundActive {
      inactiveScenes.remove(sceneId)
    } else {
      inactiveScenes.insert(sceneId)
    }
    setCaptured(scene.isCaptured, sceneId: sceneId)
  }

  /// Shows the scene's cover while `shouldCover` holds, with the capture text while the scene is captured, and puts the
  /// keyboard away under it; hides it otherwise. The cover is made the first time it is needed.
  private func updateCover(sceneId: ObjectIdentifier) {
    guard let scene = scenes[sceneId] else { return }
    let isCaptured = capturedScenes.contains(sceneId)
    let isCovered = Self.shouldCover(
      isCaptured: isCaptured,
      isForegroundActive: !inactiveScenes.contains(sceneId)
    )
    guard isCovered else {
      if let coverWindow = coverWindows[sceneId] {
        setVisibility(of: coverWindow, isShown: false, isMessageShown: false)
      }
      return
    }
    let coverWindow = coverWindows[sceneId] ?? scene.makeCoverWindow()
    coverWindows[sceneId] = coverWindow
    setVisibility(of: coverWindow, isShown: true, isMessageShown: isCaptured)
    scene.endEditing()
  }

  /// Shows or hides a cover and its message, and tells VoiceOver that the screen changed when the message cover comes
  /// or goes; the cover without it only shows while the app is not active, so VoiceOver is left where it was.
  private func setVisibility(of coverWindow: ScreenCaptureCoverWindow, isShown: Bool, isMessageShown: Bool) {
    let wasMessageVisible = !coverWindow.isHidden && coverWindow.isMessageShown
    coverWindow.isMessageShown = isMessageShown
    coverWindow.isHidden = !isShown
    if wasMessageVisible != (isShown && isMessageShown) {
      UIAccessibility.post(notification: .screenChanged, argument: nil)
    }
  }

  /// Puts the keyboard away again in a covered scene, where a field took focus under the cover.
  private func endEditingInCoveredScenes() {
    for (sceneId, coverWindow) in coverWindows where !coverWindow.isHidden {
      scenes[sceneId]?.endEditing()
    }
  }

  /// Forgets a disconnected scene and removes its cover.
  private func stopFollowing(sceneId: ObjectIdentifier) {
    guard scenes[sceneId] != nil else { return }
    if let coverWindow = coverWindows[sceneId] {
      setVisibility(of: coverWindow, isShown: false, isMessageShown: false)
    }
    coverWindows[sceneId] = nil
    capturedScenes.remove(sceneId)
    inactiveScenes.remove(sceneId)
    scenes[sceneId] = nil
  }
}
