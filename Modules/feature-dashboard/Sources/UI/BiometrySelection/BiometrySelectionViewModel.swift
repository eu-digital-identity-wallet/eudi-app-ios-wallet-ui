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
import logic_ui
import logic_authentication
import feature_common

/// Whether the change is still being made.
@Copyable
struct BiometrySelectionViewState: ViewState {
  let isLoading: Bool
}

/// Switches biometric unlock once the user has confirmed with the PIN or a biometric, then returns to the settings, as
/// Android's settings do after their check. Back from the check never reaches this screen, so nothing changes.
@Observable
final class BiometrySelectionViewModel<Router: RouterHost>: ViewModel<Router, BiometrySelectionViewState> {

  var biometryError: SystemBiometryError?

  @ObservationIgnored
  private let interactor: SettingsInteractor
  @ObservationIgnored
  private let isEnabled: Bool
  @ObservationIgnored
  private var isSwitchStarted = false

  /// - Parameter isEnabled: The setting the user asked for when they tapped the switch.
  init(router: Router, interactor: SettingsInteractor, isEnabled: Bool) {
    self.interactor = interactor
    self.isEnabled = isEnabled
    super.init(router: router, initialState: .init(isLoading: true))
  }

  /// Turns biometric unlock off with nothing more, or on through a biometric prompt, so that the biometric enrolled is
  /// known to work before the wallet relies on it; the screen calls it when it appears. It runs once, and only when
  /// the setting is not already what the user asked for, so a screen pushed twice cannot switch it back. A prompt
  /// cancelled or not matched leaves the setting as it was. An error the user can act on, such as biometrics locked
  /// out, is shown with a way to the device settings.
  func switchBiometricUnlock() async {
    guard !isSwitchStarted else { return }
    isSwitchStarted = true
    guard await interactor.isBiometryEnabled() != isEnabled else {
      returnToSettings()
      return
    }
    switch await interactor.setBiometrySelection(isEnabled: isEnabled) {
    case .authenticated:
      returnToSettings()
    case .failure(let error):
      guard error != .biometricError else {
        returnToSettings()
        return
      }
      setState { $0.copy(isLoading: false) }
      biometryError = error
    }
  }

  /// Opens the device settings from the error, and returns to the wallet's settings.
  func onBiometrySettings() {
    Task { await interactor.openBiometrySettings {} }
    returnToSettings()
  }

  /// Closes the error and returns to the settings.
  func onCancel() {
    returnToSettings()
  }

  /// Returns to the settings, or, when a link has meanwhile taken the user elsewhere, closes this screen if it is
  /// still in front, so that a screen opened above it is not closed instead.
  private func returnToSettings() {
    let settings = AppRoute.featureDashboardModule(.settingsMenu)
    if router.isScreenOnBackStack(with: settings) {
      router.popTo(with: settings)
    } else if router.isScreenForeground(with: .featureDashboardModule(.biometrySelection(isEnabled: isEnabled))) {
      router.pop()
    }
  }
}
