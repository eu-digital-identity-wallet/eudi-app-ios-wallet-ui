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
import logic_core
import logic_authentication
import feature_common

@Copyable
struct SettingsViewState: ViewState {
  let items: [SettingMenuItemUIModel]
  let isBiometryEnabled: Bool
  let appVersion: String?
  let logsUrl: URL?
  let changelogUrl: URL?
}

final class SettingsViewModel<Router: RouterHost>: ViewModel<Router, SettingsViewState> {

  var biometryError: SystemBiometryError?

  private let interactor: SettingsInteractor
  private let walletKitController: WalletKitController

  init(
    router: Router,
    interactor: SettingsInteractor,
    walletKit: WalletKitController
  ) {
    self.interactor = interactor
    self.walletKitController = walletKit
    super.init(
      router: router,
      initialState: .init(
        items: [],
        isBiometryEnabled: false,
        appVersion: nil,
        logsUrl: nil,
        changelogUrl: nil
      )
    )
  }

  func initialize() async {
    await buildUi()
  }

  func toolbarContent() -> ToolBarContent {
    .init(
      trailingActions: [],
      leadingActions: [
        .init(
          image: Theme.shared.image.chevronLeft,
          accessibilityLocator: ToolbarLocators.chevronLeft
        ) {
          self.router.pop()
        }
      ]
    )
  }

  func onBiometrySettings() {
    Task { await interactor.openBiometrySettings {} }
  }

  private func setBiometryEnabled(_ isEnabled: Bool) {
    setState { $0.copy(isBiometryEnabled: isEnabled) }
    Task {
      switch await interactor.authenticateBiometry() {
      case .authenticated:
        await interactor.setBiometrySelection(isEnabled: isEnabled)
        setState { $0.copy(isBiometryEnabled: isEnabled) }
      case .failure(let error):
        setState { $0.copy(isBiometryEnabled: !isEnabled) }
        if error != .biometricError {
          self.biometryError = error
        }
      }
    }
  }

  private func buildUi() async {

    let appVersion = await interactor.getAppVersion()
    let logsUrl = await interactor.retrieveLogFileUrl()
    let changelogUrl = await interactor.retrieveChangeLogUrl()
    let isBiometryAvailable = await interactor.isBiometryAvailable()
    let isBiometryEnabled = await interactor.isBiometryEnabled()

    var items: [SettingMenuItemUIModel] = []

    if isBiometryAvailable {
      items.append(
        .init(
          title: .loginWithBiometrics,
          isToggle: true,
          action: { [weak self] in
            guard let self else { return }
            self.setBiometryEnabled(!self.viewState.isBiometryEnabled)
          }
        )
      )
    }

    items.append(
      .init(
        title: .retrieveLogs,
        isShareLink: true,
        action: {}
      )
    )

    if let changelogUrl = await interactor.retrieveChangeLogUrl() {
      items.append(
        .init(
          title: .changelog,
          showDivider: false,
          action: { changelogUrl.open() }
        )
      )
    }

    setState {
      $0.copy(
        items: items,
        isBiometryEnabled: isBiometryEnabled,
        appVersion: appVersion,
        logsUrl: logsUrl,
        changelogUrl: changelogUrl
      )
    }
  }
}
