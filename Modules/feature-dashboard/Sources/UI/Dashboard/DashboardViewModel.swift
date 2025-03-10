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
import logic_business
import logic_core
import feature_common

@Copyable
struct DashboardState<Router: RouterHost>: ViewState {
  let homeTab: HomeTabView<Router>?
  let documentTab: DocumentTabView<Router>?
  let transactionTab: TransactionTabView<Router>?
  let toolBarContent: ToolBarContent
  let navigationTitle: LocalizableStringKey
}

enum SelectedTab {
  case home
  case documents
  case transactions
}

final class DashboardViewModel<Router: RouterHost>: ViewModel<Router, DashboardState<Router>> {

  private let interactor: DashboardInteractor

  private let deepLinkController: DeepLinkController

  @Published var selectedTab: SelectedTab = .home

  init(
    router: Router,
    dashboardInteractor: DashboardInteractor,
    homeTabInteractor: HomeTabInteractor,
    documentTabInteractor: DocumentTabInteractor,
    transactionTabInteractor: TransactionTabInteractor,
    deepLinkController: DeepLinkController
  ) {
    self.interactor = dashboardInteractor
    self.deepLinkController = deepLinkController

    super.init(
      router: router,
      initialState: .init(
        homeTab: nil,
        documentTab: nil,
        transactionTab: nil,
        toolBarContent: .init(
          trailingActions: nil,
          leadingActions: nil
        ),
        navigationTitle: .custom("")
      )
    )

    createTabs(
      homeTabInteractor: homeTabInteractor,
      documentTabInteractor: documentTabInteractor,
      transactionTabInteractor: transactionTabInteractor
    )
  }

  private func createTabs(
    homeTabInteractor: HomeTabInteractor,
    documentTabInteractor: DocumentTabInteractor,
    transactionTabInteractor: TransactionTabInteractor
  ) {

    func updateState(toolbar: ToolBarContent, title: LocalizableStringKey) {
      self.setState {
        $0.copy(
          toolBarContent: toolbar,
          navigationTitle: title
        )
      }
    }

    setState {
      $0.copy(
        homeTab: HomeTabView(
          with: .init(
            router: router,
            interactor: homeTabInteractor,
            onUpdateToolbar: { toolbar, title in
              updateState(toolbar: toolbar, title: title)
            }
          )
        ),
        documentTab: DocumentTabView(
          with: .init(
            router: router,
            interactor: documentTabInteractor,
            onUpdateToolbar: { toolbar, title in
              updateState(toolbar: toolbar, title: title)
            }
          )
        ),
        transactionTab: TransactionTabView(
          with: .init(
            router: router,
            interactor: transactionTabInteractor,
            onUpdateToolbar: { toolbar, title in
              updateState(toolbar: toolbar, title: title)
            }
          )
        )
      )
    }
  }

  func handleDeepLink() async {
    if let deepLink = deepLinkController.getPendingDeepLinkAction() {
      deepLinkController.handleDeepLinkAction(
        routerHost: router,
        deepLinkExecutable: deepLink,
        remoteSessionCoordinator: deepLink.requiresCoordinator
        ? await interactor.getWalletKitController().startSameDevicePresentation(deepLink: deepLink.link)
        : nil
      )
    }
  }
}
