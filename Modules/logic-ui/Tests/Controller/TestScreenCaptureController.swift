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
import XCTest
import UIKit
@testable import logic_ui
@testable import logic_test

final class TestScreenCaptureController: EudiTest {

  @MainActor
  func testShouldCover_WhenTheSceneIsCaptured_ThenIsTrue() {
    // When
    let result = ScreenCaptureControllerImpl.shouldCover(isCaptured: true, isForegroundActive: true)

    // Then
    XCTAssertTrue(result)
  }

  @MainActor
  func testShouldCover_WhenTheSceneIsNotActive_ThenIsTrue() {
    // When
    let result = ScreenCaptureControllerImpl.shouldCover(isCaptured: false, isForegroundActive: false)

    // Then
    XCTAssertTrue(result)
  }

  @MainActor
  func testShouldCover_WhenTheSceneIsActiveAndNotCaptured_ThenIsFalse() {
    // When
    let result = ScreenCaptureControllerImpl.shouldCover(isCaptured: false, isForegroundActive: true)

    // Then
    XCTAssertFalse(result)
  }

  @MainActor
  func testStart_WhenTheSettingIsOff_ThenFollowsNothingAndCoversNothing() {
    // Given
    let scene = RecordingScene(isCaptured: true, isForegroundActive: false)
    let controller = ScreenCaptureControllerImpl(isEnabled: false)

    // When
    controller.start(scenes: [scene])
    post(UIScene.willDeactivateNotification, object: scene)
    post(UIResponder.keyboardWillShowNotification, object: nil)

    // Then
    XCTAssertEqual(scene.observations, 0)
    XCTAssertNil(scene.coverWindow)
    XCTAssertEqual(scene.endEditingCount, 0)
  }

  @MainActor
  func testStart_WhenTheSettingIsOff_ThenTheScenesAreNotRead() {
    // Given
    let controller = ScreenCaptureControllerImpl(isEnabled: false)
    var isRead = false

    // When
    controller.start(scenes: {
      isRead = true
      return []
    }())

    // Then
    XCTAssertFalse(isRead)
  }

  @MainActor
  func testStart_WhenTheSceneIsCapturedAndThenNot_ThenTheCoverWithItsMessageComesAndGoes() {
    // Given
    let scene = RecordingScene()
    let controller = ScreenCaptureControllerImpl(isEnabled: true)
    controller.start(scenes: [scene])
    XCTAssertNil(scene.coverWindow)

    // When
    scene.setCaptured(true)

    // Then
    XCTAssertEqual(scene.coverWindow?.isHidden, false)
    XCTAssertEqual(scene.coverWindow?.isMessageShown, true)
    XCTAssertEqual(scene.endEditingCount, 1)

    // When
    scene.setCaptured(false)

    // Then
    XCTAssertEqual(scene.coverWindow?.isHidden, true)
  }

  @MainActor
  func testStart_WhenTheSceneIsAlreadyCaptured_ThenCoversItAtOnce() {
    // Given
    let scene = RecordingScene(isCaptured: true)
    let controller = ScreenCaptureControllerImpl(isEnabled: true)

    // When
    controller.start(scenes: [scene])

    // Then
    XCTAssertEqual(scene.coverWindow?.isHidden, false)
    XCTAssertEqual(scene.coverWindow?.isMessageShown, true)
  }

  @MainActor
  func testStart_WhenTheSceneIsNotActive_ThenCoversItWithoutTheMessageAndTheKeyboardUntilItIsActive() {
    // Given
    let scene = RecordingScene(isForegroundActive: false)
    let controller = ScreenCaptureControllerImpl(isEnabled: true)

    // When
    controller.start(scenes: [scene])

    // Then
    XCTAssertEqual(scene.coverWindow?.isHidden, false)
    XCTAssertEqual(scene.coverWindow?.isMessageShown, false)
    XCTAssertEqual(scene.endEditingCount, 1)

    // When
    post(UIScene.didActivateNotification, object: scene)

    // Then
    XCTAssertEqual(scene.coverWindow?.isHidden, true)
  }

  @MainActor
  func testStart_WhenTheSceneGoesToTheAppSwitcher_ThenCoversItWithoutTheMessage() {
    // Given
    let scene = RecordingScene()
    let controller = ScreenCaptureControllerImpl(isEnabled: true)
    controller.start(scenes: [scene])

    // When
    post(UIScene.willDeactivateNotification, object: scene)

    // Then
    XCTAssertEqual(scene.coverWindow?.isHidden, false)
    XCTAssertEqual(scene.coverWindow?.isMessageShown, false)
  }

