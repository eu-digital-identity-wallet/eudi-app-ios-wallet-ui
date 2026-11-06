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

/// Counts the user's interaction for the session's idle lock: every touch in the app's windows (sheets
/// and the RQES SDK's screens included, since they share the window), text input, and VoiceOver focus
/// changes.
public protocol UserInteractionController: Sendable {
  /// Starts reporting interaction to `onInteraction`. Later calls do nothing.
  @MainActor func start(onInteraction: @escaping @MainActor () -> Void)
}

/// The `UserInteractionController` of the app: a recogniser on each window of the scene, and observers of
/// text and VoiceOver focus changes.
@MainActor
final class UserInteractionControllerImpl: UserInteractionController {

  private var onInteraction: (@MainActor () -> Void)?
  private var cancellables = Set<AnyCancellable>()

  /// `nonisolated` because Swinject's registration closure, which is not on the main actor, creates the controller;
  /// the initializer sets no state.
  nonisolated init() {}

  func start(onInteraction: @escaping @MainActor () -> Void) {
    guard self.onInteraction == nil else { return }
    self.onInteraction = onInteraction
    attachToWindows()

    Publishers.MergeMany(
      [UIWindow.didBecomeVisibleNotification, UIWindow.didBecomeKeyNotification].map {
        NotificationCenter.default.publisher(for: $0)
      }
    )
    .receive(on: DispatchQueue.main)
    .sink { [weak self] _ in self?.attachToWindows() }
    .store(in: &cancellables)

    Publishers.MergeMany(
      [
        UITextField.textDidChangeNotification,
        UITextView.textDidChangeNotification,
        UIAccessibility.elementFocusedNotification
      ].map { NotificationCenter.default.publisher(for: $0) }
    )
    .receive(on: DispatchQueue.main)
    .sink { [weak self] _ in self?.onInteraction?() }
    .store(in: &cancellables)
  }

  /// Adds an `InteractionGestureRecognizer` to every window of the app's scenes that has none yet.
  private func attachToWindows() {
    let windows = UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .flatMap(\.windows)
    for window in windows {
      let isObserved = window.gestureRecognizers?.contains { $0 is InteractionGestureRecognizer } ?? false
      guard !isObserved else { continue }
      window.addGestureRecognizer(
        InteractionGestureRecognizer { [weak self] in self?.onInteraction?() }
      )
    }
  }
}
