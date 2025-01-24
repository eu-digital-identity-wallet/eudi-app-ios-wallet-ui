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
  let documents: [DocumentUIModel]
  var filteredDocuments: [DocumentUIModel]
  var filterModel: FilterModel?
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

  var pendingDocumentTitle: String {
    pendingDeletionDocument?.value.title ?? ""
  }

  var documentSections: [FilterSections]
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

final class DashboardViewModel<Router: RouterHost>: ViewModel<Router, DashboardState> {

  private let interactor: DashboardInteractor
  private let deepLinkController: DeepLinkController
  private let walletKitController: WalletKitController

  @Published var isBleModalShowing: Bool = false
  @Published var isFilterModalShowing: Bool = false
  @Published var isDeleteDeferredModalShowing: Bool = false
  @Published var isSuccededDocumentsModalShowing: Bool = false
  @Published var selectedTab: SelectedTab = .home
  @Published var isAuthenticateAlertShowing: Bool = false

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
        documents: DocumentUIModel.mocks(),
        filteredDocuments: DocumentUIModel.mocks(),
        filterModel: nil,
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
        documentSections: [.issuedSortingDate]
      )
    )

    listenForSuccededIssuedModalChanges()
  }

  func fetch() async {

    let failedDocuments = viewState.failedDocuments

    let state = await Task.detached { () -> DashboardPartialState in
      return await self.interactor.fetchDashboard(failedDocuments: failedDocuments)
    }.value

    switch state {
    case .success(let username, let documents, let hasIssuedDocuments):
      let issuers = Array(Set(documents.map { $0.value.heading })).sorted()
      setState {
        $0.copy(
          isLoading: false,
          documents: documents,
          filteredDocuments: documents,
          username: username,
          allowUserInteraction: hasIssuedDocuments,
          documentSections: [
            .issuedSortingDate,
            .sortBy,
            .issuer(options: issuers),
            .expiryPeriod,
            .state
          ]
        )
      }
      onDocumentsRetrievedPostActions()
    case .failure:
      setState {
        $0.copy(isLoading: false, documents: [])
      }
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
  }

  func onDocumentDetails(documentId: String) {

    isSuccededDocumentsModalShowing = false

    router.push(
      with: .featureIssuanceModule(
        .issuanceDocumentDetails(
          config: IssuanceDetailUiConfig(flow: .extraDocument(documentId)
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
        await fetch()
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
    onPause()
    isFilterModalShowing = true
  }

  func updateFilteredDocuments(filteredDocuments: String, listIsFiltered: Bool) {
    let trimmedSearchQuery = filteredDocuments.trimmingCharacters(in: .whitespacesAndNewlines)
    let sortedDocuments = interactor.applyFiltersWithSorting(
      filterModel: viewState.filterModel,
      documents: viewState.documents
    )

    let newDocuments = sortedDocuments.filter {
      if trimmedSearchQuery.isEmpty {
        return true
      } else {
        return $0.value.title.localizedCaseInsensitiveContains(trimmedSearchQuery) || $0.id.localizedCaseInsensitiveContains(trimmedSearchQuery)
      }
    }

    setState { $0.copy(filteredDocuments: newDocuments) }
  }

  func applyFilters(
    section: [FilterSections],
    sortAscending: Bool,
    initialSorting: String,
    selectedExpiryOption: String?,
    selectedStateOption: String
  ) {
    setState { $0.copy(filteredDocuments: viewState.documents) }

    setState { $0.copy(filterModel: .init(
      sections: section,
      sortAscending: sortAscending,
      initialSorting: initialSorting,
      selectedExpiryOption: selectedExpiryOption,
      selectedStateOption: selectedStateOption))
    }

    let sortedDocuments = interactor.applyFiltersWithSorting(
      filterModel: viewState.filterModel,
      documents: viewState.documents
    )

    setState { $0.copy(filteredDocuments: sortedDocuments) }
  }

  func resetDocumentList() {
    setState { $0.copy(filteredDocuments: viewState.documents) }
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

  func onDocumentsRetrievedPostActions() {
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
          await fetch()
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

  func getNavigationTitle() -> String {
    switch selectedTab {
      case .documents:
        return LocalizableString.shared.get(with: .documents)
      case .home:
        return LocalizableString.shared.get(with: .home)
      case .transactions:
        return LocalizableString.shared.get(with: .transactions)
    }
  }

  func enableFilterIndicator(showFilterIndicator: Bool) {
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
          Action(image: Theme.shared.image.filterMenuIcon, hasIndicator: viewState.showFilterIndicator) {
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

  func toolbarContent() -> ToolBarContent {
    .init(
      trailingActions: trailingActions(),
      leadingActions: leadingActions()
    )
  }
}
