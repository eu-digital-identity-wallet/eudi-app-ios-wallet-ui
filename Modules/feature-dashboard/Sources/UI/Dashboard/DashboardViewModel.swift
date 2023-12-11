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
import feature_common

struct DashboardState: ViewState {
  let isLoading: Bool
  let documents: [DocumentUIModel]
  let bearer: BearerUIModel
  let phase: ScenePhase
  let pendingBleModalAction: Bool
}

@MainActor
final class DashboardViewModel<Router: RouterHostType, Interactor: DashboardInteractorType, DeepLinkController: DeepLinkControllerType>: BaseViewModel<Router, DashboardState> {

  private let interactor: Interactor
  private let deepLinkController: DeepLinkController

  @Published var isMoreModalShowing: Bool = false
  @Published var isBleModalShowing: Bool = false
  @Published var onScan: Bool = false

  var bearerName: String {
    viewState.bearer.value.name
  }

  init(router: Router, interactor: Interactor, deepLinkController: DeepLinkController) {
    self.interactor = interactor
    self.deepLinkController = deepLinkController
    super.init(
      router: router,
      initialState: .init(
        isLoading: true,
        documents: DocumentUIModel.mocks(),
        bearer: BearerUIModel.mock(),
        phase: .active,
        pendingBleModalAction: false
      )
    )
  }

  func fetch() async {
    switch await interactor.fetchDashboard() {
    case .success(let bearer, let documents):
      setNewState(
        documents: documents,
        bearer: bearer
      )
      handleDeepLink()
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
  }

  func onDocumentDetails(documentId: String) {
    router.push(
      with: .issuanceDocumentDetails(
        config: IssuanceDetailUiConfig(flow: .extraDocument(documentId))
      )
    )
  }

  func onShare() {
    interactor.getBleAvailability()
      .sink { [weak self] availability in
        guard let self = self else { return }
        switch availability {
        case .available:
          self.router.push(
            with: .proximityConnection(
              presentationCoordinator: WalletKitController.shared.startProximityPresentation()
            )
          )
        case .noPermission, .disabled:
          self.toggleBleModal()
        default:
          break
        }
      }
      .store(in: &cancellables)
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
    isMoreModalShowing = !isMoreModalShowing
  }

  func onUpdatePin() {
    isMoreModalShowing = false
    router.push(with: .quickPin(config: QuickPinUiConfig(flow: .update)))
  }

  func onShowScanner() {
    isMoreModalShowing = false
    onScan = true
  }

  private func handleDeepLink() {
    if let deepLink = deepLinkController.getPendingDeepLinkAction() {
      deepLinkController.handleDeepLinkAction(routerHost: router, deepLinkAction: deepLink)
    }
  }

  func onScanSuccess(scanResult: String) {
    router.push(
      with: .crossDeviceRequest(
        presentationCoordinator: WalletKitController.shared.startRemotePresentation(
          urlString: scanResult
        )
      )
    )
  }

  private func setNewState(
    isLoading: Bool = false,
    documents: [DocumentUIModel]? = nil,
    bearer: BearerUIModel? = nil,
    phase: ScenePhase? = nil,
    pendingBleModalAction: Bool? = nil
  ) {
    setState { previousSate in
        .init(
          isLoading: isLoading,
          documents: documents ?? previousSate.documents,
          bearer: bearer ?? previousSate.bearer,
          phase: phase ?? previousSate.phase,
          pendingBleModalAction: pendingBleModalAction ?? previousSate.pendingBleModalAction
        )
    }
  }
}