  @MainActor
  func testStart_WhenACapturedSceneIsActiveAgain_ThenTheCoverStays() {
    // Given
    let scene = RecordingScene(isCaptured: true, isForegroundActive: false)
    let controller = ScreenCaptureControllerImpl(isEnabled: true)
    controller.start(scenes: [scene])

    // When
    post(UIScene.didActivateNotification, object: scene)

    // Then
    XCTAssertEqual(scene.coverWindow?.isHidden, false)
    XCTAssertEqual(scene.coverWindow?.isMessageShown, true)
  }

  @MainActor
  func testStart_WhenCaptureEndsWhileTheSceneIsNotActive_ThenTheCoverWithoutTheMessageStays() {
    // Given
    let scene = RecordingScene(isCaptured: true)
    let controller = ScreenCaptureControllerImpl(isEnabled: true)
    controller.start(scenes: [scene])

    // When
    post(UIScene.willDeactivateNotification, object: scene)
    scene.setCaptured(false)

    // Then
    XCTAssertEqual(scene.coverWindow?.isHidden, false)
    XCTAssertEqual(scene.coverWindow?.isMessageShown, false)
  }

  @MainActor
  func testStart_WhenCaptureStartedUnheardInTheBackground_ThenTheSceneIsCoveredOnReturn() {
    // Given
    let scene = RecordingScene()
    let controller = ScreenCaptureControllerImpl(isEnabled: true)
    controller.start(scenes: [scene])
    post(UIScene.willDeactivateNotification, object: scene)

    // When
    scene.isCaptured = true
    post(UIScene.didActivateNotification, object: scene)

    // Then
    XCTAssertEqual(scene.coverWindow?.isHidden, false)
    XCTAssertEqual(scene.coverWindow?.isMessageShown, true)
  }

  @MainActor
  func testStart_WhenAnInactiveSceneDisconnects_ThenItsCoverGoes() {
    // Given
    let scene = RecordingScene(isForegroundActive: false)
    let controller = ScreenCaptureControllerImpl(isEnabled: true)
    controller.start(scenes: [scene])

    // When
    post(UIScene.didDisconnectNotification, object: scene)

    // Then
    XCTAssertEqual(scene.coverWindow?.isHidden, true)
  }

  @MainActor
  func testStart_WhenASceneNotFollowedYetIsActivated_ThenItIsCoveredByItsOwnStateOnly() {
    // Given
    let scene = RecordingScene()
    let other = RecordingScene(isForegroundActive: false)
    let controller = ScreenCaptureControllerImpl(isEnabled: true)
    controller.start(scenes: [scene])

    // When
    post(UIScene.didActivateNotification, object: other)
    controller.start(scenes: [other])

    // Then
    XCTAssertEqual(other.coverWindow?.isHidden, false)
    XCTAssertEqual(other.coverWindow?.isMessageShown, false)
  }

  @MainActor
  func testStart_WhenASceneNotFollowedYetChanges_ThenNeitherSceneIsCovered() {
    // Given
    let scene = RecordingScene()
    let other = RecordingScene()
    let controller = ScreenCaptureControllerImpl(isEnabled: true)
    controller.start(scenes: [scene])

    // When
    post(UIScene.willDeactivateNotification, object: other)
    controller.start(scenes: [other])

    // Then
    XCTAssertNil(scene.coverWindow)
    XCTAssertNil(other.coverWindow)
  }

  @MainActor
  func testStart_WhenCalledAgain_ThenFollowsOnlyTheScenesNotFollowedYet() {
    // Given
    let first = RecordingScene()
    let second = RecordingScene()
    let controller = ScreenCaptureControllerImpl(isEnabled: true)

    // When
    controller.start(scenes: [first])
    controller.start(scenes: [first, second])
    second.setCaptured(true)

    // Then
    XCTAssertEqual(first.observations, 1)
    XCTAssertEqual(second.observations, 1)
    XCTAssertNil(first.coverWindow)
    XCTAssertEqual(second.coverWindow?.isHidden, false)
  }

  @MainActor
  func testStart_WhenTheSceneIsCapturedAgain_ThenTheSameCoverIsShown() {
    // Given
    let scene = RecordingScene()
    let controller = ScreenCaptureControllerImpl(isEnabled: true)
    controller.start(scenes: [scene])

    // When
    scene.setCaptured(true)
    scene.setCaptured(false)
    scene.setCaptured(true)

    // Then
    XCTAssertEqual(scene.madeCoverWindows, 1)
    XCTAssertEqual(scene.coverWindow?.isHidden, false)
  }

