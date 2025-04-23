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
  let revokedDocuments: [String: String]
  let isPaused: Bool
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
  @Published var isRevokedModalShowing: Bool = false

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
        navigationTitle: .custom(""),
        revokedDocuments: [:],
        isPaused: false
      )
    )

    createTabs(
      homeTabInteractor: homeTabInteractor,
      documentTabInteractor: documentTabInteractor,
      transactionTabInteractor: transactionTabInteractor
    )

    listenForRevokedModalChanges()
  }

  func handleRevocationNotification(for payload: [AnyHashable: Any]?) {
    guard
      let payload,
      let revokedDocuments = payload as? [String: String],
      !isRevokedModalShowing,
      !viewState.isPaused
    else {
      return
    }
    setState { $0.copy(revokedDocuments: revokedDocuments) }
    isRevokedModalShowing = true
  }

  func onDocumentDetails(documentId: String) {

    isRevokedModalShowing = false

    router.push(
      with: .featureDashboardModule(
        .documentDetails(id: documentId)
      )
    )
  }

  func setPhase(with phase: ScenePhase) {
    if phase == .active {
      onResume()
    }
    if phase == .background {
      onPause()
    }
  }

  func onPause() {
    self.setState { $0.copy(isPaused: true) }
  }

  func onCreate() async {
    onResume()
    await handleDeepLink()
  }

  private func onResume() {
    self.setState { $0.copy(isPaused: false) }
  }

  private func handleDeepLink() async {
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

  private func listenForRevokedModalChanges() {
    $isRevokedModalShowing
      .dropFirst()
      .removeDuplicates()
      .sink { [weak self] value in
        guard let self = self else { return }
        if !value {
          self.setState { $0.copy(revokedDocuments: [:]) }
        }
      }.store(in: &cancellables)
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
}
