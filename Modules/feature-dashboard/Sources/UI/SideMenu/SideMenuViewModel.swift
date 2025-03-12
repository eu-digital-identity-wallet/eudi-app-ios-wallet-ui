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
import Foundation
import logic_ui
import logic_core
import feature_common

@Copyable
struct SideMenuViewState: ViewState {
  let items: [SideMenuItemUIModel]
  let appVersion: String
  let logsUrl: URL?
  let changelogUrl: URL?
}

final class SideMenuViewModel<Router: RouterHost>: ViewModel<Router, SideMenuViewState> {

  private let interactor: SideMenuInteractor
  private let walletKitController: WalletKitController

  init(
    router: Router,
    interactor: SideMenuInteractor,
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

    if let changelogUrl = interactor.retrieveChangeLogUrl() {
      setState {
        $0.copy(items: [
          .init(
            title: .changeQuickPinOption,
            action: self.updatePin()
          ),
          .init(
            title: .retrieveLogs,
            isShareLink: true,
            action: {}()
          ),
          .init(
            title: .changelog,
            showDivider: false,
            action: changelogUrl.open()
          )
        ])
      }
    } else {
      setState {
        $0.copy(
          items: [
            .init(
              title: .changeQuickPinOption,
              action: self.updatePin()
            ),
            .init(
              title: .retrieveLogs,
              showDivider: false,
              isShareLink: true,
              action: {}()
            )
          ]
        )
      }
    }
  }

  func updatePin() {
    router.push(
      with: .featureCommonModule(
        .quickPin(
          config: QuickPinUiConfig(
            flow: .update
          )
        )
      )
    )
  }

  func onPop() {
    router.pop()
  }
}
