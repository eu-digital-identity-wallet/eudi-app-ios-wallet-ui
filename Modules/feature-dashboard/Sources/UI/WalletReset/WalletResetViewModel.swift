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
import logic_resources
import feature_common

/// Whether the reset is still running, and the error to show when it failed.
@Copyable
struct WalletResetViewState: ViewState {
  let isLoading: Bool
  let error: ContentErrorView.Config?
}

/// Runs the factory reset after the user confirmed it and verified their identity, then returns to start-up,
/// which leads to onboarding. A failure offers to try again or to go back to the settings.
@Observable
final class WalletResetViewModel<Router: RouterHost>: ViewModel<Router, WalletResetViewState> {

  @ObservationIgnored
  private let interactor: SettingsInteractor
  @ObservationIgnored
  private let deepLinkController: DeepLinkController

  init(
    router: Router,
    interactor: SettingsInteractor,
    deepLinkController: DeepLinkController
  ) {
    self.interactor = interactor
    self.deepLinkController = deepLinkController
    super.init(router: router, initialState: .init(isLoading: true, error: nil))
  }

  /// Runs the reset; the screen calls it when it appears, and the error's Try again calls it again. The link kept for
  /// after login is forgotten as the reset starts, as on Android, whatever its outcome. The app asks iOS to keep it
  /// running while the reset runs, so leaving the app does not suspend it halfway.
  func reset() async {
    setState { $0.copy(isLoading: true, error: nil) }
    deepLinkController.removeCachedDeepLinkURL()
    let result = await UIApplication.shared.keepRunningInBackground(named: "WalletReset") {
      await self.interactor.resetWallet()
    }
    switch result {
    case .success:
      router.restartAtStartup()
    case .failure:
      setState {
        $0.copy(
          isLoading: false,
          error: .init(
            cancelAction: self.router.popTo(with: .featureDashboardModule(.settingsMenu)),
            action: { Task { await self.reset() } }
          )
        )
      }
    }
  }
}
