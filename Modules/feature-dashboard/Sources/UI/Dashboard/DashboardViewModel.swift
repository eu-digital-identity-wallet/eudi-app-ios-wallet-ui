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
  let bearer: BearerUIModel
  let phase: ScenePhase
  let pendingBleModalAction: Bool
  let appVersion: String
  let allowUserInteraction: Bool
  let pendingDeletionDocument: DocumentUIModel?
  let succededIssuedDocuments: [DocumentUIModel]
  let failedDocuments: [String]
  let moreOptions: [MoreModalOption]

  var pendingDocumentTitle: String {
    pendingDeletionDocument?.value.title ?? ""
  }
}

extension DashboardState {
  enum MoreModalOption: Equatable {

    case changeQuickPin
    case scanQrCode
    case retrieveLogs(URL)

    var id: String {
      return switch self {
      case .changeQuickPin:
        "changeQuickPin"
      case .scanQrCode:
        "scanQrCode"
      case .retrieveLogs:
        "retrieveLogs"
      }
    }
  }
}

@MainActor
final class DashboardViewModel<Router: RouterHost>: BaseViewModel<Router, DashboardState> {

  private let interactor: DashboardInteractor
  private let deepLinkController: DeepLinkController
  private let walletKitController: WalletKitController

  @Published var isMoreModalShowing: Bool = false
  @Published var isBleModalShowing: Bool = false
  @Published var isDeleteDeferredModalShowing: Bool = false
  @Published var isSuccededDocumentsModalShowing: Bool = false

  private var deferredTask: Task<DashboardDeferredPartialState, Error>?

  var bearerName: String {
    viewState.bearer.value.name
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
        bearer: BearerUIModel.mock(),
        phase: .active,
        pendingBleModalAction: false,
        appVersion: interactor.getAppVersion(),
        allowUserInteraction: interactor.hasIssuedDocuments(),
        pendingDeletionDocument: nil,
        succededIssuedDocuments: [],
        failedDocuments: [],
        moreOptions: [.changeQuickPin, .scanQrCode]
      )
    )

    listenForSuccededIssuedModalChanges()
  }

  func fetch() async {
    switch await interactor.fetchDashboard(failedDocuments: viewState.failedDocuments) {
    case .success(let bearer, let documents, let hasIssuedDocuments):
      setState {
        $0.copy(
          isLoading: false,
          documents: documents,
          bearer: bearer,
          allowUserInteraction: hasIssuedDocuments
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
      with: .issuanceDocumentDetails(
        config: IssuanceDetailUiConfig(flow: .extraDocument(documentId))
      )
    )
  }

  func onShare() {
    Task { [weak self] in
      guard let self else { return }

      switch await self.interactor.getBleAvailability() {
      case .available:
        self.router.push(
          with: .proximityConnection(
            presentationCoordinator: self.walletKitController.startProximityPresentation(),
            originator: .dashboard
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
      switch await interactor.deleteDeferredDocument(with: document.value.id) {
      case .success:
        await fetch()
      case .noDocuments:
        router.popTo(with: .startup)
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
    router.push(with: .issuanceAddDocument(config: IssuanceFlowUiConfig(flow: .extraDocument)))
  }

  func onMore() {
    setState {
      $0.copy(
        moreOptions: buildArray {
          DashboardState.MoreModalOption.changeQuickPin
          DashboardState.MoreModalOption.scanQrCode
          if let url = interactor.retrieveLogFileUrl() {
            DashboardState.MoreModalOption.retrieveLogs(url)
          }
        }
      )
    }
    isMoreModalShowing = !isMoreModalShowing
  }

  func onUpdatePin() {
    onHideMore()
    router.push(with: .quickPin(config: QuickPinUiConfig(flow: .update)))
  }

  func onShowScanner() {
    onHideMore()
    router.push(with: .qrScanner(config: ScannerUiConfig(flow: .presentation)))
  }

  func onHideMore() {
    isMoreModalShowing = false
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
      deepLinkController.handleDeepLinkAction(routerHost: router, deepLinkExecutable: deepLink)
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
    onHideMore()
    isBleModalShowing = false
    isDeleteDeferredModalShowing = false
    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
      self.isSuccededDocumentsModalShowing = true
    }
  }
}
