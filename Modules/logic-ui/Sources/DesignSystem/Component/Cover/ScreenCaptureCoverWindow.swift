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
import SwiftUI

/// The window that covers the wallet for `ScreenCaptureController`. It sits above alerts, so that sheets, alerts and
/// the RQES SDK's screens are covered too, takes the touches meant for what it covers, keeps VoiceOver on itself, and
/// never becomes key, so that the wallet's own window stays the one `UIApplication.currentUIWindow` finds.
final class ScreenCaptureCoverWindow: UIWindow {

  /// Whether the cover says that the screen is captured; without it, it shows only the wallet's mark, for the app
  /// switcher.
  var isMessageShown = false {
    didSet {
      guard isMessageShown != oldValue else { return }
      hostingController.rootView = ScreenCaptureCoverView(isMessageShown: isMessageShown)
    }
  }

  private let hostingController = UIHostingController(rootView: ScreenCaptureCoverView(isMessageShown: false))

  /// A cover in the given scene, hidden until `ScreenCaptureController` shows it.
  override init(windowScene: UIWindowScene) {
    super.init(windowScene: windowScene)
    setUp()
  }

  /// A cover made without a scene, as the tests make it, is set up the same way.
  override init(frame: CGRect) {
    super.init(frame: frame)
    setUp()
  }

  required init?(coder: NSCoder) {
    nil
  }

  /// Never: the wallet's own window stays key under the cover.
  override var canBecomeKey: Bool {
    false
  }

  /// Puts the cover above alerts, keeps VoiceOver from the windows under it, and gives it the cover view.
  private func setUp() {
    windowLevel = UIWindow.Level(rawValue: UIWindow.Level.alert.rawValue + 1)
    accessibilityViewIsModal = true
    rootViewController = hostingController
  }
}
