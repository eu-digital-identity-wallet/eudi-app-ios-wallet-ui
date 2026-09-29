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
import SwiftUI
import logic_ui
import logic_resources

@Copyable
struct TrustMarkState: ViewState {
  let config: TrustMarkUiConfig
  let trustMark: TrustMarkUIModel?
  let isLoading: Bool
  let loadError: String?
  let isCompleting: Bool
  let isNavigating: Bool
}

@Observable
final class TrustMarkViewModel<Router: RouterHost>: ViewModel<Router, TrustMarkState> {

  var isBrowserErrorShowing: Bool = false

  private let interactor: TrustMarkInteractor

  init(
    router: Router,
    interactor: TrustMarkInteractor,
    config: any UIConfigType
  ) {
    guard let config = config as? TrustMarkUiConfig else {
      fatalError("TrustMarkViewModel:: Invalid configuraton")
    }
    self.interactor = interactor
    super.init(
      router: router,
      initialState: .init(
        config: config,
        trustMark: nil,
        isLoading: false,
        loadError: nil,
        isCompleting: false,
        isNavigating: false
      )
    )
  }

  func initialize() async {
    await loadTrustMark()
  }

  func onRetry() {
    Task { await loadTrustMark() }
  }

  func onContinue() {
    guard case .welcome(let continuationRoute) = viewState.config.mode,
          !viewState.isCompleting,
          !viewState.isNavigating
    else {
      return
    }

    setState { $0.copy(isCompleting: true) }

    Task {
      await interactor.completeIntroduction()
      setState { $0.copy(isCompleting: false).copy(isNavigating: true) }
      router.push(with: continuationRoute)
    }
  }

  func onOpenLink(_ url: URL) {
    guard let trustMark = viewState.trustMark,
          !viewState.isNavigating,
          url == trustMark.certifiedWalletsUrl || url == trustMark.walletSolutionUrl
    else {
      return
    }

    Task {
      let opened = await UIApplication.shared.open(url)
      if !opened {
        isBrowserErrorShowing = true
      }
    }
  }

  func toolbarContent() -> ToolBarContent? {
    guard !viewState.config.isWelcome else { return nil }
    return .init(
      leadingActions: [
        .init(
          image: Theme.shared.image.chevronLeft,
          accessibilityLocator: ToolbarLocators.chevronLeft
        ) {
          self.onBack()
        }
      ]
    )
  }

  private func onBack() {
    guard !viewState.isCompleting, !viewState.isNavigating else { return }
    router.pop()
  }

  private func loadTrustMark() async {
    guard !viewState.isLoading else { return }

    setState { $0.copy(isLoading: true).copy(loadError: nil) }

    switch await interactor.getTrustMark() {
    case .success(let trustMark):
      setState { $0.copy(trustMark: trustMark).copy(isLoading: false) }
    case .failure(let error):
      setState { $0.copy(trustMark: nil).copy(isLoading: false).copy(loadError: error) }
    }
  }
}
