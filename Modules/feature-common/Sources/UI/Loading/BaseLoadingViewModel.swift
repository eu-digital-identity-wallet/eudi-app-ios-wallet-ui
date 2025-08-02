/*
 * Copyright (c) 2025 European Commission
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
@_exported import logic_ui
@_exported import logic_resources

@Copyable
public struct BaseLoadingState<T: Sendable>: ViewState {
  let error: ContentErrorView.Config?
  let originator: AppRoute
  let isCancellable: Bool
  let contentHeaderConfig: ContentHeaderConfig
  let requestItems: [ListItemSection<T>]
  let relyingParty: String
  let relyingPartyIsTrusted: Bool
  let toolBarContent: ToolBarContent
}

open class BaseLoadingViewModel<Router: RouterHost, RequestItem: Sendable>: ViewModel<Router, BaseLoadingState<RequestItem>> {

  public init(
    router: Router,
    originator: AppRoute,
    requestItems: [ListItemSection<RequestItem>],
    relyingParty: String,
    relyingPartyIsTrusted: Bool,
    cancellationTimeout: Double = 0.0
  ) {
    super.init(
      router: router,
      initialState: .init(
        error: nil,
        originator: originator,
        isCancellable: cancellationTimeout <= 0,
        contentHeaderConfig: .init(
          appIconAndTextData: AppIconAndTextData(
            appIcon: ThemeManager.shared.image.logoEuDigitalIndentityWallet,
            appText: ThemeManager.shared.image.euditext
          ),
          description: .pleaseWait
        ),
        requestItems: requestItems,
        relyingParty: relyingParty,
        relyingPartyIsTrusted: relyingPartyIsTrusted,
        toolBarContent: .init()
      )
    )

    if cancellationTimeout > 0 {
      setCancellationWithTimeout(cancellationTimeout)
    } else {
      setState {
        $0.copy(toolBarContent: backableToolbar())
      }
    }
  }

  open func getTitle() -> LocalizableStringKey {
    return .custom("")
  }

  open func getCaption() -> LocalizableStringKey {
    return .custom("")
  }

  open func getOnPopRoute() -> AppRoute? {
    return nil
  }

  open func doWork() async {}

  public func getOriginator() -> AppRoute {
    return viewState.originator
  }

  public func getRequestItems() -> [ListItemSection<RequestItem>] {
    viewState.requestItems
  }

  public func getRelyingParty() -> String {
    viewState.relyingParty
  }

  public func isRelyingPartyIstrusted() -> Bool {
    viewState.relyingPartyIsTrusted
  }

  public func onNavigate(type: UIConfig.ThreeWayNavigationType) {
    switch type {
    case .pop:
      if let route = getOnPopRoute() {
        router.popTo(with: route)
      }
    case .push(let route):
      router.push(with: route)
    case .popTo(let route):
      router.popTo(with: route)
    }
  }

  public func onError(with error: Error) {
    setState {
      $0.copy(
        error: .init(
          description: .custom(error.localizedDescription),
          cancelAction: self.onNavigate(type: .pop),
          action: { self.onErrorAction() }
        )
      )
    }
  }

  private func backableToolbar() -> ToolBarContent {
    .init(
      leadingActions: [
        .init(image: Theme.shared.image.xmark) {
          self.onNavigate(type: .pop)
        }
      ]
    )
  }

  private func setCancellationWithTimeout(_ timeout: Double) {
    setState {
      $0.copy(
        isCancellable: false,
        toolBarContent: .init()
      )
    }
    Task { [weak self] in
      try? await Task.sleep(seconds: timeout)
      self?.setState {
        $0.copy(
          isCancellable: true,
          toolBarContent: self?.backableToolbar()
        )
      }
    }
  }

  private func onErrorAction() {
    setState {
      $0.copy(error: nil)
    }
    Task {
      await self.doWork()
    }
  }
}
