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
  let logFile: URL?

  var pendingDocumentTitle: String {
    pendingDeletionDocument?.value.title ?? ""
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
        logFile: nil
      )
    )

    listenForSuccededIssuedModalChanges()
  }

  func fetch() async {
    switch await interactor.fetchDashboard(failedDocuments: viewState.failedDocuments) {
    case .success(let bearer, let documents, let hasIssuedDocuments):
      setNewState(
        documents: documents,
        bearer: bearer,
        allowUserInteraction: hasIssuedDocuments
      )
      onDocumentsRetrievedPostActions()
    case .failure:
      setNewState(
        documents: []
      )
    }
  }

  func setPhase(with phase: ScenePhase) {
    setNewState(phase: phase)
    if phase == .active && viewState.pendingBleModalAction {
      DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
        self.setNewState(pendingBleModalAction: false)
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
            presentationCoordinator: self.walletKitController.startProximityPresentation()
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
    setNewState(pendingDeletedDocument: document)
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
    clearPendingDeleteDocument(isLoading: true)
    Task {
      switch await interactor.deleteDeferredDocument(with: document.value.id) {
      case .success:
        await fetch()
      case .noDocuments:
        router.popTo(with: .startup)
      case .failure:
        setNewState(isLoading: false)
      }
    }
  }

  func toggleBleModal() {
    guard viewState.phase == .active else {
      setNewState(pendingBleModalAction: true)
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
    Task {
      let url = await interactor.retrieveLogFile()
      setNewState(logFile: url)
      isMoreModalShowing = !isMoreModalShowing
    }
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
          self.clearPendingSuccededDocuments()
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
          setNewState(
            succededIssuedDocuments: !isSuccededDocumentsModalShowing
            ? issued
            : nil,
            failedDocuments: failed
          )
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

  private func setNewState(
    isLoading: Bool = false,
    documents: [DocumentUIModel]? = nil,
    bearer: BearerUIModel? = nil,
    phase: ScenePhase? = nil,
    pendingBleModalAction: Bool? = nil,
    allowUserInteraction: Bool? = nil,
    pendingDeletedDocument: DocumentUIModel? = nil,
    succededIssuedDocuments: [DocumentUIModel]? = nil,
    failedDocuments: [String]? = nil,
    logFile: URL? = nil
  ) {
    setState { previousSate in
        .init(
          isLoading: isLoading,
          documents: documents ?? previousSate.documents,
          bearer: bearer ?? previousSate.bearer,
          phase: phase ?? previousSate.phase,
          pendingBleModalAction: pendingBleModalAction ?? previousSate.pendingBleModalAction,
          appVersion: previousSate.appVersion,
          allowUserInteraction: allowUserInteraction ?? previousSate.allowUserInteraction,
          pendingDeletionDocument: pendingDeletedDocument ?? previousSate.pendingDeletionDocument,
          succededIssuedDocuments: succededIssuedDocuments ?? previousSate.succededIssuedDocuments,
          failedDocuments: failedDocuments ?? previousSate.failedDocuments,
          logFile: logFile ?? previousSate.logFile
        )
    }
  }

  private func clearPendingDeleteDocument(isLoading: Bool? = nil) {
    setState { previousSate in
        .init(
          isLoading: isLoading ?? previousSate.isLoading,
          documents: previousSate.documents,
          bearer: previousSate.bearer,
          phase: previousSate.phase,
          pendingBleModalAction: previousSate.pendingBleModalAction,
          appVersion: previousSate.appVersion,
          allowUserInteraction: previousSate.allowUserInteraction,
          pendingDeletionDocument: nil,
          succededIssuedDocuments: previousSate.succededIssuedDocuments,
          failedDocuments: previousSate.failedDocuments,
          logFile: previousSate.logFile
        )
    }
  }

  private func clearPendingSuccededDocuments(isLoading: Bool? = nil) {
    setState { previousSate in
        .init(
          isLoading: isLoading ?? previousSate.isLoading,
          documents: previousSate.documents,
          bearer: previousSate.bearer,
          phase: previousSate.phase,
          pendingBleModalAction: previousSate.pendingBleModalAction,
          appVersion: previousSate.appVersion,
          allowUserInteraction: previousSate.allowUserInteraction,
          pendingDeletionDocument: previousSate.pendingDeletionDocument,
          succededIssuedDocuments: [],
          failedDocuments: previousSate.failedDocuments,
          logFile: previousSate.logFile
        )
    }
  }
}