  @MainActor
  func testStart_WhenTheKeyboardShowsInACoveredScene_ThenPutsItAway() {
    // Given
    let captured = RecordingScene(isCaptured: true)
    let inactive = RecordingScene(isForegroundActive: false)
    let uncovered = RecordingScene()
    let controller = ScreenCaptureControllerImpl(isEnabled: true)
    controller.start(scenes: [captured, inactive, uncovered])

    // When
    post(UIResponder.keyboardWillShowNotification, object: nil)

    // Then
    XCTAssertEqual(captured.endEditingCount, 2)
    XCTAssertEqual(inactive.endEditingCount, 2)
    XCTAssertEqual(uncovered.endEditingCount, 0)
  }

  @MainActor
  func testStart_WhenTheKeyboardShowsAfterTheCoverWent_ThenLeavesItThere() {
    // Given
    let scene = RecordingScene(isCaptured: true)
    let controller = ScreenCaptureControllerImpl(isEnabled: true)
    controller.start(scenes: [scene])
    scene.setCaptured(false)

    // When
    post(UIResponder.keyboardWillShowNotification, object: nil)

    // Then
    XCTAssertEqual(scene.coverWindow?.isHidden, true)
    XCTAssertEqual(scene.endEditingCount, 1)
  }

  @MainActor
  func testStart_WhenTheSceneGoesToTheAppSwitcher_ThenPutsTheKeyboardAway() {
    // Given
    let scene = RecordingScene()
    let controller = ScreenCaptureControllerImpl(isEnabled: true)
    controller.start(scenes: [scene])

    // When
    post(UIScene.willDeactivateNotification, object: scene)

    // Then
    XCTAssertEqual(scene.endEditingCount, 1)
  }

  @MainActor
  func testStart_WhenTheSceneDisconnects_ThenItsCoverGoesAndItIsNoLongerFollowed() {
    // Given
    let scene = RecordingScene(isCaptured: true)
    let controller = ScreenCaptureControllerImpl(isEnabled: true)
    controller.start(scenes: [scene])

    // When
    post(UIScene.didDisconnectNotification, object: scene)
    scene.setCaptured(true)

    // Then
    XCTAssertEqual(scene.coverWindow?.isHidden, true)
    XCTAssertEqual(scene.madeCoverWindows, 1)
  }

  @MainActor
  func testCoverWindow_WhenShown_ThenSitsAboveAlertsKeepsVoiceOverAndNeverBecomesKey() {
    // Given
    let window = ScreenCaptureCoverWindow(frame: .zero)

    // When
    window.isHidden = false

    // Then
    XCTAssertGreaterThan(window.windowLevel.rawValue, UIWindow.Level.alert.rawValue)
    XCTAssertFalse(window.canBecomeKey)
    XCTAssertTrue(window.accessibilityViewIsModal)
    XCTAssertNotNil(window.rootViewController)
    XCTAssertFalse(window.isMessageShown)
    window.isHidden = true
  }
}

private extension TestScreenCaptureController {

  /// Posts a notification as UIKit does, on the main thread; the controller handles it before this returns.
  @MainActor
  func post(_ name: Notification.Name, object: AnyObject?) {
    NotificationCenter.default.post(name: name, object: object)
  }
}

/// A window scene for the tests: its capture state and activation are set by the test, and it records what the
/// controller asks of it.
@MainActor
private final class RecordingScene: ScreenCaptureScene {

  /// The capture state; setting it directly, unlike `setCaptured(_:)`, reports nothing, as a change the controller has
  /// not heard of yet.
  var isCaptured: Bool
  let isForegroundActive: Bool
  private(set) var observations = 0
  private(set) var endEditingCount = 0
  private(set) var madeCoverWindows = 0
  private(set) var coverWindow: ScreenCaptureCoverWindow?
  private var onCaptureChange: (@MainActor (Bool) -> Void)?

  init(isCaptured: Bool = false, isForegroundActive: Bool = true) {
    self.isCaptured = isCaptured
    self.isForegroundActive = isForegroundActive
  }

  /// Changes the capture state as UIKit would, and reports it to the observer.
  func setCaptured(_ isCaptured: Bool) {
    self.isCaptured = isCaptured
    onCaptureChange?(isCaptured)
  }

  func observeCaptureState(onChange: @escaping @MainActor (Bool) -> Void) {
    observations += 1
    onCaptureChange = onChange
  }

  func endEditing() {
    endEditingCount += 1
  }

  func makeCoverWindow() -> ScreenCaptureCoverWindow {
    madeCoverWindows += 1
    let window = ScreenCaptureCoverWindow(frame: .zero)
    coverWindow = window
    return window
  }
}
