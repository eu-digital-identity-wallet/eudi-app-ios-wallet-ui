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
struct DashboardState: ViewState {
  let isLoading: Bool
  let documents: [DocumentCategory: [DocumentUIModel]]
  let filterUIModel: [FilterUISection]
  let username: String
  let phase: ScenePhase
  let pendingBleModalAction: Bool
  let showFilterIndicator: Bool
  let appVersion: String
  let allowUserInteraction: Bool
  let pendingDeletionDocument: DocumentUIModel?
  let succededIssuedDocuments: [DocumentUIModel]
  let failedDocuments: [String]
  let moreOptions: [MoreModalOption]
  let contentHeaderConfig: ContentHeaderConfig
  let isFromOnPause: Bool
  let hasDefaultFilters: Bool

  var pendingDocumentTitle: String {
    pendingDeletionDocument?.value.title ?? ""
  }
}

extension DashboardState {
  enum MoreModalOption: Equatable {

    case changeQuickPin
    case scanQrCode
    case signDocument
    case retrieveLogs(URL)

    var id: String {
      return switch self {
      case .changeQuickPin:
        "changeQuickPin"
      case .scanQrCode:
        "scanQrCode"
      case .signDocument:
        "signDocument"
      case .retrieveLogs:
        "retrieveLogs"
      }
    }
  }
}

public enum SelectedTab {
  case home
  case documents
  case transactions
}

public enum SheetAction {
  case updated
  case nothing
}

final class DashboardViewModel<Router: RouterHost>: ViewModel<Router, DashboardState> {

  private let interactor: DashboardInteractor
  private let deepLinkController: DeepLinkController
  private let walletKitController: WalletKitController
  private let SEARCH_INPUT_DEBOUNCE = 250

  @Published var isBleModalShowing: Bool = false
  @Published var isFilterModalShowing: Bool = false
  @Published var isDeleteDeferredModalShowing: Bool = false
  @Published var isSuccededDocumentsModalShowing: Bool = false
  @Published var selectedTab: SelectedTab = .home
  @Published var isAuthenticateAlertShowing: Bool = false
  @Published var searchQuery: String = ""

  private var deferredTask: Task<DashboardDeferredPartialState, Error>?

  var bearerName: String {
    "viewState.bearer.value.name"
  }

  init(
    router: Router,
    interactor: DashboardInteractor,
    deepLinkController: DeepLinkController,
    walletKit: WalletKitController
  ) {
    self.interactor = interactor
    self.deepLinkController = deepLinkController
    self.walletKitController = walletKit
    super.init(
      router: router,
      initialState: .init(
        isLoading: true,
        documents: [:],
        filterUIModel: [],
        username: "",
        phase: .active,
        pendingBleModalAction: false,
        showFilterIndicator: false,
        appVersion: interactor.getAppVersion(),
        allowUserInteraction: interactor.hasIssuedDocuments(),
        pendingDeletionDocument: nil,
        succededIssuedDocuments: [],
        failedDocuments: [],
        moreOptions: [.changeQuickPin, .scanQrCode],
        contentHeaderConfig: .init(
          appIconAndTextData: AppIconAndTextData(
            appIcon: ThemeManager.shared.image.logoEuDigitalIndentityWallet,
            appText: ThemeManager.shared.image.euditext
          )
        ),
        isFromOnPause: true,
        hasDefaultFilters: false
      )
    )

    listenForSuccededIssuedModalChanges()
    subscribeToSearch()
    onFiltersChangeState()
  }

  func fetch() {
    Task {

      let failedDocuments = viewState.failedDocuments

      let state = await Task.detached { () -> DashboardPartialState in
        return await self.interactor.fetchDashboard(failedDocuments: failedDocuments)
      }.value

      switch state {
      case .success(let username, let documents, let hasIssuedDocuments):

        if viewState.isFromOnPause {
          await interactor.initializeFilters(filterableList: documents)
        } else {
          await interactor.updateLists(filterableList: documents)
        }

        await interactor.applyFilters()

        setState {
          $0.copy(
            isLoading: false,
            username: username,
            allowUserInteraction: hasIssuedDocuments,
            isFromOnPause: false
          )
        }
        onDocumentsRetrievedPostActions()
      case .failure:
        setState {
          $0.copy(isLoading: false, documents: [:])
        }
      }
    }
  }

