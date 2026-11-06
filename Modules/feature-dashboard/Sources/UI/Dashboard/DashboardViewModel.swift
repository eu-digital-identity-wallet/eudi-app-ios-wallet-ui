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
import Foundation
import logic_ui
import logic_core
import feature_common
import Observation

@Copyable
struct DashboardState<Router: RouterHost>: ViewState {
  let homeTab: HomeTabView<Router>?
  let documentTab: DocumentTabView<Router>?
  let historyTab: TransactionTabView<Router>?
  let toolBarContent: ToolBarContent
  let navigationTitle: LocalizableStringKey
  let revokedDocuments: [String: String]
  let suspendedDocuments: [String: String]
  let isPaused: Bool

  /// Every document the last check blocked, for the notice; a revocation wins over a suspension.
  var blockedDocuments: [String: String] {
    revokedDocuments.merging(suspendedDocuments) { revoked, _ in revoked }
  }
}

enum SelectedTab {
  case home
  case documents
  case history
}

@Observable
final class DashboardViewModel<Router: RouterHost>: ViewModel<Router, DashboardState<Router>> {

  @ObservationIgnored
  private let interactor: DashboardInteractor
  @ObservationIgnored
  private let deepLinkController: DeepLinkController
  @ObservationIgnored
  private let homeTabInteractor: HomeTabInteractor
  @ObservationIgnored
  private let documentTabInteractor: DocumentTabInteractor
  @ObservationIgnored
  private let transactionTabInteractor: TransactionTabInteractor

  var selectedTab: SelectedTab = .home
  var isRevokedModalShowing: Bool = false {
    didSet {
      debouncedIsRevokedModalShowing.send(isRevokedModalShowing)
    }
  }

  @ObservationIgnored
  private var debouncedIsRevokedModalShowing = CurrentValueSubject<Bool, Never>(false)

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
    self.homeTabInteractor = homeTabInteractor
    self.documentTabInteractor = documentTabInteractor
    self.transactionTabInteractor = transactionTabInteractor

    super.init(
      router: router,
      initialState: .init(
        homeTab: nil,
        documentTab: nil,
        historyTab: nil,
        toolBarContent: .init(
          trailingActions: nil,
          leadingActions: nil
        ),
        navigationTitle: .custom(""),
        revokedDocuments: [:],
        suspendedDocuments: [:],
        isPaused: false
      )
    )

    listenForRevokedModalChanges()
  }

  /// Shows the documents a revocation check newly revoked or suspended (`RevocationDashboardPayload`).
  func handleRevocationNotification(for payload: [AnyHashable: Any]?) {
    guard
      let documents = RevocationDashboardPayload(userInfo: payload),
      !isRevokedModalShowing,
      !viewState.isPaused
    else {
      return
    }
    setState {
      $0
        .copy(revokedDocuments: documents.revoked)
        .copy(suspendedDocuments: documents.suspended)
    }
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

  /// The first appearance loads the documents, then builds the tabs and starts the workers, so the tabs
  /// read loaded documents and a kept link finds them. The Digital Credential API registration pass runs in a task
  /// of its own, so a slow or hung registration store holds up neither the tabs nor a kept link.
  func onCreate() async {
    onResume()
    if viewState.homeTab == nil {
      await interactor.loadDocuments()
      deepLinkController.setDocumentsLoaded()
      createTabs(
        homeTabInteractor: homeTabInteractor,
        documentTabInteractor: documentTabInteractor,
        transactionTabInteractor: transactionTabInteractor
      )
      Task { [interactor] in await interactor.reconcileRegistrations() }
      await interactor.startWorkers()
    }
    await handleDeepLink()
  }

  private func onResume() {
    self.setState { $0.copy(isPaused: false) }
  }

  private func handleDeepLink() async {
    if let deepLink = deepLinkController.getPendingDeepLinkAction() {
      deepLinkController.handleDeepLinkAction(
        routerHost: router,
        deepLinkExecutable: deepLink
      )
    }
  }

  private func listenForRevokedModalChanges() {
    debouncedIsRevokedModalShowing
      .dropFirst()
      .removeDuplicates()
      .sink { [weak self] value in
        guard let self = self else { return }
        if !value {
          self.setState {
            $0
              .copy(revokedDocuments: [:])
              .copy(suspendedDocuments: [:])
          }
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
        historyTab: TransactionTabView(
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
