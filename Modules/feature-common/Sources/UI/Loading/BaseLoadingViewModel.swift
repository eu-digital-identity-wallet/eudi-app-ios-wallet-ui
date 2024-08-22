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
@_exported import logic_ui
@_exported import logic_resources

@Copyable
public struct BaseLoadingState: ViewState {
  let error: ContentErrorView.Config?
}

open class BaseLoadingViewModel<Router: RouterHost>: BaseViewModel<Router, BaseLoadingState> {

  public init(router: Router) {
    super.init(router: router, initialState: .init(error: nil))
  }

  open func getTitle() -> LocalizableString.Key {
    return .custom("")
  }

  open func getCaption() -> LocalizableString.Key {
    return .custom("")
  }

  open func getOnPopRoute() -> AppRoute? {
    return nil
  }

  open func doWork() async {}

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

  private func onErrorAction() {
    setState {
      $0.copy(error: nil)
    }
    Task {
      await self.doWork()
    }
  }
}