  func resetFilters() {
    Task {
      await interactor.resetFilters()
    }
  }

  func revertFilters() {
    Task {
      await interactor.revertFilters()
    }
  }

  func updateFilters(sectionID: String, filterID: String) {
    Task {
      await interactor.updateFilters(sectionID: sectionID, filterID: filterID)
    }
  }

  func setPhase(with phase: ScenePhase) {
    setState { $0.copy(phase: phase) }
    if phase == .active && viewState.pendingBleModalAction {
      DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
        self.setState { $0.copy(pendingBleModalAction: false) }
        self.toggleBleModal()
      }
    }
    if phase == .active {
      onDocumentsRetrievedPostActions()
    }
    if phase == .background {
      onPause()
    }
  }

  func onPause() {
    self.deferredTask?.cancel()
    if !isFilterModalShowing {
      setState { $0.copy(isFromOnPause: true) }
    }
  }

  func onDocumentDetails(documentId: String) {

    isSuccededDocumentsModalShowing = false

    router.push(
      with: .featureIssuanceModule(
        .issuanceDocumentDetails(
          config: IssuanceDetailUiConfig(
            flow: .extraDocument(documentId)
          )
        )
      )
    )
  }

  func onShare() {
    Task {

      let state = await Task.detached { () -> Reachability.BleAvailibity in
        return await self.interactor.getBleAvailability()
      }.value

      switch state {
      case .available:
        self.router.push(
          with: .featureProximityModule(
            .proximityConnection(
              presentationCoordinator: await self.walletKitController.startProximityPresentation(),
              originator: .featureDashboardModule(.dashboard)
            )
          )
        )
      case .noPermission, .disabled:
        self.toggleBleModal()
      default:
        break
      }
    }
  }

  func onDeleteDeferredDocument(with document: DocumentUIModel) {
    setState { $0.copy(pendingDeletionDocument: document) }
    toggleDeleteDeferredModal()
  }

  func toggleDeleteDeferredModal() {
    isDeleteDeferredModalShowing = !isDeleteDeferredModalShowing
  }

  func deleteDeferredDocument() {
    toggleDeleteDeferredModal()
    guard let document = viewState.pendingDeletionDocument else {
      return
    }
    setState { $0.copy(isLoading: true).copy(pendingDeletionDocument: nil) }
    Task {

      let state = await Task.detached { () -> DashboardDeleteDeferredPartialState in
        return await self.interactor.deleteDeferredDocument(with: document.value.id)
      }.value

      switch state {
      case .success:
        fetch()
      case .noDocuments:
        router.popTo(with: .featureStartupModule(.startup))
      case .failure:
        setState { $0.copy(isLoading: false) }
      }
    }
  }

  func toggleBleModal() {
    guard viewState.phase == .active else {
      setState { $0.copy(pendingBleModalAction: true) }
      return
    }
    isBleModalShowing = !isBleModalShowing
  }

  func onBleSettings() {
    toggleBleModal()
    interactor.openBleSettings()
  }

  func onAdd() {
    router.push(
      with: .featureCommonModule(
        .issuanceAddDocumentOptions(
          config: IssuanceFlowUiConfig(flow: .extraDocument)
        )
      )
    )
  }

  func showFilters() {
    isFilterModalShowing = true
    onPause()
  }

  func onMyWallet() {
    router.push(
      with: .featureDashboardModule(
        .sideMenu
      )
    )
  }

  func openSignDocument() {
    router.push(with: .featureDashboardModule(.signDocument))
  }

  func onShowScanner() {
    router.push(with: .featureCommonModule(.qrScanner(config: ScannerUiConfig(flow: .presentation))))
  }

  func getNavigationTitle() -> LocalizableStringKey {
    switch selectedTab {
    case .documents:
      return .documents
    case .home:
      return .home
    case .transactions:
      return .transactions
    }
  }

  func toolbarContent() -> ToolBarContent {
    .init(
      trailingActions: trailingActions(),
      leadingActions: leadingActions()
    )
  }

  private func listenForSuccededIssuedModalChanges() {
    $isSuccededDocumentsModalShowing
      .dropFirst()
      .removeDuplicates()
      .sink { [weak self] value in
        guard let self = self else { return }
        if !value {
          self.setState { $0.copy(succededIssuedDocuments: []) }
        }
      }.store(in: &cancellables)
  }

  private func onDocumentsRetrievedPostActions() {
    if let deepLink = deepLinkController.getPendingDeepLinkAction() {
      Task {
        deepLinkController.handleDeepLinkAction(
          routerHost: router,
          deepLinkExecutable: deepLink,
          remoteSessionCoordinator: deepLink.requiresCoordinator
          ? await walletKitController.startSameDevicePresentation(deepLink: deepLink.link)
          : nil
        )
      }
    } else if interactor.hasDeferredDocuments() && (self.deferredTask == nil || self.deferredTask?.isCancelled == true) {
      self.deferredTask = Task {
        try? await Task.sleep(seconds: 5)
        return await interactor.requestDeferredIssuance()
      }
      Task {
        guard let task = self.deferredTask else { return }
        let partialState = try? await task.value
        switch partialState {
        case .completion(let issued, let failed):
          self.deferredTask?.cancel()
          self.setState {
            $0.copy(
              succededIssuedDocuments: !isSuccededDocumentsModalShowing
              ? issued
              : $0.succededIssuedDocuments,
              failedDocuments: failed
            )
          }
          fetch()
        case .cancelled, .none: break
        }
      }
    }
    checkForSuccededIssuedDocuments()
  }

  private func checkForSuccededIssuedDocuments() {
    guard
      !viewState.succededIssuedDocuments.isEmpty,
      !isSuccededDocumentsModalShowing
    else {
      return
    }
    isBleModalShowing = false
    isDeleteDeferredModalShowing = false
    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
      self.isSuccededDocumentsModalShowing = true
    }
  }

  public func enableFilterIndicator(showFilterIndicator: Bool) {
    setState {
      $0.copy(showFilterIndicator: showFilterIndicator)
    }
  }

  private func trailingActions() -> [Action]? {
    switch selectedTab {
    case .documents:
      return [
        Action(image: Theme.shared.image.plus) {
          self.onAdd()
        },
        Action(image: Theme.shared.image.filterMenuIcon, hasIndicator: viewState.showFilterIndicator && !viewState.hasDefaultFilters) {
          self.showFilters()
        }
      ]
    case .home:
      return nil
    case .transactions:
      return nil
    }
  }

  private func leadingActions() -> [Action]? {
    [
      Action(image: Theme.shared.image.menuIcon) {
        self.onMyWallet()
      }
    ]
  }

  private func subscribeToSearch() {
    $searchQuery
      .dropFirst()
      .debounce(for: .milliseconds(SEARCH_INPUT_DEBOUNCE), scheduler: RunLoop.main)
      .removeDuplicates()
      .sink { [weak self] query in
        guard let self = self else { return }
        Task {
          await self.interactor.applySearch(query: query)
        }
      }.store(in: &cancellables)
  }

  private func onFiltersChangeState() {
    Task {
      for await state in interactor.onFilterChangeState() {
        switch state {
        case .filterApplyResult(let documents, let filterSections, let hasDefaultFilters):
          setState {
            $0.copy(
              documents: documents,
              filterUIModel: filterSections,
              hasDefaultFilters: hasDefaultFilters
            )
          }
        case .filterUpdateResult(let filterSections):
          setState {
            $0.copy(
              filterUIModel: filterSections
            )
          }
        case .cancelled: break
        }
      }
    }
  }
}
