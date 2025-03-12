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
import logic_resources
import feature_common

@Copyable
struct HomeTabState: ViewState {
  let username: String
  let contentHeaderConfig: ContentHeaderConfig
  let phase: ScenePhase
  let pendingBleModalAction: Bool
}

final class HomeTabViewModel<Router: RouterHost>: ViewModel<Router, HomeTabState> {

  private let interactor: HomeTabInteractor
  private let onUpdateToolbar: (ToolBarContent, LocalizableStringKey) -> Void

  @Published var isAuthenticateAlertShowing: Bool = false
  @Published var isAuthenticateModalShowing: Bool = false
  @Published var isSignDocumentAlertShowing: Bool = false
  @Published var isBleModalShowing: Bool = false

  init(
    router: Router,
    interactor: HomeTabInteractor,
    onUpdateToolbar: @escaping (ToolBarContent, LocalizableStringKey) -> Void
  ) {
    self.interactor = interactor
    self.onUpdateToolbar = onUpdateToolbar
    super.init(
      router: router,
      initialState: .init(
        username: interactor.fetchUsername(),
        contentHeaderConfig: .init(
          appIconAndTextData: AppIconAndTextData(
            appIcon: ThemeManager.shared.image.logoEuDigitalIndentityWallet,
            appText: ThemeManager.shared.image.euditext
          )
        ),
        phase: .active,
        pendingBleModalAction: false
      )
    )
  }

  func onCreate() {
    onUpdateToolbar(
      .init(
        trailingActions: nil,
        leadingActions: [
          Action(image: Theme.shared.image.menuIcon) {
            self.onMyWallet()
          }
        ]
      ),
      .home
    )
  }

  func toggleAuthenticateAlert() {
    isAuthenticateAlertShowing.toggle()
  }

  func toggleAuthenticateModal() {
    isAuthenticateModalShowing.toggle()
  }

  func toggleSignDocumentAlert() {
    isSignDocumentAlertShowing.toggle()
  }

  func openSignDocument() {
    router.push(with: .featureDashboardModule(.signDocument))
  }

  func onShowScanner() {
    router.push(with: .featureCommonModule(.qrScanner(config: ScannerUiConfig(flow: .presentation))))
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
              presentationCoordinator: await self.interactor.getWalletKitController().startProximityPresentation(),
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

  func setPhase(with phase: ScenePhase) {
    setState { $0.copy(phase: phase) }
    if phase == .active && viewState.pendingBleModalAction {
      DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
        self.setState { $0.copy(pendingBleModalAction: false) }
        self.toggleBleModal()
      }
    }
  }

  private func onMyWallet() {
    router.push(
      with: .featureDashboardModule(
        .sideMenu
      )
    )
  }
}
