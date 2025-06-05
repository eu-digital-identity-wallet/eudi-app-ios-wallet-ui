/*
 * Copyright (c) 2023 European Commission
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
import feature_common

@Copyable
struct SettingsViewState: ViewState {
  let items: [SettingMenuItemUIModel]
  let appVersion: String
  let logsUrl: URL?
  let changelogUrl: URL?
}

final class SettingsViewModel<Router: RouterHost>: ViewModel<Router, SettingsViewState> {
  @Published var isBatchCounterEnabled: Bool = false

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
        appVersion: interactor.getAppVersion(),
        logsUrl: interactor.retrieveLogFileUrl(),
        changelogUrl: interactor.retrieveChangeLogUrl()
      )
    )

    buildMenuItems()
    subscribeBatchToggle()
  }

  func toolbarContent() -> ToolBarContent {
    .init(
      trailingActions: [],
      leadingActions: [
        .init(image: Theme.shared.image.chevronLeft) {
          self.router.pop()
        }
      ]
    )
  }

  private func buildMenuItems() {

    isBatchCounterEnabled = interactor.isBatchCounterEnabled()

    var items: [SettingMenuItemUIModel] = [
      .init(
        title: .batchIssuanceCunter,
        showDivider: true,
        isToggle: true,
        action: self.updateBatchCounter(self.isBatchCounterEnabled)
      ),
      .init(
        title: .retrieveLogs,
        isShareLink: true,
        action: {}()
      )
    ]

    if let changelogUrl = interactor.retrieveChangeLogUrl() {
      items.append(
        .init(
          title: .changelog,
          showDivider: false,
          action: changelogUrl.open()
        )
      )
    }

    setState { $0.copy(items: items) }
  }

  private func subscribeBatchToggle() {
    $isBatchCounterEnabled
      .dropFirst()
      .removeDuplicates()
      .sink { [weak self] isEnabled in
        guard let self = self else { return }
        self.updateBatchCounter(isEnabled)
      }.store(in: &cancellables)
  }

  private func updateBatchCounter(_ isEnabled: Bool) {
    interactor.setBatchCounter(isEnabled: isEnabled)
  }
}
